-- 5.2 Задача: Показать месяцы, в которые сумма заказов превышала среднюю сумму заказов по месяцам.
SELECT MONTHNAME(`order`.`to`) AS `month`, IFNULL(SUM(`order`.`cost`),0) AS `sum`
FROM `order`
GROUP BY `month`
HAVING `sum`> (SELECT AVG(`sum`)
				 FROM (SELECT MONTHNAME(`order`.`to`) AS `month`, 
					   IFNULL(SUM(`order`.`cost`),0) AS `sum`
					   FROM `order`
					   GROUP BY `month`) AS `inner`)
ORDER BY `sum`;