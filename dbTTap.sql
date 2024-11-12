﻿	

	Create database dbTTap
	go
	use dbTTap
	go
	--I. TAO BẢNG
	-- Tạo bảng Users
	CREATE TABLE Users (
	  id VARCHAR(20) NOT NULL,
	  name NVARCHAR(50) NOT NULL,
	  Password VARCHAR(20) NOT NULL,
	  Phone VARCHAR(10) Not null,
	  email NVARCHAR(100) unique NOT NULL,
	  address NVARCHAR(200),
	  image NVARCHAR(200),
	  admin BIT NOT NULL,
	  status BIT DEFAULT 1,
	);
	go
	-- Tạo bảng Categories
	CREATE TABLE Categories (
	  id VARCHAR(20) NOT NULL,
	  name NVARCHAR(50) NOT NULL,
	 description NVARCHAR(200),
	);
	go
	-- Tạo bảng Products
	CREATE TABLE Products (
	  id VARCHAR(20) NOT NULL,
	  name NVARCHAR(max) NOT NULL,
	  quantity INT NOT NULL,
	  price float not null,
	 description NVARCHAR(max),
	  status BIT NOT NULL,
	  category_id VARCHAR(20) NOT NULL,
	  brand_id VARCHAR(20) NOT NULL,
	);
	go
	-- Tạo bảng Invoices
	CREATE TABLE Invoices (
	  id VARCHAR(20) NOT NULL,
	  order_date DATE NOT NULL,
	  status NVARCHAR(50) NOT NULL,
	  user_id VARCHAR(20) NOT NULL,
	);
	go
	-- Tạo bảng DetailedInvoices
	CREATE TABLE Detailed_invoices (
		id int Identity(1,1) not null,
	  invoice_id VARCHAR(20) NOT NULL,
	  product_id VARCHAR(20) NOT NULL,
	  quantity INT NOT NULL,
	  payment_method NVARCHAR(200) NOT NULL,
	);
	go
	-- Tạo bảng Carts
	CREATE TABLE Carts (
	id int Identity(1,1) not null,
	  user_id VARCHAR(20) NOT NULL,
	  product_id VARCHAR(20) NOT NULL,
	  quantity INT NOT NULL,
	 order_date DATE NOT NULL,
	  status NVARCHAR(50) NOT NULL,
	);
	go
	-- Tạo bảng Brands
	CREATE TABLE Brands (
	  id VARCHAR(20) NOT NULL,
	  name NVARCHAR(200) NOT NULL,
	  address NVARCHAR(200) NOT NULL
	);
	go
	-- Tạo bảng StockReceipts
	CREATE TABLE stock_receipts (
	  id VARCHAR(20) NOT NULL,
	  brand_id VARCHAR(20) NOT NULL,
	  product_id VARCHAR(20) NOT NULL,
	  quantity INT NOT NULL,
	  price FLOAT NOT NULL,
	  order_date Date not null,
	
	);
	go
	-- Tạo bảng DetailedImages
	CREATE TABLE DetailedImages (
		id_image int Identity(1,1) not null,
	  product_id VARCHAR(20),
	  main_image NVARCHAR(200),
	  detailed_one NVARCHAR(200),
	  detailed_two NVARCHAR(200),
	  detailed_three NVARCHAR(200),
	);
	go
	--Tạo bảng user histories
	create table UserHistories(
	id_history int Identity(1,1) not null,
	note Nvarchar(200),
	history_date date not null,
	user_id varchar(20) not null,
	);


	--II. Tạo Khóa chính
	-- Thêm khóa chính cho bảng StockReceipts
		ALTER TABLE stock_receipts
	ADD CONSTRAINT PK_DetailedReceipt PRIMARY KEY (id);
	-- Thêm khóa chính cho bảng Users 
		ALTER TABLE Users
	ADD CONSTRAINT PK_User PRIMARY KEY (id);

	go

	--Thêm khóa chính cho bảng history
	alter table  UserHistories add constraint PK_history primary key (id_history);

	-- Thêm khóa chính cho bảng Categories
	ALTER TABLE Categories
	ADD CONSTRAINT PK_Categories PRIMARY KEY (id);

	go
	-- Thêm khóa chính cho bảng Products
	ALTER TABLE Products
	ADD CONSTRAINT PK_Products PRIMARY KEY (id);

	go

	-- Thêm khóa chính cho bảng Invoices
	ALTER TABLE Invoices
	ADD CONSTRAINT PK_Invoices PRIMARY KEY (id);

	go

	-- Thêm khóa chính cho bảng Brands
	ALTER TABLE Brands
	ADD CONSTRAINT PK_Brands PRIMARY KEY (id);

	-- Thêm khóa chính cho bảng carts
	ALTER TABLE Carts
	ADD CONSTRAINT PK_Carts PRIMARY KEY (id);

	-- Thêm khóa chính cho bảng DetailedInvoices
	ALTER TABLE Detailed_invoices
	ADD CONSTRAINT PK_Detailed_invoices PRIMARY KEY (id);

	-- Thêm khóa chính cho bảng  DetailedImages
	ALTER TABLE DetailedImages
	ADD CONSTRAINT PK_DetailedImages PRIMARY KEY (id_image);

	go
	--III. Tạo khóa ngoại 

	--Thêm liên kết khóa ngoại cho StockReceipts
	ALTER TABLE	stock_receipts
	ADD CONSTRAINT FK_DetailedReceipt_Brand FOREIGN KEY (brand_id) REFERENCES Brands(id)
	go

	-- Thêm liên kết khóa ngoại cho bảng Products
	ALTER TABLE Products
	ADD CONSTRAINT FK_Product_Categories FOREIGN KEY (category_id) REFERENCES Categories(id)

	ALTER TABLE Products ADD CONSTRAINT FK_Products_Brands FOREIGN KEY (brand_id) REFERENCES Brands(id);

	go

	-- Thêm liên kết khóa ngoại cho bảng Invoices
	ALTER TABLE Invoices
	ADD CONSTRAINT FK_Invoices_Users FOREIGN KEY (user_id) REFERENCES Users(id);

	go

	-- Thêm liên kết khóa ngoại cho bảng DetailedInvoices
	ALTER TABLE Detailed_invoices
	ADD CONSTRAINT FK_DetailedInvoices_Invoices FOREIGN KEY (invoice_id) REFERENCES Invoices(id)
	ALTER TABLE Detailed_invoices
	ADD CONSTRAINT FK_DetailedInvoices_Products FOREIGN KEY (product_id) REFERENCES Products(id);

	go

	-- Thêm liên kết khóa ngoại cho bảng Carts
	ALTER TABLE Carts
	ADD CONSTRAINT FK_Carts_User FOREIGN KEY (user_id) REFERENCES Users(id)
 
	ALTER TABLE Carts ADD CONSTRAINT FK_Carts_Products FOREIGN KEY (product_id) REFERENCES Products(id);

	go

	-- Thêm liên kết khóa ngoại cho bảng StockReceipts
	ALTER TABLE stock_receipts ADD CONSTRAINT FK_stock_receipts_Products FOREIGN KEY (product_id) REFERENCES Products(id)   ON DELETE CASCADE;;

	-- Thêm liên kết khóa ngoại cho bảng DetailedImages
	ALTER TABLE DetailedImages
	ADD CONSTRAINT FK_DetailedImages_Products FOREIGN KEY (product_id) REFERENCES Products(id);

	go

	-- thêm liên kết khóa ngoại cho bảng history
	alter table  UserHistories add constraint FK_UserHistories_Users FOREIGN KEY (user_id) REFERENCES users(id)

	--III. Thêm dữ liệu

	-- Thêm dữ liệu vào bảng Users
	INSERT INTO Users (id, name, Password, Phone, email, address, image, admin)
	VALUES 
	  ('U001', 'Nguyen Van A', '12345678', '0234567890', 'admin@gmail.com', N'Địa chỉ người dùng 1', 'avatar.jpg', 1),
	   ('U002', N'Nguyễn Nhựt Đông', 'Dong0393618987', '0393618987', '0393618987dong@gmail.com', N'Ấp hoà phú xã định thành  , huyện thoại sơn tỉnh an giang', 'avatar-11.jpg', 0),
	  ('U003', N'Trần Tấn Khanh', 'ttk3x1x2xx3zc', '0987654322', 'khanhttpc03027@fpt.edu.vn', N'Số nhà 10, Đường Trần Hưng Đạo, Quận 8, TP.HCM', 'avatar-12.jpg', 0),
	  ('U004', N'Trần Văn Hoàng', '12345678', '0987654321', 'trantankhanh31102003@gmail.com', N'Số nhà 4, Đường Lê Lợi, Quận 2, TP.HCM', 'avatar-4.jpg', 0),
	  ('U005', N'Lê Thị Minh Anh', '12345678', '0234567890', 'anhle@gmail.com', N'Số nhà 5, Đường Nguyễn Đình Chiểu, Quận 3, TP.HCM', 'avatar-5.jpg', 0),
	  ('U006', N'Phạm Văn Tuấn', '12345678', '0987654321', 'tuantuan@gmail.com', N'Số nhà 6, Đường Trần Phú, Quận 4, TP.HCM', 'avatar-6.jpg', 0),
	  ('U007', N'Vũ Thị Hương', '12345678', '0123456789', 'huongvu@gmail.com', N'Số nhà 7, Đường Lý Tự Trọng, Quận 5, TP.HCM', 'avatar-7.jpg', 0),
	  ('U008', N'Ngô Đình Thảo', '12345678', '0987654321', 'thaongo@gmail.com', N'Số nhà 8, Đường Nguyễn Văn Cừ, Quận 6, TP.HCM', 'avatar-8.jpg', 0),
	  ('U009', N'Trương Văn Thắng', '12345678', '0234567890', 'thangtruong@gmail.com', N'Số nhà 9, Đường Hùng Vương, Quận 7, TP.HCM', 'avatar-9.jpg', 0),
	  ('U010', N'Nguyễn Thị Mai', '12345678', '0987654321', 'mainguyen@gmail.com', N'Số nhà 10, Đường Trần Hưng Đạo, Quận 8, TP.HCM', 'avatar-10.jpg', 0);
	 ;


	-- Thêm dữ liệu vào bảng Categories
	INSERT INTO Categories (id, name, description)
	VALUES 
	  ('C001', N'Giày thể thao', N'Mô tả danh mục 1'),
	  ('C002', N'Giày cao gót', N'Mô tả danh mục 2')

	-- Thêm dữ liệu vào bảng Brands
	INSERT INTO Brands (id, name, address)
	VALUES
	  ('B001', 'Nike', N'Địa chỉ Nike'),
	  ('B002', 'Gucci', N'Địa chỉ Gucci'),
	  ('B003', 'Adidas', N'Địa chỉ Adidas'),
	  ('B004', 'Puma', N'Địa chỉ Puma'),
	  ('B005', 'Vans', N'Địa chỉ Vans'),
	  ('B006', 'Converse', N'Địa chỉ Converse'),
	  ('B007', 'Reebok', N'Địa chỉ Reebok'),
	  ('B008', 'New Balance', N'Địa chỉ New Balance'),
	  ('B009', 'Under Armour', N'Địa chỉ Under Armour'),
	  ('B010', 'Balenciaga', N'Địa chỉ Balenciaga'),
	  ('B011', 'Salomon', N'Địa chỉ Salomon'),
	  ('B012', 'Skechers', N'Địa chỉ Skechers'),
	  ('B013', 'Fila', N'Địa chỉ Fila'),
	  ('B014', 'ASICS', N'Địa chỉ ASICS'),
	  ('B015', 'DC Shoes', N'Địa chỉ DC Shoes'),
	  ('B016', 'Palladium', N'Địa chỉ Palladium'),
	  ('B017', 'Timberland', N'Địa chỉ Timberland'),
	  ('B018', 'Clarks', N'Địa chỉ Clarks'),
	  ('B019', 'Birkenstock', N'Địa chỉ Birkenstock'),
	  ('B020', 'Dr. Martens', N'Địa chỉ Dr. Martens');



	-- Thêm dữ liệu vào bảng Products
	INSERT INTO Products (id, name, quantity, price, description, status, category_id, brand_id)
	VALUES 
	  ('P001', N'Nike Air Max 97 Mschf x Inri Jesus Shoes', 100, 150, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí. ', 1, 'C001', 'B001'),
	  ('P002', N'Giày Thể Thao Nam Bitis Hunter Core Refreshing Collection Marios DSMH06700', 50, 200, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B001'),
	  ('P003', N'Giày Thể Thao Nam Hunter X - X-NITE 22 Collection DSMH10500', 80, 180, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B001'),
	  ('P004', N'Giày Thể Thao Nam Hunter Street DSMH10400', 120, 160, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B001'),
	  ('P005', N'Giày Thể Thao Nam Hunter Tennis DSMH10200', 30, 220,N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P006', N'Giày Thể Thao Nam Hunter X - X-NITE 22 Collection DSMH10500', 60, 190, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P007', N'Giày Thể Thao Nam Hunter X - SPIKY COLLAR Collection DSMH10600', 100, 250, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P008', N'Giày Thể Thao Nam Hunter Core - Meteor Collection DSMH10800', 40, 280, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P009', N'Giày Thể Thao Nam Bitis Hunter X Festive Aurora DSMH03401', 70, 170, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B003'),
	  ('P010', N'Giày Thể Thao Nữ Bitis Hunter X "CÒN-GÌ-DÙNG-ĐÓ" Colletion – Random 100 RSWH00100', 90, 200, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B003'),
	  ('P011', N'Giày Thể Thao Nữ Biti’s Hunter X Z Collection InPink DSWH06300', 60, 220, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P012', N'Giày Bóng Đá Nam Bitis Hunter Football Gen 2K21 Futsal DSMH07300', 50, 260, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B003'),
	  ('P013', N'Giày Thể Thao Trẻ Em Bitis Hunter Street JUNIOR x Vietmax Hanoi Culture Patchwork - Old Wall DSBH00500', 10, 240, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P014', N'Giày Thể Thao Nam Bitis Hunter Core Refreshing Collection Contras DSMH06700', 80, 200, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B003'),
	  ('P015', N'Giày Thể Thao Nam Bitis Hunter X Festive Frosty-White DSMH03500', 40, 180, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B003'),
	  ('P016', N'Giày Thể Thao Cao Cấp Nữ Bitis Hunter Layered Upper DSWH02800', 70, 190, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B003'),
	  ('P017', N'Giày Thể Thao Nam Bitis Hunter X Festive Spice Pumpkin DSMH03500', 90, 230, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B003'),
	  ('P018', N'Giày Thể Thao Nam Bitis Hunter Street Z Collection High White DSMH06200', 60, 250, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P019', N'Giày Thể Thao Nam Biti’s Hunter Core Z Collection Stone DSMH06400', 30, 280, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002'),
	  ('P020', N'Giày Thể Thao Nam Bitis Hunter X Festive Frosty-White DSMH03500', 50, 260, N'Tính nhất quán là chìa khóa để xây dựng sức mạnh và sức bền. Những đôi giày chạy bộ Reebok dành cho nam này giúp bạn đạt được tiến bộ ổn định với lớp đệm Floatride Energy Foam mang lại cảm giác nhẹ nhàng và một chuyến đi êm ái, nhạy bén. Lưới phía trên thoải mái và thoáng khí.', 1, 'C001', 'B002')
 
	-- Thêm dữ liệu vào bảng Invoices
	INSERT INTO Invoices (id, order_date, status, user_id)
	VALUES 
	('I001', '2024-01-10', N'delivered', 'U001'),
	('I002', '2024-02-09', N'delivered', 'U002'),
	('I003', '2024-03-12', N'pending', 'U003'),
	('I004', '2024-04-08', N'delivered', 'U004'),
	('I005', '2024-05-13', N'delivered', 'U003'),
	('I006', '2024-06-12', N'delivered', 'U004'),
	('I007', '2024-07-11', N'pending', 'U004'),
	('I008', '2024-08-07', N'delivered', 'U002'),
	('I009', '2024-09-15', N'delivered', 'U004'),
	('I010', '2024-10-14', N'delivered', 'U003'),
	('I011', '2024-11-06', N'pending', 'U004'),
	('I012', '2024-12-05', N'delivered', 'U001'),
	('I013', '2024-01-18', N'delivered', 'U003'),
	('I014', '2024-02-17', N'delivered', 'U003'),
	('I015', '2024-03-04', N'delivered', 'U002'),
	('I016', '2024-04-16', N'delivered', 'U003'),
	('I017', '2024-05-19', N'delivered', 'U002'),
	('I018', '2024-06-03', N'pending', 'U002'),
	('I019', '2024-07-21', N'delivered', 'U002'),
	('I020', '2024-07-20', N'pending', 'U002'),
	('I021', '2024-01-10', N'pending', 'U001'),
	('I022', '2024-02-09', N'pending', 'U002'),
	('I023', '2024-03-12', N'pending', 'U003'),
	('I024', '2024-04-08', N'delivered', 'U004'),
	('I025', '2024-05-13', N'delivered', 'U003'),
	('I026', '2024-08-12', N'pending', 'U004'),
	('I027', '2024-12-11', N'pending', 'U004'),
	('I028', '2024-11-07', N'delivered', 'U002'),
	('I029', '2024-09-15', N'delivered', 'U004'),
	('I030', '2024-01-14', N'delivered', 'U003'),
	('I031', '2024-02-06', N'pending', 'U004'),
	('I032', '2024-03-05', N'delivered', 'U001'),
	('I033', '2024-05-18', N'cancelled', 'U003'),
	('I034', '2024-11-17', N'delivered', 'U003'),
	('I035', '2024-07-04', N'cancelled', 'U002'),
	('I036', '2024-09-16', N'pending', 'U003'),
	('I037', '2024-01-19', N'cancelled', 'U002'),
	('I038', '2024-12-03', N'delivered', 'U002'),
	('I039', '2024-02-21', N'pending', 'U002'),
	('I040', '2024-03-20', N'delivered', 'U002')
		INSERT INTO Invoices (id, order_date, status, user_id)
	SELECT 'INV001', '2023-01-01', 'pending', 'U002'
	UNION ALL SELECT 'INV002', '2023-02-01', 'pending', 'U002'
	UNION ALL SELECT 'INV003', '2023-03-01', 'delivered', 'U002'
	UNION ALL SELECT 'INV004', '2023-04-01', 'delivered', 'U002'
	UNION ALL SELECT 'INV005', '2023-05-01', 'delivered', 'U002'
	UNION ALL SELECT 'INV006', '2023-06-01', 'delivered', 'U003'
	UNION ALL SELECT 'INV007', '2023-07-01', 'pending', 'U003'
	UNION ALL SELECT 'INV008', '2023-08-01', 'delivered', 'U003'
	UNION ALL SELECT 'INV009', '2023-09-01', 'delivered', 'U003'
	UNION ALL SELECT 'INV010', '2023-10-01', 'delivered', 'U003'
	UNION ALL SELECT 'INV011', '2023-11-01', 'delivered', 'U003'
	UNION ALL SELECT 'INV012', '2023-12-01', 'pending', 'U003'
	UNION ALL SELECT 'INV0022', '2023-02-01', 'delivered', 'U002'
	UNION ALL SELECT 'INV0032', '2023-03-01', 'pending', 'U002'
	UNION ALL SELECT 'INV0042', '2023-07-01', 'delivered', 'U004'
	UNION ALL SELECT 'INV0052', '2023-05-01', 'delivered', 'U002'
	UNION ALL SELECT 'INV0062', '2023-07-01', 'pending', 'U004'
	UNION ALL SELECT 'INV0072', '2023-07-01', 'delivered', 'U004'
	UNION ALL SELECT 'INV0082', '2023-07-01', 'delivered', 'U004'
	UNION ALL SELECT 'INV0092', '2023-09-01', 'delivered', 'U004'
	UNION ALL SELECT 'INV0102', '2023-11-01', 'pending', 'U003'
	UNION ALL SELECT 'INV0112', '2023-11-01', 'delivered', 'U004'
	UNION ALL SELECT 'INV0122', '2023-12-01', 'delivered', 'U002';
	-- Thêm dữ liệu vào bảng DetailedInvoices
	INSERT INTO Detailed_invoices (invoice_id, product_id, quantity, payment_method)
	VALUES 
	  ('I001', 'P001', 2, N'Thanh toán khi nhận hàng'),
	  ('I001', 'P002', 1, N'Thanh toán qua ví điện tử'),
	  ('I002', 'P003', 3, N'Thanh toán khi nhận hàng'),
	  ('I002', 'P004', 2, N'Thanh toán qua thẻ tín dụng'),
	  ('I003', 'P005', 1, N'Thanh toán khi nhận hàng'),
	  ('I003', 'P006', 4, N'Thanh toán qua ví điện tử'),
	  ('I004', 'P007', 2, N'Thanh toán khi nhận hàng'),
	  ('I004', 'P008', 1, N'Thanh toán qua thẻ tín dụng'),
	  ('I005', 'P009', 3, N'Thanh toán khi nhận hàng'),
	  ('I005', 'P010', 2, N'Thanh toán qua ví điện tử'),
	  ('I006', 'P011', 1, N'Thanh toán khi nhận hàng'),
	  ('I006', 'P012', 3, N'Thanh toán qua thẻ tín dụng'),
	  ('I007', 'P013', 2, N'Thanh toán khi nhận hàng'),
	  ('I007', 'P014', 1, N'Thanh toán qua ví điện tử'),
	  ('I008', 'P015', 4, N'Thanh toán khi nhận hàng'),
	  ('I008', 'P016', 2, N'Thanh toán qua thẻ tín dụng'),
	  ('I009', 'P017', 1, N'Thanh toán khi nhận hàng'),
	  ('I009', 'P018', 3, N'Thanh toán qua ví điện tử'),
	  ('I010', 'P019', 2, N'Thanh toán khi nhận hàng'),
	  ('I010', 'P020', 1, N'Thanh toán qua thẻ tín dụng');


	-- Thêm dữ liệu vào bảng StockReceipts
	INSERT INTO stock_receipts(id, brand_id, product_id, quantity, price, order_date)
	VALUES 
	('R001', 'B001', 'P001', 100, 150, '2023-06-30'),
	('R002', 'B002', 'P002', 50, 400, '2023-06-29'),
	('R003', 'B003', 'P003', 120, 200, '2023-06-28'),
	('R004', 'B004', 'P004', 80, 300, '2023-06-27'),
	('R005', 'B005', 'P005', 60, 250, '2023-06-26'),
	('R006', 'B006', 'P006', 90, 350, '2023-06-25'),
	('R007', 'B007', 'P007', 110, 180, '2023-06-24'),
	('R008', 'B008', 'P008', 70, 400, '2023-06-23'),
	('R009', 'B009', 'P009', 95, 220, '2023-6-22'),
	('R010', 'B010', 'P010', 120, 250, '2023-06-21'),
	('R011', 'B011', 'P011', 80, 300, '2023-10-20'),
	('R012', 'B012', 'P012', 65, 350, '2023-11-19'),
	('R013', 'B013', 'P013', 105, 190, '2023-12-18'),
	('R014', 'B014', 'P014', 75, 400, '2023-04-17'),
	('R015', 'B015', 'P015', 100, 230, '2023-06-16'),
	('R016', 'B016', 'P016', 115, 270, '2023-06-15'),
	('R017', 'B017', 'P017', 85, 320, '2023-06-14'),
	('R018', 'B018', 'P018', 55, 400, '2023-06-13'),
	('R019', 'B019', 'P019', 70, 200, '2023-06-12'),
	('R020', 'B020', 'P020', 90, 350, '2023-12-11')



	-- Thêm dữ liệu vào bảng DetailedImages
	INSERT INTO DetailedImages (product_id, main_image, detailed_one, detailed_two, detailed_three)
	VALUES 
	  ('P001', 'INRIJesus.png', 'INRIJesus-CT1.png', 'INRIJesus-CT2.png', 'INRIJesus-CT3.png'),
	  ('P002', 'AdidasSmith.png', 'AdidasSmith-CT1.png', 'AdidasSmith-CT2.png', 'AdidasSmith-CT3.png'),
	  ('P003', 'Alphabounce.png', 'Alphabounce-CT1.png', 'Alphabounce-CT2.png', 'Alphabounce-CT3.png'),
	  ('P004', 'Nike.png', 'Nike-CT1.png', 'Nike-CT2.png', 'Nike-CT3.png'),
	  ('P005', 'ArmyDC.png', 'ArmyDC-CT1.png', 'ArmyDC-CT2.png', 'ArmyDC-CT3.png'),
	  ('P006', 'NikeHong.png', 'NikeHong-CT1.png', 'NikeHong-CT2.png', 'NikeHong-CT3.png'),
	  ('P007', 'BitisDSM.png', 'BitisDSM-CT1.png', 'BitisDSM-CT2.png', 'BitisDSM-CT3.png'),
	  ('P008', 'BitisHunter.png', 'BitisHunter-CT1.png', 'BitisHunter-CT2.png', 'BitisHunter-CT3.png'),
	  ('P009', 'CoreBlack.png', 'CoreBlack-CT1.png', 'CoreBlack-CT2.png', 'CoreBlack-CT3.png'),
	  ('P010', 'DSM.png', 'DSM-CT1.png', 'DSM-CT2.png', 'DSM-CT3.png'),
	  ('P011', 'FestiveArmor.png', 'FestiveArmor-CT1.png', 'FestiveArmor-CT2.png', 'FestiveArmor-CT3.png'),
	  ('P012', 'HovrMega.png', 'HovrMega-CT1.png', 'HovrMega-CT2.png', 'HovrMega-CT3.png'),
	  ('P013', 'RedLike.png', 'RedLike-CT1.png', 'RedLike-CT2.png', 'RedLike-CT3.png'),
	  ('P014', 'HunterNu.png', 'HunterNu-CT1.png', 'HunterNu-CT2.png', 'HunterNu-CT3.png'),
	  ('P015', 'HunterRunning.png', 'HunterRunning-CT1.png', 'HunterRunning-CT2.png', 'HunterRunning-CT3.png'),
	  ('P016', 'HunterStreet.png', 'HunterStreet-CT1.png', 'HunterStreet-CT2.png', 'HunterStreet-CT3.png'),
	  ('P017', 'HunterTiger.png', 'HunterTiger-CT1.png', 'HunterTiger-CT2.png', 'HunterTiger-CT3.png'),
	  ('P018', 'HunterXOTP.png', 'HunterXOTP-CT1.png', 'HunterXOTP-CT2.png', 'HunterXOTP-CT3.png'),
	  ('P019', 'JodanXam.png', 'JodanXam-CT1.png', 'JodanXam-CT2.png', 'JodanXam-CT3.png'),
	  ('P020', 'JordanDo.png', 'JordanDo-CT1.png', 'JordanDo-CT2.png', 'JordanDo-CT3.png');


-- Insert data into Detailed_invoices table
INSERT INTO Detailed_invoices (invoice_id, product_id, quantity, payment_method)
SELECT 'INV001', 'P001', 2, 'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV002', 'P002', 1, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV003', 'P003', 3, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV004', 'P004', 2, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV005', 'P005', 1, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV006', 'P006', 2, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV007', 'P007', 3, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV008', 'P008', 1, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV009', 'P009', 2, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV010', 'P010', 3, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV011', 'P011', 1, N'Thanh toán khi nhận hàng'
UNION ALL SELECT 'INV012', 'P012', 2, N'Thanh toán khi nhận hàng';


INSERT INTO detailed_invoices (invoice_id, product_id, quantity, payment_method)
VALUES
('INV001', 'P001', 2, N'Thanh toán khi nhận hàng'),
('INV001', 'P002', 1, N'Thanh toán khi nhận hàng'),
('INV002', 'P003', 3, N'Thanh toán khi nhận hàng'),
('INV002', 'P004', 2, N'Thanh toán khi nhận hàng'),
('INV003', 'P005', 1, N'Thanh toán khi nhận hàng'),
('INV003', 'P006', 2, N'Thanh toán khi nhận hàng'),
('INV004', 'P007', 3, N'Thanh toán khi nhận hàng'),
('INV004', 'P008', 1, N'Thanh toán khi nhận hàng'),
('INV005', 'P009', 2, N'Thanh toán khi nhận hàng'),
('INV005', 'P010', 1, N'Thanh toán khi nhận hàng'),
('INV006', 'P011', 2, N'Thanh toán khi nhận hàng'),
('INV006', 'P012', 3, N'Thanh toán khi nhận hàng'),
('INV007', 'P013', 1, N'Thanh toán khi nhận hàng'),
('INV007', 'P014', 2, N'Thanh toán khi nhận hàng'),
('INV008', 'P015', 3, N'Thanh toán khi nhận hàng'),
('INV008', 'P016', 1, N'Thanh toán khi nhận hàng'),
('INV009', 'P017', 2, N'Thanh toán khi nhận hàng'),
('INV009', 'P018', 1, N'Thanh toán khi nhận hàng'),
('INV010', 'P019', 2, N'Thanh toán khi nhận hàng'),
('INV010', 'P020', 3, N'Thanh toán khi nhận hàng'),
('INV011', 'P001', 1, N'Thanh toán khi nhận hàng'),
('INV011', 'P002', 2, N'Thanh toán khi nhận hàng'),
('INV012', 'P003', 3, N'Thanh toán khi nhận hàng'),

('INV0022', 'P001', 2, N'Thanh toán khi nhận hàng'),
('INV0032', 'P002', 1, N'Thanh toán khi nhận hàng'),
('INV0042', 'P003', 3, N'Thanh toán khi nhận hàng'),
('INV0052', 'P004', 2, N'Thanh toán khi nhận hàng'),
('INV0062', 'P005', 1, N'Thanh toán khi nhận hàng'),
('INV0072', 'P006', 2, N'Thanh toán khi nhận hàng'),
('INV0082', 'P007', 3, N'Thanh toán khi nhận hàng'),
('INV0092', 'P008', 1, N'Thanh toán khi nhận hàng'),
('INV0102', 'P009', 2, N'Thanh toán khi nhận hàng'),
('INV0112', 'P010', 1, N'Thanh toán khi nhận hàng'),
('INV0122', 'P011', 2, N'Thanh toán khi nhận hàng'),

('I001', 'P001', 2, N'Thanh toán khi nhận hàng'),
('I001', 'P002', 1, N'Thanh toán khi nhận hàng'),
('I002', 'P003', 3, N'Thanh toán khi nhận hàng'),
('I002', 'P004', 2, N'Thanh toán khi nhận hàng'),
('I003', 'P005', 1, N'Thanh toán khi nhận hàng'),
('I003', 'P006', 2, N'Thanh toán khi nhận hàng'),
('I004', 'P007', 3, N'Thanh toán khi nhận hàng'),
('I004', 'P008', 1, N'Thanh toán khi nhận hàng'),
('I005', 'P009', 2, N'Thanh toán khi nhận hàng'),
('I005', 'P010', 1, N'Thanh toán khi nhận hàng'),
('I006', 'P011', 2, N'Thanh toán khi nhận hàng'),
('I006', 'P012', 3, N'Thanh toán khi nhận hàng'),
('I007', 'P013', 1, N'Thanh toán khi nhận hàng'),
('I007', 'P014', 2, N'Thanh toán khi nhận hàng'),
('I008', 'P015', 3, N'Thanh toán khi nhận hàng'),
('I008', 'P016', 1, N'Thanh toán khi nhận hàng'),
('I009', 'P017', 2, N'Thanh toán khi nhận hàng'),
('I009', 'P018', 1, N'Thanh toán khi nhận hàng'),
('I010', 'P019', 2, N'Thanh toán khi nhận hàng'),
('I010', 'P020', 3, N'Thanh toán khi nhận hàng'),
('I011', 'P001', 1, N'Thanh toán khi nhận hàng'),
('I011', 'P002', 2, N'Thanh toán khi nhận hàng'),
('I012', 'P003', 3, N'Thanh toán khi nhận hàng'),
('I013', 'P013', 1, N'Thanh toán khi nhận hàng'),
('I014', 'P014', 2, N'Thanh toán khi nhận hàng'),
('I015', 'P015', 3, N'Thanh toán khi nhận hàng'),
('I016', 'P016', 1, N'Thanh toán khi nhận hàng'),
('I017', 'P017', 2, N'Thanh toán khi nhận hàng'),
('I018', 'P018', 1, N'Thanh toán khi nhận hàng'),
('I019', 'P019', 2, N'Thanh toán khi nhận hàng'),
('I020', 'P020', 3, N'Thanh toán khi nhận hàng'),

('I021', 'P001', 2, N'Thanh toán khi nhận hàng'),
('I021', 'P002', 1, N'Thanh toán khi nhận hàng'),
('I023', 'P003', 3, N'Thanh toán khi nhận hàng'),
('I024', 'P004', 2, N'Thanh toán khi nhận hàng'),
('I025', 'P005', 1, N'Thanh toán khi nhận hàng'),
('I026', 'P006', 2, N'Thanh toán khi nhận hàng'),
('I027', 'P007', 3, N'Thanh toán khi nhận hàng'),
('I028', 'P008', 1, N'Thanh toán khi nhận hàng'),
('I029', 'P009', 2, N'Thanh toán khi nhận hàng'),
('I030', 'P010', 1, N'Thanh toán khi nhận hàng'),
('I031', 'P011', 2, N'Thanh toán khi nhận hàng'),
('I032', 'P012', 3, N'Thanh toán khi nhận hàng'),
('I033', 'P013', 1, N'Thanh toán khi nhận hàng'),
('I034', 'P014', 2, N'Thanh toán khi nhận hàng'),
('I035', 'P015', 3, N'Thanh toán khi nhận hàng'),
('I036', 'P016', 1, N'Thanh toán khi nhận hàng'),
('I037', 'P017', 2, N'Thanh toán khi nhận hàng'),
('I038', 'P018', 1, N'Thanh toán khi nhận hàng'),
('I039', 'P019', 2, N'Thanh toán khi nhận hàng'),
('I040', 'P020', 3, N'Thanh toán khi nhận hàng')