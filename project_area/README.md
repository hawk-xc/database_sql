# trigger table trans

```bash
DELIMITER $$
CREATE TRIGGER `before_insert_trans` BEFORE INSERT ON `trans` FOR EACH ROW BEGIN
SET @stok = (SELECT stok FROM obat WHERE id_obat = NEW.id_obat);
SET @sisa = @stok - NEW.jumlah;
IF @sisa < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; END IF;
UPDATE obat SET stok = @sisa WHERE id_obat = NEW.id_obat;
END
$$

DELIMITER $$
CREATE TRIGGER `update_before_trans` BEFORE UPDATE ON `trans` FOR EACH ROW  BEGIN IF OLD.id_obat = NEW.id_obat THEN SET @stok = (SELECT stok FROM obat WHERE id_obat = OLD.id_obat); SET @sisa = (@stok + OLD.jumlah) - NEW.jumlah; IF @sisa < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup';  END IF; UPDATE obat SET stok = @sisa WHERE id_obat = OLD.id_obat; ELSE SET @stok_lama = (SELECT stok FROM obat WHERE id_obat = OLD.id_obat); SET @sisa_lama = (@stok_lama + OLD.jumlah); UPDATE obat SET stok = @sisa_lama WHERE id_obat = OLD.id_obat; SET @stok_baru = (SELECT stok FROM obat WHERE id_obat = NEW.id_obat); SET @sisa_baru = @stok_baru - NEW.jumlah; IF @sisa_baru < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; END IF; UPDATE obat SET stok = @sisa_baru WHERE id_obat = NEW.id_obat; END IF; END
$$

DELIMITER $$
CREATE TRIGGER `delete_after_trans` AFTER DELETE ON `trans` FOR EACH ROW 
BEGIN
SET @stok = (SELECT stok FROM obat WHERE id_obat = OLD.id_obat);
SET @sisa = @stok + OLD.jumlah;
UPDATE obat SET stok = @sisa WHERE id_obat = OLD.id_obat;
END
$$
```

# trigger table nota
```bash
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

DELIMITER $$
CREATE TRIGGER `update_before_trans_to_nota` BEFORE UPDATE ON `trans` FOR EACH ROW BEGIN 
IF OLD.id_trans = NEW.id_trans THEN
SET @harga = (SELECT harga FROM obat WHERE id_obat = NEW.id_obat);
SET @total_baru = @harga * NEW.jumlah;
UPDATE nota SET total = @total_baru WHERE id_trans = NEW.id_trans; 
END IF; 
END
$$
```