USE [master];
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'bookstore')
BEGIN
    ALTER DATABASE [bookstore] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [bookstore];
END
GO

CREATE DATABASE [bookstore];
GO

USE [bookstore];
GO

CREATE TABLE Roles (roleId INT PRIMARY KEY, role NVARCHAR(30));
CREATE TABLE Genre (genreId INT PRIMARY KEY, genre NVARCHAR(30));
CREATE TABLE Author (authorId INT PRIMARY KEY, authorFirstName NVARCHAR(50), authorLastName NVARCHAR(50));
CREATE TABLE Suppliers (supplierId INT PRIMARY KEY, companyName NVARCHAR(50), phone VARCHAR(20), address NVARCHAR(100), contactPerson NVARCHAR(50));
CREATE TABLE Clients (clientId INT PRIMARY KEY, cFirstName NVARCHAR(50), cLastName NVARCHAR(50), clientPhone VARCHAR(20), clientAddress NVARCHAR(100), email VARCHAR(100), username NVARCHAR(30), password NVARCHAR(30));
CREATE TABLE Publisher (publisherId INT PRIMARY KEY, publisher NVARCHAR(30), Suppliers_supplierId INT FOREIGN KEY REFERENCES Suppliers(supplierId));
CREATE TABLE Employees (employeeId INT PRIMARY KEY, firstName NVARCHAR(50), lastName NVARCHAR(50), salary DECIMAL(10,2), username NVARCHAR(30), password NVARCHAR(30), empEmail VARCHAR(100), empPhone VARCHAR(20), empAddress NVARCHAR(100), Roles_roleId INT FOREIGN KEY REFERENCES Roles(roleId));
CREATE TABLE Books (bookId INT PRIMARY KEY, title NVARCHAR(100), unitPrice DECIMAL(10,2), availableQuantity INT, releaseDate DATE, pages INT, Publisher_publisherId INT FOREIGN KEY REFERENCES Publisher(publisherId), Genre_genreId INT FOREIGN KEY REFERENCES Genre(genreId));
CREATE TABLE Requests (requestId INT PRIMARY KEY, createdDate DATE, requestStatus NVARCHAR(30), Employees_employeeId INT FOREIGN KEY REFERENCES Employees(employeeId), Suppliers_supplierId INT FOREIGN KEY REFERENCES Suppliers(supplierId));
CREATE TABLE Invoices (invoiceId INT PRIMARY KEY, issueDate DATE, paymentMethod NVARCHAR(30), Employees_employeeId INT FOREIGN KEY REFERENCES Employees(employeeId));
CREATE TABLE Orders (orderId INT PRIMARY KEY, orderDate DATE, orderStatus NVARCHAR(30), Clients_clientId INT FOREIGN KEY REFERENCES Clients(clientId), Invoices_invoiceId INT NOT NULL FOREIGN KEY REFERENCES Invoices(invoiceId));
CREATE TABLE OrderedBooks (Orders_orderId INT FOREIGN KEY REFERENCES Orders(orderId), Books_bookId INT FOREIGN KEY REFERENCES Books(bookId), booksQuantity INT, price DECIMAL(10,2), PRIMARY KEY (Orders_orderId, Books_bookId));
CREATE TABLE Delivery (Books_bookId INT FOREIGN KEY REFERENCES Books(bookId), Requests_requestId INT FOREIGN KEY REFERENCES Requests(requestId), deliveryDate DATE, quantity INT, deliveryStatus NVARCHAR(30), PRIMARY KEY (Books_bookId, Requests_requestId));
CREATE TABLE BooksAuthors (Author_authorId INT FOREIGN KEY REFERENCES Author(authorId), Books_bookId INT FOREIGN KEY REFERENCES Books(bookId), PRIMARY KEY (Author_authorId, Books_bookId));
GO

INSERT INTO Roles VALUES (1, 'Admin'), (2, 'Seller');
INSERT INTO Genre VALUES (1,'Classic'),(2,'Sci-Fi'),(3,'Fantasy'),(4,'Bio'),(5,'Thriller'),(6,'Romance'),(7,'History'),(8,'Mystery'),(9,'Horror'),(10,'Poetry');

INSERT INTO Author VALUES (1,'Ivan','Vazov'),(2,'Georgi','Gospodinov'),(3,'Stephen','King'),(4,'J.K.','Rowling'),(5,'George','Orwell'),(6,'Agatha','Christie'),(7,'Ernest','Hemingway'),(8,'Mark','Twain'),(9,'Victor','Hugo'),(10,'Franz','Kafka');

INSERT INTO Suppliers VALUES (1, 'BulKniga Ltd', '029887766', 'Sofia, Tsarigradsko Shose 117', 'Dimitar Berbatov');
INSERT INTO Publisher VALUES (1, 'Ciela', 1), (2, 'Hermes', 1), (3, 'Colibri', 1);

INSERT INTO Employees VALUES 
(1, 'Nikolay', 'Stefanov', 3500.00, 'admin_niko', 'pass123', 'niko@mail.bg', '0888111', 'Sofia, Mladost 1', 1),
(2, 'Ralitsa', 'Georgieva', 1800.00, 'raly_seller', 'pass456', 'raly@mail.bg', '0888222', 'Plovdiv, Center', 2);

INSERT INTO Clients VALUES 
(1,'Petar','Ivanov','0881','Sofia, Alabin 5','p@mail.bg','p_ivanov','123'),(2,'Maria','Petrova','0882','Plovdiv, Ruski 10','m@mail.bg','m_petrova','123'),
(3,'Ivan','Georgiev','0883','Varna, Oborishte 2','i@mail.bg','i_georgiev','123'),(4,'Elena','Dimova','0884','Burgas, Morska 1','e@mail.bg','e_dimova','123'),
(5,'Stefan','Kolev','0885','Ruse, Dunav 8','s@mail.bg','s_kolev','123'),(6,'Anna','Vasileva','0886','Stara Zagora, Boruy 3','a@mail.bg','a_vasileva','123'),
(7,'Yordan','Angelov','0887','Pleven, Shipka 12','y@mail.bg','y_angelov','123'),(8,'Desislava','Todorova','0888','Sliven, Druzhba 4','d@mail.bg','d_todorova','123'),
(9,'Vladimir','Borisov','0889','Dobrich, Mir 9','v@mail.bg','v_borisov','123'),(10,'Mila','Ilieva','0890','Shumen, Madara 1','mi@mail.bg','m_ilieva','123'),
(11,'Boris','Nikolov','0891','Haskovo, Rodopi 2','b@mail.bg','b_nikolov','123'),(12,'Silvia','Popova','0892','Yambol, Targovska 5','si@mail.bg','s_popova','123'),
(13,'Daniel','Zhelev','0893','Pernik, Sofiyska 1','da@mail.bg','d_zhelev','123'),(14,'Viktoria','Markova','0894','Blagoevgrad, Pirin 7','vi@mail.bg','v_markova','123'),
(15,'Kaloyan','Lazarov','0895','Gabrovo, Nikolaevska 3','k@mail.bg','k_lazarov','123'),(16,'Teodora','Dimova','0896','Vidin, Dunavska 11','t@mail.bg','t_dimova','123'),
(17,'Aleksandar','Kostov','0897','Vratsa, Hristo Botev 1','al@mail.bg','a_kostov','123'),(18,'Hristina','Pavlova','0898','Smolyan, Snezhanka 4','h@mail.bg','h_pavlova','123'),
(19,'Martin','Stoev','0899','Lovech, Targovska 6','ma@mail.bg','m_stoev','123'),(20,'Lili','Ivanova','0900','Sofia, Balgaria 100','l@mail.bg','l_ivanova','123');

INSERT INTO Books VALUES 
(1,'Under the Yoke',25.00,100,'1894-01-01',450,1,1),(2,'Time Shelter',20.00,50,'2020-01-01',320,3,1),(3,'1984',15.00,80,'1949-01-01',328,2,2),(4,'Harry Potter',22.00,120,'1997-01-01',223,1,3),(5,'The Shining',18.00,40,'1977-01-01',447,2,9),
(6,'Digital Fortress',17.00,35,'1998-01-01',350,1,5),(7,'The Great Gatsby',14.00,35,'1925-01-01',180,3,1),(8,'The Hobbit',21.00,90,'1937-01-01',310,1,3),(9,'Fahrenheit 451',16.00,55,'1953-01-01',158,2,2),(10,'Pride and Prejudice',13.00,45,'1813-01-01',279,3,6),
(11,'Sherlock Holmes',17.00,25,'1892-01-01',307,2,8),(12,'Foundation',24.00,30,'1951-01-01',255,1,2),(13,'Dune',28.00,15,'1965-01-01',412,1,2),(14,'Napoleon',19.00,50,'2010-01-01',281,3,7),(15,'Crime and Punishment',23.00,20,'1866-01-01',671,3,1),
(16,'Little Prince',10.00,200,'1943-01-01',96,2,3),(17,'Alchemist',15.00,110,'1988-01-01',197,1,3),(18,'Steppenwolf',16.00,30,'1927-01-01',237,3,1),(19,'Metamorphosis',11.00,40,'1915-01-01',102,3,1),(20,'The Stranger',12.00,45,'1942-01-01',123,2,1);

INSERT INTO BooksAuthors VALUES (1,1),(2,2),(5,3),(4,4),(3,5),(1,6),(7,7),(4,8),(5,9),(10,10),(6,11),(2,12),(3,13),(7,14),(9,15),(2,16),(1,17),(10,18),(10,19),(9,20);

INSERT INTO Requests VALUES (1,'2025-10-01','Completed',2,1),(2,'2025-11-01','Completed',2,1),(3,'2025-12-01','Pending',2,1),(4,'2025-12-10','Pending',2,1),(5,'2025-12-20','New',2,1);
INSERT INTO Delivery VALUES (1,1,'2025-10-02',50,'Delivered'),(2,2,'2025-11-02',30,'Delivered'),(3,3,'2025-12-02',20,'Ordered'),(4,4,'2025-12-12',10,'Ordered'),(5,5,'2025-12-22',5,'Ordered');

INSERT INTO Invoices VALUES (1,'2025-10-05','Card',2),(2,'2025-10-05','Cash',2),(3,'2025-10-08','Card',2),(4,'2025-10-08','Cash',2),(5,'2025-10-10','Card',2),(6,'2025-10-12','Cash',2),(7,'2025-10-15','Card',2),(8,'2025-10-18','Cash',2),(9,'2025-10-20','Card',2),(10,'2025-10-22','Cash',2);
INSERT INTO Invoices VALUES (11,'2025-10-25','Card',2),(12,'2025-10-28','Cash',2),(13,'2025-10-30','Card',2),(14,'2025-11-02','Cash',2),(15,'2025-11-05','Card',2),(16,'2025-11-08','Cash',2),(17,'2025-11-10','Card',2),(18,'2025-11-12','Cash',2),(19,'2025-11-15','Card',2),(20,'2025-11-18','Cash',2);
INSERT INTO Invoices VALUES (21,'2025-11-20','Card',2),(22,'2025-11-22','Cash',2),(23,'2025-11-25','Card',2),(24,'2025-11-28','Cash',2),(25,'2025-11-30','Card',2),(26,'2025-12-01','Cash',2),(27,'2025-12-02','Card',2),(28,'2025-12-03','Cash',2),(29,'2025-12-04','Card',2),(30,'2025-12-05','Cash',2);
INSERT INTO Invoices VALUES (31,'2025-12-06','Card',2),(32,'2025-12-07','Cash',2),(33,'2025-12-08','Card',2),(34,'2025-12-09','Cash',2),(35,'2025-12-10','Card',2),(36,'2025-12-11','Cash',2),(37,'2025-12-12','Card',2),(38,'2025-12-13','Cash',2),(39,'2025-12-14','Card',2),(40,'2025-12-15','Cash',2);
INSERT INTO Invoices VALUES (41,'2025-12-16','Card',2),(42,'2025-12-17','Cash',2),(43,'2025-12-18','Card',2),(44,'2025-12-19','Cash',2),(45,'2025-12-20','Card',2),(46,'2025-12-21','Cash',2),(47,'2025-12-22','Card',2),(48,'2025-12-23','Cash',2),(49,'2025-12-24','Card',2),(50,'2025-12-24','Cash',2);

INSERT INTO Orders VALUES (1,'2025-10-05','Done',1,1),(2,'2025-10-05','Done',2,2),(3,'2025-10-08','Done',3,3),(4,'2025-10-08','Done',4,4),(5,'2025-10-10','Done',5,5),(6,'2025-10-12','Done',6,6),(7,'2025-10-15','Done',7,7),(8,'2025-10-18','Done',8,8),(9,'2025-10-20','Done',9,9),(10,'2025-10-22','Done',10,10);
INSERT INTO Orders VALUES (11,'2025-10-25','Done',11,11),(12,'2025-10-28','Done',12,12),(13,'2025-10-30','Done',13,13),(14,'2025-11-02','Done',14,14),(15,'2025-11-05','Done',15,15),(16,'2025-11-08','Done',16,16),(17,'2025-11-10','Done',17,17),(18,'2025-11-12','Done',18,18),(19,'2025-11-15','Done',19,19),(20,'2025-11-18','Done',20,20);
INSERT INTO Orders VALUES (21,'2025-11-20','Done',1,21),(22,'2025-11-22','Done',2,22),(23,'2025-11-25','Done',3,23),(24,'2025-11-28','Done',4,24),(25,'2025-11-30','Done',5,25),(26,'2025-12-01','Done',6,26),(27,'2025-12-02','Done',7,27),(28,'2025-12-03','Done',8,28),(29,'2025-12-04','Done',9,29),(30,'2025-12-05','Done',10,30);
INSERT INTO Orders VALUES (31,'2025-12-06','Done',11,31),(32,'2025-12-07','Done',12,32),(33,'2025-12-08','Done',13,33),(34,'2025-12-09','Done',14,34),(35,'2025-12-10','Done',15,35),(36,'2025-12-11','Done',16,36),(37,'2025-12-12','Done',17,37),(38,'2025-12-13','Done',18,38),(39,'2025-12-14','Done',19,39),(40,'2025-12-15','Done',20,40);
INSERT INTO Orders VALUES (41,'2025-12-16','Done',1,41),(42,'2025-12-17','Done',2,42),(43,'2025-12-18','Done',3,43),(44,'2025-12-19','Done',4,44),(45,'2025-12-20','Done',5,45),(46,'2025-12-21','Done',6,46),(47,'2025-12-22','Done',7,47),(48,'2025-12-23','Done',8,48),(49,'2025-12-24','Done',9,49),(50,'2025-12-24','Done',10,50);

INSERT INTO OrderedBooks VALUES (1,1,2,25.00),(2,2,1,20.00),(3,3,3,15.00),(4,4,1,22.00),(5,5,1,18.00),(6,6,1,17.00),(7,7,2,14.00),(8,8,1,21.00),(9,9,1,16.00),(10,10,1,13.00);
INSERT INTO OrderedBooks VALUES (11,11,1,17.00),(12,12,1,24.00),(13,13,5,28.00),(14,14,1,19.00),(15,15,2,23.00),(16,16,1,10.00),(17,17,3,15.00),(18,18,1,16.00),(19,19,1,11.00),(20,20,1,12.00);
INSERT INTO OrderedBooks VALUES (21,1,2,25.00),(22,2,1,20.00),(23,3,3,15.00),(24,4,1,22.00),(25,5,1,18.00),(26,6,1,17.00),(27,7,2,14.00),(28,8,1,21.00),(29,9,1,16.00),(30,10,1,13.00);
INSERT INTO OrderedBooks VALUES (31,11,1,17.00),(32,12,1,24.00),(33,13,5,28.00),(34,14,1,19.00),(35,15,2,23.00),(36,16,1,10.00),(37,17,3,15.00),(38,18,1,16.00),(39,19,1,11.00),(40,20,1,12.00);
INSERT INTO OrderedBooks VALUES (41,1,2,25.00),(42,2,1,20.00),(43,3,3,15.00),(44,4,1,22.00),(45,5,1,18.00),(46,6,1,17.00),(47,7,2,14.00),(48,8,1,21.00),(49,9,1,16.00),(50,10,1,13.00);
GO