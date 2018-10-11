-- 9.1 Задача: Показать номера, заказываемые реже остальных в каждой категории.
SELECT `outer`.`class`, `outer`.`number`
FROM `times_rooms` `outer`
WHERE `outer`.`times` = (SELECT MIN(`inner`.`times`)
						 FROM `times_rooms` `inner`
						 WHERE `inner`.`class` = `outer`.`class`)
ORDER BY `outer`.`class`;