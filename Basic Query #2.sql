?--67040249106
--Ekkasit srisuk

-- *********????????? Basic Query #2 ***************
 
 --1. จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย เฉพาะสินค้าประเภท Seafood
 --แบบ Product
 
--แบบ Join
SELECT  p.ProductID, p.ProductName, p.UnitPrice
FROM    Products p
JOIN    Categories c ON p.CategoryID = c.CategoryID
WHERE   c.CategoryName = 'Seafood';
---------------------------------------------------------------------
--2.จงแสดงชื่อบริษัทลูกค้า ประเทศที่ลูกค้าอยู่ และจำนวนใบสั่งซื้อที่ลูกค้านั้น ๆ ที่รายการสั่งซื้อในปี 1997
--แบบ Product


--แบบ Join

SELECT  c.CompanyName, c.Country,
        COUNT(o.OrderID) AS OrderCount
FROM    Customers c
JOIN    Orders o ON c.CustomerID = o.CustomerID
WHERE   YEAR(o.OrderDate) = 1997
GROUP BY c.CompanyName, c.Country;
---------------------------------------------------------------------
--3. จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย ชื่อบริษัทและประเทศที่จัดจำหน่ายสินค้านั้น ๆ
--แบบ Product

--แบบ Join

SELECT  p.ProductID, p.ProductName, p.UnitPrice,
        s.CompanyName AS SupplierName, s.Country
FROM    Products p
JOIN    Suppliers s ON p.SupplierID = s.SupplierID;
---------------------------------------------------------------------
--4. ชื่อ-นามสกุลของพนักงานขาย ตำแหน่งงาน และจำนวนใบสั่งซื้อที่แต่ละคนเป็นผู้ทำรายการขาย 
--เฉพาะที่ทำรายการขายช่วงเดือนมกราคม-เมษายน ปี 1997 และแสดงเฉพาะพนักงานที่ทำรายการขายมากกว่า 10 ใบสั่งซื้อ 
--แบบ Product

--แบบ Join
SELECT  e.EmployeeID,
        (e.FirstName + ' ' + e.LastName) AS EmpName,
        e.Title,
        COUNT(o.OrderID) AS OrderCount
FROM    Employees e
JOIN    Orders o ON e.EmployeeID = o.EmployeeID
WHERE   YEAR(o.OrderDate) = 1997
  AND   MONTH(o.OrderDate) BETWEEN 1 AND 4
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Title
HAVING  COUNT(o.OrderID) > 10;
---------------------------------------------------------------------
--5.จงแสดงรหัสสินค้า ชื่อสินค้า ยอดขายรวม(ไม่คิดส่วนลด) ของสินค้าแต่ละชนิด
--แบบ Product

--แบบ Join
SELECT  p.ProductID, p.ProductName,
        SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM    Products p
JOIN    [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName;
---------------------------------------------------------------------
/*6.จงแสดงรหัสบริษัทจัดส่ง ชื่อบริษัทจัดส่ง จำนวนใบสั่งซื้อที่จัดส่งไปยังประเทศสหรัฐอเมริกา, 
อิตาลี, สหราชอาณาจักร, แคนาดา ในเดือนมกราคม-สิงหาคม ปี 1997 */
--แบบ Product

--แบบ Join

SELECT  s.ShipperID, s.CompanyName,
        COUNT(o.OrderID) AS OrderCount
FROM    Shippers s
JOIN    Orders o ON s.ShipperID = o.ShipVia
WHERE   YEAR(o.ShippedDate) = 1997
  AND   MONTH(o.ShippedDate) BETWEEN 1 AND 8
  AND   o.ShipCountry IN ('USA','Italy','UK','Canada')
GROUP BY s.ShipperID, s.CompanyName;
---------------------------------------------------------------------
-- *** 3 ตาราง ****
/*7 : จงแสดงเลขเดือน ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) เฉพาะรายการสั่งซื้อที่ทำรายการขายในปี 1996 
และจัดส่งไปยังประเทศสหราชอาณาจักร,เบลเยี่ยม, โปรตุเกส */
--แบบ Product


--แบบ Join
SELECT  MONTH(o.OrderDate) AS OrderMonth,
        SUM(od.UnitPrice * od.Quantity) AS TotalAmount
FROM    Orders o
JOIN    [Order Details] od ON o.OrderID = od.OrderID
WHERE   YEAR(o.OrderDate) = 1996
  AND   o.ShipCountry IN ('UK','Belgium','Portugal')
GROUP BY MONTH(o.OrderDate)
ORDER BY OrderMonth;
--------------------------------------------------------------------------------

/*8 : จงแสดงข้อมูลรหัสลูกค้า ชื่อบริษัทลูกค้า และยอดรวม(ไม่คิดส่วนลด) เฉพาะใบสั่งซื้อที่ทำรายการสั่งซื้อในเดือน มค. ปี 1997 
จัดเรียงข้อมูลตามยอดสั่งซื้อมากไปหาน้อย*/
--แบบ Product


--แบบ Join
SELECT  c.CustomerID, c.CompanyName, o.OrderID,
        SUM(od.UnitPrice * od.Quantity) AS OrderTotal
FROM    Customers c
JOIN    Orders o       ON c.CustomerID = o.CustomerID
JOIN    [Order Details] od ON o.OrderID = od.OrderID
WHERE   YEAR(o.OrderDate) = 1997
  AND   MONTH(o.OrderDate) = 1
GROUP BY c.CustomerID, c.CompanyName, o.OrderID
ORDER BY OrderTotal DESC;
---------------------------------------------------------------------------------

/*9 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทผู้จัดส่ง ยอดรวมค่าจัดส่ง เฉพาะรายการสั่งซื้อที่ Nancy Davolio เป็นผู้ทำรายการขาย*/
--แบบ Product


--แบบ Join

SELECT  s.ShipperID, s.CompanyName,
        SUM(o.Freight) AS TotalFreight
FROM    Employees e
JOIN    Orders o   ON e.EmployeeID = o.EmployeeID
JOIN    Shippers s ON o.ShipVia    = s.ShipperID
WHERE   (e.FirstName + ' ' + e.LastName) = 'Nancy Davolio'
GROUP BY s.ShipperID, s.CompanyName;
---------------------------------------------------------------------------------
/*10 : จงแสดงข้อมูลรหัสใบสั่งซื้อ วันที่สั่งซื้อ รหัสลูกค้าที่สั่งซื้อ ประเทศที่จัดส่ง จำนวนที่สั่งซื้อทั้งหมด ของสินค้าชื่อ Tofu ในช่วงปี 1997*/
--แบบ Product


--แบบ Join
SELECT  o.OrderID, o.OrderDate, o.CustomerID, o.ShipCountry,
        SUM(od.Quantity) AS TotalQty
FROM    Orders o
JOIN    [Order Details] od ON o.OrderID = od.OrderID
JOIN    Products p         ON od.ProductID = p.ProductID
WHERE   p.ProductName = 'Tofu'
  AND   YEAR(o.OrderDate) = 1997
GROUP BY o.OrderID, o.OrderDate, o.CustomerID, o.ShipCountry;
-----------------------------------------------------------------------------
/*11 : จงแสดงข้อมูลรหัสสินค้า ชื่อสินค้า ยอดขายรวม(ไม่คิดส่วนลด) ของสินค้าแต่ละรายการเฉพาะที่มีการสั่งซื้อในเดือน มค.-สค. ปี 1997*/
--แบบ Product


--แบบ Join
SELECT  p.ProductID, p.ProductName,
        SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM    Products p
JOIN    [Order Details] od ON p.ProductID = od.ProductID
JOIN    Orders o           ON od.OrderID  = o.OrderID
WHERE   YEAR(o.OrderDate) = 1997
  AND   MONTH(o.OrderDate) BETWEEN 1 AND 8
GROUP BY p.ProductID, p.ProductName;
-----------------------------------------------------------------------------
-- *** 4 ตาราง ****
/*12 : จงแสดงข้อมูลรหัสประเภทสินค้า ชื่อประเภทสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) เฉพาะที่มีการจัดส่งไปประเทศสหรัฐอเมริกา ในปี 1997*/
--แบบ Product


--แบบ Join
SELECT  c.CategoryID, c.CategoryName,
        SUM(od.UnitPrice * od.Quantity) AS TotalAmount
FROM    Categories c
JOIN    Products p      ON c.CategoryID = p.CategoryID
JOIN    [Order Details] od ON p.ProductID  = od.ProductID
JOIN    Orders o        ON od.OrderID   = o.OrderID
WHERE   YEAR(o.OrderDate) = 1997
  AND   o.ShipCountry = 'USA'
GROUP BY c.CategoryID, c.CategoryName;
----------------------------------------------------------------------------
/*13 : จงแสดงรหัสพนักงาน ชื่อและนามสกุล(แสดงในคอลัมน์เดียวกัน) ยอดขายรวมของพนักงานแต่ละคน เฉพาะรายการขายที่จัดส่งโดยบริษัท Speedy Express 
ไปยังประเทศสหรัฐอเมริกา และทำการสั่งซื้อในปี 1997 */
--แบบ Product


--แบบ Join
SELECT  e.EmployeeID,
        (e.FirstName + ' ' + e.LastName) AS EmpName,
        SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM    Employees e
JOIN    Orders o        ON e.EmployeeID = o.EmployeeID
JOIN    [Order Details] od ON o.OrderID    = od.OrderID
JOIN    Shippers s      ON o.ShipVia    = s.ShipperID
WHERE   s.CompanyName = 'Speedy Express'
  AND   o.ShipCountry = 'USA'
  AND   YEAR(o.OrderDate) = 1997
GROUP BY e.EmployeeID, e.FirstName, e.LastName;
--------------------------------------------------------------------------
/*14 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดขายรวม เฉพาะสินค้าที่นำมาจัดจำหน่ายจากประเทศญี่ปุ่น และมีการสั่งซื้อในปี 1997 และจัดส่งไปยังประเทศสหรัฐอเมริกา */
--แบบ Product


--แบบ Join
SELECT  p.ProductID, p.ProductName,
        SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM    Products p
JOIN    Suppliers s     ON p.SupplierID = s.SupplierID
JOIN    [Order Details] od ON p.ProductID  = od.ProductID
JOIN    Orders o        ON od.OrderID   = o.OrderID
WHERE   s.Country    = 'Japan'
  AND   o.ShipCountry = 'USA'
  AND   YEAR(o.OrderDate) = 1997
GROUP BY p.ProductID, p.ProductName;
----------------------------------------------------------------------------
-- *** 5 ตาราง ***
/*15 : จงแสดงรหัสลูกค้า ชื่อบริษัทลูกค้า ยอดสั่งซื้อรวมของการสั่งซื้อสินค้าประเภท Beverages ของลูกค้าแต่ละบริษัท  และสั่งซื้อในปี 1997 จัดเรียงตามยอดสั่งซื้อจากมากไปหาน้อย*/
--แบบ Product


--แบบ Join

SELECT  c.CustomerID, c.CompanyName,
        SUM(od.UnitPrice * od.Quantity) AS TotalAmount
FROM    Customers c
JOIN    Orders o        ON c.CustomerID   = o.CustomerID
JOIN    [Order Details] od ON o.OrderID      = od.OrderID
JOIN    Products p      ON od.ProductID   = p.ProductID
JOIN    Categories cat  ON p.CategoryID   = cat.CategoryID
WHERE   cat.CategoryName = 'Beverages'
  AND   YEAR(o.OrderDate) = 1997
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalAmount DESC;
---------------------------------------------------------------------------
/*16 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทที่จัดส่ง จำนวนใบสั่งซื้อที่จัดส่งสินค้าประเภท Seafood ไปยังประเทศสหรัฐอเมริกา ในปี 1997 */
--แบบ Product


--แบบ Join
SELECT  s.ShipperID, s.CompanyName,
        COUNT(DISTINCT o.OrderID) AS OrderCount
FROM    Shippers s
JOIN    Orders o        ON s.ShipperID = o.ShipVia
JOIN    [Order Details] od ON o.OrderID   = od.OrderID
JOIN    Products p      ON od.ProductID = p.ProductID
JOIN    Categories c    ON p.CategoryID = c.CategoryID
WHERE   c.CategoryName = 'Seafood'
  AND   o.ShipCountry  = 'USA'
  AND   YEAR(o.OrderDate) = 1997
GROUP BY s.ShipperID, s.CompanyName;
---------------------------------------------------------------------------
-- *** 6 ตาราง ***
/*17 : จงแสดงรหัสประเภทสินค้า ชื่อประเภท ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ที่ทำรายการขายโดย Margaret Peacock ในปี 1997 
และสั่งซื้อโดยลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา สหราชอาณาจักร แคนาดา */

--แบบ Product


--แบบ Join
SELECT  c.CategoryID, c.CategoryName,
        SUM(od.UnitPrice * od.Quantity) AS TotalAmount
FROM    Employees e
JOIN    Orders o        ON e.EmployeeID = o.EmployeeID
JOIN    [Order Details] od ON o.OrderID    = od.OrderID
JOIN    Products p      ON od.ProductID = p.ProductID
JOIN    Categories c    ON p.CategoryID = c.CategoryID
JOIN    Customers cust  ON o.CustomerID = cust.CustomerID
WHERE   (e.FirstName + ' ' + e.LastName) = 'Margaret Peacock'
  AND   YEAR(o.OrderDate) = 1997
  AND   cust.Country IN ('USA','UK','Canada')
GROUP BY c.CategoryID, c.CategoryName;
---------------------------------------------------------------------------
/*18 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ของสินค้าที่จัดจำหน่ายโดยบริษัทที่อยู่ประเทศสหรัฐอเมริกา ที่มีการสั่งซื้อในปี 1997 
จากลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา และทำการขายโดยพนักงานที่อาศัยอยู่ในประเทศสหรัฐอเมริกา */

--แบบ Product


--แบบ Join
SELECT  p.ProductID, p.ProductName,
        SUM(od.UnitPrice * od.Quantity) AS TotalAmount
FROM    Products p
JOIN    Suppliers s     ON p.SupplierID = s.SupplierID
JOIN    [Order Details] od ON p.ProductID  = od.ProductID
JOIN    Orders o        ON od.OrderID   = o.OrderID
JOIN    Customers c     ON o.CustomerID = c.CustomerID
JOIN    Employees e     ON o.EmployeeID = e.EmployeeID
WHERE   s.Country = 'USA'
  AND   c.Country = 'USA'
  AND   e.Country = 'USA'
  AND   YEAR(o.OrderDate) = 1997

GROUP BY p.ProductID, p.ProductName;

