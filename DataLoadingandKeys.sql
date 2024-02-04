
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema group6
-- -----------------------------------------------------
set global local_infile=on;
CREATE SCHEMA IF NOT EXISTS `group6` DEFAULT CHARACTER SET utf8 ;
USE `group6` ;

-- -----------------------------------------------------
-- Table `group6`.`genome_tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `group6`.`genome_tags` (
  `tagId` INT NOT NULL,
  `tag` VARCHAR(200) NULL,
  UNIQUE INDEX `tagId_UNIQUE` (`tagId` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `group6`.`movies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `group6`.`movies` (
  `movieId` INT NOT NULL,
  `title` VARCHAR(200) NULL,
  `genres` VARCHAR(300) NULL,
  UNIQUE INDEX `movieId_UNIQUE` (`movieId` ASC))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `group6`.`ratings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `group6`.`ratings` (
  `userId` INT NOT NULL,
  `movieId` INT NOT NULL,
  `rating` DECIMAL(5,2) NULL,
  `movie_timestamp` VARCHAR(50) NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `group6`.`genome_scores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `group6`.`genome_scores` (
  `movieId` INT NOT NULL,
  `tagId` INT NOT NULL,
  `relevance` DECIMAL(5,4) NULL)
 ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `group6`.`tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `group6`.`tags` (
  `userId` INT NULL,
  `movieId` INT NULL,
  `tag` VARCHAR(200) NOT NULL,
  `movie_timestamp` VARCHAR(50) NOT NULL)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Loading the Data
-- -----------------------------------------------------

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

LOAD DATA LOCAL INFILE '/Users/shubhratagupta/Documents/DB for BA/SQL Group Project /archive (2)/genome-tags.csv'
INTO TABLE genome_tags 
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/shubhratagupta/Documents/DB for BA/SQL Group Project /archive (2)/movies.csv'
INTO TABLE movies 
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/shubhratagupta/Documents/DB for BA/SQL Group Project /archive (2)/tags.csv'
INTO TABLE tags 
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/shubhratagupta/Documents/DB for BA/SQL Group Project /archive (2)/ratings.csv'
INTO TABLE ratings
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/shubhratagupta/Documents/DB for BA/SQL Group Project /archive (2)/genome-scores.csv'
INTO TABLE genome_scores
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- -----------------------------------------------------
-- `Defining Primary Keys'
-- -----------------------------------------------------

alter table movies add constraint pk_movies primary key (movieId);

alter table genome_tags add constraint pk_gtags primary key (tagId);

alter table tags add constraint pk_tags primary key (userId,movieId, tag, movie_timestamp);

-- -----------------------------------------------------
-- `Creating index for files with large size'
-- -----------------------------------------------------

CREATE index i_ratings
ON ratings(userId, movieId);

alter table ratings add constraint pk_ratings primary key (userId,movieId);

CREATE index i_genomescores
ON genome_scores(movieId, tagId);

alter table genome_scores add constraint pk_gscores primary key (movieId, tagId);

-- -----------------------------------------------------
-- `Defining Primary Keys'
-- -----------------------------------------------------

alter table tags add constraint foreign key (movieId) references movies(movieId);

alter table ratings add constraint foreign key (movieId) references movies(movieId);

alter table genome_scores add constraint foreign key (movieId) references movies(movieId);

alter table genome_scores add constraint foreign key (tagId) references genome_tags(tagId);

-- -----------------------------------------------------
-- `Cleaned the dataset'
-- -----------------------------------------------------

UPDATE movies SET genres=(SELECT SUBSTRING_INDEX(genres,"|",1));