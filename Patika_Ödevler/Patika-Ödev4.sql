
--film tablosunda bulunan replacement_cost sütununda bulunan birbirinden farklı değerleri sıralayınız.
select distinct replacement_cost from film 

--film tablosunda bulunan replacement_cost sütununda birbirinden farklı kaç tane veri vardır?
select count (distinct replacement_cost) from film

--film tablosunda bulunan film isimlerinde (title) kaç tanesini T karakteri ile başlar ve aynı zamanda rating 'G' ye eşittir?
select count(*) as numberofdifferent from film where title like 'T%' and rating='G'

--country tablosunda bulunan ülke isimlerinden (country) kaç tanesi 5 karakterden oluşmaktadır?
select count(*) as numberofcountry from country where country like '_____' --option 1 
select count(*) as numberofcountry from country where length(country)=5 --option 2 

--city tablosundaki şehir isimlerinin kaç tanesi 'R' veya r karakteri ile biter?
select count(*) numberofcity from city where city like '%R' or city like '%r'