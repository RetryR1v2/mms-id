CREATE TABLE `mms_id` (
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`firstname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`lastname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`nickname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`job` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`age` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`gender` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`picture` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci'
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `mms_huntingid` (
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`firstname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`lastname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`age` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`date` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`picture` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`days` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci'
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;