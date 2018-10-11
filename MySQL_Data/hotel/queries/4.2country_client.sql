-- 4.2 Задача: Показать клиентов, являющихся гражданами Украины и Республики Беларусь.
SELECT `client`.`first_name`,`client`.`last_name`, `client`.`passport`, `client`.`nationality_id`
FROM `client` INNER JOIN `nationality` ON `client`.`nationality_id` = `nationality`.`id`
WHERE `nationality`.`country` IN ('Украина', 'Республика Беларусь');
