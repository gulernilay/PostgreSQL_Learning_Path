JOIN ON 


UPDATE - updates data in a database
DELETE - deletes data from a database
INSERT INTO - inserts new data into a database
CREATE DATABASE - creates a new database
ALTER DATABASE - modifies a database
CREATE TABLE - creates a new table
ALTER TABLE - modifies a table
DROP TABLE - deletes a table
CREATE INDEX - creates an index (search key)
DROP INDEX - deletes an index


AGGREGATION FUNCTIONS 
🟣 5. [INNER JOIN + DISTINCT]
📌 "Kiralama geçmişi olan farklı şehirlerdeki müşteri şehirlerini listele."

🔴 6. [AGGREGATE: SUM, AVG]
📌 "Her ay toplam ne kadar kira geliri elde edilmiş? (payment tablosunu kullan)"

⚪ 7. [SUBQUERY + IN]
📌 "En az 3 film kiralamış müşterilerin adlarını getir."

🟤 8. [UPDATE]
📌 "customer tablosunda active = 0 olan tüm müşterilerin store_id değerini 1 yap."

🟥 9. [DELETE]
📌 "Hiç kiralama yapmamış müşterileri sil."

🟦 10. [CREATE TABLE + INSERT]
📌 "Favori filmlerini tutacağın bir tablo oluştur ve içine 3 film ekle."

🧠 Bonus [VIEW + INDEX + ALIAS + COALESCE + CASE WHEN]
📌 Hazır olduğunda sana aşağıdaki gelişmiş SQL başlıklarını da senaryolarla soracağım:

Görünümler (VIEW)

CASE ile koşullu sütunlar

NULL değer kontrolü

Performans için INDEX kullanımı

 1. En Çok Film Kiralayan İlk 5 Müşteri
  2. Belirli Bir Kategorideki (örneğin "Action") Filmleri Listele
   3. Aylık Kira Gelirini Göster


🔢 1–5: Kiralama ve Ödeme Analizi
En çok film kiralayan ilk 5 müşteriyi getir.

En fazla ödeme yapan ilk 10 müşteriyi listele.

En çok kiralama yapan ilk 3 şehir hangileridir?

En fazla hasılat getiren ilk 5 film hangileridir?

En uzun süre kiralanan ilk 7 film hangileridir?

🎬 6–10: Film Verileri Üzerinden
Süresi en uzun olan ilk 5 filmi getir.

Kiralama ücreti (rental_rate) en yüksek ilk 10 film hangisidir?

En düşük stok miktarına sahip ilk 5 film hangisidir?

En çok kategoriye ait film sayısı nedir? (kategori bazlı, film sayısına göre sıralı)

2006 yılında en çok kiralanan ilk 5 film hangisidir?

🧍 11–15: Müşteri ve Çalışan Üzerinden
En çok ödeme alan ilk 2 çalışanı listele.

Kira başına ortalama ödeme tutarı en yüksek ilk 5 müşteriyi getir.

Aynı soyadı olan en çok müşteriye sahip ilk 3 soyad nedir?

Kiralama sayısı en düşük 5 müşteriyi getir.

En az ödeme yapan ilk 10 müşteri kimdir?

🌍 16–20: Coğrafi ve Zaman Bazlı
En çok müşteriye sahip ilk 5 şehir hangisidir?

En çok kiralama yapılan ilk 5 gün nedir? (tarih bazlı)

En yüksek ödeme alınan ilk 3 ay hangisidir?

En çok sipariş alan ilk 5 mağaza (store) hangisidir?

Kiralama süresi en kısa olan ilk 5 film hangileridir?



📈 INDEXING
Veriye hızlı erişim sağlar.

sql
Kopyala
Düzenle
CREATE INDEX idx_kitap_isim ON kitap(isim);
👁 VIEW
Hazır sorguları sanal tablo olarak kaydetmek için.

sql
Kopyala
Düzenle
CREATE VIEW vw_aktif_musteriler AS
SELECT * FROM customer WHERE active = 1;
🔧 USER DEFINED FUNCTION
Kendi fonksiyonunu oluşturmak.

sql
Kopyala
Düzenle
CREATE FUNCTION dbo.KDV_Ekle (@fiyat DECIMAL)
RETURNS DECIMAL
AS
BEGIN
    RETURN @fiyat * 1.20;
END;
⚙️ STORED PROCEDURE
Komut setlerini saklayıp tekrar çalıştırmak.

sql
Kopyala
Düzenle
CREATE PROCEDURE MusteriGetir @id INT
AS
BEGIN
    SELECT * FROM customer WHERE customer_id = @id;
END;
🔥 TRIGGER
Bir tabloya veri eklendiğinde/şart gerçekleştiğinde otomatik çalışan komut.

sql
Kopyala
Düzenle
CREATE TRIGGER trg_log_rental
ON rental
AFTER INSERT
AS
BEGIN
    INSERT INTO rental_log(rental_id, log_time)
    SELECT rental_id, GETDATE() FROM inserted;
END;
💰 TRANSACTION
Birden fazla SQL işleminin tamamı başarılıysa kayıt eder.

sql
Kopyala
Düzenle
BEGIN TRANSACTION;
    UPDATE stock SET adet = adet - 1 WHERE urun_id = 10;

INSERT INTO siparis(urun_id) VALUES(10);
COMMIT; -- veya ROLLBACK;




📦 Temel SQL Nesneleri:
Nesne Türü	Açıklama
TABLE	Verilerin tutulduğu ana yapı (tablolar)
VIEW	Sanal tablo; sorgu sonucu gibi çalışır
INDEX	Verilere hızlı erişim sağlar
SEQUENCE	Otomatik sayı üreticisi (özellikle ID için)
FUNCTION	Girdi alıp değer döndüren kullanıcı fonksiyonları
PROCEDURE	SQL komutlarını saklayan tekrar çalıştırılabilir yapı
TRIGGER	Otomatik çalışan olay-temelli yapı
SCHEMA	Veritabanı içindeki nesnelerin mantıksal grubu
CONSTRAINT	Tablo kuralları: primary key, foreign key, unique, vs.
DATABASE	Tüm veritabanı yapısının kendisi
USER / ROLE	Erişim ve yetki nesneleri













