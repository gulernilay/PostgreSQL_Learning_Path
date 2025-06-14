--H11:


(SELECT first_name from customer) UNION (SELECT first_name from actor) ;
(SELECT first_name from customer) UNION ALL  (SELECT first_name from actor) ;
(SELECT first_name from customer) INTERSECT (SELECT first_name from actor) ;
(SELECT first_name from customer) INTERSECT ALL (SELECT first_name from actor) ;
(SELECT first_name from customer) EXCEPT  (SELECT first_name from actor) ;
(SELECT first_name from customer) EXCEPT ALL  (SELECT first_name from actor) ;