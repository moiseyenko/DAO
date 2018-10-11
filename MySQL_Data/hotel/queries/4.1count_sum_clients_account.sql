-- 4.1 Задача: Показать количество и общую сумму заказов по каждому клиенту для указанной учетной записи.
SELECT `client`.`first_name`,`client`.`last_name`, `client`.`passport`, `client`.`nationality_id`, 
 COUNT(`client`.`id`) AS 'quantity', SUM(`order`.`cost`) AS 'total'
FROM `account` LEFT JOIN 
 (`order` INNER JOIN `client` ON `order`.`client_id` = `client`.`id`)
 ON `account`.`id` = `order`.`account_id`
WHERE `account`.`login` = 'user10@epam.com' AND `from`<= '2018-12-31' AND 
 `to`>= '2018-01-01'
GROUP BY `client`.`id`;