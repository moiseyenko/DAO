SELECT `client`.`fname`, `client`.`lname`
-- , `order`.`id`, `order`.`from`, `order`.`to`
, ifnull(sum(timestampdiff(DAY, `from`,`to`)*price),0) AS `total, BYN`
FROM `client` LEFT JOIN `order` ON `client`.`id` = `order`.`client_id`
			  LEFT JOIN `room` ON `room`.`number` = `order`.`room_number`

GROUP BY `client`.`fname`, `client`.`lname`
ORDER BY `total, BYN` desc;

