-- JOIN YAPISI :

--1-) INNER JOIN / JOIN : 
--Ortak elemanlara sahip farklı tabloları birleştirmeye yardımcı olur. Null kalamaz. 
--Genellikle birincil anahtar (primary key) ve yabancı anahtar (foreign key) ilişkisi olan kolonlar kullanılır.
--Sadece her iki tabloda da eşleşen satırları döndürür. 

SELECT *
FROM Ogrenciler o -- bu tablonu referans alıyosun. 
INNER JOIN Bolumler b ON o.bolum_id = b.id; -- bölümler tablosun da da olan öğrenciler kalır. 
--
select f.title,o.name as category  from film o  inner join film_category f on o.category_id=f.category_id


--Her film için kategori adını listeleyin
select f.title, fc.category_id , c.name
from film f 
inner join  film_category fc on fc.film_id=f.film_id
inner join category c on c.category_id=fc.category_id



--2-)LEFT JOIN:Sol tablodaki tüm kayıtlar gelir, sağdan eşleşen varsa gelir, yoksa NULL.

-- Bölümü olmayan öğrenciler de görünür ama bölüm bilgisi NULL olur.
SELECT c.customer_id, count(r.rental_id) as amountrental
FROM customer c 
LEFT JOIN rental r ON c.customer_id = r.customer_id
group by  c.customer_id
-- 
SELECT *
FROM rental r customer c 
LEFT JOIN customer c ON c.customer_id = r.customer_id
-- 
SELECT c.customer_id, count(r.rental_id) as amountrental
FROM rental r 
LEFT JOIN customer c ON c.customer_id = r.customer_id
group by  c.customer_id



--3-)RIGHT JOIN:Sağ tablodaki tüm kayıtlar gelir, sol tabloyla eşleşmeyenler için NULL.

--Hiç öğrencisi olmayan bölümler de görünür. 
SELECT r.rental_id, c.first_name
FROM rental r  
RIGHT JOIN customer c ON r.customer_id = c.customer_id;


--4-)Full Outer Join /FULL JOIN  : PostgreSQL Destekler.Hem sol hem sağ tablonun tüm satırlarını gösterir. Eşleşmeyenler için NULL döner.
--The FULL JOIN keyword selects ALL records from both tables, even if there is not a match. For rows with a match the values from both tables are available, if there is not a match the empty fields will get the value NULL.


SELECT c.first_name, p.amount
FROM customer c
FULL OUTER JOIN payment p ON c.customer_id = p.customer_id;

--Her müşteriyi (customer) ve bu müşterilere ait ödeme işlemlerini (payment) listeleyin.Ödeme yapmamış müşteriler ve müşteri bilgisi olmayan ödemeler de görünmelidir. ( tüm tabloyu bana göster)
select c.first_name,p.amount,p.payment_date
from customer c
FULL OUTER JOIN payment p on p.customer_id=c.customer_id
--
SELECT *
FROM Ogrenciler o
FULL OUTER JOIN Bolumler b ON o.bolum_id = b.id;


---)CROSS JOIN: Manuel eşleşme olmayan, yani her satırın her satırla eşleştiği durumlarda kullanılır. Bu tür sorgular genellikle dikkatli kullanılmalıdır çünkü sonuç satır sayısı katlanarak artar (örn. 100 satır × 50 satır = 5000 satır sonuç!).
--İki tabloyu koşulsuz şekilde çarpan birleştirmedir.Her satır, diğer tablodaki tüm satırlarla eşleşir.Genellikle kombinasyon üretmek, olasılıkları listelemek gibi durumlarda kullanılır.

--Elimizde 3 film (film table) , 2 mağaza(store) var diyelim. her filmi her mağazada göstermek istiyorsak cross join ile 2000 satır gelir. Müşterilere sunulabilecek tüm mağaza-kampanya kombinasyonlarını oluşturmakwf
select f.title, s.store_id
from film f
cross join store s
---
SELECT *
FROM Ogrenciler
CROSS JOIN Bolumler;
--
SELECT 
    customer_id,
    first_name,
    last_name,
    amount,
    payment_date
FROM payment
NATURAL JOIN customer
LIMIT 10;

--
SELECT 
    c1.customer_id AS customer_1_id,
    c1.first_name || ' ' || c1.last_name AS customer_1_name,
    c2.customer_id AS customer_2_id,
    c2.first_name || ' ' || c2.last_name AS customer_2_name,
    a.address AS common_address
FROM 
    customer c1
JOIN 
    customer c2 ON c1.address_id = c2.address_id
JOIN 
    address a ON c1.address_id = a.address_id
WHERE 
    c1.customer_id < c2.customer_id
ORDER BY 
    common_address;

	
------------------------------------------------------------UNION OPERATOR------------------------------------------------------
--UNION, birden fazla SELECT sorgusunun sonuçlarını birleştirir ve tek tablo olarak gösterir.Yinelenen satırları otomatik olarak kaldırır.(Eğer tüm satırları görmek istersen: UNION ALL kullanılır.)

--Kurallar:
--Tüm sorguların seçtiği sütun sayısı ve veri tipleri aynı olmalı.
--Sıralama yalnızca en son sorguda kullanılmalı (ORDER BY).
--UNION duplicate satırları gizler, UNION ALL ise gösterir.

--Müşterilerden (customer) adı "A" harfiyle başlayanlar + Personellerden (staff) adı "A" harfiyle başlayanlar
SELECT first_name, last_name, 'Customer' AS role
FROM customer
WHERE first_name ILIKE 'A%'
UNION ALL
SELECT first_name, last_name, 'Staff' AS role
FROM staff
WHERE first_name ILIKE 'A%';--Aynı isim ve soyad varsa tekrar etmez , role sütunu sayesinde nereden geldiğini görürüz


--------------------------------------------CASE OPERATOR ----------------------------------------------------
--The CASE expression goes through conditions and returns a value when the first condition is met (like an if-then-else statement).
--Once a condition is true, it will stop reading and return the result. If no conditions are true, it returns the value in the ELSE clause.
--If there is no ELSE part and no conditions are true, it returns NULL.

CASE 
    WHEN koşul1 THEN değer1
    WHEN koşul2 THEN değer2
    ELSE varsayılan_değer
END
-----
SELECT product_name,
CASE
  WHEN price < 10 THEN 'Low price product'
  WHEN price > 50 THEN 'High price product'
ELSE
  'Normal product'
END
FROM products;

---
SELECT title,length,
    CASE 
 	    when length<60 then 'Kısa'
	    when length>60 and length<120 then 'Orta'
		when length >120 then 'Uzun'
	end as length_category
from film;

---
SELECT first_name,last_name,active,
    CASE 
 	    when active=1 then 'Aktif'
	    when active=0 then 'Pasif'
	end as activity_category
from customer;

-------------------------------------------------------NOTLAR---------------------------------------------------------

--OUTER JOIN, veritabanlarında iki tabloyu birleştirirken eşleşmeyen kayıtların da sorgu sonucuna dahil edilmesini sağlar.
--OUTER JOIN üç ana türe ayrılır: LEFT OUTER JOIN, RIGHT OUTER JOIN ve FULL OUTER JOIN. 
--Bunların farkı, hangi tarafın (sol, sağ, her iki) eşleşmeyen satırlarının sonuçlara dahil edileceğiyle ilgilidir.


--🔹 1. LEFT OUTER JOIN
--Sol (birinci) tablodaki tüm kayıtlar alınır. Sağ tabloda eşleşen kayıt varsa getirilir, yoksa NULL döner.
SELECT * 
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id; --customers tablosundaki her kayıt görünür. orders tablosunda eşleşme yoksa, o kısımlar NULL olur. 
-- Kullanım Amacı: "Müşteri olsun, sipariş olsun veya olmasın" gibi analizlerde kullanılır.



--🔹 2. RIGHT OUTER JOIN
--Sağ (ikinci) tablodaki tüm kayıtlar alınır. Sol tabloda eşleşme varsa getirilir, yoksa NULL döner.
SELECT * 
FROM customers c
RIGHT JOIN orders o ON c.id = o.customer_id;--orders tablosundaki her kayıt görünür.customers tablosunda eşleşme yoksa, NULL olur.
--📌 Kullanım Amacı: Özellikle "tüm siparişleri listele, müşteri bilgisi eksik olsa da" gibi durumlarda.



--🔹 3. FULL OUTER JOIN
--Hem sol hem sağ tablonun tüm kayıtları alınır. Her iki tarafta eşleşme yoksa, karşı taraf NULL olur.
SELECT * 
FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id;--Hem customers hem orders tablosundaki eşleşmeyen kayıtlar dahil edilir.En kapsayıcı join türüdür.
--📌 Kullanım Amacı: İki veri kümesi arasındaki farkları analiz etmek için idealdir (örneğin: eksik eşleşme kontrolü).
--OUTER JOIN kullanırken dikkat edilmesi gereken en önemli şey, NULL değerlerin sorgu mantığını etkileyebilmesidir. 
--Özellikle WHERE koşullarında dikkatli olunmalı; örneğin WHERE o.customer_id IS NULL gibi filtreler OUTER JOIN'in esas anlamını boşa çıkarabilir.
--Ayrıca performans açısından, OUTER JOIN’ler genellikle daha maliyetli olduğu için indeks stratejileriyle birlikte değerlendirilmelidir.



--4.Self JOIN (Kendinden Birleştirme)
--Self JOIN, aynı tablonun iki farklı örneği (alias) üzerinden birbirine birleştirilmesi (JOIN) işlemidir.
--Tabloyu iki kez (veya daha fazla kez) kullanmak istediğimiz durumlarda, her birine farklı takma ad (alias) vererek aralarında ilişki kurarız.
--Örneğin bir employee tablosunda her çalışanın bir “yöneticisi” (manager_id) olabilir.
--employee tablosunu kendisiyle birleştirerek “çalışan–yönetici” ilişkisini sorgulayabiliriz.
--Sosyal ağlarda veya ilişkisel sistemlerde, aynı kullanıcı tablosundaki “kullanıcı – arkadaş” eşleştirmelerini göstermek için.
--Ürünler arası komplemanterlik veya ikame ilişkisi (aynı ürünler tablosunun içinde “parça – ana ürün” ilişkisi).
--Her iki tablo örneğine (alias) özgü sütun adlarını kullanarak filtreleme yaparız.

--Örnek: Bir employee tablosunda employee_id ve manager_id sütunları olsun. Her satır, çalışanın kendi bilgilerini ve yöneticisinin bilgilerini birleştirerek getirebilir.
SELECT 
    e.employee_id        AS calisan_id,
    e.first_name         AS calisan_adi,
    e.last_name          AS calisan_soyadi,
    m.employee_id        AS yonetici_id,
    m.first_name         AS yonetici_adi,
    m.last_name          AS yonetici_soyadi
FROM 
    employee e
LEFT JOIN 
    employee m 
    ON e.manager_id = m.employee_id;


--5. Natural JOIN
--Natural JOIN, birleştirme (JOIN) sırasında aynı isimdeki tüm sütunları otomatik olarak “eşleşme koşulu” olarak kullanır.
--Yani, TTLTZ (Table1 ⨝ Table2) yaparken, iki tablo arasında ortak sütun adları varsa, hem USING() hem de ON ifadesine ihtiyaç duymadan otomatik olarak eşler.
--Kullanım Alanları
--İki (veya daha fazla) tabloda aynı ada sahip sütun(lar) varsa, tek satırda yazabileceğimiz hızlı bir JOIN sağlar.
--Küçük projelerde, mantıksal olarak “isimleri” aynı olan sütunları eşleştirmek istediğimizde kodu kısaltır.
--Gözden Kaçan Şartları Önler : USING (id) veya ON t1.id = t2.id gibi şartları manuel yazmaya gerek kalmaz; otomatik eşleşme gerçekleşir.
--Ortaya Çıkan Risk:“Adı aynı ama anlamı farklı” sütunları da otomatik olarak eşleştireceği için beklenmedik sonuçlar doğurabilir.Sütun isimlerini değiştirmek veya USING/ON kullanmak daha net ve güvenli olabilir.
--Sütun Listesi:NATURAL JOIN yapıldıktan sonra sonuç setinde, ortak sütunlar yalnızca bir kere yer alır (duplicate listelenmez).
--Örnek Senaryo:film ve inventory tablolarının her ikisinde de film_id adlı bir sütun var.


--Self JOIN
--Alias’lar mutlaka açık ve anlamlı olsun (ör. e yerine employee, m yerine manager).
--Özellikle hiyerarşik yapıda döngü oluşturabileceğiniz edge-case’lere dikkat edin.
--LEFT JOIN veya INNER JOIN kullanımı, eksik ilişki (NULL manager) durumunu kontrol etmenizi sağlar.

--Natural JOIN
--Tablolar arasında yalnızca gerçekten eş anlamlı sütunlar varsa tercih edin.
--Eğer “isim çakışması” olabilecek sütunlar varsa, manuel JOIN … ON ... veya JOIN … USING(...) kullanmak daha güvenlidir.
--Karmaşık veri modeline sahip büyük projelerde Natural JOIN’den kaçınıp açık şartlı JOIN (ON/USING) tercih edin.


















