--Yeni bir müşteri kaydı eklemek için customer tablosuna, isim, soyisim, e-posta ve aktiflik bilgisi girilecek şekilde bir INSERT INTO sorgusu yazınız.

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (1, 'John', 'Doe', 'john.doe@example.com', 5, true, CURRENT_DATE);

--customer tablosunda, müşteri ID’si 42 olan kişinin e-posta adresini newmail@exampleemail.com olarak güncelleyen bir UPDATE sorgusu yazınız.
update customer
set email='newmail@exampleemail.com'
where customer_id=42

--payment tablosuna payment_method adında yeni bir sütun (VARCHAR(20)) eklemek için gerekli ALTER TABLE sorgusunu yazınız.
ALTER TABLE payment ADD column payment_method varchar(20);


--Müşteri yorumlarını saklamak için customer_feedback adında feedback_id, customer_id, comment, feedback_date sütunlarına sahip bir tablo oluşturacak CREATE TABLE sorgusunu yazınız. 
create table customer_feedback (
	feedback_id INT primary key,
	customer_id INT Not null,
	comment text,
	feedback_date DATE default CURRENT_DATE	
)

--rental tablosunda, 2005-05-25 tarihinden önce yapılmış tüm kiralamaları silmek için bir DELETE sorgusu yazınız.
delete from rental
where rental_date<'2005-05-25'

--test_table adındaki örnek bir tabloyu veritabanından tamamen silmek için gerekli DROP TABLE sorgusunu yazınız. 
drop table employees_deneme 