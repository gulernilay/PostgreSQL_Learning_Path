-- 1. Soru – SELECT, FROM, WHERE, GROUP BY

--Dikkat: SELECT ifadesinde, GROUP BY'da olmayan sütunlar sadece aggregate fonksiyonla kullanılabilir. 
--SELECT customer_id, COUNT(*) FROM rental GROUP BY customer_id;  -- doğru
--SELECT customer_id, rental_date FROM rental GROUP BY customer_id; -- HATA verir


-- "Her mağazada (store) aktif olan müşteri sayısını listele."-- store id, ve müşteri sayısı istersin. 
select store_id , count(*) as numberOFcustomer
from customer 
where active=1
group by store_id

-- 2. Soru – SELECT, FROM, WHERE, GROUP BY
-- "Her şehirde kaç müşteri bulunduğunu listele."
select city_id , count(*) numberofCustomer
from 
group by city_id


--Müşteri Sayısını Mağazaya Göre Grupla
SELECT store_id, COUNT(*) AS musteri_sayisi
FROM customer
GROUP BY store_id;


--Her kategorideki film sayısını getir
SELECT c.name AS kategori, COUNT(*) AS film_sayisi
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;


-- her kiralama süresinde ortalama ücretler neler
SELECT rental_duration, AVG(rental_rate) AS ortalama_ucret
FROM film
GROUP BY rental_duration;

--Mağaza başında 300 den fazla müşterisi olan mağazalar neler
SELECT store_id, COUNT(*) AS musteri_sayisi
FROM customer
GROUP BY store_id
HAVING COUNT(*) > 300; -- her zaman group by dan sonra kullanılacak 

--Her film derecesi (rating) için ortalama kiralama süresi (rental_duration) nedir?
select rating ,AVG(rental_duration)
from film
group by rating

-- payment tablosunda ödeme miktarlarına göre kaç ödeme yapılmış?
SELECT amount, count(*) amount_of_frequency
FROM PAYMENT 
group by amount
order by amount DESC;

--Müşterilerin yaptığı ödeme sayısı 40’tan fazla olanları listele
select customer_id , count(*) as frequency 
from payment
group by customer_id


--Her mağazada toplam kaç müşteri var ve 300’den fazla olanları getir
select store_id , count(*) customeramount
from customer
group by store_id
HAVING COUNT(*) > 300;

--film tablosunda her rating için ortalama film süresi (length) 120’nin üzerinde olanları listele
SELECT rating, COUNT(*) AS film_count, AVG(length) AS averagefilmduration
FROM film
GROUP BY rating
HAVING AVG(length) > 120;

-- aktif olan müşterileri şehirlerine göre grupla, her şehirde kaç müşteri olduğunu yaz. sonuçları çok müşteriden az müşteriye doğru sırala
--customer address id ile address tablosundaki addressid ye kaşılık gelen city id
SELECT 
    city_id,
    COUNT(customer_id) AS customer_count
FROM 
    customer
WHERE 
    active = true
GROUP BY 
    city_id
ORDER BY 
    customer_count DESC;


-- AGGREGATE FUNCTIONS 
--MIN , MAX, COUNT ,AVG ,SUM 
select min(amount) from payment;

SELECT MIN(amount) AS SmallestPrice FROM payment;

-- ödeme günlerine göre en düşük ödemeleri grupla
SELECT MIN(amount) AS SmallestPrice, payment_date FROM payment GROUP BY payment_id;

-- amount of rows in payment 
select count(*) from payment

-- the number of product name that is not null 
SELECT COUNT(staff_id) FROM payment;

-- how many different amount 
SELECT COUNT(DISTINCT amount) FROM payment;

-- create the new column called as numberofdifferentpayment
select count(distinct amount ) as numberofdifferentpayment from payment;

-- the sum of amount in table payment 
select sum(amount) as totalamount from payment ; 
select sum (amount*10) from payment;
select sum(amount*price) from tablex

--avg function
select avg(amount) as avgprice from payment
SELECT * FROM payment WHERE amount > (SELECT AVG(amount) FROM payment);


--soru:Ödeme tutarı 0’dan büyük olan işlemleri dikkate alarak, her bir personelin kaç adet ödeme işlemi gerçekleştirdiğini listeleyiniz. 
--Sonuçları en fazla işlem yapan personelden başlayarak sıralayınız.C
select staff_id, count(*) as odeme_adedi
from payment where amount >0 group by staff_id order by odeme_adedi DESC



--SORU :Kiralama ücreti 2.99'dan yüksek olan filmleri, uzunluklarına göre gruplayarak her uzunlukta kaç film olduğunu bulunuz. En fazla filme sahip uzunluklardan başlayarak sıralayınız.
select title,count(*) as uzunlugunagorefilmsayisi from film where renatl_rate>2.99 group by length order by uzunlugunagorefilmsayisi DESC 


