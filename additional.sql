DROP TABLE IF EXISTS test; ---- noktalı virgül aslında en sona konur , ara sorgularda virgülle ayır. 

CREATE TABLE author2 (LIKE author); -- bir tabloya enzer tblo yaratmak ( sadece tablo yapısı gelir ancak içi boş gelir ) 

select * from public.author 
order by id ASC 

insert into author2 -- bir tablonun verilerini başka bir tabloyakopyalamak 
select * from author 
where first_name="Sabahaddin"

create table author3 as - author un verileriyle kopyaladık
select * from author 


-- mockaroo ile random sql datası üretebiliyorsun. 

-- yaptığımız update işlemin
update author 
set last_name="X"
where first_name="Y"
RETURNING *;  -- güncellenen verinin gelmesini istiyorsak 





-- foreign key tanımlamasında : 
  author_id INT REFERENCES author (id) --author tablosundaki id ye referans veriyorum. 
--diğer tablodaki foreign key değerleri birden fazla olabilir. 

Benzersiz (Unique) olmalıdır.
NULL değerine sahip olamaz.
Bir tabloda en fazla 1 tane bulunur.


Bir tabloda birden fazla sütun FK olarak tanımlanabilir.
Aynı sütunun içerisinde aynı değerler bulunabilir. 


-- DBMS  
--VERİ TİPLERİ  ( dökümantasyona bak ) VARCHAR,CHAR,TEXT 

select(10+12); -- kendisi otomatik data type atıyor
select(10.0::INT) --type integera dönüyor
select(10.4444444444::REAL)
select(10.4444444444::DOUBLE PRECISION)
select(10.4444444444::NUMERIC)

SELECT ('lORE'::CHAR(10))-- 10 KRAKTERLİK YER AYIRIR. 
SELECT ('lORE'::VARCHAR(10)) --10 KRAKTERLİK YER AYIRMAMIZA RAĞMEN 5 KARAKTERLİK YER AYIRIR. 
SELECT ('lORE'::TEXT)-- KARAKTER KISITLAMASI OK. 


--BOOLEAN VERİ TİPLERİ : TRUE, FALSE, NULL
SELECT (1,'t','yes',true) --true kabul eder. 
SELECT (1::boolean) --true döner 
SELECT (null::boolean) --true döner 





SELECT '1980-12-03'::DATE;
SELECT 'DEC-03-1980'::DATE;
SELECT 'DEC 03 1980'::DATE;
SELECT '1980 December 03'::DATE; -- date demezsek string olrak gelicektir. 

SELECT '03:44'::TIME;
SELECT '03:44 AM'::TIME;
SELECT '03:44 PM'::TIME;
SELECT '03:44:11'::TIME;
SELECT '02:16:07+03'::TIME WITH TIME ZONE;
SELECT '02:16'::TIME WITH TIME ZONE; 
SELECT '1980 December 03 02:16:07'::TIMESTAMP;


Sınırlı sayıda karekter kullanımı için VARCHAR veya CHAR veri tipleri kullanılır. VARCHAR veri tipi doldurulmayan karakterleri yok sayar, CHAR veri tipi ise doldurulmayan karakterler için boşluk bırakır. Sınırsız karekter kullanımı için ise TEXT veri tipi kullanılır.

Boolean Veri Tipleri
TRUE, FALSE veya NULL (Bilinmeyen) değerlerini alabilirler.

TRUE: true, yes, on, 1
FALSE: false, no, off, 0
 
ALTER ve NOT NULL
NOT NULL
Birçok durumda bizler herhangi bir sütuna yazılacak olan verilere belirli kısıtlamalar getirmek isteriz. Örneğin yaş sütünunda sadece sayısal verilerin olmasını isteriz ya da kullanıcı adı sütununda bilinmeyen (NULL) değerlerin olasını istemeyiz. Bu gibi durumlarda ilgili sütunda CONSTRAINT kısıtlama yapıları kullanılır.
NULL bilinmeyen veri anlamındadır. Boş string veya 0 verilerinden farklıdır. Şu şekilde bir senaryo düşünelim bir kullanıcının email hesabı yoksa buradaki veriyi boş string şeklinde düşünebiliriz. Acak eğer kullanıcının maili var ancak ne olduğunu bilmiyorsak bu durumda o veri NULL (bilinmeyen) olarak tanımlanabilir.
NOT NULL Kullanımı
Employees şeklinde bir tablomuzu oluşturalım. Tablodaki first_name ve last_name sütunlarında bilinmeyen veri istemiyoruz, bu sütunlarda NOT NULL kısıtlama yapısı kullanabiliriz.




ALTER TABLE users ALTER COLUMN username SET NOT NULL ; -- BAŞTAN CREATE LEMEKTENSE 
--AMA NULL OLAN SATIRLAR VARSA ALER İŞLEMİ YAPILMAZ
DELETE FROM users where username IS null ; -- doğru tanımdır. IS kulla. 
--boş bir string olabilir ancak null olamaz .
ALTER TABLE x ADD UNIQUE(y) -- eğer unique olmaan y ler varsa hata alıırsın. DELETE LEDİKTEN SONRA ANCAK ALTER LEYEBİLİRSİN. 
--UNIQUE kısıtlaması ile uyguladığımız sütundaki verilerin birbirlerinden farklı benzersiz olmalarını isteriz. PRIMARY KEY kısıtlaması kendiliğinden UNIQUE kısıtlamasına sahiptir.
--NOT NULL kısıtlamasında olduğu gibi tablo oluştururken veya ALTER komutu ile beraber tablo oluştuktan sonra da kullanabiliriz.

--CHECK

CHECK kısıtlaması ile uyguladığımız sütundaki verilere belirli koşullar verebiliriz. Örneğin age (yaş) olarak belirlediğimiz bir sütuna negatif değerler verebiliriz veya web portaline üye olan kullanıcıların yaşlarının 18 yaşından büyük olması gibi kendi senaryolarımıza uygun başka kıstlamalar da vermek isteyebiliriz.

CHECK kısıtlamasını da tablo oluştururken veya ALTER komutu ile beraber tablo oluştuktan sonra kullanabiliriz.
  
--ALTER TABLE <tablo_adı> ADD CHECK (age>=18) 





-PSQL


PSQL, PostgreSQL ile birlikte gelen terminal tabanlı bir kullanıcı arayüzüdür. PSQL sayesinde komut satırında sorgular yazıp, sonuçlarını görebiliriz. Aşağıda temel PSQL komutlarının ilk bölümünü bulabilirsiniz.



1.PSQL ile PostgreSQL'e host, port, kullanıcı adı ve veritabanı ismi ile bağlanmak için:
psql -h <host_name> -p <port_name> -U <kullanıcı_adı> <veritabanı_adı>

TERS SLACH L İLE DB LERİ GÖREBİLİRSİN. 
2.Yeni veritabanı oluşturmak için
CREATE DATABASE <veritabanı_adı>

3.Yeni tablo oluşturmak için
CREATE TABLE <tablo_adı> (   <sütun_adı> VERİ TİPİ (KISITLAMA)
 
4.Tablo detaylarını görmek için
\d+ <tablo_adı>

5.Bir tablodaki sütun ismini değiştirmek için
ALTER TABLE <tablo_adı> RENAME COLUMN <sütun_adı> TO <yeni_sütun_adı>


6.Bir sütuna UNIQUE kısıtlaması eklemek için
ALTER TABLE <tablo_adı> ADD CONSTRAINT <kısıtlama_adı> UNIQUE <sütun_adı>

TERS SLACH C  dvdrental  :  database e bağlanırın. 
TERS CHALS dt ile list of relations 


ters slash d+ ile tüm tablo detayları 

ters slash d+ user 










LEFT JOIN
LEFT JOIN yapısındaki tablo birleştirmesinde, birleştirme işlemi tablo 1 (soldaki tablo) üzerinden gerçekleştirilir. Senaryomuzu şu şekilde düşünelim eğer tablo 1 olarak book tablosunu aldığımızda öncelikle book tablosundaki ilgili sütundaki tüm verileri alacağız, sonrasında bu verilerin eşleştiği ilgili tablo 2 sütunundaki verileri alacağız. Tablo 1 de olup Tablo 2 de olmayan veriler için NULL değeri kullanılır.

Aşağıdaki SQL sorgusunda kitap isimlerinin tamamını alıyoruz, sonrasında bu kitap isimleriyle eşleşebilen yazar isimlerini alıyoruz. Kitap isimlerine karşılık olmayan yazarlar için NULL değeri alıyoruz.
SELECT book.title, author.first_name, author.last_name FROM book
LEFT JOIN author
ON author.id = book.author_id;

RIGHT JOIN yapısındaki tablo birleştirmesinde, birleştirme işlemi tablo 2 (sağdaki tablo) üzerinden gerçekleştirilir. Senaryomuzu şu şekilde düşünelim eğer tablo 2 olarak author tablosunu aldığımızda öncelikle author tablosundaki ilgili sütundaki tüm verileri alacağız, sonrasında bu verilerin eşleştiği ilgili tablo 1 sütunundaki verileri alacağız. Tablo 2 de olup Tablo 1 de olmayan veriler için NULL değeri kullanılır.
Aşağıdaki SQL sorgusunda yazar isim ve soyisim bilgilerinin tamamını alıyoruz, sonrasında eşleşebilen kitap isimlerini alıyoruz. Yazar bilgilerine karşılık olmayan kitap isimleri için NULL değeri alıyoruz.
SELECT book.title, author.first_name, author.last_name
FROM book
RIGHT JOIN author
ON author.id = book.author_id;


RIGHT JOIN Söz Dizimi
SELECT <sütun_adı>, <sütun_adı> ...
FROM <tablo1_adı>
RIGHT JOIN <tablo2_adı>
ON <tablo1_adı>.<sütun_adı> = <tablo2_adı>.<sütun_adı>;
Buradaki tablo1 "left table", tablo2 "right table" olarak da adlandırılır.



FULL JOIN

Full JOIN yapısındaki tablo birleştirmesinde, birleştirme işlemi her iki tablo üzerinden gerçekleştirilir. Senaryomuzu şu şekilde düşünelim eğer tablo 1 olarak book tablosunu aldığımızda öncelikle book tablosundaki ilgili sütundaki tüm verileri alacağız, sonrasında tablo 2 deki ilgili sütunlardan tüm verileri alacağız. Tablo 1 de olup Tablo 2 de olmayan ve Tablo 2 de olup Tablo 1 de olmayan veriler için NULL değeri kullanılır.

Aşağıdaki SQL sorgusunda kitap isimlerinin tamamını alıyoruz, sonrasında yazar isimlerini alıyoruz. Eşleşemeyen veriler için NULL değeri alıyoruz.

SELECT book.title, author.first_name, author.last_name FROM book
FULL JOIN author
ON author.id = book.author_id;
Yukarıdaki sorgumuz sonucunda göreceğimiz gibi kitapların yazar bilgisine sahip değilse NULL değerlerini alırız, yazarlar kitap bilgisine sahip değilse orada da NULL değerlerini alırız.

Full Join

Yukarıdaki görselimizde de gördüğümüz üzere FULL JOIN tablolar arasındaki birleştirmeyi her iki tablo üzerinden belirlenir.

FULL JOIN Söz Dizimi
SELECT <sütun_adı>, <sütun_adı> ... FROM <tablo1_adı>
FULL JOIN <tablo2_adı>
ON <tablo1_adı>.<sütun_adı> = <tablo2_adı>.<sütun_adı>;
Buradaki tablo1 "left table", tablo2 "right table" olarak da adlandırılır.


full outer da öncesinde author.id=author_author_id kısmında eşleşenleri alırız. ancak id !=author id kıımlarında ise yazar olup kitabı olmayanarda vardır . eşleşmeyenleri kldırdığında aslında inner join olur. 


--Unıon 
bu operatöre farklı/aynı tabloya ait sütunlara ai sorgu sonuçlarını ortak id ler üzerinden brileştirir ancak hr iki sorgudaki seçişeln sütun sayısı aynı olmlı , sütun sayısı ve veri tipleri aynı olmalıdır. 

INTERSECT ve EXCEPT



INTERSECT operatörü sayesinde farklı SELECT sorgularıyla oluşan sonuçların kesişen verilerini tek bir sonuç kümesi haline getiririz.



INTERSECT Kullanımı


bookstore veritabanında iki adet sorgu yapıyoruz. İlk sorgumuzda sayfa sayısı en fazla olan 5 kitabı, ikinci sorgumuzda ise isme göre 5 kitabı sıralıyoruz. INTERSECT anahtar kelimesi sayesinde bu iki sorgu sonucunda oluşan veri kümelerinden kesişen verileri tek bir sonuçta birleştiririz.



( SELECT * 
FROM book
ORDER BY title
LIMIT 5
)
INTERSECT
(
SELECT * 
FROM book
ORDER BY page_number DESC
LIMIT 5
);


INTERSECT operatörü kullanılacağı sorguların, sütun sayıları eşit olmalıdır ve sütunlardaki veri tipleri eşleşmelidir.



INTERSECT Söz Dizimi


SELECT <sütun_adı>, <sütun_adı>... FROM <table1>
INTERSECT
SELECT <sütun_adı>, <sütun_adı>...
FROM <table2>

INTERSECT ALL


INTERSECT operatörü bize kesişen veriler içerisindeki tekrar edenleri göstermez. Tekrar edenleri görmek için INTERSECT ALL kullanırız.



EXCEPT Kullanımı


bookstore veritabanında iki adet sorgu yapıyoruz. İlk sorgumuzda sayfa sayısı en fazla olan 5 kitabı, ikinci sorgumuzda ise isme göre 5 kitabı sıralıyoruz. EXCEPT anahtar kelimesi sayesinde ilk sorguda olup ancak ikinci sorguda olmayan verileri gösterir.



( SELECT * 
FROM book
ORDER BY title
LIMIT 5
)
EXCEPT
(
SELECT * 
FROM book
ORDER BY page_number DESC
LIMIT 5
);


EXCEPT operatörü kullanılacağı sorguların, sütun sayıları eşit olmalıdır ve sütunlardaki veri tipleri eşleşmelidir.



EXCEPT Söz Dizimi


SELECT <sütun_adı>, <sütun_adı>... FROM <table1>
EXCEPT
SELECT <sütun_adı>, <sütun_adı>...
FROM <table2>

EXCEPT ALL


EXCEPT operatörü bize ilk sorguda olan ancak ikinci sorguda olmayan veriler içerisindeki tekrar edenleri göstermez. Tekrar edenleri görmek için EXCEPT ALL kullanırız.



