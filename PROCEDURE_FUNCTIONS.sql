-- Functions 

--ALIAS: Bir tabloya ya da sütuna başka bir isim vermek için kullanılır, ama kalıcı değildir


--FUNCTIONS: "STORED PREOCEDURES" : Duplicating code yerine ya da several :Stored procedures (saklı yordamlar), veritabanı üzerinde sık kullanılan, tekrar eden ya da karmaşık işlemleri bir kez tanımlayıp, ihtiyaç duyuldukça çağırmak için kullanılan yapılar olup, 
--SQL kodu bir kez derlenir ve optimize edilmiş hali saklanır. Böylece her çalıştırıldığında tekrar derlenmesi gerekmez.
--Özellikle çoklu sorgu işlemleri tek bir procedure içinde olduğu için, istemci–sunucu trafiği azalır.
--Kod tekrarı azaltılır, bakım kolaylaşır.
--Kullanıcıların doğrudan tabloya erişmesi yerine sadece prosedürü çalıştırmasına izin verilerek, yetki sınırlandırması yapılabilir.
--Büyük miktarda verinin işlenmesi gerektiğinde, prosedür ile sunucu tarafında işlem yapılır, verinin istemciye çekilmesine gerek kalmaz.


-- Bir müşterinin (customer_id) yaptığı kiralamalardan toplam ne kadar ödeme yaptığını dönen bir procedure yazalım. customerların tüm kiralamalarını ve amountlarını getir.
select c.customer_id, sum(p.amount) as Toplam_Odeme , count(r.rental_id) as kiralama_say
from customer c
inner join rental r on r.customer_id=c.customer_id
inner join payment p on p.rental_id=r.rental_id
group by c.customer_id
order by c.customer_id ASC  ---400 :24,  404:29


-- function ile procedure arasındaki fark : 
-- function : returns ile belirlenir , procedure de return yok out parametreleriyle bilgi verebilir.  Hayır (yalnızca mesaj verir)
-- procedure doğrudan sorgu döndrüemez.terminal çıktısı verir, fonksiyon terminal çıktısı vermez. 

--Özellik									FUNCTION								PROCEDURE
--SELECT içinde çağrılabilir mi?			Evet – SELECT my_function()				Hayır – sadece CALL my_procedure() ile 
--Genelde hangi amaçla kullanılır?			Hesaplama, veri döndürme, raporlama		DML (INSERT/UPDATE/DELETE), işlem mantığı, loglama
--Yan etkili işlem (data değişikliği)?		Evet ama sınırlı						Evet – transaction içinde daha uygundur 
--BEGIN, COMMIT, ROLLBACK içerir mi?		Hayır (fonksiyon içinde olamaz)			Evet – tam transaction kontrolü mümkündür
											RETURN x + y							BEGIN ... COMMIT bloklarıyla kullanılabilir

-- FUNCTION çağırma şekli 
SELECT get_total_payments(1);

-- PROCEDURE çağırma şekli 
CALL calculate_total_payments(1, NULL);

--Kısaca Ne Zaman Hangisini Kullanmalı?
--Raporlama, hesaplama, veri döndürme						✅ FUNCTION
--Veri değiştirme (INSERT/UPDATE/DELETE) ve kontrol akışı	✅ PROCEDURE
--OUT parametreyle işlem sonucu göstermek istiyorsan		✅ PROCEDURE
--SELECT içinde başka bir sorguda kullanmak istiyorsan		✅ FUNCTION



-- Tüm müşterilerin kiralama ve ödeme bilgilerini yazdıran procedure
CREATE OR REPLACE PROCEDURE get_customer_rental_and_payments() --Veritabanında herhangi bir şey döndürmez. Terminal çıktısı verir (RAISE NOTICE) → sadece görsel olarak ekranda görünür.Genellikle loglama, veri kontrolü veya görsel geri bildirim amaçlı kullanılır.
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'CustomerID | Toplam Kiralama | Toplam Ödeme'; -- Konsola sabit başlık yaz RAISE NOTICE PostgreSQL'in sadece terminal mesajı üretmesidir. SELECT gibi döndürmez.

    FOR customer_row IN -- Her müşteri için kiralama ve ödeme bilgilerini al 
        SELECT 
            c.customer_id,
            COUNT(r.rental_id) AS toplam_kiralama,
            SUM(p.amount) AS toplam_odeme
        FROM 
            customer c
        INNER JOIN 
            rental r ON r.customer_id = c.customer_id
        INNER JOIN 
            payment p ON p.rental_id = r.rental_id
        GROUP BY 
            c.customer_id
    LOOP
        RAISE NOTICE '% | % | %', 
            customer_row.customer_id, 
            customer_row.toplam_kiralama, 
            customer_row.toplam_odeme;
    END LOOP;
END;
$$;

CALL get_customer_rental_and_payments();

------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_customer_rental_and_payments() --Gerçekten veri döndürür. Yani SELECT sorgusunda sonuç alırsın. Bu fonksiyon, SELECT içinde başka sorgulara gömülebilir.

RETURNS TABLE (
    customer_id INTEGER,
    toplam_kiralama INTEGER,
    toplam_odeme NUMERIC
)
LANGUAGE plpgsql--plpgsql is the name of the language that the function is implemented in.
AS $$
BEGIN
    RETURN QUERY --RETURN clause specifies that data type you are going to return from the function. 
    SELECT 
        c.customer_id,
        COUNT(r.rental_id),
        SUM(p.amount)
    FROM 
        customer c
    INNER JOIN 
        rental r ON r.customer_id = c.customer_id
    INNER JOIN 
        payment p ON p.rental_id = r.rental_id
    GROUP BY 
        c.customer_id;
END;
$$;

SELECT * FROM get_customer_rental_and_payments();
-------



--Verilen bir customer_id için, o müşterinin yaptığı kiralamaları ve her birine ait ödeme tutarlarını listeleyen bir FUNCTION yazınız.
create or replace function soru1(p_customer_id INTEGER)
RETURNS TABLE (
    rental_id INTEGER,
    rental_date TIMESTAMP,
    amount NUMERIC
)

LANGUAGE plpgsql--plpgsql is the name of the language that the function is implemented in.
AS $$
BEGIN
    RETURN QUERY --RETURN clause specifies that data type you are going to return from the function. 
	SELECT 
        r.rental_id,
        r.rental_date,
        p.amount
    FROM 
        rental r
    INNER JOIN 
        payment p ON p.rental_id = r.rental_id
    WHERE 
        r.customer_id = p_customer_id;
END;
$$;
SELECT * FROM soru1(5);


--"Tüm müşterilerin customer_id, toplam kiralama sayısı ve toplam ödeme tutarını konsola yazdıran bir PROCEDURE yazınız."
CREATE OR REPLACE PROCEDURE print_customer_rentals_and_payments()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'CustomerID | Toplam Kiralama | Toplam Ödeme';

    FOR customer_row IN
        SELECT 
            c.customer_id,
            COUNT(r.rental_id) AS toplam_kiralama,
            SUM(p.amount) AS toplam_odeme
        FROM 
            customer c
        INNER JOIN 
            rental r ON r.customer_id = c.customer_id
        INNER JOIN 
            payment p ON p.rental_id = r.rental_id
        GROUP BY 
            c.customer_id
    LOOP
        RAISE NOTICE '% | % | %', 
            customer_row.customer_id, 
            customer_row.toplam_kiralama, 
            customer_row.toplam_odeme;
    END LOOP;
END;
$$;

CALL print_customer_rentals_and_payments();

--"Bir müşteriye yeni kiralama ve ödeme kaydı ekleyen bir PROCEDURE yazınız. Aynı işlemde log tablosuna kayıt eklensin. Hatalı işlemde ROLLBACK yapılmalı."
--rental lof adında bir basit bir log tablosu oluşturalım 
CREATE TABLE rental_log (
    log_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    film_id INTEGER,
    rental_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT
);
CREATE OR REPLACE PROCEDURE create_rental_with_log(
    IN p_customer_id INTEGER,
    IN p_film_id INTEGER,
    IN p_amount NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_rental_id INTEGER;
    new_inventory_id INTEGER;
BEGIN
    -- Uygun bir envanter (inventory) bul
    SELECT inventory_id INTO new_inventory_id
    FROM inventory
    WHERE film_id = p_film_id
    LIMIT 1;

    IF new_inventory_id IS NULL THEN
        RAISE EXCEPTION 'Uygun envanter bulunamadı!';
    END IF;

    -- Kiralama ekle
    INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
    VALUES (CURRENT_TIMESTAMP, new_inventory_id, p_customer_id, 1)
    RETURNING rental_id INTO new_rental_id;

    -- Ödeme ekle
    INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
    VALUES (p_customer_id, 1, new_rental_id, p_amount, CURRENT_TIMESTAMP);

    -- Log kaydı ekle
    INSERT INTO rental_log (customer_id, film_id, status)
    VALUES (p_customer_id, p_film_id, 'Başarılı Kiralama');

EXCEPTION
    WHEN OTHERS THEN
        -- Hata durumunda log yaz ve rollback yap
        INSERT INTO rental_log (customer_id, film_id, status)
        VALUES (p_customer_id, p_film_id, 'HATA: ' || SQLERRM);
        RAISE;
END;
$$;

CALL create_rental_with_log(1, 100, 4.99);
------------------------------------------------------------------------------------------------------------------------------------------------
--PostgreSQL ARRAY_AGG function is used to concatenate the input values including null into an array. 
SELECT
    c.customer_id,
    c.first_name,
    ARRAY_AGG(f.title) AS rented_films
FROM 
    customer c
JOIN 
    rental r ON r.customer_id = c.customer_id
JOIN 
    inventory i ON i.inventory_id = r.inventory_id
JOIN 
    film f ON f.film_id = i.film_id
GROUP BY 
    c.customer_id, c.first_name;


-------------------------------------------------------------------STRING FUNCTIONS ---------------------------------------------------------------------------------------------

-- ASCII(): İlk karakterin ASCII değerini verir
SELECT ASCII('A');  -- 65

-- BIT_LENGTH(): Stringin bit cinsinden uzunluğu
SELECT BIT_LENGTH('ABC');  -- 24

-- CHAR_LENGTH(): Karakter sayısını verir
SELECT CHAR_LENGTH('hello');  -- 5

-- CHARACTER_LENGTH(): CHAR_LENGTH() ile aynıdır
SELECT CHARACTER_LENGTH('abc');  -- 3

-- CONCAT_WS(): Ayırıcı ile birleştirir
SELECT CONCAT_WS('-', 'a', 'b', 'c');  -- 'a-b-c'

-- CONCAT(): Argümanları birleştirir
SELECT CONCAT('foo', 'bar');  -- 'foobar'

-- LOWER(): Tüm harfleri küçültür (LCASE() eşleniği)
SELECT LOWER('ABC');  -- 'abc'

-- LEFT(): Soldan belirtilen kadar karakter alır
SELECT LEFT('abcdef', 3);  -- 'abc'

-- LENGTH(): Byte cinsinden uzunluk verir (UTF8’e dikkat!)
SELECT LENGTH('€');  -- 3

-- LOWER(): Tüm harfleri küçük yapar
SELECT LOWER('HeLLo');  -- 'hello'

-- LPAD(): Soldan belirtilen karakterle doldurur
SELECT LPAD('42', 5, '0');  -- '00042'

-- LTRIM(): Baştaki boşlukları siler
SELECT LTRIM('   test');  -- 'test'

-- SUBSTRING(): MID() eşleniği
SELECT SUBSTRING('abcdef' FROM 2 FOR 3);  -- 'bcd'

-- POSITION(): Alt string’in başlangıç pozisyonunu döner
SELECT POSITION('b' IN 'abc');  -- 2

-- QUOTE_LITERAL(): Stringi SQL için güvenli hale getirir
SELECT QUOTE_LITERAL('O''Reilly');  -- '''O''Reilly'''

-- REGEXP (~): Regex eşleştirmesi yapar
SELECT 'abc' ~ 'b';  -- true

-- REPEAT(): Stringi tekrarlamak için kullanılır
SELECT REPEAT('ha', 3);  -- 'hahaha'

-- REPLACE(): Belirli bir ifadeyi başka biriyle değiştirir
SELECT REPLACE('hello world', 'world', 'you');  -- 'hello you'

-- REVERSE(): Stringi ters çevirir (UDF gerekir)
-- Aşağıdaki fonksiyon tanımlı ise çalışır
-- CREATE OR REPLACE FUNCTION REVERSE(TEXT) RETURNS TEXT ...
SELECT REVERSE('abc');  -- 'cba'

-- RIGHT(): Sağdan belirtilen kadar karakter alır
SELECT RIGHT('abcdef', 2);  -- 'ef'

-- RPAD(): Sağdan karakterle doldurur
SELECT RPAD('42', 5, 'x');  -- '42xxx'

-- RTRIM(): Sondaki boşlukları siler
SELECT RTRIM('test   ');  -- 'test'

-- SUBSTRING(): Belirli bir alt string döner
SELECT SUBSTRING('abcdef' FROM 3 FOR 2);  -- 'cd'

-- TRIM(): Hem baştaki hem sondaki boşlukları siler
SELECT TRIM('  text  ');  -- 'text'

-- UPPER(): Tüm harfleri büyük yapar (UCASE() eşleniği)
SELECT UPPER('abc');  -- 'ABC'

-- UPPER(): Argümanı büyük harfe çevirir
SELECT UPPER('Hello');  -- 'HELLO'

-- ABS(): Mutlak değeri döner
SELECT ABS(-5);  -- 5

-- ACOS(): Arkkosinüs (radyan cinsinden), değer -1 ile 1 arasında olmalı
SELECT ACOS(1);  -- 0.0

-- ASIN(): Arksinüs (radyan), değer -1 ile 1 arasında olmalı
SELECT ASIN(0.5);  -- ~0.5236

-- ATAN(): Arktanjant (radyan)
SELECT ATAN(1);  -- ~0.7854

-- ATAN2(): İki sayının arktanjantı (y, x)
SELECT ATAN2(1, 1);  -- ~0.7854

-- CEIL(): Yukarı yuvarlar (tamsayıya)
SELECT CEIL(4.2);  -- 5

-- CEILING(): Yukarı yuvarlar (CEIL ile aynı)
SELECT CEILING(4.2);  -- 5

-- COS(): Kosinüs değeri (radyan cinsinden)
SELECT COS(0);  -- 1

-- COT(): Kotanjant değeri
SELECT COT(1);  -- ~0.6421

-- DEGREES(): Radyanı dereceye çevirir
SELECT DEGREES(PI());  -- 180

-- EXP(): e^x değerini döner
SELECT EXP(1);  -- ~2.7182

-- FLOOR(): Aşağı yuvarlar
SELECT FLOOR(4.8);  -- 4

-- GREATEST(): Verilen sayılardan en büyüğünü döner
SELECT GREATEST(3, 7, 5);  -- 7

-- LEAST(): Verilen sayılardan en küçüğünü döner
SELECT LEAST(3, 7, 5);  -- 3

-- LOG(): Doğal logaritma (ln)
SELECT LOG(2.7182);  -- ~1

-- MOD(): Mod alma (kalanı döner)
SELECT MOD(10, 3);  -- 1

-- PI(): Pi sayısı
SELECT PI();  -- ~3.1416

-- POW(): Üs alma (x^y)
SELECT POW(2, 3);  -- 8

-- POWER(): Üs alma (POW ile aynı)
SELECT POWER(2, 4);  -- 16

-- RADIANS(): Dereceyi radyana çevirir
SELECT RADIANS(180);  -- ~3.1416

-- ROUND(): Sayıyı yuvarlar (ondalık da verilebilir)
SELECT ROUND(4.567, 2);  -- 4.57

-- SIN(): Sinüs değeri (radyan)
SELECT SIN(PI()/2);  -- 1

-- SQRT(): Karekök alır
SELECT SQRT(9);  -- 3

-- TAN(): Tanjant değeri (radyan)
SELECT TAN(PI()/4);  -- ~1
----------------------------------------------------------------------SCHEMA---------------------------------------------------------------------------------------
--A schema is a named collection of tables. A schema can also contain views, indexes, sequences, data types, operators, and functions. 
--Schemas are like folders in an operating system, but they can't contain other schemas inside them. PostgreSQL statement CREATE SCHEMA creates a schema.
--Benzer işleri yapan objeleri gruplamak
--Kullanıcıya özel alanlar oluşturmak
--İsim çakışmalarını önlemek (aynı isimde iki tablo farklı şemalarda olabilir)
--Yetkilendirme ve erişim kontrolü sağlamak

CREATE SCHEMA muhasebe;
CREATE TABLE muhasebe.faturalar (
    id SERIAL PRIMARY KEY,
    tutar NUMERIC
);
--public adında bir varsayılan schema vardır.Eğer belirtmezsen:
SELECT * FROM musteriler;--→ public.musteriler tablosunu çağırır.

-- PostgreSQL’de dvdrental veritabanı varsayılan olarak tüm tabloları public şeması içinde barındırır. Ancak sen bu yapıyı örneğin mantıksal modüllere ayırmak istersen (örneğin: musteri, film, odeme, yonetim gibi), kendi şemalarını oluşturup tablolara buna göre taşıyabilirsin.
--dvdrental veritabanında:
--Müşteri ile ilgili tablolar → musteri şeması
--Film ve içeriklerle ilgili tablolar → film şeması
--Ödeme ile ilgili tablolar → odeme şeması

CREATE SCHEMA musteri;
CREATE SCHEMA film;
CREATE SCHEMA odeme;

--Mevcut tabloları yeni şemaya taşı
ALTER TABLE public.customer SET SCHEMA musteri;--Örneğin customer tablosunu musteri şemasına taşı:
ALTER TABLE public.film SET SCHEMA film; --film, actor, category tablolarını film şemasına taşı:
ALTER TABLE public.actor SET SCHEMA film;
ALTER TABLE public.category SET SCHEMA film;
ALTER TABLE public.payment SET SCHEMA odeme; --payment ve rental tablolarını odeme şemasına taşı: 
ALTER TABLE public.rental SET SCHEMA odeme;

SELECT * FROM musteri.customer; -- Artık bu tablolara erişmek için tam şema adı kullanman gerekir 
SELECT * FROM film.film;
SELECT * FROM odeme.payment;

--Neden Şema Kullanılır? 
--Modülerlik sağlar
--Büyük veritabanlarında karmaşayı azaltır
--Yetkilendirme ve güvenlik kontrollerini kolaylaştırır
--Geliştirici ekipler için izolasyon sağlar (her ekip kendi şemasında çalışabilir)

---------------------------------------------------------------YETKİLENDİRME---------------------------------------------------------------------------------------- 
GRANT USAGE ON SCHEMA odeme TO reporting_user;
GRANT SELECT ON ALL TABLES IN SCHEMA odeme TO reporting_user;

--
create function procedure1
RETURNS text AS $variable_name$