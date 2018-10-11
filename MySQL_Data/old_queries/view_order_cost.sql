USE `hotel`;
CREATE  OR REPLACE VIEW `order_cost` AS SELECT `order`.*, if(timestampdiff(DAY, `from`,`to`)<>0, timestampdiff(DAY, `from`,`to`),1)*price AS `SUM`
FROM `order` JOIN `room` ON `room`.`number` = `order`.`room_number`;
