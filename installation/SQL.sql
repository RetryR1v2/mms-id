CREATE TABLE `mms_huntingid` (
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`charidentifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`firstname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`lastname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`age` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`picture` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`days` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci'
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `mms_id` (
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`charidentifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`firstname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`lastname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`nickname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`job` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`age` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`gender` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`picture` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci'
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `mms_docrecipe` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
	`charidentifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`docname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`reason` LONGTEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`therapie` LONGTEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`age` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`days` VARCHAR(50) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=6
;
