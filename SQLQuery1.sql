use Electronics


create table Brands (
    Id tinyint primary key identity,
    Name Nvarchar(100)
);


create table Notebooks (
    Id tinyint  primary key identity,
    Name Nvarchar(100),
    Price smallint,
    BrandId tinyint,
    Foreign key (BrandId) references Brands(Id)
);


create table Phones (
    Id tinyint  primary key identity,
    Name Nvarchar(100),
    Price smallint,
    BrandId tinyint,
    Foreign key (BrandId) references Brands(Id)
);

insert into Brands ( Name)
values
    ('Hp'),
    ('Apple'),
    ('Samsung');


insert into Notebooks ( Name,Price,BrandId)
values
    ('Hp noutbook', 1000, 1),
    ('Mac', 1200, 2),
	    ('Samsung s', 1500, 3),
		    ('sssssss', 1500, 3),
			  ('Asus', 4500, 1);



insert into Phones( Name,Price,BrandId)
values
    ('Hp phone', 1000, 1),
    ('Apple', 1200, 2),
    ('Samsung Galaxy S23', 1500, 3);

select n.Name as NotebooksName, B.Name as BrandName, n.Price
from Notebooks as n
join Brands as b on n.BrandId = b.Id;


select p.Name as PhonesName, b.Name as BrandName, p.Price
from Phones p
join Brands b on p.BrandId = b.Id;


select n.Name as NotebooksName
from Notebooks as n
where exists (
    select 1
    from Brands as b
    where b.Id = n.BrandId
    and b.Name like '%s%'
);


select n.Name as NotebooksName,n.Price as NoutbookPrice
from Notebooks as n
where n.Price between 2000 and 5000 or n.Price > 5000;


select p.Name as PhonesName,p.Price as PhonePrice
from Phones as p
where p.Price between 1000 and 1500 or p.Price > 1500;



select b.Name as BrandName, Count(n.Id) as NotebookCount
from Brands as b
left join Notebooks as n on b.Id = n.BrandId
group by b.Name;



select b.Name as BrandName, Count(p.Id) as PhoneCount
from Brands as b
left join Phones as p on b.Id = p.BrandId
group by b.Name;




select n.Name as product, n.BrandId
from Notebooks as n
union
select p.Name as product, p.BrandId
from Phones as p;


select Id, Name, Price, BrandId from Notebooks
union
select Id, Name, Price, BrandId from Phones;


select n.Id, n.Name, n.Price, b.Name as BrandName
from Notebooks as n
join Brands as b on n.BrandId = b.Id
union
select p.Id, p.Name, p.Price, b.Name as BrandName
from Phones as p
join Brands as b on p.BrandId = b.Id;


select b.Name as BrandName, SUM(p.Price) as TotalPrice, COUNT(*) as ProductCount
from Phones as p
join Brands as b on p.BrandId = b.Id
group by b.Name;



select b.Name as BrandName, SUM(n.Price) as TotalPrice, COUNT(*) as ProductCount
from Notebooks as n
join Brands as b on n.BrandId = b.Id
group by b.Name
having COUNT(*) >= 3;






--Task 2


create table Books (
    Id tinyint primary key identity,
    Name Nvarchar(100) check (len(Name) >= 2 and len(Name) <= 100),
    PageCount tinyint check (PageCount >= 10)
);

create table Authors (
    Id tinyint primary key identity,
    Name Nvarchar(100),
    Surname Nvarchar(100)
);

create table BookAuthors (
    BookId tinyint,
    AuthorId tinyint,
    foreign key (BookId) references Books(Id),
    foreign key (AuthorId) references Authors(Id)
);


insert into Books (Name, PageCount)
values
    ('Kitab1', 150),
    ('Kitab2', 200),
    ('Kitab3', 120);

insert into Authors (Name, Surname)
values
    ('YAzici1', 'Soyad1'),
    ('YAzici2', 'Soyad2'),
    ('YAzici3', 'Soyad3');

insert into BookAuthors (BookId, AuthorId)
values
    (1, 1),
    (1, 2),
    (2, 2),
    (3, 3);

create view BookDetails as
select b.Id, b.Name, b.PageCount, concat(a.Name, ' ', a.Surname) as AuthorFullName
from Books as b
join BookAuthors as ba on b.Id = ba.BookId
join Authors as a on ba.AuthorId = a.Id;


select * from BookDetails;


create procedure SearchBooks
    @SearchValue nvarchar(100)
as
begin
    select Id, Name, PageCount, AuthorFullName
    from BookDetails
    where Name like '%' + @SearchValue + '%' or AuthorFullName like '%' + @SearchValue + '%';
end;


exec SearchBooks @SearchValue = 'kitab2'

create procedure CreateAuthor
    @AuthorName nvarchar(100),
    @AuthorSurname nvarchar(100)
as
begin
    insert into Authors (Name, Surname)
    values (@AuthorName, @AuthorSurname);
end;


create procedure UpdateAuthor
    @AuthorId tinyint,
    @AuthorName nvarchar(100),
    @AuthorSurname nvarchar(100)
as
begin
    update Authors
    set Name = @AuthorName, Surname = @AuthorSurname
    where Id = @AuthorId;
end;

create procedure DeleteAuthor
    @AuthorId tinyint
as
begin
    delete from Authors
    where Id = @AuthorId;
end;




exec CreateAuthor @AuthorName = 'Nijat', @AuthorSurname = 'AZizov';


