-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 22, 2023 at 11:18 AM
-- Server version: 8.0.33
-- PHP Version: 8.1.2-1ubuntu2.11

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
-- Table structure for table `data_apoteker`
--

CREATE TABLE `data_apoteker` (
  `KD_apoteker` char(7) NOT NULL,
  `nama_apoteker` varchar(30) NOT NULL,
  `jabatan` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data_apoteker`
--

INSERT INTO `data_apoteker` (`KD_apoteker`, `nama_apoteker`, `jabatan`) VALUES
('APT001', 'Denny', 'Apoteker'),
('APT002', 'Dimas', 'Apoteker');

-- --------------------------------------------------------

--
-- Table structure for table `data_obat`
--

CREATE TABLE `data_obat` (
  `KD_obat` char(5) NOT NULL,
  `nama_obat` varchar(30) NOT NULL,
  `harga_obat` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data_obat`
--

INSERT INTO `data_obat` (`KD_obat`, `nama_obat`, `harga_obat`) VALUES
('MN010', 'Ibuprofen', '15000'),
('MN011', 'Biotin', '20000'),
('MN012', 'Cafepine', '30000'),
('MN013', 'Bupropion', '30000');

-- --------------------------------------------------------

--
-- Table structure for table `data_pelanggan`
--

CREATE TABLE `data_pelanggan` (
  `KD_pelanggan` char(5) NOT NULL,
  `nama_pelanggan` varchar(30) NOT NULL,
  `riwayat` varchar(30) DEFAULT 'TIDAK ADA RIWAYAT',
  `no_telp` varchar(30) DEFAULT NULL,
  `alamat` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data_pelanggan`
--

INSERT INTO `data_pelanggan` (`KD_pelanggan`, `nama_pelanggan`, `riwayat`, `no_telp`, `alamat`) VALUES
('USR01', 'Dafiyan', 'PENYAKIT JANTUNG', '0822212212312', 'Dusun Gedangan');

-- --------------------------------------------------------

--
-- Table structure for table `data_transaksi_obat`
--

CREATE TABLE `data_transaksi_obat` (
  `KD_transaksi` char(5) NOT NULL,
  `KD_obat` char(5) NOT NULL,
  `jumlah` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data_transaksi_obat`
--

INSERT INTO `data_transaksi_obat` (`KD_transaksi`, `KD_obat`, `jumlah`) VALUES
('TR001', 'MN010', 12);

-- --------------------------------------------------------

--
-- Table structure for table `data_transaksi_pelanggan`
--

CREATE TABLE `data_transaksi_pelanggan` (
  `KD_transaksi` char(5) NOT NULL,
  `KD_apoteker` char(7) NOT NULL,
  `KD_pelanggan` char(5) NOT NULL,
  `tanggal_transaksi` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data_transaksi_pelanggan`
--

INSERT INTO `data_transaksi_pelanggan` (`KD_transaksi`, `KD_apoteker`, `KD_pelanggan`, `tanggal_transaksi`) VALUES
('TR001', 'APT001', 'USR01', '2023-06-22 00:20:10');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `data_apoteker`
--
ALTER TABLE `data_apoteker`
  ADD PRIMARY KEY (`KD_apoteker`),
  ADD UNIQUE KEY `KD_apoteker` (`KD_apoteker`);

--
-- Indexes for table `data_obat`
--
ALTER TABLE `data_obat`
  ADD PRIMARY KEY (`KD_obat`),
  ADD UNIQUE KEY `KD_obat` (`KD_obat`);

--
-- Indexes for table `data_pelanggan`
--
ALTER TABLE `data_pelanggan`
  ADD PRIMARY KEY (`KD_pelanggan`),
  ADD UNIQUE KEY `KD_pelanggan` (`KD_pelanggan`);

--
-- Indexes for table `data_transaksi_obat`
--
ALTER TABLE `data_transaksi_obat`
  ADD PRIMARY KEY (`KD_transaksi`),
  ADD KEY `FK_transaksi_obat` (`KD_obat`);

--
-- Indexes for table `data_transaksi_pelanggan`
--
ALTER TABLE `data_transaksi_pelanggan`
  ADD UNIQUE KEY `KD_transaksi` (`KD_transaksi`),
  ADD UNIQUE KEY `KD_apoteker` (`KD_apoteker`),
  ADD UNIQUE KEY `KD_pelanggan` (`KD_pelanggan`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `data_transaksi_obat`
--
ALTER TABLE `data_transaksi_obat`
  ADD CONSTRAINT `FK_transaksi_obat` FOREIGN KEY (`KD_obat`) REFERENCES `data_obat` (`KD_obat`);

--
-- Constraints for table `data_transaksi_pelanggan`
--
ALTER TABLE `data_transaksi_pelanggan`
  ADD CONSTRAINT `FK_tr_apoteker` FOREIGN KEY (`KD_apoteker`) REFERENCES `data_apoteker` (`KD_apoteker`),
  ADD CONSTRAINT `FK_tr_obat` FOREIGN KEY (`KD_transaksi`) REFERENCES `data_transaksi_obat` (`KD_transaksi`),
  ADD CONSTRAINT `FK_tr_pelanggan` FOREIGN KEY (`KD_pelanggan`) REFERENCES `data_pelanggan` (`KD_pelanggan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
