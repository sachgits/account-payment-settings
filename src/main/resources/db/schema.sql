drop table T_ACCOUNT if exists;

create table T_ACCOUNT (ID bigint identity primary key, NUMBER varchar(9),
                        NAME varchar(50) not null, BALANCE decimal(8,2), unique(NUMBER));
                        
ALTER TABLE T_ACCOUNT ALTER COLUMN BALANCE SET DEFAULT 0.0;

drop table country if exists;
create table country (
	ID bigint identity primary key, 
	NAME varchar(60) not null unique,
	CODE varchar(2) not null unique,
	FLAG varchar(2) not null unique, 
	CURRENCY varchar(3) not null unique);

CREATE CACHED TABLE PUBLIC.COUNTRY(
    ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_9D678882_E8C0_40B8_9462_F23CB862813C) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_9D678882_E8C0_40B8_9462_F23CB862813C,
    NAME VARCHAR(60) NOT NULL,
    CODE VARCHAR(2) NOT NULL,
    FLAG VARCHAR(2) NOT NULL,
    CURRENCY VARCHAR(3) NOT NULL
)

/*
CREATE TABLE `country` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(60) NOT NULL,
  `CODE` varchar(2) NOT NULL,
  `FLAG` varchar(2) NOT NULL,
  `CURRENCY` varchar(3) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME_UNIQUE` (`NAME`),
  UNIQUE KEY `ID_UNIQUE` (`ID`),
  UNIQUE KEY `CODE_UNIQUE` (`CODE`),
  UNIQUE KEY `FLAG_UNIQUE` (`FLAG`),
  UNIQUE KEY `CURRENCY_UNIQUE` (`CURRENCY`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 
*/	


drop table section if exists;
create table section (ID bigint identity primary key, NAME varchar(255) not null, 
	VALUE varchar(255), 
	unique (NAME, VALUE));
	
/*
CREATE TABLE `ferdinand`.`section` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(255) NOT NULL,
  `VALUE` VARCHAR(255) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  UNIQUE INDEX `NAME_VALUE_UNIQUE` (`NAME` ASC, `VALUE` ASC)); 
 * */	

	
drop table sections if exists;
create table sections (NAME varchar(255) not null, 
	ACCOUNT_ID bigint not null, 
	SECTION_ID bigint not null, 
	foreign key (ACCOUNT_ID) references public.country(ID),
	foreign key (SECTION_ID) references public.section(ID),
);

/* BEGIN H2 statements*/
drop table account if exists;
CREATE TABLE account(
  ID bigint NOT NULL identity primary key,
  USER_ID bigint NOT NULL,
  CREATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CURRENCY varchar(3) NOT NULL,
  BALANCE decimal(8,2) NOT NULL DEFAULT 0.0,
  OVERDRAFT decimal(8,2) NOT NULL DEFAULT 0.0,
  TYPE varchar(255) NOT NULL DEFAULT 'CURRENT',
  PRIMARY KEY (ID),
  FOREIGN KEY (USER_ID) REFERENCES user (ID)
)

/* OLD ACCOUNT table */
/*
CREATE CACHED TABLE PUBLIC.ACCOUNT(
    ID BIGINT DEFAULT (NEXT VALUE FOR PUBLIC.SYSTEM_SEQUENCE_A7ABAB74_FAAC_45A4_BEF5_49E8B852E2A9) NOT NULL NULL_TO_DEFAULT SEQUENCE PUBLIC.SYSTEM_SEQUENCE_A7ABAB74_FAAC_45A4_BEF5_49E8B852E2A9,
    NUMBER VARCHAR(9),
    NAME VARCHAR(50) NOT NULL,
    BALANCE DECIMAL(8, 2) DEFAULT 0.0
)	
*/	
/* END H2 statements*/

/* BEGIN MySQL statements*/
CREATE TABLE user (
  ID bigint(20) NOT NULL AUTO_INCREMENT,
  NAME varchar(255) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE account(
  ID bigint(20) unsigned not null auto_increment,
  USER_ID bigint(20) NOT NULL,
  CREATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CURRENCY varchar(3) NOT NULL,
  BALANCE double NOT NULL DEFAULT 0.00,
  OVERDRAFT double NOT NULL DEFAULT 0.00,
  TYPE varchar(255) NOT NULL DEFAULT 'CURRENT',
  PRIMARY KEY (ID),
  FOREIGN KEY (USER_ID) REFERENCES user (ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE account MODIFY CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
	/* ALTER TABLE account ALTER CREATED SET DEFAULT CURRENT_TIMESTAMP; */
ALTER TABLE account ALTER BALANCE SET DEFAULT 0.00;
ALTER TABLE account ALTER OVERDRAFT SET DEFAULT 0.00;
ALTER TABLE account
  ADD CONSTRAINT unique_user_id_curr_type UNIQUE( USER_ID, CURRENCY, TYPE);

CREATE TABLE payee (
  ID bigint(20) NOT NULL AUTO_INCREMENT,
  NAME varchar(255) NOT NULL,
  PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE payee ADD UNIQUE INDEX name_unique (NAME ASC);

CREATE TABLE user_payee (
  USER_ID bigint(20) NOT NULL,
  PAYEE_ID bigint(20) NOT NULL,
  PRIMARY KEY ( USER_ID, PAYEE_ID),
  FOREIGN KEY ( USER_ID ) REFERENCES user ( ID ),
  FOREIGN KEY ( PAYEE_ID ) REFERENCES payee ( ID )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE payment (
  ID bigint(20) unsigned not null auto_increment,
  USER_ID bigint(20) NOT NULL,
  ACCOUNT_ID bigint(20) NOT NULL,
  PAYEE_ID bigint(20) NOT NULL,
  CREATED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  AMOUNT double NOT NULL DEFAULT 0.00,
  PAYMENT_CURRENCY varchar(3) NOT NULL,
  RATE double NOT NULL DEFAULT 1.00,
  CHARGE double   NOT NULL DEFAULT 0.00,  
  CALCULATED_AMOUNT double NOT NULL DEFAULT 0.00,
  PAYEE_CURRENCY varchar(3) NOT NULL,
  
  PLACED bit(1) NOT NULL DEFAULT 0,
  DATE_PLACED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  CANCELLED bit(1) NOT NULL DEFAULT 0,
  DATE_CANCELLED datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  SETTLED bit(1) NOT NULL DEFAULT 0,
  DATE_SETTLED datetime NOT NULL  DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ( ID ),
  FOREIGN KEY ( USER_ID ) REFERENCES user ( ID ),
  FOREIGN KEY ( PAYEE_ID ) REFERENCES payee ( ID ),
  FOREIGN KEY ( ACCOUNT_ID ) REFERENCES account ( ID )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE payment MODIFY CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE payment MODIFY DATE_PLACED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE payment MODIFY DATE_CANCELLED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE payment MODIFY DATE_SETTLED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE payment ALTER AMOUNT SET DEFAULT 0.00;
ALTER TABLE payment ALTER RATE SET DEFAULT 1.00;
ALTER TABLE payment ALTER CHARGE SET DEFAULT 0.00;
ALTER TABLE payment ALTER CALCULATED_AMOUNT SET DEFAULT 0.00;
ALTER TABLE payment ALTER PLACED SET DEFAULT 0;
ALTER TABLE payment ALTER CANCELLED SET DEFAULT 0;
ALTER TABLE payment ALTER SETTLED SET DEFAULT 0;

alter table payment ADD CONSTRAINT payment_ibfk_1 FOREIGN KEY ( USER_ID ) REFERENCES user ( ID );
alter table payment ADD CONSTRAINT payment_ibfk_2 FOREIGN KEY ( PAYEE_ID ) REFERENCES payee ( ID );
alter table payment ADD CONSTRAINT payment_ibfk_3 FOREIGN KEY ( ACCOUNT_ID ) REFERENCES account ( ID );


/* END MySQL statements*/