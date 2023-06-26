-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 26, 2023 at 08:04 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

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
('A-02', 'Dewancha', 'Gudang'),
('A-03', 'dicky', 'apoteker'),
('A-04', 'gundala', 'pemimpin'),
('A-05', 'diana', 'apoteker'),
('A-06', 'jordan', 'Quality Control'),
('A-07', 'gunawan', 'kepala jabatan'),
('A-08', 'prili', 'wakil pemimpin'),
('A-09', 'dwiky', 'laboratary'),
('A-10', 'asep', 'kasir');

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
('U-1', 'Denny', 'demam', '088783493234', 19),
('U-10', 'agung', 'pilek', '324953503294', 10),
('U-11', 'demian', 'scabies', '095209403223', 45),
('U-12', 'juki', 'demam', '082308503232', 21),
('U-13', 'fitri', 'migrain', '008058324323', 45),
('U-14', 'permadi', 'demam', '085673283244', 57),
('U-15', 'gifarry', 'pilek', '089989523223', 14),
('U-16', 'grace', 'mencret', '089949342455', 24),
('U-17', 'cici', 'luka', '089895343432', 28),
('U-18', 'kirana', 'nyeri', '089878786343', 20),
('U-19', 'doky', 'maag', '089938472344', 23),
('U-2', 'Dimas', 'masuk angin', '088989763432', 20),
('U-20', 'salman', 'nyeri', '088763742342', 21),
('U-21', 'joni', 'cacar', '089738242343', 38),
('U-3', 'Dafiyan', 'sakit gigi', '089989975324', 21),
('U-4', 'Maulana', 'sembelit', '82266671261', 21),
('U-5', 'lucky', 'cacar', '083449284332', 18),
('U-6', 'erick', 'alergidingin', '9374924029741', 29),
('U-7', 'prasetyo', 'hipertensi', '113122435326', 23),
('U-8', 'agus', 'biangkringet', '937240923040', 17),
('U-9', 'mamat', 'batuk', '093240932432', 28);

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
