--🔹 Soru 1: "Kiralama süresi 7 gün olan filmleri, uzunluklarına göre azalan şekilde sırala."
select title, rental_duration from film where rental_duration=7 order by length DESC;
select title, rental_duration from film where rental_duration=7 order by length ASC; -- artan sırada sıralar

--🔹 Soru 2: "Adı 'S' harfiyle başlayan müşterileri alfabetik sırayla getir."
select first_name from customer where first_name ILIKE 'S%' order by ASC;

--🔹 SORU 3 : "Hangi kategori kaç filme sahip? En fazla filme sahip kategoriden en az olana doğru sırala."
select category_id , count(*) as amountfilms
from film_category
group by category_id 
order by amountfilms DESC;

--ÖRNEK :
SELECT * FROM customer
ORDER BY first_name,last_name

--ÖRNEK :
SELECT * FROM customer
ORDER BY first_name ASC,last_name DESC;

