/**********************************************************************

 ██████╗███████╗ ██████╗██╗    ██████╗ ██╗  ██╗ ██╗ ██████╗ 
██╔════╝██╔════╝██╔════╝██║    ╚════██╗██║  ██║███║██╔═████╗
██║     ███████╗██║     ██║     █████╔╝███████║╚██║██║██╔██║
██║     ╚════██║██║     ██║     ╚═══██╗╚════██║ ██║████╔╝██║
╚██████╗███████║╚██████╗██║    ██████╔╝     ██║ ██║╚██████╔╝
 ╚═════╝╚══════╝ ╚═════╝╚═╝    ╚═════╝      ╚═╝ ╚═╝ ╚═════╝                                                          
 ____ ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____ ____ 
||F |||i |||n |||a |||l |||       |||P |||r |||o |||j |||e |||c |||t ||
||__|||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|

**********************************************************************/

/**********************************************************************

 Database Developer Name: Nathaniel Copeland
           Project Title: Online Book Store
      Script Create Date: 4/26/2019

**********************************************************************/

/**********************************************************************
	CREATE TABLE SECTION
**********************************************************************/

create table nrcope0421.Address
(
	AddressID int not null primary key identity(1,1), -- good for single column keys
	street nvarchar(255) not null,
    city nvarchar(255) not null,
	state nvarchar(2) not null,
	zip nvarchar(5) not null default '00000',
	county nvarchar(255) not null
);
create table nrcope0421.Author
(
	AuthorID int not null primary key identity(1,1), -- good for single column keys
	firstName nvarchar(255) not null,
    lastName nvarchar(255) not null,
	birthday date not null,
	deathday date null,
	website nvarchar(255) null default 'www.google.com'
);
create table nrcope0421.Condition
(
	ConditionID int not null primary key identity(1,1), -- good for single column keys
	new bit not null,
	scale nvarchar(1) null,
	dateEvaluated date not null default(getdate()),
	userEvaulated nvarchar(255) not null,
);
create table nrcope0421.Publisher
(
	PublisherID int not null primary key identity(1,1), -- good for single column keys
	name nvarchar(255) unique not null,
	address_id int foreign key REFERENCES nrcope0421.Address(AddressID),
	phone nvarchar(10) not null,
	active bit not null default '0'
);
create table nrcope0421.Customer
(
	CustomerID int not null primary key identity(1,1), -- good for single column keys
	firstName nvarchar(255) not null,
    lastName nvarchar(255) not null,
	lastActive date not null default(getdate()),
	phone nvarchar(10) not null,
	address_id int foreign key REFERENCES nrcope0421.Address(AddressID)
);
create table nrcope0421.Review
(
	ReviewID int not null primary key identity(1,1), -- good for single column keys
	customer_id int foreign key REFERENCES nrcope0421.Customer(CustomerID),
	dateCreated date not null default(getdate()),
	score nvarchar(1) not null default '0',
	verifiedPurchase bit not null
);
create table nrcope0421.Book
(
	BookID int not null primary key identity(1,1), -- good for single column keys
	title nvarchar(255) not null,
	author_id int foreign key REFERENCES nrcope0421.Author(AuthorID),
	publisher_id int foreign key REFERENCES nrcope0421.Publisher(PublisherID),
	conditon_id int foreign key REFERENCES nrcope0421.Condition(ConditionID),
	review_id int foreign key REFERENCES nrcope0421.Review(ReviewID),
	yearReleased nvarchar(4) not null default '0000',
	price float not null,
	stock int not null,
	check (price>0)
);
create table nrcope0421.BookQuanity
(
	BookOrderID int not null primary key identity(1,1), -- good for single column keys
	book_id int foreign key REFERENCES nrcope0421.Book(BookID),
	quantity int not null,
	totalCost float not null,
	dateAdded datetime not null default(getdate()),
);
create table nrcope0421.Cart
(
	CartID int not null primary key identity(1,1), -- good for single column keys
	bookquanity_id int foreign key REFERENCES nrcope0421.BookQuanity(BookOrderID),
	discount float null,
	finalAmount float not null,
	dateProcessed datetime not null default(getdate()),
	isPaid bit not null
);
create table nrcope0421.Orders
(
	OrdersID int not null primary key identity(1,1), -- good for single column keys
	customer_id int foreign key REFERENCES nrcope0421.Customer(CustomerID),
	cart_id int foreign key REFERENCES nrcope0421.Cart(CartID),
	dateShipped date not null default(getdate()),
	dateReceived date null
);

/**********************************************************************
	CREATE STORED PROCEDURE SECTION
**********************************************************************/

go
CREATE PROCEDURE nrcope0421.updateDiscount AS
begin
UPDATE nrcope0421.Cart
SET discount=0.10, finalAmount=23.2
WHERE CartID=1
end

go
create procedure nrcope0421.deleteChild as
begin
delete from nrcope0421.Orders
where OrdersID=1
end


go

/**********************************************************************
	DATA POPULATION SECTION
**********************************************************************/

declare @authorFK int
declare @conditionFK int
declare @addressFK int
declare @publisherFK int
declare @addressFK2 int
declare @customerFK int
declare @reviewFK int
declare @bookFK int
declare @bookQuanityFK int
declare @cartFK int

insert into nrcope0421.Author
values('Stephen', 'King', '11/2/1970', null, 'www.stephenking.com')
set @authorFK = @@identity

insert into nrcope0421.Condition
values(1, null, getdate(), 'Steve')
set @conditionFk = @@identity

insert into nrcope0421.Address
values('4584 Highland Rd', 'Gainesville', 'GA', '30506', 'USA')
set @addressFK = @@identity

insert into nrcope0421.Publisher
values('Penguin', @addressFK, '7705404365', 1)
set @publisherFK = @@identity

insert into nrcope0421.Address
values('60 Ruby Rd', 'Horse Cave', 'KY', '42749', 'USA')
SET @addressFK2 = @@IDENTITY

insert into nrcope0421.Customer
values('Bob', 'Smith', getdate(), 7709837341, @addressFK2)
set @customerFK = @@identity

insert into nrcope0421.Review
values(@customerFK, getdate(), '9', 1)
set @reviewFK = @@identity

insert into nrcope0421.Book
values('It', @authorFK, @publisherFK, @conditionFK, @reviewFK, '1970', '12.89', 100)
set @bookFK = @@identity

insert into nrcope0421.BookQuanity
values(@bookFK, 2, 25.78, getdate())
set @bookQuanityFK = @@identity

insert into nrcope0421.Cart
values(@bookQuanityFK, 0.05, 24.49, getdate(), 1)
set @cartFK = @@identity

insert into nrcope0421.Orders
values(@customerFK, @cartFK, '11/24/2016', '11/27/2019')
--2nd Insert

insert into nrcope0421.Author
values('Bill', 'Murray', '1/2/1980', null, 'www.billmurray.com')
set @authorFK = @@identity

insert into nrcope0421.Condition
values(1, null, '04/21/2010', 'Bill')
set @conditionFk = @@identity

insert into nrcope0421.Address
values('956 Oak Rd', 'Dallas', 'TX', '77701', 'USA')
set @addressFK = @@identity

insert into nrcope0421.Publisher
values('Cloud', @addressFK, '8658521458', 1)
set @publisherFK = @@identity

insert into nrcope0421.Address
values('85 Scarlet Ln', 'Gadsden', 'AL', '35901', 'USA')
SET @addressFK2 = @@IDENTITY

insert into nrcope0421.Customer
values('Jackie', 'Jones', getdate(), 5212501452, @addressFK2)
set @customerFK = @@identity

insert into nrcope0421.Review
values(@customerFK, getdate(), '4', 1)
set @reviewFK = @@identity

insert into nrcope0421.Book
values('How To Be', @authorFK, @publisherFK, @conditionFK, @reviewFK, '1980', '5.06', 20)
set @bookFK = @@identity

insert into nrcope0421.BookQuanity
values(@bookFK, 3, 15.18, '1/01/2010')
set @bookQuanityFK = @@identity

insert into nrcope0421.Cart
values(@bookQuanityFK, 0.20, 12.14,'1/02/2010', 1)
set @cartFK = @@identity

insert into nrcope0421.Orders
values(@customerFK, @cartFK, '1/03/2010', '1/06/2010')
--3rd Insert

insert into nrcope0421.Author
values('Jack', 'Frost', '3/20/1940', null, 'www.jackfrost.com')
set @authorFK = @@identity

insert into nrcope0421.Condition
values(0, 4, '04/05/2008', 'James')
set @conditionFk = @@identity

insert into nrcope0421.Address
values('20 Cedar Pt', 'Chicago', 'IL', '60007', 'USA')
set @addressFK = @@identity

insert into nrcope0421.Publisher
values('Fox', @addressFK, '4512852345', 0)
set @publisherFK = @@identity

insert into nrcope0421.Address
values('852 Apple Ln', 'Albuquerque', 'NM', '87101', 'USA')
SET @addressFK2 = @@IDENTITY

insert into nrcope0421.Customer
values('Link', 'of Hyrule', getdate(), 1254368745, @addressFK2)
set @customerFK = @@identity

insert into nrcope0421.Review
values(@customerFK, getdate(), '9', 1)
set @reviewFK = @@identity

insert into nrcope0421.Book
values('Poems and Such', @authorFK, @publisherFK, @conditionFK, @reviewFK, '2002', '10.14', 40)
set @bookFK = @@identity

insert into nrcope0421.BookQuanity
values(@bookFK, 1, 10.14, '5/12/2012')
set @bookQuanityFK = @@identity

insert into nrcope0421.Cart
values(@bookQuanityFK, 0.00, 10.14,'5/13/2012', 1)
set @cartFK = @@identity

insert into nrcope0421.Orders
values(@customerFK, @cartFK, '5/14/2012', '5/16/2012')
--4th Insert

insert into nrcope0421.Author
values('Mark', 'Hamill', '3/10/1930', null, 'www.markhamill.com')
set @authorFK = @@identity

insert into nrcope0421.Condition
values(0, 7, '06/07/2004', 'Christy')
set @conditionFk = @@identity

insert into nrcope0421.Address
values('20 Alexander Way', 'Chicago', 'IL', '60007', 'USA')
set @addressFK = @@identity

insert into nrcope0421.Publisher
values('Blue Tides', @addressFK, '4555522214', 0)
set @publisherFK = @@identity

insert into nrcope0421.Address
values('212 Rooftop Dr', 'Albuquerque', 'NM', '87101', 'USA')
SET @addressFK2 = @@IDENTITY

insert into nrcope0421.Customer
values('Arya', 'Stark', getdate(), 5242523654, @addressFK2)
set @customerFK = @@identity

insert into nrcope0421.Review
values(@customerFK, getdate(), '6', 1)
set @reviewFK = @@identity

insert into nrcope0421.Book
values('Become Noone', @authorFK, @publisherFK, @conditionFK, @reviewFK, '1960', '10.08', 40)
set @bookFK = @@identity

insert into nrcope0421.BookQuanity
values(@bookFK, 1, 10.08, '5/10/2015')
set @bookQuanityFK = @@identity

insert into nrcope0421.Cart
values(@bookQuanityFK, 0.00, 10.08,'5/11/2015', 1)
set @cartFK = @@identity

insert into nrcope0421.Orders
values(@customerFK, @cartFK, '5/11/2015', '5/13/2015')--5th Insert

insert into nrcope0421.Author
values('Natalie', 'Portman', '8/04/1960', null, 'www.natalieportman.com')
set @authorFK = @@identity

insert into nrcope0421.Condition
values(1, null, '04/8/2004', 'Ben')
set @conditionFk = @@identity

insert into nrcope0421.Address
values('40 Privot Dr', 'Chicago', 'IL', '60007', 'USA')
set @addressFK = @@identity

insert into nrcope0421.Publisher
values('McCleoud', @addressFK, '5247841325', 0)
set @publisherFK = @@identity

insert into nrcope0421.Address
values('1 Hope St', 'Albuquerque', 'NM', '87101', 'USA')
SET @addressFK2 = @@IDENTITY

insert into nrcope0421.Customer
values('Harold', 'Truman', getdate(), 2524147852, @addressFK2)
set @customerFK = @@identity

insert into nrcope0421.Review
values(@customerFK, getdate(), '2', 1)
set @reviewFK = @@identity

insert into nrcope0421.Book
values('SelpHelp', @authorFK, @publisherFK, @conditionFK, @reviewFK, '1900', '12.00', 40)
set @bookFK = @@identity

insert into nrcope0421.BookQuanity
values(@bookFK, 1, 12.00, '9/12/2010')
set @bookQuanityFK = @@identity

insert into nrcope0421.Cart
values(@bookQuanityFK, 0.00, 12.00,'9/13/2010', 1)
set @cartFK = @@identity

insert into nrcope0421.Orders
values(@customerFK, @cartFK, '9/13/2010', '9/16/2010')

/**********************************************************************
	RUN STORED PROCEDURE SECTION
**********************************************************************/

exec nrcope0421.updateDiscount
exec nrcope0421.deleteChild


/**********************************************************************
	END OF SCRIPT
**********************************************************************/