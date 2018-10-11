SELECT `client`.*, `order`.*
FROM `account` LEFT JOIN `account_m2m_client` ON `account`.`id` = `account_m2m_client`.`account_id`
			LEFT JOIN `client` ON `account_m2m_client`.`client_id` = `client`.`id`
			LEFT JOIN `order` ON `client`.`id` = `order`.`client_id`
WHERE `account`.`login` = 'user5@epam.com'