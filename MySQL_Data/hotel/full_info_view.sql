CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `full_info_account` AS
    (SELECT 
        `account`.`id` AS `account`,
        `account`.`login` AS `login`,
        `account`.`password` AS `password`,
        `account`.`admin` AS `admin`,
        `client`.`id` AS `client`,
        `client`.`first_name` AS `fname`,
        `client`.`last_name` AS `lname`,
        `client`.`passport` AS `passport`,
        `client`.`nationality_id` AS `nationality`,
        `order`.`id` AS `id`,
        `order`.`room_number` AS `room_number`,
        `order`.`client_id` AS `client_id`,
        `order`.`account_id` AS `account_id`,
        `order`.`from` AS `from`,
        `order`.`to` AS `to`,
        (IF((TIMESTAMPDIFF(DAY,
                `order`.`from`,
                `order`.`to`) <> 0),
            TIMESTAMPDIFF(DAY,
                `order`.`from`,
                `order`.`to`),
            1) * `room`.`price`) AS `SUM`,
        `room`.`class` AS `class`,
        `room`.`capacity` AS `capacity`,
        `room`.`price` AS `price`
    FROM
        (`account`
        LEFT JOIN ((`client`
        JOIN `order` ON ((`client`.`id` = `order`.`client_id`)))
        JOIN `room` ON ((`order`.`room_number` = `room`.`number`))) ON ((`account`.`id` = `order`.`account_id`))))