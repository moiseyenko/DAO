-- 7.1 Задача: Показать учетные записи, с которых не производились заказы номеров.
SELECT `account`.`login`, COUNT(`client`.`id`) AS 'clients'
FROM `account` LEFT JOIN (`order` INNER JOIN `client` ON `order`.`client_id` = `client`.`id`)
ON `account`.`id` = `order`.`account_id`
GROUP BY `account`.`login`
HAVING `clients` = 0;