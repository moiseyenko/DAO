SELECT `full_info_account`.`login`, IFNULL(SUM(`full_info_account`.`SUM`),0) AS 'worth'
FROM `full_info_account`
GROUP BY `full_info_account`.`login`
ORDER BY `worth` DESC;
