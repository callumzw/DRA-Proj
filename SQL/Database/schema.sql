-- Retailers table
CREATE TABLE retailers (
    retailer_id INTEGER PRIMARY KEY,
    retailer_name VARCHAR(100) NOT NULL,
    retailer_type VARCHAR(50) CHECK (retailer_type IN ('grocery', 'convenience')),
    region VARCHAR(100)
);

-- Customers table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    signup_date DATE NOT NULL
);

-- Orders table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_datetime TIMESTAMP NOT NULL,
    retailer_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_value DECIMAL(10,2) CHECK (order_value >= 0),
    order_status VARCHAR(20) CHECK (order_status IN ('completed', 'cancelled')),
    delivery_time_minutes INTEGER,
    CONSTRAINT fk_retailer
        FOREIGN KEY (retailer_id) REFERENCES retailers(retailer_id),
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_delivery_time
        CHECK (
            delivery_time_minutes IS NULL
            OR delivery_time_minutes >= 0
        )
);

-- Performance indexes
CREATE INDEX idx_orders_datetime ON orders(order_datetime);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_retailer ON orders(retailer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_customers_signup ON customers(signup_date);