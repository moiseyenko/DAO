-- 8.1 Задача: Показать статус клиента. Статус зависит от общей суммы его заказов: 
-- не менее 40 000 – VIP; от 30 000(включительно) до 40 000 – IP; менее 30 000 – CLIENT.
SELECT `first_name`, `last_name`, SUM(`cost`) AS 'total', 'VIP' AS 'status'
FROM `client` LEFT JOIN `order` ON `client`.`id` = `order`.`client_id`
GROUP BY `first_name`, `last_name`
HAVING total>=40000
UNION
SELECT `first_name`, `last_name`, SUM(`cost`) AS 'total', 'IP'
FROM `client` LEFT JOIN `order` ON `client`.`id` = `order`.`client_id`
GROUP BY `first_name`, `last_name`
HAVING `total`>=30000 AND `total`<40000
UNION 
SELECT `first_name`, `last_name`, IFNULL(SUM(`cost`),0) AS 'total', 'CLIENT'
FROM `client` LEFT JOIN `order` ON `client`.`id` = `order`.`client_id`
GROUP BY `first_name`, `last_name`
HAVING `total`<30000 OR ISNULL(`total`)
ORDER BY `status` DESC;