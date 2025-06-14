--hw 12:

--film tablosunda film uzunluğu length sütununda gösterilmektedir. Uzunluğu ortalama film uzunluğundan fazla kaç tane film vardır?
select count(film_id) as filmsayisi
from film 
where length > (Select AVG(length) from film ); 


-- film tablosunda en yüksek rental_rate değerine sahip kaç tane film vardır?
select count(film_id ) as amountofilms
from film
where rental_rate=(Select max(rental_rate) from film );


-- film tablosunda en düşük rental_rate ve en düşün replacement_cost değerlerine sahip filmleri sıralayınız. 
select title , rental_rate, replacement_cost 
from film
where rental_rate=(Select min(rental_rate) from film) and replacement_cost=(select min(replacement_cost) from film ) 
order by rental_rate ASC , replacement_cost ASC ; 


--payment tablosunda en fazla sayıda alışveriş yapan müşterileri(customer) sıralayınız. 
select customer_id, count(payment_id) as numberofshopping
from payment
group by customer_id 
order by numberofshopping DESC
limit 5; 

