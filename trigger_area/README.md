TRIGGER

Fungsi Trigger :
Mengeksekusi script sql secara otomatis ketika terjadi perubahan pada sebuah tabel.
Menjaga integritas data.
Mencegah proses perubahan yang tidak dibenarkan atau tidak sah.

Manfaat Trigger :
Aplikasi yang dibuat menjadi lebih cepat jika dibandingkan menulis langsung script sql di kode program.
Reusable, artinya ketika terjadi migrasi atau perpindahan bahasa pemrograman 
maka kita tidak perlu menulis
ulang script sql di source code aplikasi.
Mudah untuk di maintenance.

Insert
Trigger ketika insert merupakan sebuah kondisi dimana menjalankan script sql 
ketika perintah insert pada sebuah tabel dieksekusi. Trigger di proses insert terdapat 
dua buah kejadian, yakni BEFORE dan AFTER. BEFORE akan di eksekusi sebelum 
perintah insert dijalankan, sedangkan AFTER sendiri akan di eksekusi ketika perintah 
insert selesai dijalankan. Pada saat membuat trigger, bagian script eksekusi 
biasanya perlu mengambil nilai field dari tabel yang berubah tersebut. 
Cara mengambil nilai field tersebut adalah dengan keyword NEW dan diikuti dengan nama field ditabel.

Update
Trigger update akan dieksekusi ketika perintah update di jalankan pada sebuah tabel. 
Sama seperti trigger insert, trigger update juga terdapat dua buah kejadian yakni BEFORE dan AFTER.
Perbedaannya adalah trigger update terdapat keyword NEW dan OLD sedangkan trigger insert hanya keyword 
NEW. Dimana keyword NEW digunakan untuk mengambil field tabel yang baru saja diubah nilainya,
sedangkan keyword OLD digunakan untuk mengambil nilai field sebelum diubah.

Delete
Terakhir adalah trigger delete. Trigger ini akan di eksekusi ketika data pada sebuah tabel dihapus. 
Sama seperti kedua trigger diatas, trigger ini juga memiliki dua buah kejadian.
Perbedaannya adalah trigger delete hanya memiliki keyword OLD untuk mengambil nilai field.

Perintah. Buat database barang_inventoryDB

Mulai membuat trigger dengan ketentuan syarat

1. Stok di tabel items akan otomatis ter-update pada saat dilakukan insert, 
   update ataupun delete di tabel transaction.
2. Sebelum melakukan insert, pertama cek terlebih dahulu stok di tabel items.
   Dimana stok di tabel items tidak boleh kurang dari 0 pada saat terjadi transaksi 
   pada tabel transaction.
3. Pada saat melakukan update data di tabel transaction, jika jumlah qty yang baru 
   di masukkan lebih kecil dari qty yang sebelumnya (qty lama), maka stok 
   yang ada di tabel items akan otomatis bertambah, begitu juga sebaliknya stok akan berkurang 
   jika qty baru lebih besar dari qty sebelumnya.
4. Pada saat setelah terjadi proses delete, stok di tabel items akan otomatis bertambah.



INSERT BEFORE
Trigger yang pertama yang akan kita buat adalah trigger insert before. 
Trigger ini sendiri akan melakukan pengecekan pada saat ada penambahan baris data baru 
pada tabel transaction, dimana jika qty yang akan dijual dikurangi stok yang ada di item 
tidak boleh kurang dari nol. Script sql-nya adalah seperti dibawah ini :

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



Pada script diatas trigger dengan nama `transaction_insert_before` pada tabel transaction. 
Pada baris berikutnya kita membuat variabel `@stok` dan mengisinya dengan stok yang ada di tabel items, 
sesuai dengan id_item yang dimasukkan ditabel transaction. Selanjutnya kita 
membuat variabel sisa yang isinya adalah hasil pengurangan antara stok dengan qty yang 
dimasukkan dari tabel transaction. Kemudian dilakukan cek apakah hasil pengurangan tadi kurang dari nol? 
Jika iya, maka kita akan menghentikan operasi insert ditabel transaction dengan melemparkan pesan 
kesalalahan SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Warning: stok tidak cukup'; . 
Namun jika sisa tidak kurang dari nol, maka kita akan meng-update stok yang ada ditabel items 
dengan nilai yang ditampung di variabel sisa tadi. Hasilnya jika memasukkan qty melebihi 
stok yang ada ditabel items, maka akan muncul pesan kesalahan seperti ini pada saat insert 
transaction :



UPDATE BEFORE
Trigger ini akan melakukan pengecekan pada saat tabel transaction melakukan proses update data. 
Dimana rule yang telah ditentukan diatas, maka script sql untuk membuat trigger update before 
adalah sebagai berikut :

CREATE  TRIGGER `transaction_update_before` BEFORE UPDATE ON `transaction` FOR EACH ROW 
BEGIN
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


Saat membuat trigger update, kita melihat bahwa disana ada keyword NEW dan OLD.
Keyword NEW disini berarti merupakan nilai sebuah field yang baru saja diubah, 
sedangkan untuk OLD adalah nilai field yang sebelumnya atau yang lama. Sama seperti trigger insert, 
melakukan pengecekan jika kondisi tidak sesuai dengan yang diinginkan maka akan memberikan 
pesan kesalahan dalam bentuk SIGNAL SQLSTATE '45000' .

DELETE AFTER
Untuk terakhir, adalah trigger delete after. Trigger ini akan dieksekusi 
setelah proses delete terjadi. Script-nya adalah sebagai berikut :

CREATE TRIGGER `transaction_delete_after` AFTER DELETE ON `transaction` FOR EACH ROW 
BEGIN
SET @stok = (SELECT stok FROM items WHERE id_item = OLD.id_item);
SET @sisa = @stok + OLD.qty;
UPDATE items SET stok = @sisa WHERE id_item = OLD.id_item;
END

Mengikuti rule yang telah dibuat sebelumnya, yakni jika ada baris data yang dihapus pada
tabel transaction, maka stok pada tabel items akan bertambah sesuai dengan jumlah qty yang dihapus 
pada tabel transaction.
