-- 5.1 Задача: Показать стоимость каждого заказа.
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `cost_order` AS
    (SELECT `order`.`id` AS `id`, `order`.`room_number` AS `room_number`, `order`.`client_id` AS `client_id`,
        `order`.`account_id` AS `account_id`, `order`.`from` AS `from`, `order`.`to` AS `to`,
		(IF(TIMESTAMPDIFF(DAY, `order`.`from`, `order`.`to`) <> 0, 
			TIMESTAMPDIFF(DAY, `order`.`from`, `order`.`to`), 1) * `room`.`price`) AS `cost`
    FROM `order` JOIN `room` ON `order`.`room_number` = `room`.`number`)