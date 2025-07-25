-- En az bir kiralama yapmış müşterilerin ad ve soyadlarını listeleyiniz. EXISTS 
select first_name,last_name from customer c
where exists (select 1 from rental r where r.customer_id = c.customer_id )


--Tüm personellerin işlem yaptığı ödemelerden daha yüksek tutarda olan ödeme kayıtlarını listeleyiniz. ALL
select payment_id from payment p where p.amount > ALL(select amount from payment where staff_id IN (1,2) )


--Herhangi bir kiralama işlemi 5 gün veya daha uzun süren müşterilerin ad ve soyadlarını listeleyiniz.  
select first_name,last_name 
from customer c
where customer_id =ANY()


