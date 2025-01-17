-- MySQL Script generated by MySQL Workbench
-- Mon Jul 22 09:44:42 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Bookstore
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Bookstore
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Bookstore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
-- -----------------------------------------------------
-- Schema bookstore
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bookstore
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bookstore` ;
USE `Bookstore` ;

-- -----------------------------------------------------
-- Table `Bookstore`.`authors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`authors` (
  `author_id` INT NOT NULL,
  `author_first_name` VARCHAR(100) NULL DEFAULT NULL,
  `author_last_name` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`author_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`book_sales_summary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`book_sales_summary` (
  `book_id` INT NOT NULL,
  `title` VARCHAR(100) NULL DEFAULT NULL,
  `total_quantity_sold` INT NULL DEFAULT NULL,
  PRIMARY KEY (`book_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`books` (
  `book_id` INT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `author_id` INT NULL DEFAULT NULL,
  `price` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`book_id`),
  INDEX `author_id` (`author_id` ASC) VISIBLE,
  CONSTRAINT `books_ibfk_1`
    FOREIGN KEY (`author_id`)
    REFERENCES `Bookstore`.`authors` (`author_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`customers` (
  `customer_id` INT NOT NULL,
  `customer_first_name` VARCHAR(100) NULL DEFAULT NULL,
  `customer_last_name` VARCHAR(100) NULL DEFAULT NULL,
  `customer_email` VARCHAR(100) NULL DEFAULT NULL,
  `customer_phone` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`daily_sales_report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`daily_sales_report` (
  `report_date` DATE NOT NULL,
  `book_id` INT NULL DEFAULT NULL,
  `total_quantity_sold` INT NULL DEFAULT NULL,
  `total_sales` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`report_date`),
  INDEX `book_id` (`book_id` ASC) VISIBLE,
  CONSTRAINT `daily_sales_report_ibfk_1`
    FOREIGN KEY (`book_id`)
    REFERENCES `Bookstore`.`books` (`book_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`orders` (
  `order_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `order_date` DATE NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `customer_id` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `orders_ibfk_1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Bookstore`.`customers` (`customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`order_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`order_details` (
  `order_details_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `book_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`order_details_id`),
  INDEX `order_id` (`order_id` ASC) VISIBLE,
  INDEX `book_id` (`book_id` ASC) VISIBLE,
  CONSTRAINT `order_details_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `Bookstore`.`orders` (`order_id`),
  CONSTRAINT `order_details_ibfk_2`
    FOREIGN KEY (`book_id`)
    REFERENCES `Bookstore`.`books` (`book_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`reviews` (
  `review_id` INT NOT NULL,
  `book_id` INT NULL DEFAULT NULL,
  `customer_id` INT NULL DEFAULT NULL,
  `rating` INT NULL DEFAULT NULL,
  `book_review` TEXT NULL DEFAULT NULL,
  `review_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  INDEX `book_id` (`book_id` ASC) VISIBLE,
  INDEX `customer_id` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `reviews_ibfk_1`
    FOREIGN KEY (`book_id`)
    REFERENCES `Bookstore`.`books` (`book_id`),
  CONSTRAINT `reviews_ibfk_2`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Bookstore`.`customers` (`customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Bookstore`.`special_day_discounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bookstore`.`special_day_discounts` (
  `discount_id` INT NOT NULL AUTO_INCREMENT,
  `special_day_discount` DECIMAL(5,2) NULL DEFAULT NULL,
  `special_day` DATE NOT NULL,
  PRIMARY KEY (`discount_id`),
  UNIQUE INDEX `special_day` (`special_day` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `bookstore` ;
USE `Bookstore` ;

-- -----------------------------------------------------
-- function calculate_total_cost
-- -----------------------------------------------------

DELIMITER $$
USE `Bookstore`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_total_cost`(order_date DATE, book_id INT, quantity INT) RETURNS decimal(10,2)
    READS SQL DATA
BEGIN
    DECLARE book_price DECIMAL(5,2);
    DECLARE discount DECIMAL(5,2);
    DECLARE total_cost DECIMAL(10,2);

    -- Initialize default values
    SET book_price = 0;
    SET discount = 0;

    -- Get the price of the book
    SELECT price INTO book_price
    FROM books
    WHERE book_id = book_id
    LIMIT 1;

    -- If no book price is found, set it to 0
    IF book_price IS NULL THEN
        SET book_price = 0;
    END IF;

    -- Get the discount for the special day
    SELECT COALESCE(special_day_discount, 0) INTO discount
    FROM special_day_discounts
    WHERE special_day = order_date
    LIMIT 1;

    -- Calculate the total cost with discount applied
    SET total_cost = ROUND(quantity * book_price * (1 - discount / 100), 2);

    RETURN total_cost;
END$$

DELIMITER ;
USE `bookstore` ;

-- -----------------------------------------------------
-- Placeholder table for view `bookstore`.`book_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`book_details` (`book_id` INT, `title` INT, `author_first_name` INT, `author_last_name` INT, `price` INT, `book_review` INT);

-- -----------------------------------------------------
-- Placeholder table for view `bookstore`.`customer_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookstore`.`customer_orders` (`customer_id` INT, `customer_first_name` INT, `customer_last_name` INT, `order_id` INT, `order_date` INT);

-- -----------------------------------------------------
-- View `bookstore`.`book_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookstore`.`book_details`;
USE `bookstore`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bookstore`.`book_details` AS select `bookstore`.`books`.`book_id` AS `book_id`,`bookstore`.`books`.`title` AS `title`,`bookstore`.`authors`.`author_first_name` AS `author_first_name`,`bookstore`.`authors`.`author_last_name` AS `author_last_name`,`bookstore`.`books`.`price` AS `price`,`bookstore`.`reviews`.`book_review` AS `book_review` from ((`bookstore`.`books` join `bookstore`.`authors` on((`bookstore`.`books`.`author_id` = `bookstore`.`authors`.`author_id`))) join `bookstore`.`reviews` on((`bookstore`.`books`.`book_id` = `bookstore`.`reviews`.`book_id`)));

-- -----------------------------------------------------
-- View `bookstore`.`customer_orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookstore`.`customer_orders`;
USE `bookstore`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bookstore`.`customer_orders` AS select `bookstore`.`customers`.`customer_id` AS `customer_id`,`bookstore`.`customers`.`customer_first_name` AS `customer_first_name`,`bookstore`.`customers`.`customer_last_name` AS `customer_last_name`,`bookstore`.`orders`.`order_id` AS `order_id`,`bookstore`.`orders`.`order_date` AS `order_date` from (`bookstore`.`customers` join `bookstore`.`orders` on((`bookstore`.`orders`.`customer_id` = `bookstore`.`customers`.`customer_id`)));
USE `Bookstore`;

DELIMITER $$
USE `Bookstore`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `Bookstore`.`after_order_details_insert`
AFTER INSERT ON `Bookstore`.`order_details`
FOR EACH ROW
BEGIN
    -- Update the total_quantity_sold in book_sales_summary for the newly inserted order details
    INSERT INTO book_sales_summary (book_id, title, total_quantity_sold)
    VALUES (
        NEW.book_id,
        (SELECT title FROM books WHERE book_id = NEW.book_id),
        (SELECT IFNULL(SUM(quantity), 0) FROM order_details WHERE book_id = NEW.book_id)
    )
    ON DUPLICATE KEY UPDATE
        total_quantity_sold = VALUES(total_quantity_sold);
END$$

USE `Bookstore`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `Bookstore`.`after_order_details_update`
AFTER UPDATE ON `Bookstore`.`order_details`
FOR EACH ROW
BEGIN
    -- Update the total_quantity_sold for the old book_id
    INSERT INTO book_sales_summary (book_id, title, total_quantity_sold)
    VALUES (
        OLD.book_id,
        (SELECT title FROM books WHERE book_id = OLD.book_id),
        (SELECT IFNULL(SUM(quantity), 0) FROM order_details WHERE book_id = OLD.book_id)
    )
    ON DUPLICATE KEY UPDATE
        total_quantity_sold = VALUES(total_quantity_sold);

    -- Update the total_quantity_sold for the new book_id
    INSERT INTO book_sales_summary (book_id, title, total_quantity_sold)
    VALUES (
        NEW.book_id,
        (SELECT title FROM books WHERE book_id = NEW.book_id),
        (SELECT IFNULL(SUM(quantity), 0) FROM order_details WHERE book_id = NEW.book_id)
    )
    ON DUPLICATE KEY UPDATE
        total_quantity_sold = VALUES(total_quantity_sold);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
