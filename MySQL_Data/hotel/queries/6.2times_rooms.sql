CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `times_rooms` AS
    (SELECT 
        `room`.`number` AS `number`,
        `room`.`class` AS `class`,
        COUNT(`order`.`room_number`) AS `times`
    FROM
        (`room`
        LEFT JOIN `order` ON ((`order`.`room_number` = `room`.`number`)))
    GROUP BY `room`.`number` , `room`.`class`)
