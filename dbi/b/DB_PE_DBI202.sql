create database HOTEL
go
use HOTEL
go
create table tblCustomer
(
	CustID varchar (10) primary key,
	CustName nvarchar(40) not null,
	DOB date,
	Tel char(10) not null Check(Tel like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
go
Insert into tblCustomer values('KH001',N'Nguyễn Thanh Thúy','1988-05-18','0905678541')
Insert into tblCustomer values('KH002',N'Trần Anh Tuấn','1980-03-28','0935678789')
Insert into tblCustomer values('KH003',N'Lâm Thùy Dương','1981-06-20','0935654321')
go
create table tblRoomType
(
	TypeID varchar(3) primary key,
	TypeName nvarchar(30),
	TypePrice decimal(10,0) check (TypePrice >=0)
);
go
Insert into tblRoomType values('STD','Standard',700000)
Insert into tblRoomType values('DLX','Deluxe',1200000)
Insert into tblRoomType values('SUT','Suite',2000000)
go
create table tblRoom
(
	RoomID varchar(4) primary key,
	Rstatus varchar(2),
	TypeID varchar(3)foreign key(TypeID) references tblRoomType(TypeID) on update cascade	
);
go
Insert into tblRoom values('R101','A','STD')
Insert into tblRoom values('R102','A','STD')
Insert into tblRoom values('R201','A','DLX')
Insert into tblRoom values('R301','A','SUT')
go
create table tblHotelOrder
(
	OrderID varchar(10) primary key,
	OrderDate date default getdate(),
	CustID varchar (10) not null foreign key references tblCustomer(CustID) on update cascade
);
go
Insert into tblHotelOrder values('001', '2023-4-15', 'KH001')
Insert into tblHotelOrder values('002', '2023-4-18', 'KH002')
Insert into tblHotelOrder values('003', '2023-5-25', 'KH001')
go
create table tblRoomOrder
(
	OrderID varchar(10) not null foreign key(OrderID) references tblHotelOrder(OrderID),
	RoomID varchar(4) not null foreign key(RoomID) references tblRoom(RoomID) on update cascade,
	checkIn date,
	checkOut date, 
	constraint pk_rO primary key(OrderID,RoomID)
);
go
Insert into tblRoomOrder values('001','R101','2023-04-25','2023-04-29')
Insert into tblRoomOrder values('001','R102','2023-04-25','2023-04-29')
Insert into tblRoomOrder values('001','R201','2023-04-25','2023-04-29')
Insert into tblRoomOrder values('003','R301','2023-05-10','2023-05-12')
go
create table has(
	TypeID varchar(3),
	OrderID varchar(10),
	numberOfR int,
	FOREIGN KEY (TypeID) REFERENCES tblRoomType(TypeID),
	FOREIGN KEY (OrderID) REFERENCES tblHotelOrder(OrderID)
)
go
CREATE PROCEDURE addition(
@CustID varchar (10),
@CustName nvarchar(40),
@DOB date,
@Tel char(10)
)
AS
BEGIN
Insert into tblCustomer values(@CustID,@CustName,@DOB,@Tel)

END;

CREATE TABLE tblRoomReservation
(
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    TypeID VARCHAR(3) FOREIGN KEY REFERENCES tblRoomType(TypeID),
    OrderID VARCHAR(10) FOREIGN KEY REFERENCES tblHotelOrder(OrderID),
    ServiceID VARCHAR(10),
    ServiceName NVARCHAR(50),
    ServiceCharge DECIMAL(10,2),
    UsageDateTime DATETIME,
    NumberOfTimesUsed INT
);

INSERT INTO tblRoomReservation (TypeID, OrderID, ServiceID, ServiceName, ServiceCharge, UsageDateTime, NumberOfTimesUsed)
VALUES 
('STD', '001', 'S001', N'Room Cleaning', 100.00, '2023-04-26 10:00:00', 1),
('DLX', '002', 'S002', N'Laundry', 150.00, '2023-04-19 15:30:00', 2),
('SUT', '003', 'S003', N'In-Room Dining', 250.00, '2023-05-11 20:45:00', 1);
 
CREATE PROCEDURE AddNewCustomer
@CustID VARCHAR(10),
@CustName NVARCHAR(40),
@DOB DATE,
@Tel CHAR(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO tblCustomer (CustID, CustName, DOB, Tel)
        VALUES (@CustID, @CustName, @DOB, @Tel)
    END TRY
    BEGIN CATCH
        PRINT 'Error encountered while adding new customer. Please check the data and try again.'
    END CATCH
END;

CREATE TRIGGER tr_AssignRoomToOrder
ON tblRoomOrder
AFTER INSERT
AS
BEGIN
    DECLARE @RoomID VARCHAR(4)
    SELECT @RoomID = RoomID FROM INSERTED

    IF EXISTS (SELECT 1 FROM tblRoom WHERE RoomID = @RoomID AND Rstatus = 'NA')
    BEGIN
        ROLLBACK TRANSACTION
        PRINT 'Cannot assign this room as it is not available.'
    END
    ELSE
    BEGIN
        UPDATE tblRoom
        SET Rstatus = 'NA'
        WHERE RoomID = @RoomID
    END
END;

CREATE VIEW v_RepeatedCustomers AS
SELECT 
    c.CustID,
    c.CustName,
    c.DOB,
    c.Tel,
    COUNT(o.OrderID) AS NumberOfReservations
FROM tblCustomer c
JOIN tblHotelOrder o ON c.CustID = o.CustID
GROUP BY c.CustID, c.CustName, c.DOB, c.Tel
HAVING COUNT(o.OrderID) > 1;
