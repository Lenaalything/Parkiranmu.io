from flask import Flask, jsonify, request, send_from_directory
import pymysql
from flask_cors import CORS
from datetime import datetime, timedelta

app = Flask(__name__, static_folder='static')
CORS(app)


app.config['MYSQL_HOST'] = 'EvERLASTING.mysql.pythonanywhere-services.com'
app.config['MYSQL_USER'] = 'EvERLASTING'
app.config['MYSQL_PASSWORD'] = 'putr4s3ty4'
app.config['MYSQL_DB'] = 'EvERLASTING$db_parkir'


def get_db_connection():
    conn = pymysql.connect(
        host=app.config['MYSQL_HOST'],
        user=app.config['MYSQL_USER'],
        password=app.config['MYSQL_PASSWORD'],
        db=app.config['MYSQL_DB'],
        cursorclass=pymysql.cursors.DictCursor
    )
    return conn

def reset():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT last_reset FROM reset WHERE id = 1")
    row = cursor.fetchone()

    if row:
        last_reset = row["last_reset"]
        now = datetime.now()

        if now - last_reset >= timedelta(days=7):
            cursor.execute("DELETE FROM log_parkiran")
            cursor.execute("UPDATE reset SET last_reset = %s WHERE id = 1", (now,))
            conn.commit()

    cursor.close()
    conn.close()


def translate_day(english_day):
    days = {
        'Monday': 'Senin',
        'Tuesday': 'Selasa',
        'Wednesday': 'Rabu',
        'Thursday': 'Kamis',
        'Friday': 'Jumat',
        'Saturday': 'Sabtu',
        'Sunday': 'Minggu'
    }
    return days.get(english_day, english_day)


@app.route('/')
def index():
    return send_from_directory('static', 'index.html')

@app.route('/statistik', methods=['GET'])
def statistik():
    reset()
    return statistik_mingguan()

@app.route('/parkiran', methods=['POST'])
def create_parkiran():
    conn, cursor = None, None
    try:
        data = request.json
        slot = data.get('slot')
        status = data.get('status')

        if slot is None or status is None:
            return jsonify({'message': 'Data tidak lengkap!'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()
        sql = """
            INSERT INTO parkiran (slot, status)
            VALUES (%s, %s)
            ON DUPLICATE KEY UPDATE status = VALUES(status)
        """
        cursor.execute(sql, (slot, status))
        conn.commit()
        return jsonify({'message': 'Parkiran terisi!'}), 201

    except Exception as e:
        print("Error create_parkiran:", e)
        return jsonify({'message': 'Terjadi kesalahan pada server', 'error': str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()


@app.route('/parkiran', methods=['GET'])
def read_all_parkiran():
    reset()
    conn, cursor = None, None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT slot, status FROM parkiran")
        results = cursor.fetchall()
        return jsonify(results), 200
    except Exception as e:
        print("Error read_all_parkiran:", e)
        return jsonify({'message': 'Terjadi kesalahan pada server', 'error': str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

@app.route('/log_parkiran', methods=['GET'])
def get_log():
    reset()
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM log_parkiran ORDER BY id DESC LIMIT 7")
    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


@app.route('/parkiran/<slot>', methods=['PUT'])
def update_parkiran(slot):
    conn, cursor = None, None
    try:
        data = request.json
        status = data.get('status')
        if status is None:
            return jsonify({'message': 'Data tidak lengkap!'}), 400

        status = int(status)

        conn = get_db_connection()
        cursor = conn.cursor()


        cursor.execute("SELECT status FROM parkiran WHERE slot=%s", (slot,))
        old = cursor.fetchone()
        if not old:
            return jsonify({'message': 'Slot tidak ditemukan'}), 404

        old_status = old['status']

        cursor.execute("UPDATE parkiran SET status=%s WHERE slot=%s", (status, slot))


        if old_status == 0 and status == 1:
            cursor.execute(
                "INSERT INTO log_parkiran (slot, keterangan, waktu) VALUES (%s, 'MASUK', NOW())", (slot,)
            )
        elif old_status == 1 and status == 0:
            cursor.execute(
                "INSERT INTO log_parkiran (slot, keterangan, waktu) VALUES (%s, 'KELUAR', NOW())", (slot,)
            )

        conn.commit()
        return jsonify({'message': 'Status slot diperbarui'}), 200

    except Exception as e:
        print("Error update_parkiran:", e)
        if conn: conn.rollback()
        return jsonify({'message': 'Terjadi kesalahan server', 'error': str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

def statistik_mingguan():
    conn, cursor = None, None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()


        cursor.execute("""
            SELECT
                DAYNAME(waktu) AS hari,
                COUNT(*) AS total_masuk
            FROM log_parkiran
            WHERE keterangan = 'MASUK'
              AND waktu >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            GROUP BY DAYNAME(waktu), DAYOFWEEK(waktu)
            ORDER BY DAYOFWEEK(waktu)
        """)
        total_rows = cursor.fetchall()

        cursor.execute("""
            SELECT
                DAYNAME(waktu) AS hari,
                HOUR(waktu) AS jam,
                COUNT(*) AS total
            FROM log_parkiran
            WHERE keterangan = 'MASUK'
              AND waktu >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            GROUP BY DAYNAME(waktu), HOUR(waktu)
        """)
        jam_rows = cursor.fetchall()


        jam_teramai_map = {}

        for hari in ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']:
            rows = [r for r in jam_rows if r['hari'] == hari]

            if rows:

                max_total = -1
                max_row = None

                for r in rows:
                    if r['total'] > max_total:
                        max_total = r['total']
                        max_row = r

                jam_teramai_map[translate_day(hari)] = f"{max_row['jam']:02d}:00 - {max_row['jam']+1:02d}:00"
            else:
                jam_teramai_map[translate_day(hari)] = "-"


        all_days = ['Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu']
        existing_totals = {translate_day(r['hari']): r['total_masuk'] for r in total_rows}

        result = [
            {
                'hari': day,
                'total_masuk': existing_totals.get(day, 0),
                'jam_teramai': jam_teramai_map.get(day, "-")
            }
            for day in all_days
        ]

        return jsonify(result), 200

    except Exception as e:
        print("Error /log_parkiran:", e)
        return jsonify({'message':'Terjadi kesalahan server','error':str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()

if __name__ == '__main__':
    app.run(debug=True)