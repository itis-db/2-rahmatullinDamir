INSERT INTO address (country, city, street, housenumber, apartmentnumber)
SELECT
    (ARRAY['USA', 'Canada', 'Germany', 'France', 'Japan'])[FLOOR(random() * 5 + 1)],
    (ARRAY['New York', 'Toronto', 'Berlin', 'Paris', 'Tokyo'])[FLOOR(random() * 5 + 1)],
    'Street ' || (ARRAY['Main', 'High', 'Broadway', 'Maple', 'Oak'])[FLOOR(random() * 5 + 1)],
    FLOOR(random() * 200 + 1),
    FLOOR(random() * 50 + 1)
FROM generate_series(1, 100);

INSERT INTO profile (name, email, dateofregistration, deliveryaddressid)
SELECT
    (ARRAY['Alice', 'Bob', 'Charlie', 'David', 'Emma', 'Frank', 'Grace', 'Hannah', 'Ivan', 'Julia'])[FLOOR(random() * 10 + 1)],
    'user' || FLOOR(random() * 10000) || FLOOR(random()*100) ||'@example.com' ,
    NOW() - INTERVAL '1 day' * FLOOR(random() * 365),
    FLOOR(random() * 100 + 1)
FROM generate_series(1, 100);

INSERT INTO product (name, description, price, amount)
SELECT
    (ARRAY['Phone', 'Laptop', 'Table', 'Chair', 'Headphones', 'Keyboard', 'Mouse'])[FLOOR(random() * 7 + 1)],
    'This is a high-quality ' || (ARRAY['Phone', 'Laptop', 'Table', 'Chair', 'Headphones'])[FLOOR(random() * 5 + 1)] || ' model ' || FLOOR(random() * 100 + 1),
    FLOOR(random() * 1950 + 50),
    FLOOR(random() * 100 + 1)
FROM generate_series(1, 100);

INSERT INTO statusorder (name, description)
VALUES
    ('Pending', 'Order is pending confirmation'),
    ('Processing', 'Order is being prepared for shipment'),
    ('Shipped', 'Order has been shipped to the customer'),
    ('Delivered', 'Order has been delivered successfully'),
    ('Cancelled', 'Order was cancelled by the user');

INSERT INTO userorder (deliveryaddressid, statusid, userprofileid)
SELECT
    FLOOR(random() * 100 + 1),
    FLOOR(random() * 5 + 1),
    FLOOR(random() * 100 + 1)
FROM generate_series(1, 100);

INSERT INTO productorder (orderid, productid)
SELECT orderid, productid
FROM (
         SELECT
             FLOOR(random() * 100 + 1) AS orderid,
             FLOOR(random() * 100 + 1) AS productid
         FROM generate_series(1, 200)
     ) subquery
GROUP BY orderid, productid
LIMIT 100;