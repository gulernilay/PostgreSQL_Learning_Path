--country tablosunda bulunan country sütunundaki ülke isimlerinden 'A' karakteri ile başlayıp 'a' karakteri ile sonlananları sıralayınız.
select country from country where country like 'A%a' order by country
--country tablosunda bulunan country sütunundaki ülke isimlerinden en az 6 karakterden oluşan ve sonu 'n' karakteri ile sonlananları sıralayınız.
select country from country where country like '______%n' order by country

SELECT country
FROM country
WHERE LENGTH(country) >= 6 AND country LIKE '%n'
ORDER BY country;


--film tablosunda bulunan title sütunundaki film isimlerinden en az 4 adet büyük ya da küçük harf farketmesizin 'T' karakteri içeren film isimlerini sıralayınız.
select title from film WHERE LENGTH(LOWER(title)) - LENGTH(REPLACE(LOWER(title), 't', '')) >= 4 ORDER BY title; 
--film tablosunda bulunan tüm sütunlardaki verilerden title 'C' karakteri ile başlayan ve uzunluğu (length) 90 dan büyük olan ve rental_rate 2.99 olan verileri sıralayınız.SELECT *
FROM film
WHERE title LIKE 'C%' 
  AND length > 90
  AND rental_rate = 2.99
ORDER BY title;