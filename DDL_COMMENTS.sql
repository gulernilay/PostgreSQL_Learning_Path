 -- DDL (Data Definition Language) : Veri yapısı tanımlama komutlarıdır : CREATE, ALTER, DROP ,TRUNCATE,RENAME 


-----------------------------------------------------INSERT INTO------------------------------------------------------ 

insert into country  values ('110','X','2025-05-18')
insert into country (country) values ('NilayCountry') -- tek sütuna değer atasan bile diğerleri de otomatikman oluşuyor. 
insert into country  values ('112','y','2025-05-18'),('113','z','2025-05-18'),('114','t','2025-05-18')
--customer tablosuna yeni bir müşteri ekle (ad, soyad, store_id, active).
INSERT INTO customer (store_id, first_name, last_name, address_id, active)
VALUES (1, 'Deneme', 'Deneme', 10, 1);
--film tablosuna yeni bir film ekle: “SQL HERO”, uzunluk 120, kiralama ücreti 3.99.
insert into film (title,length,rental_rate) values('SQL HERO','120','3.99')
--category tablosuna yeni bir kategori ekle: “Educational”.
insert into category (name)  values ('Educational')
--staff tablosuna yeni bir çalışan ekle (isim, mağaza, aktiflik).
insert into staff (first_name,last_name,address_id, store_id,active,username) values('DENEME','SOYADI','22','4','0','deneme')



-----------------------------------------------------------DELETE-------------------------------------
--customer tablosunda hiç aktif olmayan müşterileri sil.
DELETE  from customer where active=0 
--film tablosunda uzunluğu (length) 0 olan filmleri sil.
delete from film where length=0
--payment tablosunda ödeme tutarı (amount) 0 olan kayıtları sil.
delete from payment where 
--address tablosunda telefon numarası boş olanları sil.
delete from address where phone is null 
--Kiralama süresi (rental_duration) 1 olan filmleri sil.
delete from rental where rental_duration=1
--tüm tablonun içeriğini sil ama tablo kalsın
delete from rental 



-----------------------------------------------------------TRUNCATE  :Tablodaki tüm verileri siler, ancak tablo yapısını korur---------------------------------------------------
TRUNCATE TABLE ogrenci; 


-----------------------------------------------------------RENAME :  POSTGRESQL DESTEKLER AMA SQL SERVER DESTEKLEMEZ. ------------------------------------------------------------

-----------------------------------------------------------DROP :Nesneyi tamamen siler (tablo, view, procedure vs.)----------------------------------------------------------------
--Veritabanındaki test_customers adlı tabloyu sil.
drop table test_customers
--film tablosundaki geçici olarak eklediğin temp_column adlı sütunu kaldır.
drop temp_column in table film 

--Tablonun tamamını değil, sadece verisini silmek istiyorsan DELETE ile farkını açıkla. (teorik)email_log adında var olduğunu düşündüğün tabloyu silmeden önce olup olmadığını kontrol et.
-- tüm tablo içeriği ve tablo silinir. 
DROP TABLE Customers;





-----------------------------------------------------------ALTER ----------------------------------------------------------------------------------------------------------
--The PostgreSQL ALTER TABLE command is used to add, delete or modify columns in an existing table.You would also use ALTER TABLE command to add and drop various constraints on an existing table.
-- Veritabanı şemasını (yani tablonun yapısını) değiştirir. Yeni sütun ekler , var olan sütunu siler veya yeniden adlandırır ,  sğtunun veri tipini değiştirir , varsayılan değer ekler / siler , kısıtlamalar (NOT NULL UNIQUE ekler) 

--customer tablosuna second_email adında yeni bir sütun ekle.
alter table customer add column second_email2 varchar(150) 
--film tablosundaki length sütunun veri tipini SMALLINT olarak değiştir.
alter table film alter column length type SMALLINT 
--payment tablosundaki amount sütununu DECIMAL(6,2) olarak değiştir.
alter table payment alter column amount type decimal(6,2)
--address tablosundan postal_code sütununu sil.
alter table address drop column postal_code 
--employees tablosundaki email sütununun veri tipini VARCHAR(150) yap ve NOT NULL olarak zorunlu hale getir.
ALTER TABLE employees MODIFY email type VARCHAR(150) NOT NULL; -- Mysql söz dizimi
ALTER TABLE employees ALTER COLUMN email type VARCHAR(150) SET NOT NULL; --PostgreSQL söz dizimi
--customer tablosunda email sütununun benzersiz olmasını zorunlu kılacak bir UNIQUE constraint ekle.
ALTER TABLE customer ADD CONSTRAINT MyUniqueConstraint UNIQUE(email); 
--orders tablosunda aynı müşteri aynı ürünü yalnızca bir kez sipariş edebilsin.--Bunun için customer_id ve product_id birlikte benzersiz olmalı.
ALTER TABLE orders  ADD CONSTRAINT unique_customer_product UNIQUE(customer_id, product_id);
--products tablosunda price alanına 0’dan büyük olma kısıtı ekle.
ALTER TABLE products  ADD CONSTRAINT check_positive_price CHECK (price > 0);
--course_enrollments tablosunda student_id ve course_id alanları birlikte birincil anahtar olmalı.Her öğrenci aynı kursa yalnızca 1 kez kayıt olabilir.
ALTER TABLE course_enrollments ADD CONSTRAINT MyPrimaryKey PRIMARY KEY (student_id,course_id);
--temp_users tablosundaki user_id alanında bulunan mevcut PRIMARY KEY constraint’ini kaldır.
ALTER TABLE temp_users DROP CONSTRAINT temp_users_pkey;-- direk primary key adını kaldır.
--employees tablosunda daha önce eklenmiş olan salary > 0 kuralını kaldır.
ALTER TABLE employees DROP CONSTRAINT check_salary_positive; --direk constraint adını vermelisin. 
--customer tablosunda daha önce tanımlanmış UNIQUE(email) kısıtlamasını kaldır.
ALTER TABLE customer DROP CONSTRAINT myuniqueconstraint;
--orders tablosundaki delivery_date sütunundan NOT NULL zorunluluğunu kaldır.
ALTER TABLE orders  ALTER COLUMN delivery_date DROP NOT NULL;
--film tablosuna stock_quantity adında bir sütun ekle, veri tipi INT, varsayılan değeri 10 olsun.
ALTER TABLE film  ADD COLUMN stock_quantity INT DEFAULT 10;


--------------------------------------------------UPDATE : where belirlemezsen tümünü siler. ------------------------------
--UPDATE: Tablonun içindeki verileri (satırları) günceller. Bir satırdaki sütunların değerlerini değiştirir.elirli koşullara göre veri günceller.Veri düzeyinde işlemdir
--customer tablosunda active = 0 olan tüm müşterilerin store_id değerini 1 olarak güncelle.
update customer 
set store_id=1
where active=0 
--film tablosunda rental_rate değeri 0 olan filmleri 2.99 olarak güncelle.
update film
set rental_rate=0
where rental_Rate=2.99

--Soyadı “SMITH” olan müşterilerin adını “John” yap.
update customer
set first_name="John"
where last_name="SMITH"

--Mağaza (store) ID’si 2 olan müşterilerin active değerini kapat (0 yap).
update customer 
set active=0
where store_id=2 

--------------------------------------------------------------CREATE---------------------------------------------------------------------------------------------
--Yeni veritabanı nesnesi oluşturur (tablo, view, procedure, function, index vs.)	
CREATE TABLE ogrenci (id INT, ad VARCHAR(50)); --

CREATE TABLE kitap (
    kitap_id INT PRIMARY KEY,
    ad VARCHAR(100),
    fiyat DECIMAL(10,2)
);
--Yeni bir tablo oluştur: favorite_films , Her müşterinin en sevdiği filmleri saklayacağın bir tablo oluştur:
--fav_id: otomatik artan birincil anahtar
--customer_id: müşteri referansı
--film_id: film referansı
--notlar: opsiyonel açıklama alanı (metin)
CREATE TABLE favorite_films (
  fav_id SERIAL PRIMARY KEY,              -- Otomatik artan birincil anahtar
  customer_id INT,                        -- Müşteri kimliği (referans)
  film_id INT,                            -- Film kimliği
  notlar TEXT,                            -- Açıklama (uzun metin)
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)  -- Dış anahtar ilişkisi
);
-- orders adında bir tablo yarat. 
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,                    -- Otomatik artan ID (SERIAL → INT + AUTO INCREMENT)
  customer_name VARCHAR(100) NOT NULL,            -- Müşteri adı (metin, boş bırakılamaz)
  product_name TEXT,                              -- Ürün adı (sınırsız uzunlukta metin)
  quantity INT CHECK (quantity > 0),              -- Adet, 0'dan büyük olmalı (kısıtlama)
  price NUMERIC(8,2) DEFAULT 0.00,                -- Fiyat, varsayılan 0.00 (ondalık)
  is_paid BOOLEAN DEFAULT FALSE,                  -- Ödeme durumu (TRUE / FALSE)
  order_date DATE DEFAULT CURRENT_DATE,           -- Sipariş tarihi, otomatik olarak bugünün tarihi
  delivery_date DATE                              -- Teslimat tarihi (isteğe bağlı)
);

CREATE TABLE employees_deneme(
	emp_id SERIAL primary key,
	full_name varchar(1000) NOT NULL,
	email varchar(1000) UNIQUE,
	salary numeric(10,2) CHECK (salary>=0),
	is_active boolean default false,
	start_date date default current_date,
	departman_id INT ,
	notes TEXT
)

--------------------------------------------------------------------SELECT TOP--------------------------------------------------------------------------------------------
--The SELECT TOP clause is used to specify the number of records to return.
--select the first 3 rows from customers 
SELECT TOP 3 * FROM Customers;
select * from customer limit 3 
select * from customer where activebool=1 limit 3 
select top 3 * from customer where activebool=0
select top 5 * from customer where activebool=0 order by first_name DESC 
--ın mysql , it is used as: 
SELECT column_name(s)
FROM table_name
WHERE condition
LIMIT number;


--------------------------------------------------------------------SELECT INTO---------------------------------------------------------------------------------------
--Bir sorgu sonucunu yeni bir tablo olarak oluşturmak için kullanılır. Yeni tablo oluşturur. Var olan tablo varsa hata verir.
--Örnek : Tüm uzunluğu 90 dakikadan fazla olan filmleri yeni bir tabloya atalım: long_films

select * into long_films
from film 
where length>9
-- Eğer var olan tabloya ekleyecek olsaydık INSERT INTO tablename Select .. 


----------------------------------------------------------------------NOTLAR--------------------------------------------------------------------------------------------

--NOT : Primary Key : Benzersiz ve tabloya özgüdür ,null olamaz, tekrar edemez. 
--NOT : Foreign Key : Başka bir tablodaki sütuna referans verir, null olabilir,tekrar edebilir.  
--NOT: VARCHAR(n): max n karaktere kadar değer alabilirken, CHAR(n):her zaman n karakter değer alır. 
--NOT: NUMERIC :ondalık sayılarda kullanılır. NUMERIC(X,Y) - X:toplam kaç basamak olacak , Y: virgülden sonra kaç basamak var.
--NUMERIC(8,2) → Maksimum 999999.99 değerini alabilir , NUMERIC(5,0) → Maksimum 99999 (tam sayı, ondalık yok)
--NOT : SAYISAL VERİ TİPLERİ :SMALLINT (2 byte tam sayı) , INT (4 byte sayı) ,BIGINT(Büyük tam sayı 8 byte) , SERIAL/BIGSERIAL(OTOMATIK ARTAN ) , NUMERICA (p,d)/DECIMAL(p,s) : hassas veriler  , REAL (float : hassas değil :yaklaşık değerli ) 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




















