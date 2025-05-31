use db4virtual 

--drop table produkter;
--drop table produsertevarer;
--drop table sysdiagrams;

select [name] 
from sys.tables;

select * 
from produkter;


--see contraints

SELECT [name] 
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID('produsertevarer');

--make a table
		--unreserve the reserved keywords of sql by []

create table produkter(
produktId int identity(1,1),
category char(6) not null, 
[name] varchar(30)not null unique, 
[description] varchar(100) null, 
[weight] float null check(weight>0), 
price decimal(10,2) null,
productiondate date null,
servicetime time null,
deliverytime datetime null,
--(instead of) produktId int primary key,
constraint pk_produkter primary key (produktId) 
);

--complete report of a table
exec sp_help produkter;

--rename a table
exec sp_rename produkter, varer;

 
 --extra columns 

alter table varer 
add added_column int null;

alter table varer 
drop column added_column;

--extra checks and constraints

ALTER TABLE varer 
DROP CONSTRAINT CK__produkter__weight__05D8E0BE;

alter table varer 
alter column weight decimal(2,2);

--add extra check

ALTER TABLE varer 
ADD CONSTRAINT CK_varer_weight 
CHECK (weight > 0.1);

--drop a constraint

alter table varer 
drop constraint name_z;

--add a constraing with check

ALTER TABLE varer 
ADD CONSTRAINT name_z 
CHECK (name IS NULL OR name = 'z');

--1 to many relationships
		--tips, when altering a fk to already filled table,
		--nullable it at start, later not null

create table category (categoryName char(6));

--make the column non null to enable FK

ALTER TABLE category
ALTER COLUMN categoryName 
char(6) 
NOT NULL;

--add column, just a table needs a column to delete one

alter table category 
add categoryId int identity;

--only a pk can become a fk

alter table category
add constraint pk_categoryName 
primary key(categoryName);

--make it fk

alter table produkter 
add constraint fk_produktCategory 
foreign key (kategori) 
references category(categoryName);

--script of fk
ALTER TABLE [dbo].[produkter]  
WITH CHECK ADD  CONSTRAINT [fk_produktCategory] 
FOREIGN KEY([kategori])
REFERENCES [dbo].[category] ([categoryName])
GO

ALTER TABLE [dbo].[produkter] 
CHECK CONSTRAINT [fk_produktCategory]
GO

--rename a column
exec sp_rename 'produkter.category', 'kategori', 'column';

--stored process
exec sp_help produkter;
exec sp_help category;

--many to many relationship
	-- kurs -->registratioin<--student
	-- registratioin is a MAPPING TABLE enabling many students to many kurs
	--just need two fk, 1 to many and many to 1

--prapare second table for many to many

create table orders(
orderId int not null primary key,
orderDate datetime not null,
customerEmail varchar(200) not null
);


--mapping table for many to many

create table orderlines(
orderLineId int identity(1,1) primary key,
orderId int not null foreign key references orders(orderId),
produktId int not null foreign key references produkter(produktId),
quantity int not null check(quantity>=1)
);

--mapping many to many-example 2

CREATE TABLE Movies(
MovieId INT IDENTITY(1,1) PRIMARY KEY,
Title nvarchar (100) NOT NULL,
LaunchDate Date NULL
);

CREATE TABLE Actors(
ActorId INT IDENTITY(1,1) PRIMARY KEY,
Name nvarchar (200) NOT NULL,
Country varchar(100) NULL
);

CREATE TABLE MovieActor(
MovieActorId INT IDENTITY(1,1) PRIMARY KEY,
MovieId INT FOREIGN KEY References Movies (MovieId), 
ActorId INT FOREIGN KEY References Actors(ActorId)
);

exec sp_help movies;
exec sp_help actors;
exec sp_help movieactor;
