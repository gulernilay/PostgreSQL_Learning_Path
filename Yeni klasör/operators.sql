--OPERATORS

--UNION / UNION ALL 

--ANY/ALL/EXISTS/SOME 

--INTERSECT : iki farklı sql sorgusunun ortak değerleirni döndürür.INTERSECT, iki SELECT sorgusunun ortak olan satırlarını döndürür.
--Yani: her iki sorguda da bulunan satırlar gelir.
--Her iki sorgunun da aynı sayıda sütun döndürmesi gerekir.
--Sütunların veri tipleri uyumlu olmalı.

--Örnek : Hem personel hem de müşteri olan kişilerin isimleri : customer ve staff tablolarında adı ve soyadı aynı olanları verir. 
select first_name,last_name from customer 
INTERSECT
select first_name,last_name from stuff 

--EXCEPT :EXCEPT, ilk SELECT’in sonucundan ikinci SELECT’in sonucunu çıkarır. Yani: ilk sorguda olup ikinci sorguda olmayan satırlar döner.

--ÖRNEK : Sadece müşteri olan (personel olmayan) kişilerin isimleri
SELECT first_name, last_name FROM customer
EXCEPT
SELECT first_name, last_name FROM staff;

--INTERSECT ve EXCEPT tekrar eden satırları otomatik olarak kaldırır.
--Yani sonuçlar DISTINCT gibi davranır.
--Eğer tekrarları görmek istersen: PostgreSQL’de INTERSECT ALL veya EXCEPT ALL kullanabilirsin.



--Örnek Sorular: Hiç kiralama yapmamış müşterileri bulun.
select first_name ,last_name
from customer 

EXCEPT

select c.first_name ,c.last_name
from customer c
inner join rental r on c.customer_id=r.customer_id


SELECT customer_id FROM customer
EXCEPT
SELECT customer_id FROM rental;

---------------------------------------------------------FUNCTIONS -----------------------------------------------------------------





