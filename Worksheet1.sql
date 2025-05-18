-- Worksheet 1: SELECT, FROM , WHERE 

-- Adı "Mary" olan tüm müşterileri listele.
Select first_name from customer where first_name='Mary'

-- Kiralama ücreti (rental_rate) 4.99 olan filmleri bul.
select rental_rate from film where rental_rate=4.99

-- Müşterisi aktif olmayanları (active = 0) getir.
select first_name,active from customer where active=0

--------------------------------------------------AND / OR /NOT ------------------------------------------------------------- 

-- Adı "PATRICIA" ve soyadı "JOHNSON" olan müşteriyi getir.
Select first_name,last_name from customer where first_name='PATRICIA' and last_name='JOHNSON'

-- rental_rate = 2.99 veya rental_duration = 7 olan filmleri listele.
select * from film where rental_rate=2.99 or rental_duration=7


-- İspanyada yaşayan ve ismi G harfi ile başlayan müşteriler 
SELECT * FROM Customers WHERE Country = 'Spain' AND CustomerName LIKE 'G%';



------------------------------------------------SELECT DISTINCT------------------------------------------------------------
--The SELECT DISTINCT statement is used to return only distinct (different) values.
SELECT DISTINCT Country FROM Customers; --farklı ülkeler listeleneir.

SELECT COUNT(DISTINCT Country) FROM Customers;  --her farklı ülkeye ait müşteri sayısı 

SELECT Count(*) AS DistinctCountries
FROM (SELECT DISTINCT Country FROM Customers);


----------------------WHERE kullanımında eğer string varsa tek tırnak , sayısal değer varsa direk yaz-------------------------------
SELECT * FROM Customers WHERE CustomerID=1;
SELECT * FROM Customers WHERE first_name='Johnson';


----------------------------------------------------OPERATORS------------------------------------------------------------
SELECT * FROM customer WHERE first_name = 'John';
SELECT * FROM film WHERE length > 120;
SELECT * FROM payment WHERE amount < 5;
SELECT * FROM rental WHERE rental_id >= 1000;
SELECT * FROM film WHERE rental_duration <= 3;
SELECT * FROM customer WHERE last_name <> 'Smith'; -- OR  !='Smith'
SELECT * FROM payment WHERE amount BETWEEN 5 AND 10;
SELECT * FROM customer WHERE first_name LIKE 'A%'; --A ile başlayanlar 
SELECT * FROM film WHERE rating IN ('PG', 'PG-13'); -- bu değerlerle eşleşen tüm satırları getirir.


-----------------------------------KARAKTER ARAMA : LIKE , ILIKE----------------------------------------------------------------

--Adı A harfiyle başlayan müşterileri getir.
Select first_name from customer where first_name ILIKE 'A%'  --ILIKE case sensitive değil ve postgresql e özgüdür , LIKE ise büyük/küçük harfe duyarlıdır. 
--Film adında "LOVE" geçen filmleri listele.
Select title from film where title ILIKE '%LOVE%'
--Film adı "THE" ile biten kayıtları bul.
Select title from film where title ILIKE '%THE'
-- NOT LIKE : A harfi ile başlamayan 
SELECT * FROM Customers
WHERE CustomerName NOT LIKE 'A%';

-------------------------------------------Sayısal Aralıklar (BETWEEN, >, <, =)--------------------------------------------------
--Süresi 90 ile 120 dakika arasında olan filmleri bul.
Select title ,length from film where length BETWEEN 90 and 120

--Kiralama süresi 7 günden fazla olan filmleri getir.
select title,rental_duration from film where rental_duration>7

--Müşteri store_id değeri 1 olanları listele.
select first_name,active from customer where active=1

--NOT BETWEEN 
SELECT * FROM Customers
WHERE CustomerID NOT BETWEEN 10 AND 60;

--NOT IN 
SELECT * FROM Customers
WHERE City NOT IN ('Paris', 'London');

-- NOT
SELECT country_id,country FROM country  WHERE NOT country = 'Spain'
SELECT country_id,country FROM country  WHERE  country != 'Spain'

----------------------------------------------NULL ve Boolean Kontrolleri-------------------------------------------------------
--Telefon numarası olmayan adresleri getir.
select address_id,phone from address where phone IS NULL or phone=''

--customer tablosunda store_id NULL olan kayıtları bul.
select store_id,first_name from customer where store_id is null

--Telefon numarası olan adresleri getir.
select store_id,first_name from customer where store_id is not null


-----------------------------------------------Tarih ve Zaman (DATE, TIMESTAMP)-----------------------------------------------

--2006 yılına ait kiralama kayıtlarını (rental_date) getir.
SELECT rental_date
FROM rental
WHERE EXTRACT(YEAR FROM rental_date) = 2006;

--Belirli bir gün: 2006-05-15 tarihinde kiralanan filmleri getir.
SELECT r.rental_id, r.rental_date, f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE DATE(r.rental_date) = '2006-05-15';

--rental_date değeri bugünden eski olan kayıtları listele.
SELECT rental_date
FROM rental
WHERE rental_date < CURRENT_DATE;

-----------------------------------------HARD EXAMPLES---------------------------
--Spain de yaşayan ve (ismi ya G harfi ile başlayacak ya da R)
SELECT * FROM Customers WHERE Country = 'Spain' AND (CustomerName LIKE 'G%' OR CustomerName LIKE 'R%');
--( Spain de yaşayan ve ismi G ile başlayan ) ya da ismi R ile başlayan 
SELECT * FROM Customers WHERE Country = 'Spain' AND CustomerName LIKE 'G%' OR CustomerName LIKE 'R%';








