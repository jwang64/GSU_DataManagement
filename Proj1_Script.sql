CREATE 	TABLE IF NOT EXISTS `lost`.`client` (
  `CLIENT_ID` CHAR(10) NOT NULL,
  `OUTING_ID` CHAR(10) NULL,
  `CLIENT_FIRST_NM` CHAR(20) NULL,
  `CLIENT_LAST_NM` CHAR(20) NULL,
  `PARTYNUMBER` INT NULL,
  `TELEPHONENUM` VARCHAR(10) NULL,
  PRIMARY KEY (`CLIENT_ID`),
  INDEX `FK_CLIENT_OUTING` (`OUTING_ID` ASC) VISIBLE,
  CONSTRAINT `FK_CLIENT_OUTING`
    FOREIGN KEY (`OUTING_ID`)
    REFERENCES `lost`.`outing` (`OUTING_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE	TABLE IF NOT EXISTS `lost`.`outing` (
  `OUTING_ID` CHAR(10) NOT NULL,
  `CLIENT_ID` CHAR(10) NULL,
  `TOUR_ID` CHAR(10) NULL,
  `OUTING_DATE` date NULL,
  `OUTING_TIME` time NULL,
  PRIMARY KEY (`OUTING_ID`),
  INDEX `FK_OUTING_TOUR_idx` (`TOUR_ID` ASC) VISIBLE,
  INDEX `FK_OUTING_CLIENT_idx` (`CLIENT_ID` ASC) VISIBLE,
  CONSTRAINT `FK_OUTING_TOUR_idx`
    FOREIGN KEY (`TOUR_ID`)
    REFERENCES `lost`.`outing` (`TOUR_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_OUTING_CLIENT_idx`
    FOREIGN KEY (`CLIENT_ID`)
    REFERENCES `lost`.`outing` (`CLIENT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
  
CREATE TABLE IF NOT EXISTS `lost`.`tour` (
  `TOUR_ID` CHAR(10) NOT NULL,
  `OUTING_ID` CHAR(10) NULL,
  `LOCATION_ID` CHAR(10) NULL,
  `EMPLOYEE_ID` CHAR(8) NULL,
  `TOUR_NAME` CHAR(50) NULL,
  `TOUR_LENGTH` CHAR(50) NULL,
  `TOUR_FEE` DOUBLE NULL,
  PRIMARY KEY (`TOUR_ID`),
  INDEX `OUTING_ID_idx` (`OUTING_ID` ASC) VISIBLE,
  INDEX `FK_TOUR_LOCATION_idx` (`LOCATION_ID` ASC) VISIBLE,
  INDEX `FK_TOUR_GUIDE_idx` (`EMPLOYEE_ID` ASC) VISIBLE,
  CONSTRAINT `FK_TOUR_OUTING`
    FOREIGN KEY (`OUTING_ID`)
    REFERENCES `lost`.`outing` (`OUTING_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TOUR_LOCATION`
    FOREIGN KEY (`TOUR_ID`)
    REFERENCES `lost`.`outing` (`TOUR_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TOUR_GUIDE`
    FOREIGN KEY (`EMPLOYEE_ID`)
    REFERENCES `lost`.`outing` (`EMPLOYEE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '	';

CREATE TABLE IF NOT EXISTS `lost`.`qualification` (
  `QUAL_ID` CHAR(10) NOT NULL,
  `EMPLOYEE_ID` CHAR(8) NULL,
  `QUAL_NM` CHAR(50) NULL,
  PRIMARY KEY (`QUAL_ID`));

CREATE TABLE IF NOT EXISTS `lost`.`guide` (
  `EMPLOYEE_ID` CHAR(8) NOT NULL,
  `TOUR_ID` CHAR(10) NULL,
  `QUAL_ID` CHAR(10) NULL,
  `EMPLOYEE_FIRST_NM` CHAR(20) NULL,
  `EMPLOYEE_LAST_NM` CHAR(20) NULL,
  `EMPLOYEE_ADDR` VARCHAR(255) NULL,
  `EMPLOYEE_HIRE_DT` DATE NULL,
  PRIMARY KEY (`EMPLOYEE_ID`),
  INDEX `FK_GUIDE_QUALIFICATION_idx` (`QUAL_ID` ASC) VISIBLE,
  INDEX `FK_GUIDE_TOUR_idx` (`TOUR_ID` ASC) VISIBLE,
  CONSTRAINT `FK_GUIDE_QUALIFICATION`
    FOREIGN KEY (`QUAL_ID`)
    REFERENCES `lost`.`qualification` (`QUAL_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_GUIDE_TOUR`
    FOREIGN KEY (`TOUR_ID`)
    REFERENCES `lost`.`tour` (`TOUR_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = '		';

CREATE TABLE IF NOT EXISTS `lost`.`location` (
  `LOCATION_ID` CHAR(10) NOT NULL,
  `TOUR_ID` CHAR(10) NOT NULL,
  `LOCATION_NAME` CHAR(50) NOT NULL,
  `LOCATION_TYPE` CHAR(50) NOT NULL,
  `LOCATION_DESC` VARCHAR(255) NOT NULL,
  `ORDER` INT NOT NULL,
  PRIMARY KEY (`LOCATION_ID`, `TOUR_ID`),
  INDEX `PFK_LOCATION_TOUR_idx` (`TOUR_ID` ASC) VISIBLE,
  CONSTRAINT `PFK_LOCATION_TOUR`
    FOREIGN KEY (`TOUR_ID`)
    REFERENCES `lost`.`tour` (`TOUR_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
