--TRANSACTION
--Transaction, bir veritabanında yapılan bir dizi işlemin (INSERT, UPDATE, DELETE vb.) bir bütün olarak ele alınıp, 
--ya tamamen gerçekleştirilmesi (commit) ya da tamamen geri alınmasıdır (rollback).
-- Temel Özellikleri: ACID
--Özellik							Açıklama
--A - Atomicity (Atomiklik)		Transaction’daki işlemler bölünemez bir bütündür. Ya hepsi olur ya hiçbiri.
--C - Consistency (Tutarlılık)	Transaction, veritabanını bir geçerli durumdan diğerine taşır. Kuralları bozan bir işlem yapılmaz.
--I - Isolation (Yalıtım)			Transaction’lar birbirini etkilemeden çalışır. Paralel işlemler çakışmaz.
--D - Durability (Kalıcılık)		Commit edilen işlemler kalıcıdır; sistem çökse bile kaybolmaz.

--TRANSACTIONAL COMMANDS: BEGIN , COMMIT,ROLLBACK 
BEGIN; --transaction başlatır 
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT; --COMMIT OR END TRANSACTION → İşlemler kalıcı hale gelir. To save the changes, alternatively you can use END TRANSACTION command.
--Eğer bir hata olursa ROLLBACK ile tüm işlemler iptal edilir.


BEGIN;-- or BEGIN TRANSACTION 
UPDATE inventory SET stock = stock - 10 WHERE product_id = 1;
-- Hata oldu! Örneğin ürün bulunamadı veya stok yetersiz
ROLLBACK; --Hiçbir değişiklik uygulanmaz; transaction başa sarılır.


--The ROLLBACK command is the transactional command used to undo transactions that have not already been saved to the database.
--The ROLLBACK command can only be used to undo transactions since the last COMMIT or ROLLBACK command was issued.


-- Transaction’lar Ne Zaman Kullanılır?
--Banka işlemleri (para transferi)
--Sipariş – stok – fatura zinciri
--Çok tabloluk veri güncellemelerinde tutarlılığı korumak
--Birden fazla INSERT/UPDATE içeren işlemler


--a transaction is a logical unit of work that uses SQL queries to combine one or more database operations. 
--These operations shows the sequences like INSERT, UPDATE, DELETE, or SELECT. 
--When executing multiple queries as a transaction, proper error handling is required for maintaining data integrity.

--Transactions Properties in PostgreSQL
--Transactions follow four standard properties which is referred by the acronym ACID −
--Atomicity 		− Ensures that all operations within the work unit are completed successfully; otherwise, the transaction is aborted at the point of failure and previous operations are rolled back to their former state.
--Consistency 		− Ensures that the database properly changes states upon a successfully committed transaction.
--Isolation 		− Enables transactions to operate independently of and transparent to each other.
--Durability		− Ensures that the result or effect of a committed transaction persists in case of a system failure.

--Transactional control commands are only used with the DML commands INSERT, UPDATE and DELETE only. 
--They cannot be used while creating tables or dropping them because these operations are automatically committed in the database.


BEGIN;
-- 1. Yeni kiralama ekle
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (CURRENT_TIMESTAMP, 1, 1, 1)
RETURNING rental_id;
-- Diyelim ki dönen rental_id = 16050 olsun (uygulamada saklanır)
-- 2. Ödeme işlemini ekle
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, 16050, 4.99, CURRENT_TIMESTAMP);
-- 3. Tüm işlemleri kalıcılaştır
COMMIT; --Hayır, bir COMMIT işleminden sonra veritabanı seviyesinde rollback yapılamaz. Çünkü COMMIT, transaction içindeki tüm değişiklikleri kalıcı olarak veritabanına yazar.
--COMMIT komutu, disk üzerine yazma işlemini tamamlar.Bu andan itibaren, veritabanı sistemi o değişiklikleri geri alma (rollback) için gereken bilgileri serbest bırakır.
--Bu nedenle ROLLBACK artık mümkün değildir.Elle manual geri alabilirsin. Eğer transaction büyük çaplı veri kaybına yol açtıysa, yedeğe dönülür.
--In PostgreSQL, COMMIT is used for saving all the changes made by the current transaction. Once you run the COMMIT statement, all the changes you made (like adding, updating, or deleting data) since the last COMMIT or ROLLBACK are permanently saved in the database. After that, those changes cannot be removed.
BEGIN;
-- işlemler...
-- bir hata meydana gelirse:
ROLLBACK;





--To undertand its usage in transaction remember the below points −
--i. Transaction starts with BEGIN or START TRANSACTION.
--ii. Mostly SQL statement are executed to resolve the transaction issues.
--iii. If everything is successful, COMMIT is required to save the changes permanently.
--iv. If an error occurs then ROLLBACK will be used to undo the changes.


--. Explicit Commit (Açık Onaylama)
--Geliştiricinin transaction’ı manuel olarak başlattığı ve COMMIT komutunu açıkça yazdığı durumdur.
BEGIN;  -- Transaction başlat
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;  -- Açıkça commit edilir
--Birden fazla işlem tutarlı şekilde yapılmak istendiğinde
--İşlemlerin geri alınabilme ihtimali varsa (ROLLBACK)
--Karmaşık iş akışlarında (bankacılık, e-ticaret, stok yönetimi vs.)


--Implicit Commit (Gizli/Otomatik Onaylama)
--Veritabanı sisteminin kendi başına transaction’ı başlatıp, işlem sonunda otomatik olarak commit etmesidir. Geliştirici BEGIN veya COMMIT yazmaz.
UPDATE employees SET salary = salary * 1.05;
-- Bu komut çalıştığında PostgreSQL işlem öncesinde BEGIN, sonrasında otomatik COMMIT yapar.
--Ayrıca bazı komutlar her zaman implicit commit tetikler:
--DDL komutları: CREATE, ALTER, DROP
--PostgreSQL’de bu komutlar otomatik commit ile çalışır.
CREATE TABLE test (...);  -- Bu işlem implicit commit yapar




--Özellik						Explicit Commit								Implicit Commit
--Kontrol						Geliştiricinin elindedir					Veritabanı otomatik yapar
--Kullanım						BEGIN ... COMMIT ile açık yapılır			Her işlem otomatik commit edilir
--Rollback imkânı				Evet, işlem geri alınabilir					Hayır, işlem anında kalıcı olur
--Performans					Daha kontrollü								Daha hızlı ama risklidir
--Tipik Kullanım Alanı			Çok adımlı işlemler, hata toleransı			Basit tek adımlı işlemler
--DDL etkisi					Transaction içinde olabilir					DDL (CREATE, DROP) işlemleri otomatik commit yapar

--Explicit commit → “Bu işlemleri tamamla” demek bizim elimizde.
--Implicit commit → “Veritabanı arka planda işi yaptı ve kapattı” demektir.Changes are automatically saved without requiring a COMMIT command.

--Feature						Implicit Commit															Explicit Commit
--Definition					Changes are automatically saved without requiring a COMMIT command.		Changes are saved only when the user explicitly issues a COMMIT command.
--Control						Automatic																Manual
--When it happens				After certain statements (e.g., DDL) or in autocommit mode.				Only when COMMIT is issued.
--Transaction block				Not required															Required for grouping multiple operations into a single transaction.
--Rollback						Not possible after autocommit.											Possible until COMMIT is issued.
--Use case						Simple, single-statement operations.									Complex, multi-statement transactions requiring atomicity.


--What is ROLLBACK in PostgreSQL?
--In PostgreSQL, ROLLBACK removes the changes made in a transaction before they are permanently saved. It is used to undo mistakes and restore the database to its original state.


--Relationship Between ROLLBACK and COMMIT
--COMMIT permanently saves changes made in a transaction.
--ROLLBACK removes the changes if something goes wrong.
--Both work together to maintain database integrity.

--When do we need ROLLBACK?
--Imagine you transfers the money from one bank account to another. First, the amount is deducted from your account. If the deposit to the other account fails due to a system issue, the deducted money should be returned. This is where ROLLBACK helps − it cancels incomplete transactions and prevents data errors.
--Importance of ROLLBACK in Transactions
--Preventing Data Errors − If an operation goes wrong, ROLLBACK cancels unwanted changes.
--Maintains Data Consistency − This check whether valid data is saved.
--Protects Against System Failures − If a system crashes mid-transaction, ROLLBACK prevents partial updates.
--Controlled Testing − The developer can test the transactions without makes any permanent changes.
--Enhances User Trust − The banking, e−commerce, and other critical systems use ROLLBACK to protect user transactions.


--How ROLLBACK Works?
--Suppose an online shopping site updates inventory when someone places an order. The process involves the following −
--It reduce the stocks for the buying items.
--It charges the customer payments.
--Suppose the payment fails, the stock should not be reduced. ROLLBACK ensures the stock is restored if the transaction is incomplete.


BEGIN;
INSERT INTO employees (id, name, position, salary, department, hire_date)
VALUES (6, 'Rahul', 'Developer', 72000.00, 'Engineering', '2023-10-01');
-- If something goes wrong, use ROLLBACK
ROLLBACK;
SELECT * FROM employees; --try to check the new info present on the tabşe 






---------------------------------------------------------------RELATIONSHIPS---------------------------------------------------------------------------------------------------
--One to one : Her personel (staff) kaydı tek bir adrese sahiptir.Her address kaydı yalnızca bir personel tarafından kullanılır.
SELECT s.first_name, a.address
FROM staff s
JOIN address a ON s.address_id = a.address_id;
-- Bu ilişki bire-bir’dir çünkü address_id hem address tablosunda primary key, hem de staff tablosunda foreign key olarak bulunur.

--One-to-many: Bir müşteri birçok kiralama yapabilir. Ama her kiralama yalnızca bir müşteriye aittir. 
SELECT c.first_name, r.rental_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id; --customer_id burada rental tablosunda foreign key’dir, customer tablosunda ise primary key.

--Many-to-one: Çok sayıda kiralama, aynı film kopyasından (inventory) yapılmış olabilir.
SELECT r.rental_id, i.film_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id;-- rental tablosundaki birçok kayıt, inventory tablosundaki tek bir kayıtla eşleşebilir.

--Many-to-many: Bir filmde birden çok aktör oynayabilir.Bir aktör birden fazla filmde rol alabilir. 
SELECT f.title, a.first_name || ' ' || a.last_name AS actor_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id;











