SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- -------------------------
-- TABLE: parkiran
-- -------------------------

DROP TABLE IF EXISTS `parkiran`;
CREATE TABLE `parkiran` (
  `slot` varchar(10) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tambahkan slot default (opsional)
INSERT INTO `parkiran` (`slot`, `status`) VALUES
('m1', 1), ('m2', 0), ('m3', 0), ('m4', 0), ('m5', 0), ('m6', 0),
('m7', 0), ('m8', 0), ('m9', 0), ('m10', 0), ('m11', 0), ('m12', 0),
('m13', 0), ('m14', 0), ('m15', 0), ('m16', 0), ('m17', 0), ('m18', 0),
('m19', 0), ('m20', 0), ('m21', 0), ('m22', 0), ('m23', 0), ('m24', 0),
('m25', 0), ('m26', 0), ('m27', 0), ('m28', 0), ('m29', 0), ('m30', 0),
('m31', 0), ('m32', 0), ('m33', 0), ('m34', 0), ('m35', 0), ('m36', 0),
('m37', 0), ('m38', 0), ('m39', 0), ('m40', 0), ('m41', 0), ('m42', 0),
('m43', 0), ('m44', 0), ('m45', 0), ('m46', 0), ('m47', 0), ('m48', 0),
('c1', 0), ('c2', 0), ('c3', 0), ('c4', 0), ('c5', 0),
('c6', 0), ('c7', 0), ('c8', 0), ('c9', 0), ('c10', 0);

-- -------------------------
-- TABLE: log_parkiran
-- -------------------------

DROP TABLE IF EXISTS `log_parkiran`;
CREATE TABLE `log_parkiran` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slot` varchar(10) NOT NULL,
  `keterangan` varchar(10) NOT NULL,
  `waktu` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tidak ada INSERT otomatis (server Flask akan mengisi)


-- -------------------------
-- TABLE: reset
-- -------------------------

DROP TABLE IF EXISTS `reset`;
CREATE TABLE `reset` (
  `id` int(11) NOT NULL,
  `last_reset` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `reset` (`id`, `last_reset`) VALUES
(1, NOW() - INTERVAL 8 DAY);


COMMIT;