-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema hotel
-- -----------------------------------------------------
-- Гостиница предоставляет номера клиентам на определенный срок. Каждый номер характеризуется вместимостью, классом («Стандарт», «Семейный», «Для молодоженов», «Люкс», «Президентский люкс») и ценой. Клиентами гостиницы являются различные лица, с определенной информацией (фамилия, имя, паспортные данные, гражданство). Заказ номера клиентом осуществляется с помощью своей или чужой (если нет возможности войти в систему) учетной записи (логин, пароль). Сдача номера клиенту производится при наличии свободных мест в номерах, подходящих клиенту по количеству мест в номере, классу апартаментов и времени пребывания.

-- -----------------------------------------------------
-- Schema hotel
--
-- Гостиница предоставляет номера клиентам на определенный срок. Каждый номер характеризуется вместимостью, классом («Стандарт», «Семейный», «Для молодоженов», «Люкс», «Президентский люкс») и ценой. Клиентами гостиницы являются различные лица, с определенной информацией (фамилия, имя, паспортные данные, гражданство). Заказ номера клиентом осуществляется с помощью своей или чужой (если нет возможности войти в систему) учетной записи (логин, пароль). Сдача номера клиенту производится при наличии свободных мест в номерах, подходящих клиенту по количеству мест в номере, классу апартаментов и времени пребывания.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hotel` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `hotel` ;

-- -----------------------------------------------------
-- Table `hotel`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`account` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
  `login` VARCHAR(45) NULL COMMENT 'Логин',
  `password` VARCHAR(150) NULL COMMENT 'Пароль',
  `admin` BIT NOT NULL COMMENT 'Админ = 1; обычный пользователь = 0',
  `removed` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC) COMMENT 'Обеспечение уникальности логина')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Учетная запись';


-- -----------------------------------------------------
-- Table `hotel`.`nationality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`nationality` (
  `id` CHAR(2) NOT NULL COMMENT 'Идентификатор страны',
  `country` VARCHAR(55) NULL COMMENT 'Наименование страны',
  `removed` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `country_UNIQUE` (`country` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Граждаство';


-- -----------------------------------------------------
-- Table `hotel`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`client` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор клиента',
  `first_name` VARCHAR(45) NULL COMMENT 'Имя',
  `last_name` VARCHAR(45) NULL COMMENT 'Фамилия',
  `passport` VARCHAR(15) NULL COMMENT 'Номер паспорта',
  `nationality_id` CHAR(2) NOT NULL COMMENT 'Код страны граждаства',
  `removed` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_client_nationality1_idx` (`nationality_id` ASC),
  CONSTRAINT `fk_client_nationality1`
    FOREIGN KEY (`nationality_id`)
    REFERENCES `hotel`.`nationality` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Клиент';


-- -----------------------------------------------------
-- Table `hotel`.`room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`room` (
  `number` SMALLINT(1) NOT NULL COMMENT 'Номер комнаты (аппартаментов)',
  `class` ENUM('Стандарт', 'Люкс', 'Бизнес', 'Семейный', 'Для молодоженов', 'Президентский Люкс') NULL COMMENT 'Класс: \'Стандарт\', \'Люкс\', \'Бизнес\', \'Семейный\', \'Для молодоженов\', \'Президентский Люкс\'',
  `capacity` SMALLINT(1) NULL COMMENT 'Вместимость',
  `price` DECIMAL(10,2) NULL COMMENT 'Цена',
  `removed` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Номер (комната)';


-- -----------------------------------------------------
-- Table `hotel`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор заказа',
  `room_number` SMALLINT(1) NOT NULL COMMENT 'Номер комнаты отеля',
  `account_id` INT NOT NULL COMMENT 'Идентификатор учетной записи',
  `client_id` INT NOT NULL,
  `from` DATE NULL COMMENT 'Дата поселения',
  `to` DATE NULL COMMENT 'Дата выселения',
  `removed` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_order_room1_idx` (`room_number` ASC),
  INDEX `fk_order_account1_idx` (`account_id` ASC),
  INDEX `fk_order_client1_idx` (`client_id` ASC),
  CONSTRAINT `fk_order_room1`
    FOREIGN KEY (`room_number`)
    REFERENCES `hotel`.`room` (`number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_account1`
    FOREIGN KEY (`account_id`)
    REFERENCES `hotel`.`account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `hotel`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Заказ';

USE `hotel` ;

-- -----------------------------------------------------
-- Placeholder table for view `hotel`.`cost_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`cost_order` (`id` INT);

-- -----------------------------------------------------
-- View `hotel`.`cost_order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotel`.`cost_order`;
USE `hotel`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `cost_order` AS
    (SELECT `order`.`id` AS `id`, `order`.`room_number` AS `room_number`, `order`.`client_id` AS `client_id`,
        `order`.`account_id` AS `account_id`, `order`.`from` AS `from`, `order`.`to` AS `to`,
		(IF(TIMESTAMPDIFF(DAY, `order`.`from`, `order`.`to`) <> 0, 
			TIMESTAMPDIFF(DAY, `order`.`from`, `order`.`to`), 1) * `room`.`price`) AS `cost`, 
		`order`.`removed` AS `removed`
    FROM `order` JOIN `room` ON `order`.`room_number` = `room`.`number`);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
