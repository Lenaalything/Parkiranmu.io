-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 17, 2025 at 12:15 PM
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
('c1', 1),
('c10', 0),
('c2', 0),
('c3', 0),
('c4', 0),
('c5', 0),
('c6', 0),
('c7', 0),
('c8', 1),
('c9', 1),
('m1', 1),
('m10', 1),
('m11', 1),
('m12', 1),
('m13', 0),
('m14', 0),
('m15', 0),
('m16', 0),
('m17', 0),
('m18', 0),
('m19', 0),
('m2', 0),
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
('m3', 0),
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
('m5', 1),
('m6', 1),
('m7', 1),
('m8', 1),
('m9', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `parkiran`
--
ALTER TABLE `parkiran`
  ADD PRIMARY KEY (`slot`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
