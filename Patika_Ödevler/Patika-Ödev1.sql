--Q1: film tablosunda bulunan title ve description sütunlarındaki verileri sıralayınız. 
select title ,description from film 

--Q2: film tablosunda bulunan tüm sütunlardaki verileri film uzunluğu (length) 60 dan büyük VE 75 ten küçük olma koşullarıyla sıralayınız.
select * from film where length between 60 and 75 order by length 

--Q3: film tablosunda bulunan tüm sütunlardaki verileri rental_rate 0.99 VE replacement_cost 12.99 VEYA 28.99 olma koşullarıyla sıralayınız.
select * from film where rental_rate = 0.99 AND (replacement_cost = 12.99 OR replacement_cost = 28.99) order by title

--Q4: customer tablosunda bulunan first_name sütunundaki değeri 'Mary' olan müşterinin last_name sütunundaki değeri nedir?
select last_name from customer where first_name='Mary'

--Q5:film tablosundaki uzunluğu(length) 50 ten büyük OLMAYIP aynı zamanda rental_rate değeri 2.99 veya 4.99 OLMAYAN verileri sıralayınız.
select * from film WHERE length <= 50 AND rental_rate NOT IN (2.99, 4.99)
