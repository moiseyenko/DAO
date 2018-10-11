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
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
  `login` VARCHAR(25) NULL COMMENT 'Логин',
  `password` VARCHAR(150) NULL COMMENT 'Пароль',
  `email` VARCHAR(46) NULL,
  `admin` BIT NOT NULL DEFAULT 0 COMMENT 'Админ = 1; обычный пользователь = 0',
  `removed` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
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
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор клиента',
  `first_name` VARCHAR(45) NULL COMMENT 'Имя',
  `last_name` VARCHAR(45) NULL COMMENT 'Фамилия',
  `passport` VARCHAR(15) NULL COMMENT 'Номер паспорта',
  `nationality_id` CHAR(2) NOT NULL COMMENT 'Код страны граждаства',
  `blacklist` BIT NOT NULL DEFAULT 0,
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
  `number` SMALLINT(1) UNSIGNED NOT NULL COMMENT 'Номер комнаты (аппартаментов)',
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
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор заказа',
  `from` DATE NULL COMMENT 'Дата поселения',
  `to` DATE NULL COMMENT 'Дата выселения',
  `cost` DECIMAL NOT NULL,
  `removed` BIT NOT NULL DEFAULT 0,
  `client_id` INT UNSIGNED NOT NULL,
  `room_number` SMALLINT(1) UNSIGNED NOT NULL,
  `account_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_client1_idx` (`client_id` ASC),
  INDEX `fk_order_room1_idx` (`room_number` ASC),
  INDEX `fk_order_account1_idx` (`account_id` ASC),
  CONSTRAINT `fk_order_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `hotel`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_room1`
    FOREIGN KEY (`room_number`)
    REFERENCES `hotel`.`room` (`number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_account1`
    FOREIGN KEY (`account_id`)
    REFERENCES `hotel`.`account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Заказ';

USE `hotel` ;

-- -----------------------------------------------------
-- Placeholder table for view `hotel`.`times_rooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`times_rooms` (`id` INT);

-- -----------------------------------------------------
-- View `hotel`.`times_rooms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `hotel`.`times_rooms`;
USE `hotel`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
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
    GROUP BY `room`.`number` , `room`.`class`);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
