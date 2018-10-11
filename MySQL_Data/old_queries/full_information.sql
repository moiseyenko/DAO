SELECT
`account`.`id` AS 'account', `account`.`login`, `account`.`password`, `account`.`admin`, `client`.`id` AS 'client', `client`.`fname`,
	 `client`.`lname`, `client`.`passport`, `client`.`nationality`, `order_cost`.*, `room`.*
FROM `account` LEFT JOIN `account_m2m_client` ON `account`.`id` = `account_m2m_client`.`account_id`
			LEFT JOIN `client` ON `account_m2m_client`.`client_id` = `client`.`id`
			LEFT JOIN `order_cost` ON `client`.`id` = `order_cost`.`client_id`
            LEFT JOIN `room` ON `order_cost`.`room_number` = `room`.`number`