-- Worksheet 1: 


------------------------------------------------------------SELECT, FROM , WHERE --------------------------------------------------------------------------------
-- Adı "Mary" olan tüm müşterileri listele.
Select first_name from customer where first_name='Mary'

-- Kiralama ücreti (rental_rate) 4.99 olan filmleri bul.
select rental_rate from film where rental_rate=4.99

-- Müşterisi aktif olmayanları (active = 0) getir.
select first_name,active from customer where active=0

-- SELECT + COUNT + DISTINCT 
SELECT COUNT(DISTINCT country) FROM country

-- SELECT + COUNT + DISTINCT  
SELECT Count(*) AS DistinctCountries
FROM (SELECT DISTINCT Country FROM Customers);

--Q1 : film tablosunu kullanarak, süresi (length) tüm filmlerin ortalamasından düşük olan filmleri listele. 
--Sadece film adını ve süresini getir.
select title, length from film where length <select AVG(length) from film -- AVG fonksiyonu select almaz. 

--Q2:customer ve rental tablolarını kullanarak, hiç kiralama yapmamış müşterilerin adını ve soyadını listele.
select first_name,last_name from customer where customer_id not in (select customer_id from rental )

--Q3: customer tablosundan, soyadları aynı olan ancak adları farklı olan müşteri kayıtlarını getir.
SELECT first_name, last_name
FROM customer
WHERE last_name IN (
    SELECT last_name
    FROM customer
    GROUP BY last_name
    HAVING COUNT(DISTINCT first_name) > 1
);
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


----------------------WHERE kullanımında eğer string varsa tek tırnak kullanılır , sayısal değer varsa direk yazılır-------------------------------
SELECT * FROM Customers WHERE CustomerID=1;
SELECT * FROM Customers WHERE first_name='Johnson';


-----------------------------------------------------------------OPERATORS------------------------------------------------------------
SELECT * FROM customer WHERE first_name = 'John';
SELECT * FROM film WHERE length > 120;
SELECT * FROM payment WHERE amount < 5;
SELECT * FROM rental WHERE rental_id >= 1000;
SELECT * FROM film WHERE rental_duration <= 3;
SELECT * FROM customer WHERE last_name <> 'Smith'; -- OR  !='Smith'
SELECT * FROM payment WHERE amount BETWEEN 5 AND 10;
SELECT * FROM customer WHERE first_name LIKE 'A%'; --A ile başlayanlar 
SELECT * FROM film WHERE rating IN ('PG', 'PG-13'); -- bu değerlerle eşleşen tüm satırları getirir.

SELECT * FROM customer
WHERE country = 'Brazil'
AND country_id = 5
AND last_update > 2025-05-10;

SELECT * FROM Customers
WHERE NOT Country = 'Spain';

SELECT * FROM Customers
WHERE CustomerID NOT BETWEEN 10 AND 60;

SELECT * FROM Customers
WHERE City NOT IN ('Paris', 'London');

select 30+50 
select 50-30
select 60/30 
select 60%2
select 3*2

--Q1:İsmi "A" ile başlayan ve 5 harfli olan müşteri adlarını (first_name) benzersiz şekilde listele
select distinct first_name from customer where first_name like 'A_____'
SELECT DISTINCT first_name FROM customer WHERE first_name LIKE 'A%' AND LENGTH(first_name) = 5;

--Q2:Soyadında “son” ifadesi geçen ama “sonic” geçmeyen müşteri isimlerini getir
select first_name ,last_name from customer where last_name like '%son%' and  last_name not like '%sonic%'

--Q3:Film adı K, L veya M harfiyle başlayan filmlerin sayısını getir
SELECT COUNT(*) AS film_sayisi
FROM film
WHERE title LIKE 'K%' OR title LIKE 'L%' OR title LIKE 'M%';

--Q4 :country tablosundan, adı şu ülkelerden biri olmayan ülkeleri listele: 'Canada', 'Brazil', 'Japan', 'Turkey'
select country from country where country not in ('Canada', 'Brazil', 'Japan', 'Turkey')

--Q5:rental tablosunda kiralama yapan benzersiz müşteri sayılarını (customer_id) say
select count(distinct customer_id) from rental 

-----------------------------------------------------------------+=	Add equals
UPDATE products
SET price = price + 5
WHERE product_id = 101;

----------------------------------------------------------------- -=	Subtract equals
UPDATE products
SET stock_quantity = stock_quantity - 10
WHERE product_id = 101;

----------------------------------------------------------------- *=	Multiply equals
UPDATE products
SET price = price * 1.10
WHERE category_id = 3;

----------------------------------------------------------------- /=	Divide equals
UPDATE products
SET price = price / 2
WHERE price > 100;

----------------------------------------------------------------- %=	Modulo equals
UPDATE inventory
SET remainder = quantity % 2;

--Q1:inventory tablosuna is_even adlı bir sütun eklediğini varsayalım (0 veya 1 tutacak).
--Her ürünün miktarına göre çift ise 1, tek ise 0 olacak şekilde is_even değerlerini güncelle.
UPDATE inventory
SET is_even = CASE 
                WHEN quantity % 2 = 0 THEN 1
                ELSE 0
             END;
--
UPDATE inventory
SET is_even = 1
WHERE quantity % 2 = 0;


--
UPDATE inventory
SET is_even = 0
WHERE quantity % 2 != 0;

--Q2: Soru 1 — Film süresine göre etiket oluştur
--Her film için aşağıdaki kurallara göre bir length_label sütunu oluşturmak istiyoruz (sanal olarak):
--Süresi 0–60 dakika arası → 'Kısa'
--Süresi 61–120 dakika arası → 'Orta'
--Süresi 121 dakika ve üzeri → 'Uzun'
--Film adı (title) ve length_label birlikte listelensin.
ALTER TABLE film ADD COLUMN length_label VARCHAR(20);
UPDATE film 
SET length_label = CASE 
				    WHEN length BETWEEN 0 AND 60 THEN 'Kısa'
				    WHEN length BETWEEN 61 AND 120 THEN 'Orta'
				    WHEN length >= 121 THEN 'Uzun'
				    ELSE 'Bilinmiyor'
				    END;
select title,length_label from film 				
			
-----------------------------------------------------LOGICAL OPERATORS----------------------------------------------------

--ALL :tüm alt sorgu sonuçlarını karşılaması gerekir.

--category_id si 2 olan tüm ürünlerin price ından büyük olan ürün isimlerini getir. 
SELECT product_name
FROM products
WHERE price > ALL (
    SELECT price FROM products WHERE category_id = 2
);
--Maaşı, departman 2’deki tüm çalışanlardan daha yüksek olan çalışanları getir.
SELECT * FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees WHERE department_id = 2
);
---
SELECT ProductName
FROM Products
WHERE ProductID = ALL
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);

--ANY : Alt sorgudaki herhangi bir koşulu sağlarsa sonucu getirir.
SELECT product_name FROM products
WHERE price < ANY (
    SELECT price FROM products WHERE category_id = 3
);
---
SELECT column_name(s)
FROM table_name
WHERE column_name operator ANY
  (SELECT column_name
  FROM table_name
  WHERE condition);
---

--EXISTS: Alt sorgu en az 1 kayıt döndürüyorsa TRUE olur. En az bir siparişi olan müşterileri getir.


--The EXISTS operator is used to test for the existence of any record in a subquery. 
SELECT * FROM customer c
WHERE EXISTS (
    SELECT 1 FROM payment p WHERE p.customer_id = c.customer_id
);
SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price < 20);

SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price = 22);

-- SOME : İçlerinden biri bile şartı sağlasa yeter : PG filmlerinden en az birinden daha pahalı kiralanan filmleri getirir.
SELECT * FROM film
WHERE rental_rate > SOME (
    SELECT rental_rate FROM film WHERE rating = 'PG';
);
--Maaşı, departman 1’deki çalışanlardan herhangi birinin maaşından düşük olan çalışanları getir.
SELECT * FROM employees
WHERE salary < ANY ( 
    SELECT salary FROM employees WHERE department_id = 1
);

--AND / BETWEEN / IN / LIKE /NOT / OR  





--Exercises : 
--Rental süresi, PG dereceli filmlerden herhangi birinden kısa olan filmleri listele.
SELECT title
FROM film
WHERE rental_duration < ANY (
    SELECT rental_duration FROM film WHERE rating = 'PG'
);
--Kira ücreti (rental_rate), G dereceli tüm filmlerden daha yüksek olan filmleri getir.
SELECT title
FROM film
WHERE rental_rate > ALL (
    SELECT rental_rate FROM film WHERE rating = 'G'
);
--En az bir film kiralayan müşterileri listele.
SELECT *
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM rental r
    WHERE r.customer_id = c.customer_id
);
--Hiç film kiralamamış müşterileri listele. 
SELECT *
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM rental r
    WHERE r.customer_id = c.customer_id
);
--Q1:Tüm ödemelerden yüksek ödeme yapan müşteriler : customer_id, amount 
select customer_id, amount from payment where amount > ALL(select amount from payment)

-- Q2: 2 numaralı müşterinin herhangi bir ödemesinden daha fazla ödeme yapan müşteri kayıtlarını getir

select customer_id,amount from payment where amount > ANY (select amount from payment where customer_id=2)  

--Q3: En az bir film kiralayan müşterileri göster
select customer_id from customer c where exists(select 1 from rental r where r.customer_id = c.customer_id); 

--Q4: Tüm filmler arasında bazılarından daha kısa olan filmleri listele
select title from film where length < some (select length from film)

--Q5: film tablosundan, tüm diğer filmlerden daha kısa olan filmleri getir. Yani en kısa film(ler) hangisi, onu bul.
select title from film where length < ALL (select length from film )

--Q6:payment tablosunu kullanarak, herhangi bir ödemenin tutarına eşit olmayan tüm ödemeleri listele. -- ANY 
select payment_id from payment where amount !=ANY(select amount from payment )

--Q7:  film tablosundan, herhangi bir kategoriye atanmış olan filmleri listele (title). --EXISTS 
SELECT title
FROM film f
WHERE EXISTS (
    SELECT 1
    FROM film_category fc
    WHERE fc.film_id = f.film_id
);



-----------------------------------------------------KARAKTER ARAMA : LIKE , ILIKE----------------------------------------------------------------

--Adı A harfiyle başlayan müşterileri getir.
Select first_name from customer where first_name ILIKE 'A%'  --ILIKE case sensitive değil ve postgresql e özgüdür , LIKE ise büyük/küçük harfe duyarlıdır. 
--Film adında "LOVE" geçen filmleri listele.
Select title from film where title ILIKE '%LOVE%'
--Film adı "THE" ile biten kayıtları bul.
Select title from film where title ILIKE '%THE'
-- NOT LIKE : A harfi ile başlamayan 
SELECT * FROM Customers
WHERE CustomerName NOT LIKE 'A%';

--wildcard : _işareti 1 karakteri simgeler. 
SELECT * FROM customer
WHERE first_name LIKE 'L_nd__'; 

--L harfi içeren tüm stringler
SELECT * FROM customer
WHERE first_name LIKE '%L%'; 

--Return all customers that starts with "a" and are at least 3 characters in length:
SELECT * FROM customer
WHERE first_name LIKE 'a__%';

--Return all customers that have "r" in the second position:
select * from customer where first_name like '_r%'

--Return all customers from Spain:
select * from customer where country like 'Spain'


-----------------------------------------------------------------Sayısal Aralıklar (BETWEEN, >, <, =)--------------------------------------------------
--Süresi 90 ile 120 dakika arasında olan filmleri bul.
Select title ,length from film where length BETWEEN 90 and 120

--Kiralama süresi 7 günden fazla olan filmleri getir.
select title,rental_duration from film where rental_duration>7

--Müşteri store_id değeri 1 olanları listele.
select first_name,active from customer where active=1

--NOT BETWEEN 
SELECT * FROM Customers
WHERE CustomerID NOT BETWEEN 10 AND 60;

SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20
AND CategoryID IN (1,2,3);

SELECT * FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';


--NOT IN 
SELECT * FROM Customers
WHERE City NOT IN ('Paris', 'London');

-- NOT
SELECT country_id,country FROM country  WHERE NOT country = 'Spain'
SELECT country_id,country FROM country  WHERE  country != 'Spain'



---------------------------------------------------------NULL ve Boolean Kontrolleri-------------------------------------------------------
--Telefon numarası olmayan adresleri getir.
select address_id,phone from address where phone IS NULL or phone=''

--customer tablosunda store_id NULL olan kayıtları bul.
select store_id,first_name from customer where store_id is null

--Telefon numarası olan adresleri getir.
select store_id,first_name from customer where store_id is not null


---------------------------------------------------------Tarih ve Zaman (DATE, TIMESTAMP)-----------------------------------------------

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

-- rental tablosunu kullanarak, 2005-07-01 tarihinde yapılan kiralamaları listele (rental_id, rental_date).
select rental_id ,rental_date
from rental
where DATE(rental_date)='2005-07-01'

--payment tablosundan, saat 14:00’ten sonra yapılan ödemeleri listele (payment_id, amount, payment_date).
select payment_id, amount, payment_date from payment where EXTRACT(HOUR FROM payment_date) > 14 --WHERE payment_date::time > '14:00:00';  

--Soru: 2006 yılından önce eklenmiş çalışanları listele
SELECT first_name, last_name, last_update
FROM staff
WHERE last_update < '2006-01-01'; -- last_update zaten TIMESTAMP olduğu için direk kullanılabilir. 

select * from staff -- tüm veri tiplerini görebilrsin. 

--Spain de yaşayan ve (ismi ya G harfi ile başlayacak ya da R)
SELECT * FROM Customers WHERE Country = 'Spain' AND (CustomerName LIKE 'G%' OR CustomerName LIKE 'R%');
--( Spain de yaşayan ve ismi G ile başlayan ) ya da ismi R ile başlayan 
SELECT * FROM Customers WHERE Country = 'Spain' AND CustomerName LIKE 'G%' OR CustomerName LIKE 'R%';






--------------------------------------WILDCARDS----------------------------------------
--Mysql ve postgresql de desteklenenler:  % , _ 


--------------------------------------IN OPERATOR : birden fazla or kullanmanı engeller. 
SELECT * from customer where country in ('Germany', 'France', 'UK')
SELECT * from customer where country not in ('Germany', 'France', 'UK')
select * from city where country_id in ( select country_id from country)

-------------------------------------ALIAS----------------------------
SELECT CustomerID AS id , CustomerName AS Customer FROM Customers;
SELECT ProductName AS [My Great Products] FROM Products; -- eğer yeni sütunun adında boşluk olucaksa 
SELECT CustomerName, Address + ', ' + PostalCode + ' ' + City + ', ' + Country AS Address -- 4 tane sütun değerinden oluşan yeni sütun 
FROM Customers;

-- Soru — İsmi belirli desene uyan müşterileri getir ve sütunlara takma ad ver,customer tablosunu kullanarak:İsmi (first_name) ikinci harfi "a" olan müşterileri bul (örneğin: "Sara", "Nadia" gibi) , :first_name sütununu "Ad" olarak,last_name sütununu "Soyad" olarak göster.
SELECT first_name AS AD, last_name AS SOYAD
FROM customer
WHERE first_name LIKE '_a%';

