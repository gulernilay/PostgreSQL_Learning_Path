-- 1. Soru – SELECT, FROM, WHERE, GROUP BY

--Dikkat: SELECT ifadesinde, GROUP BY'da olmayan sütunlar sadece aggregate fonksiyonla kullanılabilir. 
--SELECT customer_id, COUNT(*) FROM rental GROUP BY customer_id;  -- doğru
--SELECT customer_id, rental_date FROM rental GROUP BY customer_id; -- HATA verir


-- "Her mağazada (store) aktif olan müşteri sayısını listele."
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



