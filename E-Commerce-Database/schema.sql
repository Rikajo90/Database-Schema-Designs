-- =============================================
-- E-Commerce Database Schema Design
-- Author: Rika Afriyani
-- Date: December 2024
-- DBMS: SQL Server / PostgreSQL
-- =============================================

-- Users & Authentication
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME,
    is_active BIT DEFAULT 1
);

-- User Addresses
CREATE TABLE Addresses (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    address_type VARCHAR(20), -- shipping, billing
    street_address VARCHAR(500),
    city VARCHAR(100),
    province VARCHAR(100),
    postal_code VARCHAR(10),
    is_default BIT DEFAULT 0
);

-- Product Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(255) NOT NULL,
    parent_category_id INT,
    description TEXT,
    created_at DATETIME DEFAULT GETDATE()
);

-- Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    category_id INT FOREIGN KEY REFERENCES Categories(category_id),
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    sku VARCHAR(100) UNIQUE,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Product Images
CREATE TABLE Product_Images (
    image_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT FOREIGN KEY REFERENCES Products(product_id) ON DELETE CASCADE,
    image_url VARCHAR(500),
    is_primary BIT DEFAULT 0,
    display_order INT
);

-- Shopping Cart
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Cart_Items (
    cart_item_id INT PRIMARY KEY IDENTITY(1,1),
    cart_id INT FOREIGN KEY REFERENCES Cart(cart_id) ON DELETE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    quantity INT NOT NULL,
    added_at DATETIME DEFAULT GETDATE()
);

-- Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    order_status VARCHAR(20) DEFAULT 'pending', -- pending, processing, shipped, delivered, cancelled
    total_amount DECIMAL(10,2),
    shipping_address_id INT FOREIGN KEY REFERENCES Addresses(address_id),
    payment_method VARCHAR(50),
    payment_status VARCHAR(20) DEFAULT 'unpaid',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT FOREIGN KEY REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(10,2)
);

-- Reviews & Ratings
CREATE TABLE Product_Reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT FOREIGN KEY REFERENCES Products(product_id) ON DELETE CASCADE,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at DATETIME DEFAULT GETDATE()
);

-- Indexes for Performance
CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_products_price ON Products(price);
CREATE INDEX idx_orders_user ON Orders(user_id);
CREATE INDEX idx_orders_status ON Orders(order_status);
CREATE INDEX idx_order_items_order ON Order_Items(order_id);
CREATE INDEX idx_reviews_product ON Product_Reviews(product_id);
