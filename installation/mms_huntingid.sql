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
