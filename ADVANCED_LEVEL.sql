---------------------------------------------------------------------VIEWS---------------------------------------------------------------------------------------------------

--Bir veya birden fazla tablodan tüm / seçili satırlardan meydana gelirler. Aslında gerçek tablo değil- ancak Select açısından gerçek tablo gibi görünürler.
--View, bir gerçek tablonun alt kümesini temsil edebilir ,  yalnızca belirli sütun veya satırları seçerek yapılır.Bir view, birden fazla tablonun join’lenmiş halini bile temsil edebilir.
--Görünümlere ayrı yetkiler atanabildiği için, kullanıcıların yalnızca belirli satırları veya sütunları görmesini sağlayarak tablo erişimini kısıtlamak için kullanılabilirler.
--Görünümler, sıradan tablolar olmadıkları için, genellikle DELETE, INSERT veya UPDATE işlemleri doğrudan üzerlerinde çalışmaz.
--Ancak, bu işlemleri görünümler üzerinden çalışabilir hale getirmek için RULE (kural) oluşturabilirsin.
--Görünümler (views) sadece veri görüntülemek için tasarlanmış yapılardır.
--Onlar üzerinden veri değiştirmek (INSERT, UPDATE, DELETE) her zaman mümkün değildir.
--Özellikle bir görünüm, birden fazla tabloyu birleştiriyorsa (JOIN), hangi tabloya nasıl güncelleme yapılacağı belirsizdir.
--Ancak PostgreSQL gibi sistemlerde, RULE yazarak, "bu görünümde biri DELETE yaparsa, aslında git X tablosundan şu satırı sil" diyebilirsin.


--Create view
create view namaeX as --create view temp/tempororary view name as : temp/temporary varsa the view will be created in the temporary space.
select column1,column2
from table_nameX
where
--
create view deneme as 
select film_id,title,description,length
from film
where length>20

--Drop view 
drop view deneme 

--DDL komutlarını view içinde çalıştırabilmek için rule eklenmelidir.
CREATE RULE deneme_delete AS -- DELETE işlemi için rule : View'den bir satır silinmek istenirse (DELETE FROM deneme WHERE film_id = 5).Aslında film tablosundaki ilgili satır silinir
ON DELETE TO deneme
DO INSTEAD
DELETE FROM film
WHERE film_id = OLD.film_id;

CREATE RULE deneme AS --INSERT işlemi için RULE 
ON DELETE TO active_customers
DO INSTEAD
DELETE FROM customer WHERE customer_id = OLD.customer_id;

--RULE sistemi PostgreSQL’e özgüdür. Modern senaryolarda INSTEAD OF TRIGGER kullanımı daha esnektir.
--View kullanmının amacı  :  yinelenen sorguları yeniden yazmamak , abstraction :  hangi tablodan neyi joinlediğine bakmaksızın neye baktığını göyüosun ,(veri gizliliği ve kısıtlama)  kullanıcılara sadece bazı sütun ve satırları gösterirsin. 



----------------------------------------------------------------------NULL VALUES--------------------------------------------------------------------
--A field with a NULL value is a field with no value. It is very important to understand that a NULL value is different from a zero value or a field that contains spaces.
--Null :  yok-tanımsız
--0: sayısal değer
--space: 1 karakterli string 





-----------------------------------------------------------------------TRIGGERS----------------------------------------------------------------------
--Belirli bir veritabanı olayı gerçekleştiğinde otomatik olarak çalışan (callback) fonksiyonlardır.
--Trigger (tetikleyici), veritabanında bir tabloya INSERT, UPDATE veya DELETE işlemi uygulandığında otomatik olarak çalışan bir yapıdır.

--Neden trigger kullanılır : 
--Otomasyon sağlamak - Örneğin, bir kayıt silinince otomatik log tutmak 
--Denetim ve loglama yapmak -Değişiklikleri başka tabloya yazmak 
--Hesaplamaları otomatikleştirmek-	Örneğin bir toplam alanı güncellemek

-- Trigger şu zamanlarda tetiklenebilir:
--BEFORE: Satır üzerinde işlem yapılmadan önce (kısıtlamalar kontrol edilmeden önce, INSERT, UPDATE veya DELETE girişimi yapılmadan önce)
--AFTER: İşlem tamamlandıktan sonra (kısıtlamalar kontrol edildikten sonra, INSERT, UPDATE veya DELETE tamamlandıktan sonra)
--INSTEAD OF: Gerçek işlem yerine tetiklenir (özellikle view’lar üzerindeki INSERT, UPDATE, DELETE işlemleri için)

--FOR EACH ROW vs FOR EACH STATEMENT
--FOR EACH ROW olarak tanımlanan bir trigger, işlem tarafından değiştirilen her satır için ayrı ayrı bir kez çalıştırılır.
--FOR EACH STATEMENT ise sadece bir kez, işlem başına çalıştırılır – işlem kaç satırı etkilerse etkilesin.


--NEW.column_name ve OLD.column_name
--WHEN koşulu ve trigger içinde yazılan PostgreSQL ifadeleri, ilgili satıra ait değerleri şu şekilde kullanabilir:
--NEW.column_name → Yeni değer (INSERT/UPDATE sonrası)
--OLD.column_name → Eski değer (DELETE/UPDATE öncesi)


-- WHEN Koşulu
--Eğer bir WHEN koşulu tanımlanmışsa, belirtilen PostgreSQL komutları sadece bu koşulun TRUE döndüğü satırlar için çalıştırılır.
--WHEN koşulu verilmemişse, trigger tüm uygun satırlar için çalıştırılır.

-- Aynı türde birden fazla trigger varsa
--Aynı olay için tanımlanmış birden fazla trigger varsa, alfabetik sıraya göre (isimlerine göre) çalıştırılırlar.


-- BEFORE / AFTER / INSTEAD OF Seçimi
--Trigger’ın ne zaman çalışacağını belirler:
--BEFORE → Kayıt yapılmadan önce
--AFTER → Kayıt yapıldıktan sonra
--INSTEAD OF → Asıl işlemin yerine

-- Tablo silinirse trigger da silinir.Trigger’lar, ilişkilendirildikleri tablo silindiğinde otomatik olarak kaldırılır.
-- Tablolar aynı veritabanında olmalı,Trigger’ın değiştireceği tablo ile ilişkilendirildiği tablo/view aynı veritabanında bulunmalıdır.
--database.tablename kullanılamaz, sadece tablename yazılmalıdır.

-- CONSTRAINT trigger
--Eğer CONSTRAINT seçeneği kullanılırsa, bu bir constraint trigger (kısıtlama tetikleyicisi) olur.
--Normal trigger gibidir ancak SET CONSTRAINTS komutu ile tetikleme zamanı ayarlanabilir.
--Bu tür trigger’lar genellikle kısıtlama ihlali durumunda hata fırlatmak (EXCEPTION) amacıyla kullanılır.

--Trigger sadece tek bir tabloya atanır. PostgreSQL’de trigger'lar tabloya özgü olarak tanımlanır. Yani bir trigger, belirli bir tabloya veya view'e bağlıdır ve sadece o tablo üzerinde gerçekleşen belirli bir olay (INSERT, UPDATE, DELETE) sonucunda tetiklenir.
--trigger ile procedure kullanılmaaz. 
--Neden PROCEDURE kullanılamaz?
--✅ FUNCTION → RETURNS TRIGGER	:Trigger tetiklendiğinde veritabanı, fonksiyonun eski ve yeni satırları döndürebileceğini ve trigger kurallarına uyduğunu varsayar.
--❌ PROCEDURE → RETURNS VOID:Trigger mekanizması, PROCEDURE'ün dönüş yapısını tanımaz; NEW, OLD gibi değerlerle etkileşemez.
--Fonksiyonun içinde procedure çağırma kurabilirsin. 
-- bir customer tablosuna tanımlı tüm triggerları listeler. 
SELECT trigger_name, event_manipulation, action_timing
FROM information_schema.triggers
WHERE event_object_table = 'customer';


--1-Trigger Function 
--2-Trigger tanımlanacak 

create table logtable(
	deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	customer_id INT 
)

CREATE OR REPLACE FUNCTION log_customer_delete() --log tablsouna kaydetme fonksiyonu 

RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO customer_delete_log (customer_id)
    VALUES (OLD.customer_id);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_customer_delete
AFTER DELETE ON customer   -- create trigger trigger_name before/after/instead of   [INSERT/DELETE/UPDATE/TRUNCATE] on table_name [......]
FOR EACH ROW
EXECUTE FUNCTION log_customer_delete();


--Kiralama yapılırken stok yetersizse engelle.rental eklemeden önce, film stoğu 0 ise işlemi engelle.

CREATE OR REPLACE FUNCTION check_inventory_before_rent()--trigger fonksiyonu 
RETURNS TRIGGER AS $$
DECLARE
    stock_count INT;
BEGIN
    SELECT COUNT(*) INTO stock_count
    FROM inventory
    WHERE inventory_id = NEW.inventory_id;

    IF stock_count = 0 THEN
        RAISE EXCEPTION 'Bu ürün stokta yok!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_stock
BEFORE INSERT ON rental
FOR EACH ROW
EXECUTE FUNCTION check_inventory_before_rent();



--Güncellenen filmin uzunluğu loglansın.Eğer bir film güncellenirken length değeri değişirse, eski ve yeni değer loglansın.
CREATE TABLE film_length_log (
    film_id INT,
    old_length INT,
    new_length INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_film_length_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.length IS DISTINCT FROM NEW.length THEN
        INSERT INTO film_length_log (film_id, old_length, new_length)
        VALUES (OLD.film_id, OLD.length, NEW.length);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_film_length_change
AFTER UPDATE ON film
FOR EACH ROW
EXECUTE FUNCTION log_film_length_change();


--Soft Delete (Müşteri silinmesin, sadece işaretlensin).Gerçekten silmek yerine, active = false yap.

CREATE OR REPLACE FUNCTION soft_delete_customer()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE customer
    SET active = false
    WHERE customer_id = OLD.customer_id;

    RETURN NULL;  -- Silme işlemini iptal et
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_soft_delete_customer
BEFORE DELETE ON customer
FOR EACH ROW
EXECUTE FUNCTION soft_delete_customer();


--Hangi Trigger Türü Ne Zaman?
--BEFORE INSERT		Veri eklenmeden önce kontrol/ayar yapmak
--AFTER DELETE		Silinen veriyi loglamak
--AFTER UPDATE		Değişiklikleri izlemek/loglamak
--BEFORE DELETE		Silme işlemini durdurup yönlendirmek

--Tetikleme	 : 				Tabloya INSERT, UPDATE, DELETE vs. yapılır
--Trigger devreye girer	:	Belirtilen olay için tanımlanmış trigger tetiklenir
--Fonksiyon çağrılır	:	Trigger fonksiyonu (RETURNS TRIGGER) çalıştırılır

-- bir tabloya trigger eklediğinde, bu trigger tetiklendiğinde bir fonksiyon çağrılır. Eğer bu fonksiyon, kullanıcın erişemediği bir şemada tanımlıysa, trigger çalışmaz 


--Drop trigger
drop trigger trigger_name

--Listing trigger
select * from actor

----------------------------------------------------------------YETKİLENDİRME---------------------------------------------------------------------------------------------------
GRANT INSERT ON TABLE public.customer TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;         -- Şemaya erişim
GRANT EXECUTE ON FUNCTION public.log_customer_insert() TO app_user;  -- Fonksiyonu çalıştırma yetkisi






---------------------------------------------------------------	INDEXES----------------------------------------------------------------------------------------------------------
--Index (indeks), veritabanı performansını artırmak için kullanılan bir veri yapısıdır. Temel amacı, arama (SELECT), sıralama (ORDER BY) ve koşullu filtreleme (WHERE) işlemlerini çok daha hızlı hale getirmektir.
--Index sadece okuma hızını artırır(INSERT, UPDATE, DELETE işlemleri index güncellemesi nedeniyle biraz yavaşlayabilir.)🧹 Gereksiz index zararlıdır(Kullanılmayan index’ler disk alanı tüketir ve performansa zarar verebilir.) 
--Index = Sorgu motorunun hızlı erişim için kullandığı kütüphane dizini gibi.
--Doğru kullanıldığında veritabanı performansında dramatik iyileşme sağlar.
-- 100.000 kişilik bir telefon rehberi düşün. Ali yılmazı bulmak istiyosun. Normalde 100.000 satırı kontrol edersin ancak alfabetik dizin(index) varsa A harfi : Sayfa 1 , B harfi : Sayfa 20 .. hemen Y harfine girder ordan Ali ismine zıplarsın. 
--Veritabanı da aynen bu mantıkla bir sütun için alfabetik ya da sıralı index yapısı kurar. Bu genellikle bir B-tree veri yapısıdır. böylece WHERE email = 'ali@example.com' gibi sorgularda, tüm tabloyu taramak yerine doğrudan doğru satıra ulaşır.  
--İndeksler, veritabanı arama motorunun veriyi daha hızlı bulmasını sağlayan özel bakış (lookup) tablolarıdır.
--Basitçe ifade edersek:Bir indeks, tablo içindeki verilere işaretçi (pointer) görevi görür.
--SELECT sorguları ve WHERE koşulları daha hızlı çalışır.
--Ancak INSERT, UPDATE, DELETE işlemleri yavaşlayabilir, çünkü indeksler de güncellenmek zorundadır.

--İndeks Türleri (PostgreSQL)
--B-tree:		En yaygın olan, varsayılan index tipi. Her türlü eşitlik/sıralama için iyi.
--Hash:			Yalnızca = işlemleri için uygundur.
--GiST:			Coğrafi veriler ve karmaşık aramalar için.
--SP-GiST:		Parçalı yapılar için optimize edilmiş.
--GIN: 		Çok değerli sütunlar için (örneğin ARRAY, JSONB). Full-text search’te kullanılır.

--Tek sütun indeksi 
CREATE INDEX idx_name ON table_name (column_name);

--Çoklu Sütun Indexi 
CREATE INDEX idx_multi ON table_name (col1, col2);--Eğer bir sorguda WHERE col1 = ? AND col2 = ? varsa, bileşik indeks daha verimlidir.

--Unique Index 
CREATE UNIQUE INDEX idx_unique_email ON users(email);

-- PARTIAL (KISMİ) İndeks :Sadece belirli koşulu sağlayan satırları indeksler: 
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;

--IMPLICIT (Örtük) İndeks : PostgreSQL tarafından otomatik oluşturulur: PRIMARY KEY ve UNIQUE constraint’leri otomatik olarak indekslenir.

--Ne Zaman İndeks KULLANILMAMALI?
--Küçük tablolar :											Zaten tarama hızlı olur, indeks fayda sağlamaz.
--Sık ve büyük 	INSERT veya UPDATE işlemleri	:		Her işlemde indeks güncellenir → yavaşlık.
--Çok sayıda NULL içeren sütunlar		:					İndeks verimli çalışmaz.
--Sürekli güncellenen sütunlar		:					Sık güncellenen sütunlar indeks için pahalıdır.


CREATE TABLE users (
    id SERIAL,
    name TEXT,
    email TEXT
);
SELECT * FROM users WHERE email = 'ali@example.com'; -- eğer index yoksa satır satır tarar ve çok yavaş
CREATE INDEX idx_users_email ON users(email); -- sadece email sütunundaki sıralı yapıyı kullanılır. 



--bir tabloya ait indexleri görüntülemek için 
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'customer';



--Her sütuna ait ayrı ayrı index oluşturmamalıyız. 
-- Yazma işlemlerini yavaşlatır					Her INSERT, UPDATE, DELETE işleminde PostgreSQL, ilgili tüm indexleri de günceller. 7 sütun = 7 index = 7 ayrı güncelleme maliyeti.
-- PostgreSQL her indexi kullanmaz				Sorgularına göre PostgreSQL sadece gerekli olan index(ler)i kullanır, geri kalanlar boşa yer kaplar.
-- Diskte fazladan alan tüketir					Her index fiziksel olarak saklanır. 7 index → 7 kat daha fazla depolama kullanımı.
-- Query Planner karmaşıklaşır					PostgreSQL'in en uygun indexi seçmesi daha zorlaşır (plan cost yükselir).
-- Bakım maliyeti artar							VACUUM, REINDEX, ANALYZE gibi işlemler tüm indexleri yeniden işler, sistem yavaşlar.


-- Ne Zaman Bir Sütuna Index Açılır?
-- Index eklemek mantıklıysa:
--Sütun sorgu filtrelerinde sıkça kullanılıyorsa:
--WHERE email = 'x', WHERE status = 'active'

--Sütun **sıralama (ORDER BY) ya da gruplama (GROUP BY) işlemlerinde kullanılıyorsa`
--Sütun üzerinde sık sık JOIN işlemi yapılıyorsa

-- Peki Alternatif Ne?
-- Birden fazla sütunu kapsayan bileşik index (composite index): 
CREATE INDEX idx_customer_name_email ON customer (first_name, email);
--Sorgun WHERE first_name = 'Ali' AND email = 'ali@example.com' ise çok etkili olur.

-- Partial Index (kısmi index):
--CREATE INDEX idx_active_customers ON customer (email) WHERE active = true;
--Yalnızca aktif müşteriler için email index'i oluşturur → Daha verimli.


-- Gerçek Dünya Önerisi
--Tüm sütunlara index açmak							❌ Kötü fikir – yazma maliyeti artar
--Sadece WHERE’de geçen sütunlara					✅ Mantıklı
--JOIN veya ORDER BY için gerekli sütunlara			✅ Mantıklı
--Düşük cardinality (az değerli) alanlarda			⚠️ Faydasız olabilir (örnek: cinsiyet gibi M/F)
--Sık güncellenen sütunlar							⚠️ Dikkatli olunmalı – index güncellenir

--Sütun Adı						Sorgularda Kullanılıyor mu?					Index Gerekli mi?
--id (PK)							Evet (JOIN, WHERE)						✅ Zaten var (PRIMARY KEY)
--name							Hayır										❌ Gerek yok
--email							Evet (WHERE, JOIN)							✅ Evet
--create_date						Evet (ORDER BY)							✅ Evet
--gender							Hayır (çok az değişken var)				❌ Gerek yok
--status							Evet (aktif/pasif sorgusu)				✅ Belki partial index
--last_login						Nadiren	⚠️ 								Gerek olmayabilir

--Az ve akıllıca index = performans
--Çok ve rastgele index = yavaşlık + karmaşa

drop index indexname







------------------------------------------------------------------LOCKS--------------------------------------------------------------------------------------------------
--Lock = Başkası değiştirirken senin aynı anda o veriyi değiştirmemeni sağlayan güvenlik önlemidir.
--Neden Lock Kullanılır? 
--Çok kullanıcılı sistemlerde, aynı anda birden fazla kişi aynı veriye erişmeye çalışabilir:
--Bir kullanıcı veriyi okurken,
--Diğeri aynı veriyi güncelliyorsa,
--Veri bozulabilir (örnek: çifte güncelleme, hatalı kayıt vs.)
-- Lock, bu sorunları önler.


-- Gerçek Hayat Benzetişi
--Bir müşteri, bankadaki bakiyesini güncelliyor.
--Aynı anda başka biri bu bakiyeyi sorgulamak istiyor.
--Eğer kilit kullanılmazsa:
--Biri 500₺ olarak görür,
--Diğeri 600₺'ye güncellemiş olur.
-- Tutarsızlık çıkar.
--Lock = "Bu işlem bitene kadar bekle kardeşim" demektir.


--Lock Türleri (PostgreSQL için)
--Lock Türü	Açıklama
-- Shared Lock (S)				Veriye okuma izni verir, ancak kimse güncelleyemez. Birden fazla kullanıcı aynı anda okuyabilir.
-- Exclusive Lock (X)			Veriye sadece bir kişi tam yetkiyle erişebilir (okuma+yazma). Diğer tüm işlemler bekletilir.
-- Row-Level Lock				Sadece belirli satır(lar) kilitlenir. Diğer satırlar erişilebilir kalır.
-- Table-Level Lock				Tüm tabloya uygulanan kilittir. Büyük işlemler için kullanılır (DDL gibi).


-- Aşırı lock oluşturmak : Deadlock (Kilitleme Çakışması) riski 
--İki işlem karşılıklı birbirinin kilidini bekliyorsa
--Sistem tıkanır, buna deadlock denir
--PostgreSQL birini sonlandırır:
--"deadlock detected" hatası alırsın.


--Satır kilitleme : For update : Tabloyu değil, belirli satırları kilitler. Diğer kullanıcılar bu satırları güncelleyemez veya silemez, ama okuyabilir.
--Aynı tablo üzerinde birçok kullanıcı çalışırken sadece ilgili satır kilitlenir, sistem esnek çalışmaya devam eder.
BEGIN;
SELECT * FROM customer WHERE customer_id = 10 FOR UPDATE;
-- Bu satır kilitlendi. Başka kullanıcı bu satırı UPDATE/DELETE edemez.
--Bu sorgudan sonra customer_id = 10 satırı kilitlenmiş olur.
--Sen commit edene kadar kimse bu satırı değiştiremez, ama diğer satırlar serbesttir.
--Gerçek Hayat Benzetmesi:
--Bir banka şubesindesin. 100 müşterilik sırada sen Ali Yılmaz’ın işlemini yapıyorsun.
--Sen sadece Ali Yılmaz’ın dosyasını masana aldın (FOR UPDATE)
--Diğer personeller başka müşterilerle ilgilenebiliyor
--Ama Ali Yılmaz’la sen ilgileniyorsun, kimse dokunamaz.


--Manuel Table Lock :  Tüm tabloyu kilitler. Başka hiçbir kullanıcı o tabloyu okuyamaz, yazamaz, değiştiremez
BEGIN;
LOCK TABLE customer IN ACCESS EXCLUSIVE MODE;
-- Artık customer tablosuna hiçbir işlem yapılamaz. Bekletilir.
-- Gerçek Hayat Benzetmesi:
--Bir okulda dosya arşiv odasına sen girdin ve kapıyı kilitledin.
--Kimse başka dosya alamaz
--O sırada içeride ne yapıyorsan sadece sen yapabilirsin
--Tam kilit!


--Locks (kilitler), bir satırın ya da tablonun başka kullanıcılar tarafından değiştirilmesini geçici olarak engelleyen yapıdır.
--UPDATE ve DELETE işlemleri yapıldığında, değiştirilen satırlar otomatik olarak "exclusive lock" ile kilitlenir.
--Bu kilit, işlem (transaction) commit edilene veya rollback yapılana kadar geçerlidir.
--Bu süre boyunca diğer kullanıcılar o satırı değiştiremez.

-- Ne zaman bekleme olur, ne zaman olmaz?
-- Aynı satırı iki kullanıcı değiştirmek isterse: Bekleme olur.
-- Farklı satırlar üzerinde işlem yapılıyorsa: Beklemeye gerek kalmaz.
-- SELECT sorguları hiçbir zaman beklemek zorunda kalmaz.

--Kilitler otomatik mi verilir?
--Evet, veritabanı çoğu durumda kilitleri otomatik olarak uygular.
--Ancak bazı özel durumlarda, manuel olarak kilitleme yapılması gerekebilir.

--LOCK Komutu ile Manuel Kilitleme
LOCK [ TABLE ] tablo_adi IN kilit_modu;

--tablo_adi		Kilitlenecek tablo (isteğe bağlı olarak şema adıyla birlikte yazılabilir)
--kilit_modu	Kilit türü. Yazılmazsa varsayılan olarak ACCESS EXCLUSIVE kullanılır

-- ONLY anahtar sözcüğü kullanılırsa, sadece o tablo kilitlenir. Alt tablolar (inheritance) kilitlenmez.

-- Kilit Modları (lock_mode):
--Mod Adı					Etki Alanı								Açıklama
--ACCESS SHARE				En hafif kilit							Sadece okuma, genelde SELECT
--ROW SHARE					Hafif yazma								SELECT FOR UPDATE ile oluşur
--ROW EXCLUSIVE				Güncelleme hazırlığı					INSERT, UPDATE, DELETE yapıldığında oluşur
--SHARE UPDATE EXCLUSIVE	Orta seviye								VACUUM gibi işlemler için
--SHARE	Okuma kilidi		DDL işlemleri engellenir
--SHARE ROW EXCLUSIVE		Daha güçlü								Aynı anda çoklu işlem engeller
--EXCLUSIVE					Yüksek seviye							Tabloyu başka işlemden korur
--ACCESS EXCLUSIVE			En güçlü kilit							Tüm diğer işlemleri engeller (DDL, SELECT dahil)

-- Kilit, işlem bitene kadar (commit/rollback) sürer. UNLOCK komutu yoktur.
-- Deadlock (Kilit Çakışması) Nedir?
--İki işlem birbirini bekliyorsa ve her biri diğerinin tuttuğu kilide ulaşmaya çalışıyorsa, deadlock oluşur.PostgreSQL bu durumu otomatik tespit eder ve işlemlerden birini ROLLBACK yapar.
-- Ancak bu durumlar performans düşüklüğüne ve beklenmeyen hatalara yol açabilir.
-- Öneri: Uygulamalar tasarlanırken kilit sırası standartlaştırılmalı, örneğin her zaman önce müşteri, sonra sipariş kilitlensin gibi.
-- Advisory Locks (Danışman Kilitler)
--PostgreSQL ayrıca uygulama tanımlı kilitler (advisory locks) sağlar.
--Sistem bu kilitleri zorunlu kılmaz, uygulamanın sorumluluğundadır.
--MVCC (çok versiyonlu eşzamanlılık) yapısına uygun olmayan özel senaryolar için uygundur.
--“Düz dosya tabanlı sistemlerde” kullanılan pessimistic locking (önceden engelleme) stratejilerini benzetmek için kullanılır.
--Bir tablonun satırında “şu anda biri çalışıyor” gibi bir bayrak yerine advisory lock kullanılır.
--Daha hızlıdır
--Tablo şişmesini (bloat) önler
--Otomatik olarak temizlenir (oturum bitince)
SELECT pg_advisory_lock(123);  -- kilitle
-- işlem yapılır
SELECT pg_advisory_unlock(123);  -- kilidi kaldır

-- Lock				Veritabanı nesnelerini geçici olarak kilitler
-- Exclusive Lock	Satırı başkası değiştiremesin diye tutar
-- LOCK komutu		Manuel kilit uygular
-- Deadlock			İşlemler birbirini beklerse oluşur
-- Advisory Lock	Uygulama tarafından kontrol edilen özel kilitler




---------------------------------------------------------SUBQUERY------------------------------------------------------------------------------------------------------------
--A subquery or Inner query or Nested query is a query within another PostgreSQL query and embedded within the WHERE clause.
--A subquery is used to return data that will be used in the main query as a condition to further restrict the data to be retrieved.
--Subqueries can be used with the SELECT, INSERT, UPDATE and DELETE statements along with the operators like =, <, >, >=, <=, IN, etc.
--Genellikle SELECT, FROM, WHERE, HAVING veya IN, EXISTS gibi ifadeler içinde kullanılır.
--------
SELECT first_name, last_name,
       (SELECT COUNT(*) FROM rental WHERE customer_id = c.customer_id) AS rental_count
FROM customer c;
--------
SELECT * FROM film
WHERE film_id IN (SELECT film_id FROM inventory WHERE store_id = 1);
--------
SELECT customer_id, first_name
FROM customer c
WHERE EXISTS (
    SELECT 1 FROM payment p
    WHERE p.customer_id = c.customer_id
    AND p.amount > 10
);
--------
SELECT store_id, COUNT(*) AS total_films
FROM (
    SELECT DISTINCT store_id, film_id
    FROM inventory
) AS sub
GROUP BY store_id;


--Her müşterinin yaptığı toplam ödeme tutarını gösteren bir sorgu yaz. ,
SELECT 
    customer_id,
    first_name,
    last_name,
    (SELECT SUM(p.amount) 
     FROM payment p 
     WHERE p.customer_id = c.customer_id) AS toplam_odeme
FROM customer c;

--En çok kiralanan filmi getiren sorgu (tek satır)
SELECT f.film_id, f.title, rental_count
FROM film f
JOIN (
    SELECT i.film_id, COUNT(*) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    GROUP BY i.film_id
    ORDER BY rental_count DESC
    LIMIT 1
) AS most_rented ON most_rented.film_id = f.film_id;


--En az bir ödeme yapmış müşteriler
SELECT c.customer_id, c.first_name, 
       (SELECT SUM(p.amount) 
        FROM payment p 
        WHERE p.customer_id = c.customer_id) AS total_payment
FROM customer c
WHERE EXISTS (
    SELECT 1 FROM payment p WHERE p.customer_id = c.customer_id
);


SELECT customer_id, first_name
FROM customer
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM payment
);

--1 numaralı mağazada bulunmayan filmler

SELECT f.film_id, f.title
FROM film f
WHERE NOT EXISTS (
    SELECT 1
    FROM inventory i
    WHERE i.film_id = f.film_id AND i.store_id = 1
);

--Her kategoride en uzun film

SELECT f.film_id, f.title, f.length, c.name AS category_name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.length = (
    SELECT MAX(f2.length)
    FROM film f2
    JOIN film_category fc2 ON f2.film_id = fc2.film_id
    WHERE fc2.category_id = fc.category_id
);


--Yöntem 2: ROW_NUMBER() (daha performanslıdır)
SELECT film_id, title, length, category_name
FROM (
    SELECT 
        f.film_id,
        f.title,
        f.length,
        c.name AS category_name,
        ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY f.length DESC) AS rn
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
) sub
WHERE rn = 1;
--ROW_NUMBER() ile her kategori için en uzun film sıralanır.rn = 1 olanlar seçilerek sonuç alınır.



SELECT *
   FROM COMPANY
   WHERE ID IN (SELECT ID
      FROM COMPANY
      WHERE SALARY > 45000) ;
---
INSERT INTO table_name [ (column1 [, column2 ]) ]
   SELECT [ *|column1 [, column2 ] ]
   FROM table1 [, table2 ]
   [ WHERE VALUE OPERATOR ]
-- 
UPDATE COMPANY
   SET SALARY = SALARY * 0.50
   WHERE AGE IN (SELECT AGE FROM COMPANY_BKP
      WHERE AGE >= 27 );
--
DELETE FROM COMPANY
   WHERE AGE IN (SELECT AGE FROM COMPANY_BKP
      WHERE AGE > 27 );


--2. Subquery sadece tek bir sütun döndürebilir,
Ancak ana sorguda bu sütunla karşılaştırma yapacak birden fazla sütun varsa, o zaman birden fazla sütun dönebilir.
SELECT first_name
FROM customer
WHERE customer_id = (SELECT customer_id FROM rental WHERE rental_id = 100);

--3. Subquery içinde ORDER BY kullanılamaz.
Alt sorguda ORDER BY kullanılamaz. Ana sorguda kullanılmalıdır.
Sıralama istiyorsan, GROUP BY ya da MAX/MIN gibi fonksiyonlarla çözebilirsin.

-- Alt sorguda ORDER BY varsa hata verir:
SELECT * FROM film
WHERE film_id = (SELECT film_id FROM rental ORDER BY rental_date DESC LIMIT 1);


-- Subquery'yi derived table yaparak sıralama yapılabilir:
SELECT * FROM film
WHERE film_id = (
    SELECT film_id FROM (
        SELECT film_id FROM rental ORDER BY rental_date DESC LIMIT 1
    ) AS sub
);


--Birden fazla satır döndüren subquery'ler, yalnızca çok-değerli operatörlerle kullanılabilir:
--IN, NOT IN, EXISTS, ANY / SOME, ALL
-- Tek bir değer bekleyen '=' operatörü, birden fazla satır dönen subquery ile kullanılamaz:
SELECT * FROM customer
WHERE customer_id = (SELECT customer_id FROM rental);

--Doğru Kullanım 
SELECT * FROM customer
WHERE customer_id IN (SELECT customer_id FROM rental);


-- Subquery doğrudan BETWEEN içinde kullanılamaz
--BETWEEN (subquery) şeklinde kullanım geçersizdir.
--Ancak alt sorgunun içinde BETWEEN kullanılabilir.
--Geçersiz:
SELECT * FROM film
WHERE length BETWEEN (SELECT MIN(length) FROM film);

-- Geçerli:
SELECT title FROM film
WHERE length BETWEEN 90 AND (SELECT MAX(length) FROM film);
--VEYA: 
SELECT * FROM rental
WHERE rental_date BETWEEN 
    (SELECT MIN(rental_date) FROM rental)
    AND
    (SELECT MAX(rental_date) FROM rental);


--AUTO INCREMENT
--Auto-increment, veritabanlarında bir sütunun değerinin otomatik olarak artmasını sağlayan bir özelliktir. Genellikle birincil anahtar (primary key) olarak kullanılan sütunlar için kullanılır ve her yeni kayıt eklendiğinde bu sütun değeri benzersiz şekilde bir öncekinin üzerine 1 eklenerek otomatik olarak atanır.

-- PostgreSQL'de Auto-increment Nasıl Çalışır?
--PostgreSQL'de auto-increment özelliği için şu yollar kullanılır:
-- 1. SERIAL tipi ile:

CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    name TEXT
);
--id için bir otomatik artan sequence oluşturur.
--Yeni satır eklerken id vermezsen, PostgreSQL otomatik olarak bir değer atar.

--GENERATED ifadesiyle (yeni sürümlerde önerilen yöntem):
CREATE TABLE employee (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT
);
--SERIAL tipinden farklı olarak, veritabanı objesi olarak sequence'ı açık şekilde tanımlar ve daha iyi yönetilebilir.

--Auto-increment Özelliğinin Avantajları
-- Benzersizlik sağlar			Her satıra eşsiz bir ID atanır
-- Manuel takip gerekmez		ID’yi elle vermene gerek kalmaz
-- Performanslıdır				Özellikle PK olarak kullanıldığında index performansına katkı sağlar

--UPDATE işlemlerinde auto-increment devreye girmez, sadece INSERT işlemlerinde çalışır.
--Eğer auto-increment sütuna manuel değer verirsen, bir sonraki otomatik değer o sayıdan devam eder.
--SERIAL bir veri türü değildir, aslında sequence + default nextval() kombinasyonudur.

INSERT INTO employee (name) VALUES ('Ahmet');
-- id otomatik olarak 1 olur

INSERT INTO employee (name) VALUES ('Ayşe');
-- id otomatik olarak 2 olur





----------------------------------------------------------PRIVILEGES-----------------------------------------------------------------------
--PostgreSQL'de Yetkiler (Privileges) ve Kullanımı
-- Nesne Sahibi (Owner)
--Veritabanında bir nesne (tablo, view, sequence, fonksiyon, vs.) oluşturulduğunda, sahibi (owner) genellikle o SQL’i çalıştıran kullanıcı olur.
--İlk durumda sadece sahibi veya superuser o nesneyi değiştirebilir, silebilir.
--Yetki Tipleri (Privileges)
--Yetkiler, nesne türüne göre değişir. Aşağıdaki yetkiler tanımlanabilir:

--Yetki	Açıklama
--SELECT	Tablo verisini okuma izni
--INSERT	Yeni satır ekleme izni
--UPDATE	Satır güncelleme izni
--DELETE	Satır silme izni
--TRUNCATE	Tabloyu hızlıca boşaltma izni
--REFERENCES	Dış anahtar tanımlama izni
--TRIGGER	Trigger oluşturma izni
--CREATE	Yeni nesne oluşturma izni (örneğin yeni tablo)
--CONNECT	Veritabanına bağlanma izni
--TEMPORARY	Geçici tablo oluşturma izni
--EXECUTE	Fonksiyon/procedure çalıştırma izni
--USAGE	Sequence ve schema erişim izni

-- 1. Yeni kullanıcı oluştur
CREATE USER manisha WITH PASSWORD 'password';
-- 2. manisha’ya COMPANY tablosu üzerinde tüm yetkileri ver
GRANT ALL ON COMPANY TO manisha;
-- veya sadece okuma ve yazma izni ver
GRANT SELECT, INSERT ON COMPANY TO manisha;

-- Tüm yetkileri geri al
REVOKE ALL ON COMPANY FROM manisha;
-- Sadece SELECT yetkisini geri al
REVOKE SELECT ON COMPANY FROM manisha;


DROP USER manisha;  -- Eğer manisha artık kullanılmıyorsa
-- veya
DROP ROLE manisha;


GRANT SELECT ON COMPANY TO PUBLIC; -- bu tabloyu herkes okuyabilir

-- Belirli bir tablo üzerindeki yetkileri görüntülemek:
SELECT * FROM information_schema.role_table_grants 
WHERE table_name = 'company';



