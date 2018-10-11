-- 9.2 Задача: Показать свободные номера с подходящими классом, вместимостью и датами пребывания.
SET @input_capasity = 3;
SET @input_class = "Стандарт";
SET @input_from = '2018-01-19';
SET @input_to = '2018-05-31';
SELECT `room`.`number`, `room`.`class`, `room`.`capacity`
FROM `room`
WHERE `capacity` = @input_capasity AND `class` = @input_class
AND `number` NOT IN (SELECT DISTINCT`order`.`room_number`
					 FROM `order` JOIN `room` ON `order`.`room_number` = `room`.`number` 
					 WHERE `capacity` = @input_capasity AND `class` = @input_class 
					 AND `from`<= @input_to AND `to`>= @input_from);