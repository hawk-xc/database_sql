-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 26 Jun 2023 pada 16.56
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `puskesmas_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `dokter`
--

CREATE TABLE `dokter` (
  `kode_dok` char(10) NOT NULL,
  `nama_dok` varchar(25) DEFAULT NULL,
  `kelamin` char(15) DEFAULT NULL,
  `spesialis` varchar(30) DEFAULT NULL,
  `alamat_dok` varchar(60) DEFAULT NULL,
  `kota` char(25) DEFAULT NULL,
  `telp_dok` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `dokter`
--

INSERT INTO `dokter` (`kode_dok`, `nama_dok`, `kelamin`, `spesialis`, `alamat_dok`, `kota`, `telp_dok`) VALUES
('D0001', 'Moch.Yusuf', 'Pria', 'Anak', 'Jl. Sudirman No. 100', 'Cimahi Selatan', '022-1234567'),
('D0002', 'Dinda Indah', 'Wanita', 'Kandungan', 'LPH, Lembah Mawar No.122', 'Cimahi Utara', '022-5612345'),
('D0003', 'Gede Watumbara', 'Pria', 'Kandungan', 'LPH, Lembah Anggrek No.200', 'Cimahi Utara', '022-4567123'),
('D0004', 'Dwi Nugroho', 'Pria', 'Penyakit Dalam', 'Jl. Raya Cimahi No. 502', 'Cimahi Selatan', '022-4512367');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kamar`
--

CREATE TABLE `kamar` (
  `kode_kamar` int(11) NOT NULL,
  `kode_pas` char(10) NOT NULL,
  `kode_obat` char(10) NOT NULL,
  `status` enum('rawat_inap','rawat_jalan') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `obat`
--

CREATE TABLE `obat` (
  `kode_obat` char(10) NOT NULL,
  `nama_obat` varchar(25) DEFAULT NULL,
  `jenis` varchar(40) DEFAULT NULL,
  `kemasan` char(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `harga_obat` decimal(12,0) DEFAULT NULL,
  `jumlah_obat` decimal(12,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `obat`
--

INSERT INTO `obat` (`kode_obat`, `nama_obat`, `jenis`, `kemasan`, `harga_obat`, `jumlah_obat`) VALUES
('A0001', 'Ampisilin kaplet 250 mg', 'Generic', 'ktk 10 x 10 kaplet', '36315', '5'),
('A0002', 'Amoksisilin kaplet 500 mg', 'Generic', 'ktk 10 x 10 kaplet', '49950', '2'),
('B0001', 'Betametason tablet 0,5 mg', 'Generic', 'ktk 10 x 10 tablet', '9446', '15'),
('E0001', 'Eritromisin kapsul 250 mg', 'Generic', 'ktk 10 x 10 kapsul', '68040', '10'),
('P0001', 'Parasetamol sirup 120 mg ', 'Generic', 'btl 60 ml', '3105', '20'),
('P0002', 'Parasetamol tablet 500 mg', 'Generic', 'btl 1000 tablet', '67500', '25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pasien`
--

CREATE TABLE `pasien` (
  `kode_pas` char(10) NOT NULL,
  `nama_pas` varchar(40) DEFAULT NULL,
  `jenis_kel` char(10) DEFAULT NULL,
  `usia` char(15) DEFAULT NULL,
  `pekerjaan` char(30) DEFAULT NULL,
  `ktp` varchar(15) DEFAULT NULL,
  `alamat_rumah` varchar(50) DEFAULT NULL,
  `telepon` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pasien`
--

INSERT INTO `pasien` (`kode_pas`, `nama_pas`, `jenis_kel`, `usia`, `pekerjaan`, `ktp`, `alamat_rumah`, `telepon`) VALUES
('P0001', 'Dewi Lestari', 'Wanita', '30', 'ASN', '11.001', 'LPH, Lembah Anggrek No.100', '022-1234567'),
('P0002', 'Didin', 'Pria', '31', 'ASN', '11.002', 'LPH, Lembah Mawar No.122', '022-5612345'),
('P0003', 'Amirudin', 'Pria', '35', 'ASN', '12.001', 'LPH, Lembah Anggrek No.120', '022-4567123'),
('P0004', 'Dinda Lestari', 'Wanita', '25', 'ASN', '11.003', 'LPH, Lembah Kenanga Y12', '022-1267345'),
('P0005', 'Ketut Darmayuda', 'Pria', '40', 'Pegawai Swasta', '11.004', 'LPH, Lembah Kenanga Y14', '022-1324675'),
('P0006', 'Darmayuda Ketut', 'Pria', '40', 'Pegawai Swasta', '11.001', 'LPH, Lembah Anggrek No.117', '022-1234567'),
('P0007', 'Dwi Yuni Purwandari', 'Wanita', '35', 'Pegawai Swasta', '11.010', 'LPH, Melati No.100', '022-1234567'),
('P0008', 'Winsu R.', 'Pria', '30', 'ASN', '11.011', 'LPH, Lembah Anggrek No.100', '022-1234567'),
('P0009', 'Achmad Dwi Margono', 'Pria', '33', 'Pegawai Swasta', '13.001', 'LPH, Lembah Melati No.100', '022-1234567');

-- --------------------------------------------------------

--
-- Struktur dari tabel `periksa`
--

CREATE TABLE `periksa` (
  `kode_periksa` char(10) NOT NULL,
  `kode_pas` char(10) NOT NULL,
  `kode_dok` char(10) NOT NULL,
  `kode_obat` char(10) NOT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `total_harga` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `periksa`
--
DELIMITER $$
CREATE TRIGGER `after_insert_periksa_lanjut` AFTER INSERT ON `periksa` FOR EACH ROW BEGIN
SET @OBAT = (SELECT kode_obat FROM obat WHERE kode_obat = NEW.kode_obat);
INSERT INTO kamar (kode_pas, kd_obat, status) VALUES (NEW.kode_pas, @OBAT, 'rawat_inap');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_periksa` BEFORE INSERT ON `periksa` FOR EACH ROW BEGIN
SET @stok = (SELECT stok FROM obat WHERE kode_obat = NEW.kode_obat);
SET @sisa = @stok - NEW.jumlah;
IF @sisa < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; END IF;
UPDATE obat SET stok = @sisa WHERE kode_obat = NEW.kode_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `delete_after_periksa` AFTER DELETE ON `periksa` FOR EACH ROW BEGIN
SET @stok = (SELECT stok FROM obat WHERE kode_obat = OLD.kode_obat);
SET @sisa = @stok + OLD.jumlah;
UPDATE obat SET stok = @sisa WHERE kode_obat = OLD.kode_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_before_periksa` BEFORE UPDATE ON `periksa` FOR EACH ROW BEGIN IF OLD.kode_obat = NEW.kode_obat THEN SET @stok = (SELECT stok FROM obat WHERE kode_obat = OLD.kode_obat); SET @sisa = (@stok + OLD.jumlah) - NEW.jumlah; IF @sisa < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup';  END IF; UPDATE obat SET stok = @sisa WHERE kode_obat = OLD.kode_obat; ELSE SET @stok_lama = (SELECT stok FROM obat WHERE kode_obat = OLD.kode_obat); SET @sisa_lama = (@stok_lama + OLD.jumlah); UPDATE obat SET stok = @sisa_lama WHERE kode_obat = OLD.kode_obat; SET @stok_baru = (SELECT stok FROM obat WHERE kode_obat = NEW.kode_obat); SET @sisa_baru = @stok_baru - NEW.jumlah; IF @sisa_baru < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; END IF; UPDATE obat SET stok = @sisa_baru WHERE kode_obat = NEW.kode_obat; END IF; END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `periksa_lanjut`
--

CREATE TABLE `periksa_lanjut` (
  `kode_per_lanjut` char(10) NOT NULL,
  `kode_periksa` char(10) NOT NULL,
  `kode_kamar` int(11) DEFAULT NULL,
  `lama` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`kode_dok`);

--
-- Indeks untuk tabel `kamar`
--
ALTER TABLE `kamar`
  ADD PRIMARY KEY (`kode_kamar`);

--
-- Indeks untuk tabel `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`kode_obat`);

--
-- Indeks untuk tabel `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`kode_pas`);

--
-- Indeks untuk tabel `periksa`
--
ALTER TABLE `periksa`
  ADD PRIMARY KEY (`kode_periksa`),
  ADD KEY `FK_pasien` (`kode_pas`),
  ADD KEY `FK_dokter` (`kode_dok`),
  ADD KEY `FK_obat` (`kode_obat`);

--
-- Indeks untuk tabel `periksa_lanjut`
--
ALTER TABLE `periksa_lanjut`
  ADD PRIMARY KEY (`kode_per_lanjut`),
  ADD KEY `FK_periksa` (`kode_periksa`),
  ADD KEY `FK_kamar` (`kode_kamar`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `kamar`
--
ALTER TABLE `kamar`
  MODIFY `kode_kamar` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `periksa`
--
ALTER TABLE `periksa`
  ADD CONSTRAINT `FK_dokter` FOREIGN KEY (`kode_dok`) REFERENCES `dokter` (`kode_dok`),
  ADD CONSTRAINT `FK_obat` FOREIGN KEY (`kode_obat`) REFERENCES `obat` (`kode_obat`),
  ADD CONSTRAINT `FK_pasien` FOREIGN KEY (`kode_pas`) REFERENCES `pasien` (`kode_pas`);

--
-- Ketidakleluasaan untuk tabel `periksa_lanjut`
--
ALTER TABLE `periksa_lanjut`
  ADD CONSTRAINT `FK_kamar` FOREIGN KEY (`kode_kamar`) REFERENCES `kamar` (`kode_kamar`),
  ADD CONSTRAINT `FK_periksa` FOREIGN KEY (`kode_periksa`) REFERENCES `periksa` (`kode_periksa`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
