-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema hotel
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema hotel
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hotel` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `hotel` ;

-- -----------------------------------------------------
-- Table `hotel`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`account` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
  `login` VARCHAR(25) NULL DEFAULT NULL COMMENT 'Логин',
  `password` VARCHAR(150) NULL DEFAULT NULL COMMENT 'Пароль',
  `email` VARCHAR(46) NULL DEFAULT NULL,
  `admin` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'Админ = 1; обычный пользователь = 0',
  `removed` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Учетная запись';


-- -----------------------------------------------------
-- Table `hotel`.`bankaccount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`bankaccount` (
  `account_id` INT(10) UNSIGNED NOT NULL,
  `amount` DECIMAL(10,2) NULL DEFAULT '0.00',
  PRIMARY KEY (`account_id`),
  INDEX `fk_bank_account1_idx` (`account_id` ASC),
  CONSTRAINT `fk_bank_account1`
    FOREIGN KEY (`account_id`)
    REFERENCES `hotel`.`account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


-- -----------------------------------------------------
-- Table `hotel`.`class`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`class` (
  `id` VARCHAR(25) NOT NULL,
  `removed` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


-- -----------------------------------------------------
-- Table `hotel`.`nationality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`nationality` (
  `id` CHAR(2) NOT NULL COMMENT 'Идентификатор страны',
  `country` VARCHAR(80) NULL DEFAULT NULL COMMENT 'Наименование страны',
  `removed` BIT(1) NOT NULL DEFAULT b'0',
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
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор клиента',
  `first_name` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Имя',
  `last_name` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Фамилия',
  `passport` VARCHAR(15) NULL DEFAULT NULL COMMENT 'Номер паспорта',
  `nationality_id` CHAR(2) NOT NULL COMMENT 'Код страны граждаства',
  `blacklist` BIT(1) NOT NULL DEFAULT b'0',
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
  `capacity` SMALLINT(1) UNSIGNED NOT NULL COMMENT 'Вместимость',
  `class_id` VARCHAR(25) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL COMMENT 'Цена',
  `removed` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`number`),
  INDEX `fk_room_class1_idx` (`class_id` ASC),
  CONSTRAINT `fk_room_class1`
    FOREIGN KEY (`class_id`)
    REFERENCES `hotel`.`class` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Номер (комната)';


-- -----------------------------------------------------
-- Table `hotel`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotel`.`order` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор заказа',
  `client_id` INT(10) UNSIGNED NOT NULL,
  `account_id` INT(10) UNSIGNED NOT NULL,
  `room_number` SMALLINT(1) UNSIGNED NOT NULL,
  `from` DATE NULL DEFAULT NULL COMMENT 'Дата поселения',
  `to` DATE NULL DEFAULT NULL COMMENT 'Дата выселения',
  `cost` DECIMAL(10,2) NOT NULL,
  `removed` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  INDEX `fk_order_client1_idx` (`client_id` ASC),
  INDEX `fk_order_account1_idx` (`account_id` ASC),
  INDEX `fk_order_room1_idx` (`room_number` ASC),
  CONSTRAINT `fk_order_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `hotel`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_account1`
    FOREIGN KEY (`account_id`)
    REFERENCES `hotel`.`account` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_room1`
    FOREIGN KEY (`room_number`)
    REFERENCES `hotel`.`room` (`number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin
COMMENT = 'Заказ';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
