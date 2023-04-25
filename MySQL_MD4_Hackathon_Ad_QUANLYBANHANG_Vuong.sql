create database QUANLYBANHANG;
use QUANLYBANHANG;

-- Tạo bảng
create table Customers (
customer_id varchar(4) primary key,
name varchar(100) not null,
email varchar(100) not null unique,
phone varchar(25) not null unique,
address varchar(255) not null
);

create table Orders (
order_id varchar(4) primary key,
customer_id varchar(4),
order_date date not null,
total_amount double not null,
foreign key (customer_id) references Customers(customer_id)
);

create table Products (
product_id varchar(4) primary key,
name varchar(255) not null,
description text,
price double not null,
status bit(1) not null
);

create table  ORDERS_DETAILS (
order_id varchar(4),
product_id varchar(4),
quantity int(11) not null,
price double not null,
primary key(order_id,product_id),
foreign key (order_id) references Orders(order_id),
foreign key (product_id) references Products(product_id)
);

-- Bài 2: Thêm dữ liệu
-- Bảng CUSTOMERS
insert into customers values 
("C001", "Nguyễn Trung Mạnh", "manhnt@gmail.com", "984756322", "Cầu Giấy, Hà Nội"),
("C002", "Hồ Hải Nam", "namhh@gmail.com", "984875926", "Ba Vì, Hà Nội"),
("C003", "Tô Ngọc Vũ", "vutn@gmail.com", "904725784", "Mộc Châu, Sơn La"),
("C004", "Phạm Ngọc Anh", "anhpn@gmail.com", "984635365", "Vinh, Nghệ An"),
("C005", "Trương Minh Cường", "cuongtm@gmail.com", "989735624", "Hai Bà Trưng, Hà Nội");

-- Bảng PRODUCTS
insert into products values 
("P001", "Iphone 13 Promax", "Bản 512GB, xanh lá", 22999999,1),
("P002", "Dell Vostro V3510", "Core i5, RAM 8GB", 14999999,1),
("P003", "Macbook Pro M2", "8CPU 10GPU 8GB 256GB", 28999999,1),
("P004", "Apple Watch Ultra", "Titanium Alpine Loop Small", 18999999,1),
("P005", "Airpods 2 2022", "Spatial Audio", 4090000,1);

-- Bảng ORDERS
insert into orders values 
("H001", "C001","2023-02-22", 52999997),
("H002", "C001","2023-03-11", 80999997),
("H003", "C002","2023-01-22", 54359998),
("H004", "C003","2023-03-14", 102999995),
("H005", "C003","2023-03-12", 80999997),
("H006", "C004","2023-02-01", 110449994),
("H007", "C004","2023-03-29", 79999996),
("H008", "C005","2023-02-14", 29999998),
("H009", "C005","2023-01-10", 28999999),
("H010", "C005","2023-04-01", 149999994);

--  Bảng Orders_details
insert into orders_details values 
("H001", "P002", 1, 14999999),
("H001", "P004", 2, 18999999),
("H002", "P001", 1, 22999999),
("H002", "P003", 2, 28999999),
("H003", "P004", 2, 18999999),
("H003", "P005", 4, 4090000),
("H004", "P002", 3, 14999999),
("H004", "P003", 2, 28999999),
("H005", "P001", 1, 22999999),
("H005", "P003", 2, 28999999),
("H006", "P005", 5, 4090000),
("H006", "P002", 6, 14999999),
("H007", "P004", 3, 18999999),
("H007", "P001", 1, 22999999),
("H008", "P002", 2, 14999999),
("H009", "P003", 1, 28999999),
("H010", "P003", 2, 28999999),
("H010", "P001", 4, 22999999);

-- Bài 3: Truy vấn dữ liệu
-- Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers
select name, email, phone, address
from customers;

-- Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng)
select distinct c.name, c.phone, c.address
from customers c
join orders o on o.customer_id = c.customer_id
where o.order_date like "2023-03-%";

-- Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ).
select month(order_date) as Tháng, sum(total_amount) as Doanh_Thu
from orders
where year(order_date) = 2023
group by Tháng
order by Tháng;

-- Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điện thoại)
select c.name, c.address, c.email, c.phone
from customers c
where not exists (select 1 from orders where (c.customer_id = orders.customer_id) and orders.order_date like "2023-02-%");

-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra)
select p.product_id, p.name, sum(od.quantity) as Total
from products p
join orders_details od on od.product_id = p.product_id
join orders o on o.order_id = od.order_id
where o.order_date like "2023-03-%"
group by p.product_id;

-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu)
select c.customer_id, c.name, sum(total_amount) as Tong_chi_tieu
from customers c 
join orders o on o.customer_id = c.customer_id
where year(o.order_date) = 2023
group by c.customer_id
order by Tong_chi_tieu DESC;

-- Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) .
select c.name, o.total_amount, o.order_date, sum(od.quantity) as So_Luong
from orders o
join customers c on c.customer_id = o.customer_id
join orders_details od on od.order_id = o.order_id
group by o.order_id
having So_Luong >= 5;

-- Bài 4: Tạo View, Procedure
-- Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn .
CREATE VIEW ORDER_VIEW AS
SELECT c.name, c.phone, c.address, o.total_amount as "Tổng tiền", o.order_date
FROM orders o
join customers c on c.customer_id = o.customer_id;
select * from ORDER_VIEW;

-- Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt
CREATE VIEW CUSTOMER_VIEW AS
SELECT c.name, c.address, c.phone, count(o.order_id) as Total_orders
FROM orders o
join customers c on c.customer_id = o.customer_id
group by c.customer_id;
select * from CUSTOMER_VIEW;

-- Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.
CREATE VIEW PRODUCT_VIEW AS
SELECT p.name, p.description, p.price, sum(od.quantity) as Total_product_sold
FROM products p
join orders_details od on od.product_id = p.product_id
group by p.product_id;
select * from PRODUCT_VIEW;

-- Đánh Index cho trường `phone` và `email` của bảng Customer.
create index customers_index on customers(phone,email);


-- Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
DELIMITER //
CREATE PROCEDURE PROC_SELECTSTUDENT
(IN cusID varchar(4))
BEGIN
	select * from customers where customer_id = cusID;
END //

-- Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
DELIMITER //
CREATE PROCEDURE PROC_FINDALL_PRODUCT()
BEGIN
	select * from products;
END //
call PROC_FINDALL_PRODUCT();

-- Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. 
DELIMITER //
CREATE PROCEDURE PROC_SHOWLISTORDERBYCUSTOMERID
(IN cusID varchar(4))
BEGIN
	select row_number() over (order by o.order_id ASC) as 'STT', o.order_id, o.order_date, o.total_amount
    from orders o
    join customers c on c.customer_id = o.customer_id
    where cusID = c.customer_id;
END //


-- Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
DELIMITER //
CREATE PROCEDURE PROC_CREATE_NEW_ORDER_THEN_SHOW_IT
(IN ordID varchar(4), cusID varchar(4), order_date date, total double)
BEGIN
  insert into orders values (ordID,cusID,order_date,total);
  select * from orders where orders.order_id = ordID;
END //

-- Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.
DELIMITER //
CREATE PROCEDURE PROC_COUNT_PRODUCT
(IN startDate date, endDate date)
BEGIN
	select p.name ,sum(od.quantity) as Total_sold
    from orders o
    join orders_details od on od.order_id = o.order_id
    join products p on p.product_id = od.product_id
    where o.order_date between startDate and endDate
    group by p.product_id;
END //

-- Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. 
DELIMITER //
CREATE PROCEDURE PROC_COUNT_PRODUCT_BY_MONTH
(IN months varchar(2), years varchar(4))
BEGIN
	select p.name, sum(od.quantity) as Total
    from orders o
    join orders_details od on od.order_id = o.order_id
    join products p on p.product_id = od.product_id
    where (month(o.order_date) = months) and (year(o.order_date) = years)
    group by p.product_id
    order by Total DESC;
END //
call PROC_COUNT_PRODUCT_BY_MONTH("03","2023");