-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 22, 2023 at 11:14 AM
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
-- Database: `inventory_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id_item` int NOT NULL,
  `nama_item` varchar(100) DEFAULT NULL,
  `harga` float(15,2) DEFAULT NULL,
  `stok` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id_item`, `nama_item`, `harga`, `stok`) VALUES
(1, 'Gula', 11000.00, 7),
(2, 'Kopi', 5000.00, 19),
(3, 'Susu', 8000.00, 25),
(4, 'Indomie', 2500.00, 10);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id_transaction` int NOT NULL,
  `id_item` int NOT NULL,
  `qty` int DEFAULT '1',
  `total` float(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id_transaction`, `id_item`, `qty`, `total`) VALUES
(100, 2, 1, 14.00),
(101, 1, 3, 12.00),
(102, 4, 5, 5000.00);

--
-- Triggers `transaction`
--
DELIMITER $$
CREATE TRIGGER `transaction_delete_after` AFTER DELETE ON `transaction` FOR EACH ROW BEGIN
SET @stok = (SELECT stok FROM items WHERE id_item = OLD.id_item);
SET @sisa = @stok + OLD.qty;
UPDATE items SET stok = @sisa WHERE id_item = OLD.id_item;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `transaction_insert_before` BEFORE INSERT ON `transaction` FOR EACH ROW BEGIN
SET @stok = (SELECT stok FROM items WHERE id_item = NEW.id_item);
SET @sisa = @stok - NEW.qty;
IF @sisa < 0 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; 
END IF;
UPDATE items SET stok = @sisa WHERE id_item = NEW.id_item;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `transaction_update_before` BEFORE UPDATE ON `transaction` FOR EACH ROW BEGIN
IF OLD.id_item = NEW.id_item THEN 
	SET @stok = (SELECT stok FROM items WHERE id_item = OLD.id_item);
	SET @sisa = (@stok + OLD.qty) - NEW.qty;
	IF @sisa < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; 
	END IF;
	UPDATE items SET stok = @sisa WHERE id_item = OLD.id_item;
ELSE
	SET @stok_lama = (SELECT stok FROM items WHERE id_item = OLD.id_item);
	SET @sisa_lama = (@stok_lama + OLD.qty);
	UPDATE items SET stok = @sisa_lama WHERE id_item = OLD.id_item;
	SET @stok_baru = (SELECT stok FROM items WHERE id_item = NEW.id_item);
	SET @sisa_baru = @stok_baru - NEW.qty;
	IF @sisa_baru < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; 
	END IF;
	UPDATE items SET stok = @sisa_baru WHERE id_item = NEW.id_item;
END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id_item`) USING BTREE;

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id_transaction`) USING BTREE,
  ADD KEY `FK__items` (`id_item`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id_item` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id_transaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `FK__items` FOREIGN KEY (`id_item`) REFERENCES `items` (`id_item`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
