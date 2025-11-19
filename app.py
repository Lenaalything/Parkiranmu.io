from flask import Flask, jsonify, request, send_from_directory
import pymysql
from flask_cors import CORS

app = Flask(__name__, static_folder='static')
CORS(app)


app.config['MYSQL_HOST'] = 'EvERLASTING.mysql.pythonanywhere-services.com'
app.config['MYSQL_USER'] = 'EvERLASTING'
app.config['MYSQL_PASSWORD'] = 'putr4s3ty4'
app.config['MYSQL_DB'] = 'EvERLASTING$db_parkiran'


def get_db_connection():
    conn = pymysql.connect(
        host=app.config['MYSQL_HOST'],
        user=app.config['MYSQL_USER'],
        password=app.config['MYSQL_PASSWORD'],
        db=app.config['MYSQL_DB'],
        cursorclass=pymysql.cursors.DictCursor
    )
    return conn

@app.route('/')
def index():
    return send_from_directory('static', 'index.html')

@app.route('/parkiran', methods=['POST'])
def create_parkiran():
    conn = None
    cursor = None
    try:
        data = request.json
        slot = data.get('slot')
        status = data.get('status')

        if slot is not None and status is not None:
            conn = get_db_connection()
            cursor = conn.cursor()
            sql = """
                INSERT INTO parkiran (slot, status)
                VALUES (%s, %s)
            """
            values = (slot, status)
            cursor.execute(sql, values)
            conn.commit()
            return jsonify({'message': 'Parkiran terisi!'}), 201
        else:
            return jsonify({'message': 'Data tidak lengkap!'}), 400
    except Exception as e:
        print(e)
        return jsonify({'message': 'Terjadi kesalahan pada server'}), 500
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()


@app.route('/parkiran', methods=['GET'])
def read_all_parkiran():
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT slot, status FROM parkiran")
        results = cursor.fetchall()
        return jsonify(results), 200
    except Exception as e:
        print(e)
        return jsonify({'message': 'Terjadi kesalahan pada server'}), 500
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

@app.route('/parkiran/<slot>', methods=['PUT'])
def update_parkiran(slot):
    conn = None
    cursor = None
    try:
        data = request.json
        status = data.get('status')

        if status is None:
            return jsonify({'message': 'Data tidak lengkap!'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        sql = "UPDATE parkiran SET status=%s WHERE slot=%s"
        values = (status, slot)

        cursor.execute(sql, values)
        conn.commit()

        return jsonify({'message': 'Status slot diperbarui'}), 200

    except Exception as e:
        print(e)
        return jsonify({'message': 'Terjadi kesalahan pada server'}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()
if __name__ == '__main__':
    app.run(debug=True)
