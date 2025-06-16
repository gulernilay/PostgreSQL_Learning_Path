-----------------------------------------------------------OVERALL NOTES-------------------------------------------------- 

--UPDATE - updates data in a database
--DELETE - deletes data from a database
--INSERT INTO - inserts new data into a database
--CREATE DATABASE - creates a new database
--ALTER DATABASE - modifies a database
--CREATE TABLE - creates a new table
--ALTER TABLE - modifies a table
--DROP TABLE - deletes a table
--CREATE INDEX - creates an index (search key)
--DROP INDEX - deletes an index


--AGGREGATION FUNCTIONS 
--[INNER JOIN + DISTINCT]
--"Kiralama geçmişi olan farklı şehirlerdeki müşteri şehirlerini listele."

--[AGGREGATE: SUM, AVG]
--"Her ay toplam ne kadar kira geliri elde edilmiş? (payment tablosunu kullan)"

-- [SUBQUERY + IN]
-- "En az 3 film kiralamış müşterilerin adlarını getir."

-- [UPDATE]
-- "customer tablosunda active = 0 olan tüm müşterilerin store_id değerini 1 yap."

-- [DELETE]
-- "Hiç kiralama yapmamış müşterileri sil."

-- [CREATE TABLE + INSERT]
-- "Favori filmlerini tutacağın bir tablo oluştur ve içine 3 film ekle."

-- [VIEW + INDEX + ALIAS + COALESCE + CASE WHEN]
-- Hazır olduğunda sana aşağıdaki gelişmiş SQL başlıklarını da senaryolarla soracağım:

--INDEXING
--Veriye hızlı erişim sağlar.

CREATE INDEX idx_kitap_isim ON kitap(isim);


--VIEW : Hazır sorguları sanal tablo olarak kaydetmek için.

CREATE VIEW vw_aktif_musteriler AS
SELECT * FROM customer WHERE active = 1;

--USER DEFINED FUNCTION
--Kendi fonksiyonunu oluşturmak.
CREATE FUNCTION dbo.KDV_Ekle (@fiyat DECIMAL)
RETURNS DECIMAL
AS
BEGIN
    RETURN @fiyat * 1.20;
END;


--STORED PROCEDURE
--Komut setlerini saklayıp tekrar çalıştırmak.
CREATE PROCEDURE MusteriGetir @id INT
AS
BEGIN
    SELECT * FROM customer WHERE customer_id = @id;
END;



--TRIGGER
--Bir tabloya veri eklendiğinde/şart gerçekleştiğinde otomatik çalışan komut.
CREATE TRIGGER trg_log_rental
ON rental
AFTER INSERT
AS
BEGIN
    INSERT INTO rental_log(rental_id, log_time)
    SELECT rental_id, GETDATE() FROM inserted;
END

--TRANSACTION
--Birden fazla SQL işleminin tamamı başarılıysa kayıt eder.

BEGIN TRANSACTION;
    UPDATE stock SET adet = adet - 1 WHERE urun_id = 10;

INSERT INTO siparis(urun_id) VALUES(10);
COMMIT; -- veya ROLLBACK;


-- Temel SQL Nesneleri:
--TABLE			Verilerin tutulduğu ana yapı (tablolar)
--VIEW			Sanal tablo; sorgu sonucu gibi çalışır
--INDEX			Verilere hızlı erişim sağlar
--SEQUENCE		Otomatik sayı üreticisi (özellikle ID için)
--FUNCTION		Girdi alıp değer döndüren kullanıcı fonksiyonları
--PROCEDURE		SQL komutlarını saklayan tekrar çalıştırılabilir yapı
--TRIGGER		Otomatik çalışan olay-temelli yapı
--SCHEMA		Veritabanı içindeki nesnelerin mantıksal grubu
--CONSTRAINT	Tablo kuralları: primary key, foreign key, unique, vs.
--DATABASE		Tüm veritabanı yapısının kendisi
--USER / ROLE	Erişim ve yetki nesneleri













