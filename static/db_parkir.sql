-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 02, 2025 at 05:09 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_parkir`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_dummy_senin_rabu` ()   BEGIN
    DECLARE d INT;
    DECLARE j INT;
    DECLARE total INT;
    DECLARE h INT;
    DECLARE slot_name VARCHAR(3);
    DECLARE masuk_time DATETIME;

    -- 1 = Monday, 2 = Tuesday, 3 = Wednesday
    SET d = 1;

    WHILE d <= 3 DO
        
        SET total = FLOOR(20 + (RAND() * 41));
        SET j = 0;

        WHILE j < total DO
            SET h = FLOOR(RAND() * 11) + 1;

            IF h <= 5 THEN
                SET slot_name = CONCAT('c', h);
            ELSE
                SET slot_name = CONCAT('m', h - 5);
            END IF;

            SET masuk_time =
                DATE_ADD(
                    DATE_SUB(CURDATE(), INTERVAL (DAYOFWEEK(CURDATE()) - 2) DAY),
                    INTERVAL (d - 1) DAY
                )
                + INTERVAL FLOOR(RAND()*24) HOUR
                + INTERVAL FLOOR(RAND()*60) MINUTE
                + INTERVAL FLOOR(RAND()*60) SECOND;

            INSERT INTO log_parkiran (slot, keterangan, waktu)
            VALUES (slot_name, 'MASUK', masuk_time);

            SET j = j + 1;
        END WHILE;

        SET d = d + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_dummy_senin_selasa_rabu` ()   BEGIN
    DECLARE j INT;
    DECLARE total INT;
    DECLARE h INT;
    DECLARE slot_name VARCHAR(3);
    DECLARE masuk_time DATETIME;
    DECLARE target_date DATE;

    -- Loop 0=Senin, 1=Selasa, 2=Rabu
    DECLARE i INT DEFAULT 0;

    WHILE i < 3 DO
        
        -- Tentukan tanggal Senin–Selasa–Rabu minggu ini
        SET target_date = DATE_SUB(CURDATE(), INTERVAL (WEEKDAY(CURDATE())) DAY) + INTERVAL i DAY;

        -- Data yang lebih hidup: 20–60 kendaraan
        SET total = FLOOR(20 + (RAND() * 41));
        SET j = 0;

        WHILE j < total DO

            -- Slot acak antara c1–c5 dan m1–m6
            SET h = FLOOR(RAND() * 11) + 1;

            IF h <= 5 THEN
                SET slot_name = CONCAT('c', h);
            ELSE
                SET slot_name = CONCAT('m', h - 5);
            END IF;

            -- Waktu acak selama hari tersebut
            SET masuk_time = target_date
                             + INTERVAL FLOOR(RAND()*24) HOUR
                             + INTERVAL FLOOR(RAND()*60) MINUTE
                             + INTERVAL FLOOR(RAND()*60) SECOND;

            INSERT INTO log_parkiran (slot, keterangan, waktu)
            VALUES (slot_name, 'MASUK', masuk_time);

            SET j = j + 1;
        END WHILE;

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `log_parkiran`
--

CREATE TABLE `log_parkiran` (
  `id` int(11) NOT NULL,
  `slot` varchar(10) NOT NULL,
  `keterangan` enum('MASUK','KELUAR') DEFAULT NULL,
  `waktu` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_parkiran`
--

INSERT INTO `log_parkiran` (`id`, `slot`, `keterangan`, `waktu`) VALUES
(961, 'm6', 'MASUK', '2025-12-01 09:08:32'),
(962, 'c4', 'MASUK', '2025-12-01 19:12:36'),
(963, 'c5', 'MASUK', '2025-12-01 06:02:26'),
(964, 'c1', 'MASUK', '2025-12-01 00:50:11'),
(965, 'c5', 'MASUK', '2025-12-01 12:19:04'),
(966, 'c5', 'MASUK', '2025-12-01 18:43:14'),
(967, 'c1', 'MASUK', '2025-12-01 14:49:18'),
(968, 'c1', 'MASUK', '2025-12-01 08:34:48'),
(969, 'c4', 'MASUK', '2025-12-01 08:45:39'),
(970, 'c1', 'MASUK', '2025-12-01 04:47:25'),
(971, 'm4', 'MASUK', '2025-12-01 11:11:28'),
(972, 'm4', 'MASUK', '2025-12-01 13:22:13'),
(973, 'm6', 'MASUK', '2025-12-01 04:02:40'),
(974, 'c3', 'MASUK', '2025-12-01 00:32:37'),
(975, 'm1', 'MASUK', '2025-12-01 11:54:11'),
(976, 'c3', 'MASUK', '2025-12-01 10:35:36'),
(977, 'c4', 'MASUK', '2025-12-01 15:24:04'),
(978, 'c2', 'MASUK', '2025-12-01 10:50:52'),
(979, 'm4', 'MASUK', '2025-12-01 10:43:18'),
(980, 'c5', 'MASUK', '2025-12-01 23:47:59'),
(981, 'm2', 'MASUK', '2025-12-01 20:38:37'),
(982, 'c2', 'MASUK', '2025-12-01 00:31:36'),
(983, 'c5', 'MASUK', '2025-12-01 07:20:43'),
(984, 'm2', 'MASUK', '2025-12-01 17:52:14'),
(985, 'm2', 'MASUK', '2025-12-01 04:05:59'),
(986, 'm2', 'MASUK', '2025-12-01 05:11:16'),
(987, 'm5', 'MASUK', '2025-12-01 08:16:18'),
(988, 'm4', 'MASUK', '2025-12-01 16:18:28'),
(989, 'c5', 'MASUK', '2025-12-01 19:39:53'),
(990, 'm1', 'MASUK', '2025-12-01 17:13:53'),
(991, 'm4', 'MASUK', '2025-12-01 08:25:59'),
(992, 'm3', 'MASUK', '2025-12-01 13:40:43'),
(993, 'm2', 'MASUK', '2025-12-01 18:06:12'),
(994, 'm4', 'MASUK', '2025-12-01 00:57:43'),
(995, 'm3', 'MASUK', '2025-12-01 08:39:13'),
(996, 'c2', 'MASUK', '2025-12-01 01:47:48'),
(997, 'c2', 'MASUK', '2025-12-02 08:24:00'),
(998, 'm5', 'MASUK', '2025-12-02 04:27:41'),
(999, 'c1', 'MASUK', '2025-12-02 06:04:37'),
(1000, 'm5', 'MASUK', '2025-12-02 15:32:45'),
(1001, 'c2', 'MASUK', '2025-12-02 11:00:32'),
(1002, 'm3', 'MASUK', '2025-12-02 21:25:25'),
(1003, 'm5', 'MASUK', '2025-12-02 23:16:29'),
(1004, 'm2', 'MASUK', '2025-12-02 15:18:37'),
(1005, 'c3', 'MASUK', '2025-12-02 03:04:58'),
(1006, 'm3', 'MASUK', '2025-12-02 08:46:51'),
(1007, 'm6', 'MASUK', '2025-12-02 05:14:30'),
(1008, 'm4', 'MASUK', '2025-12-02 12:05:59'),
(1009, 'm3', 'MASUK', '2025-12-02 09:54:24'),
(1010, 'c3', 'MASUK', '2025-12-02 03:51:54'),
(1011, 'm6', 'MASUK', '2025-12-02 23:08:45'),
(1012, 'c4', 'MASUK', '2025-12-02 09:02:58'),
(1013, 'm4', 'MASUK', '2025-12-02 18:39:56'),
(1014, 'm4', 'MASUK', '2025-12-02 21:16:38'),
(1015, 'c5', 'MASUK', '2025-12-02 04:41:51'),
(1016, 'c3', 'MASUK', '2025-12-02 16:36:03'),
(1017, 'c5', 'MASUK', '2025-12-02 22:23:09'),
(1018, 'm2', 'MASUK', '2025-12-02 12:49:33'),
(1019, 'c4', 'MASUK', '2025-12-02 21:36:18'),
(1020, 'm3', 'MASUK', '2025-12-02 15:07:39'),
(1021, 'm6', 'MASUK', '2025-12-02 14:12:15'),
(1022, 'm3', 'MASUK', '2025-12-02 15:10:56'),
(1023, 'c3', 'MASUK', '2025-12-02 02:58:31'),
(1024, 'm3', 'MASUK', '2025-12-02 22:35:09'),
(1025, 'c1', 'MASUK', '2025-12-02 16:19:32'),
(1026, 'm4', 'MASUK', '2025-12-02 03:32:13'),
(1027, 'm1', 'MASUK', '2025-12-02 16:04:15'),
(1028, 'c1', 'MASUK', '2025-12-02 12:29:52'),
(1029, 'm5', 'MASUK', '2025-12-02 20:34:17'),
(1030, 'm4', 'MASUK', '2025-12-02 00:42:29'),
(1031, 'c4', 'MASUK', '2025-12-02 04:55:02'),
(1032, 'm1', 'MASUK', '2025-12-02 07:04:24'),
(1033, 'm5', 'MASUK', '2025-12-02 00:38:04'),
(1034, 'c5', 'MASUK', '2025-12-02 22:27:25'),
(1035, 'm4', 'MASUK', '2025-12-02 14:40:34'),
(1036, 'm5', 'MASUK', '2025-12-02 12:00:31'),
(1037, 'm2', 'MASUK', '2025-12-02 09:08:33'),
(1038, 'c5', 'MASUK', '2025-12-02 03:41:57'),
(1039, 'm4', 'MASUK', '2025-12-02 19:49:43'),
(1040, 'c2', 'MASUK', '2025-12-02 15:44:44'),
(1041, 'm1', 'MASUK', '2025-12-02 05:36:23'),
(1042, 'c2', 'MASUK', '2025-12-02 11:56:18'),
(1043, 'm4', 'MASUK', '2025-12-02 20:53:59'),
(1044, 'c4', 'MASUK', '2025-12-02 10:22:33'),
(1045, 'm2', 'MASUK', '2025-12-03 02:35:42'),
(1046, 'm4', 'MASUK', '2025-12-03 16:06:32'),
(1047, 'c4', 'MASUK', '2025-12-03 04:46:23'),
(1048, 'm2', 'MASUK', '2025-12-03 21:36:20'),
(1049, 'm6', 'MASUK', '2025-12-03 13:03:35'),
(1050, 'm4', 'MASUK', '2025-12-03 02:15:56'),
(1051, 'm6', 'MASUK', '2025-12-03 17:58:38'),
(1052, 'c4', 'MASUK', '2025-12-03 13:54:52'),
(1053, 'm3', 'MASUK', '2025-12-03 14:03:27'),
(1054, 'c2', 'MASUK', '2025-12-03 10:42:13'),
(1055, 'c1', 'MASUK', '2025-12-03 09:57:35'),
(1056, 'c1', 'MASUK', '2025-12-03 15:00:05'),
(1057, 'm1', 'MASUK', '2025-12-03 23:32:44'),
(1058, 'c2', 'MASUK', '2025-12-03 06:06:41'),
(1059, 'c2', 'MASUK', '2025-12-03 11:01:44'),
(1060, 'm2', 'MASUK', '2025-12-03 22:43:49'),
(1061, 'm6', 'MASUK', '2025-12-03 09:01:58'),
(1062, 'm4', 'MASUK', '2025-12-03 20:06:53'),
(1063, 'c2', 'MASUK', '2025-12-03 23:30:35'),
(1064, 'm1', 'MASUK', '2025-12-03 13:20:05'),
(1065, 'c5', 'MASUK', '2025-12-03 18:37:48'),
(1066, 'c3', 'MASUK', '2025-12-03 12:58:20'),
(1067, 'm4', 'MASUK', '2025-12-03 20:55:03'),
(1068, 'm2', 'MASUK', '2025-12-03 13:14:26'),
(1069, 'm1', 'MASUK', '2025-12-03 04:23:27'),
(1070, 'c1', 'MASUK', '2025-12-03 23:37:14'),
(1071, 'c4', 'MASUK', '2025-12-03 01:11:49'),
(1072, 'm1', 'MASUK', '2025-12-03 04:23:22'),
(1073, 'm3', 'MASUK', '2025-12-03 06:23:07'),
(1074, 'c5', 'MASUK', '2025-12-03 20:54:00'),
(1075, 'c4', 'MASUK', '2025-12-03 11:26:49'),
(1076, 'm4', 'MASUK', '2025-12-03 09:34:46'),
(1077, 'c2', 'MASUK', '2025-12-03 07:10:56'),
(1078, 'c2', 'MASUK', '2025-12-03 22:18:43'),
(1079, 'm3', 'MASUK', '2025-12-03 00:17:20'),
(1080, 'm4', 'MASUK', '2025-12-03 23:28:29'),
(1081, 'm6', 'MASUK', '2025-12-03 12:37:34'),
(1082, 'm6', 'MASUK', '2025-12-03 04:57:16'),
(1083, 'm1', 'MASUK', '2025-12-03 16:53:24'),
(1084, 'c5', 'MASUK', '2025-12-03 18:39:56'),
(1085, 'm4', 'MASUK', '2025-12-03 23:37:09'),
(1086, 'm6', 'MASUK', '2025-12-03 05:22:08'),
(1087, 'm2', 'MASUK', '2025-12-03 11:36:37'),
(1088, 'c4', 'MASUK', '2025-12-03 13:02:28'),
(1089, 'c3', 'MASUK', '2025-12-03 15:34:56'),
(1090, 'm6', 'MASUK', '2025-12-03 00:13:01'),
(1091, 'c5', 'MASUK', '2025-12-03 03:23:33');

-- --------------------------------------------------------

--
-- Table structure for table `parkiran`
--

CREATE TABLE `parkiran` (
  `slot` varchar(10) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parkiran`
--

INSERT INTO `parkiran` (`slot`, `status`) VALUES
('c1', 0),
('c10', 0),
('c2', 0),
('c3', 0),
('c4', 0),
('c5', 0),
('c6', 0),
('c7', 0),
('c8', 0),
('c9', 1),
('m1', 1),
('m10', 0),
('m11', 0),
('m12', 0),
('m13', 0),
('m14', 0),
('m15', 0),
('m16', 0),
('m17', 0),
('m18', 0),
('m19', 0),
('m2', 1),
('m20', 0),
('m21', 0),
('m22', 0),
('m23', 0),
('m24', 0),
('m25', 0),
('m26', 0),
('m27', 0),
('m28', 0),
('m29', 0),
('m3', 1),
('m30', 0),
('m31', 0),
('m32', 0),
('m33', 0),
('m34', 0),
('m35', 0),
('m36', 0),
('m37', 0),
('m38', 0),
('m39', 0),
('m4', 1),
('m40', 0),
('m41', 0),
('m42', 0),
('m43', 0),
('m44', 0),
('m45', 0),
('m46', 0),
('m47', 0),
('m48', 0),
('m5', 0),
('m6', 0),
('m7', 0),
('m8', 0),
('m9', 0);

-- --------------------------------------------------------

--
-- Table structure for table `reset`
--

CREATE TABLE `reset` (
  `id` int(11) NOT NULL,
  `last_reset` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reset`
--

INSERT INTO `reset` (`id`, `last_reset`) VALUES
(1, '2025-12-02 10:53:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `log_parkiran`
--
ALTER TABLE `log_parkiran`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `parkiran`
--
ALTER TABLE `parkiran`
  ADD PRIMARY KEY (`slot`);

--
-- Indexes for table `reset`
--
ALTER TABLE `reset`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `log_parkiran`
--
ALTER TABLE `log_parkiran`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1092;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
