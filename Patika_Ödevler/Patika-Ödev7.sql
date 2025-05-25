--Aşağıdaki sorgu senaryolarını dvdrental örnek veri tabanı üzerinden gerçekleştiriniz.

--film tablosunda bulunan filmleri rating değerlerine göre gruplayınız.
select rating  from film group by rating 


--film tablosunda bulunan filmleri replacement_cost sütununa göre grupladığımızda film sayısı 50 den fazla olan replacement_cost değerini ve karşılık gelen film sayısını sıralayınız.
select replacement_cost, count(*) as amount_of_films_per_replacement_cost
from film 
group by replacement_cost 
having  count(*)>50
order by amount_of_films_per_replacement_cost DESC


--customer tablosunda bulunan store_id değerlerine karşılık gelen müşteri sayılarını nelerdir? 
select store_id ,count(*) as amount_of_customer_per_store_id
from customer
group by store_id


--city tablosunda bulunan şehir verilerini country_id sütununa göre gruplandırdıktan sonra en fazla şehir sayısı barındıran country_id bilgisini ve şehir sayısını paylaşınız.
select country_id,count(*) as amount_of_city_per_country
from city
group by country_id
order by amount_of_city_per_country DESC 
limit 1 