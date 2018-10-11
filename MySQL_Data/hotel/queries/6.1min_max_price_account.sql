-- 6.1 Задача: Показать максимальную и минимальную стоимость заказов 
--             для заданной учетной записи.
SELECT `account`.`login`, IFNULL(MIN(`order`.`cost`),0) AS 'MIN',
		IFNULL(MAX(`order`.`cost`),0) AS 'MAX'
FROM `account` JOIN `order` ON `account`.`id` = `order`.`account_id`
WHERE `account`.`login` = 'user20@epam.com';