-- phpMyAdmin SQL Dump
-- version 5.0.4deb2+deb11u1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 25, 2023 at 10:34 PM
-- Server version: 10.11.4-MariaDB
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `meta_farma`
--

-- --------------------------------------------------------

--
-- Table structure for table `apoteker`
--

CREATE TABLE `apoteker` (
  `id_apoteker` char(10) NOT NULL,
  `nama_apoteker` varchar(30) NOT NULL,
  `jabatan` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `apoteker`
--

INSERT INTO `apoteker` (`id_apoteker`, `nama_apoteker`, `jabatan`) VALUES
('A-01', 'Wahyu Tri', 'apoteker'),
('A-02', 'Dewancha', 'Gudang');

-- --------------------------------------------------------

--
-- Table structure for table `nota`
--

CREATE TABLE `nota` (
  `id_nota` int(11) NOT NULL,
  `id_trans` char(10) NOT NULL,
  `id_obat` char(10) NOT NULL,
  `id_pel` char(10) NOT NULL,
  `nama_pelanggan` varchar(30) NOT NULL,
  `nama_apoteker` varchar(30) NOT NULL,
  `harga` float DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `id_obat` char(10) NOT NULL,
  `nama_obat` varchar(30) NOT NULL,
  `stok` int(11) DEFAULT NULL,
  `harga` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`id_obat`, `nama_obat`, `stok`, `harga`) VALUES
('MN01', 'Ibuprofen', 45, 12000),
('MN02', 'Asipilin', 60, 2000),
('MN03', 'Biofarma', 34, 50000);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pel` char(10) NOT NULL,
  `nama_pel` varchar(30) NOT NULL,
  `riwayat` varchar(30) DEFAULT NULL,
  `no_telp` char(15) DEFAULT NULL,
  `usia` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pel`, `nama_pel`, `riwayat`, `no_telp`, `usia`) VALUES
('U-1', 'Denny', NULL, NULL, 19),
('U-2', 'Dimas', NULL, NULL, 20),
('U-3', 'Dafiyan', NULL, NULL, 21);

-- --------------------------------------------------------

--
-- Table structure for table `trans`
--

CREATE TABLE `trans` (
  `id_trans` char(10) NOT NULL,
  `id_obat` char(10) NOT NULL,
  `id_pel` char(10) NOT NULL,
  `id_apoteker` char(10) NOT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `tanggal` date DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `trans`
--
DELIMITER $$
CREATE TRIGGER `after_insert_trans` AFTER INSERT ON `trans` FOR EACH ROW BEGIN
SET @pelanggan = (SELECT nama_pel FROM pelanggan where id_pel = NEW.id_pel);
SET @apoteker = (SELECT nama_apoteker FROM apoteker where id_apoteker = NEW.id_apoteker);
SET @harga = (SELECT harga FROM obat WHERE id_obat = NEW.id_obat);
SET @total = @harga * NEW.jumlah;
SET @stok = (SELECT stok FROM obat WHERE id_obat = NEW.id_obat);
INSERT INTO nota (id_trans, id_obat, id_pel, nama_pelanggan, nama_apoteker, harga, jumlah, total) VALUES (NEW.id_trans, NEW.id_obat, NEW.id_pel, @pelanggan, @apoteker, @harga, NEW.jumlah, @total);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_trans` BEFORE INSERT ON `trans` FOR EACH ROW BEGIN
SET @stok = (SELECT stok FROM obat WHERE id_obat = NEW.id_obat);
SET @sisa = @stok - NEW.jumlah;
IF @sisa < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; END IF;
UPDATE obat SET stok = @sisa WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_after_trans` AFTER DELETE ON `trans` FOR EACH ROW BEGIN
SET @stok = (SELECT stok FROM obat WHERE id_obat = OLD.id_obat);
SET @sisa = @stok + OLD.jumlah;
UPDATE obat SET stok = @sisa WHERE id_obat = OLD.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_before_trans` BEFORE UPDATE ON `trans` FOR EACH ROW BEGIN IF OLD.id_obat = NEW.id_obat THEN SET @stok = (SELECT stok FROM obat WHERE id_obat = OLD.id_obat); SET @sisa = (@stok + OLD.jumlah) - NEW.jumlah; IF @sisa < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup';  END IF; UPDATE obat SET stok = @sisa WHERE id_obat = OLD.id_obat; ELSE SET @stok_lama = (SELECT stok FROM obat WHERE id_obat = OLD.id_obat); SET @sisa_lama = (@stok_lama + OLD.jumlah); UPDATE obat SET stok = @sisa_lama WHERE id_obat = OLD.id_obat; SET @stok_baru = (SELECT stok FROM obat WHERE id_obat = NEW.id_obat); SET @sisa_baru = @stok_baru - NEW.jumlah; IF @sisa_baru < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; END IF; UPDATE obat SET stok = @sisa_baru WHERE id_obat = NEW.id_obat; END IF; END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_before_trans_to_nota` BEFORE UPDATE ON `trans` FOR EACH ROW BEGIN 
IF OLD.id_trans = NEW.id_trans THEN
SET @harga = (SELECT harga FROM obat WHERE id_obat = NEW.id_obat);
SET @total_baru = @harga * NEW.jumlah;
UPDATE nota SET total = @total_baru WHERE id_trans = NEW.id_trans; 
END IF; 
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `apoteker`
--
ALTER TABLE `apoteker`
  ADD PRIMARY KEY (`id_apoteker`);

--
-- Indexes for table `nota`
--
ALTER TABLE `nota`
  ADD PRIMARY KEY (`id_nota`),
  ADD KEY `FK_trans` (`id_trans`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`id_obat`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pel`),
  ADD UNIQUE KEY `id_pel` (`id_pel`);

--
-- Indexes for table `trans`
--
ALTER TABLE `trans`
  ADD PRIMARY KEY (`id_trans`),
  ADD KEY `FK_obat` (`id_obat`),
  ADD KEY `FK_pel` (`id_pel`),
  ADD KEY `FK_apoteker` (`id_apoteker`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `nota`
--
ALTER TABLE `nota`
  MODIFY `id_nota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `nota`
--
ALTER TABLE `nota`
  ADD CONSTRAINT `FK_trans` FOREIGN KEY (`id_trans`) REFERENCES `trans` (`id_trans`);

--
-- Constraints for table `trans`
--
ALTER TABLE `trans`
  ADD CONSTRAINT `FK_apoteker` FOREIGN KEY (`id_apoteker`) REFERENCES `apoteker` (`id_apoteker`),
  ADD CONSTRAINT `FK_obat` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`),
  ADD CONSTRAINT `FK_pel` FOREIGN KEY (`id_pel`) REFERENCES `pelanggan` (`id_pel`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
