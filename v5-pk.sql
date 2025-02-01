CREATE TABLE temp_userorder AS SELECT * FROM userorder;
CREATE TABLE temp_productorder AS SELECT * FROM productorder;
CREATE TABLE temp_profile AS SELECT * FROM profile;

ALTER TABLE profile DROP CONSTRAINT IF EXISTS profile_deliveryaddressid_fkey;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_deliveryaddressid_fkey;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_statusid_fkey;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_userprofileid_fkey;
ALTER TABLE productorder DROP CONSTRAINT IF EXISTS productorder_orderid_fkey;
ALTER TABLE productorder DROP CONSTRAINT IF EXISTS productorder_productid_fkey;


ALTER TABLE address DROP CONSTRAINT IF EXISTS address_pkey;
ALTER TABLE profile DROP CONSTRAINT IF EXISTS profile_pkey;
ALTER TABLE product DROP CONSTRAINT IF EXISTS product_pkey;
ALTER TABLE statusorder DROP CONSTRAINT IF EXISTS statusorder_pkey;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_pkey;
ALTER TABLE productorder DROP CONSTRAINT IF EXISTS productorder_pkey;


ALTER TABLE product ADD PRIMARY KEY (name, description, price, amount);
ALTER TABLE statusorder ADD PRIMARY KEY (name);
ALTER TABLE address ADD PRIMARY KEY (country, city, street, housenumber, apartmentnumber);

ALTER TABLE profile ADD COLUMN country VARCHAR(20);
ALTER TABLE profile ADD COLUMN city VARCHAR(20);
ALTER TABLE profile ADD COLUMN street VARCHAR(30);
ALTER TABLE profile ADD COLUMN housenumber INTEGER;
ALTER TABLE profile ADD COLUMN apartmentnumber INTEGER;


UPDATE profile p
SET
    country = a.country,
    city = a.city,
    street = a.street,
    housenumber = a.housenumber,
    apartmentnumber = a.apartmentnumber
FROM temp_profile tp
         JOIN address a ON tp.deliveryaddressid = a.id
WHERE p.email = tp.email;

ALTER TABLE profile DROP COLUMN deliveryaddressid;
ALTER TABLE profile ADD PRIMARY KEY (email);


ALTER TABLE userorder ADD COLUMN country VARCHAR(20);
ALTER TABLE userorder ADD COLUMN city VARCHAR(20);
ALTER TABLE userorder ADD COLUMN street VARCHAR(30);
ALTER TABLE userorder ADD COLUMN housenumber INTEGER;
ALTER TABLE userorder ADD COLUMN apartmentnumber INTEGER;
ALTER TABLE userorder ADD COLUMN statusname VARCHAR(15);
ALTER TABLE userorder ADD COLUMN email VARCHAR(50);

UPDATE userorder u
SET
    country = a.country,
    city = a.city,
    street = a.street,
    housenumber = a.housenumber,
    apartmentnumber = a.apartmentnumber,
    statusname = s.name,
    email = p.email
FROM temp_userorder tu
         JOIN address a ON tu.deliveryaddressid = a.id
         JOIN statusorder s ON tu.statusid = s.id
         JOIN profile p ON tu.userprofileid = p.id
WHERE u.id = tu.id;

ALTER TABLE userorder DROP COLUMN deliveryaddressid, DROP COLUMN statusid, DROP COLUMN userprofileid;
ALTER TABLE userorder ADD PRIMARY KEY (country, city, street, housenumber, apartmentnumber, statusname, email);


ALTER TABLE productorder ADD COLUMN country VARCHAR(20);
ALTER TABLE productorder ADD COLUMN city VARCHAR(20);
ALTER TABLE productorder ADD COLUMN street VARCHAR(30);
ALTER TABLE productorder ADD COLUMN housenumber INTEGER;
ALTER TABLE productorder ADD COLUMN apartmentnumber INTEGER;
ALTER TABLE productorder ADD COLUMN statusname VARCHAR(15);
ALTER TABLE productorder ADD COLUMN email VARCHAR(50);
ALTER TABLE productorder ADD COLUMN productname VARCHAR(50);
ALTER TABLE productorder ADD COLUMN productdescription TEXT;
ALTER TABLE productorder ADD COLUMN productprice INTEGER;
ALTER TABLE productorder ADD COLUMN productamount INTEGER;

UPDATE productorder po
SET
    country = u.country,
    city = u.city,
    street = u.street,
    housenumber = u.housenumber,
    apartmentnumber = u.apartmentnumber,
    statusname = u.statusname,
    email = u.email,
    productname = p.name,
    productdescription = p.description,
    productprice = p.price,
    productamount = p.amount
FROM temp_productorder tpo
         JOIN userorder u ON tpo.orderid = u.id
         JOIN product p ON tpo.productid = p.id
WHERE po.id = tpo.id;

ALTER TABLE productorder DROP COLUMN orderid, DROP COLUMN productid;
ALTER TABLE productorder ADD PRIMARY KEY (country, city, street, housenumber, apartmentnumber, statusname, email, productname, productdescription, productprice, productamount);

ALTER TABLE profile ADD FOREIGN KEY (country, city, street, housenumber, apartmentnumber) REFERENCES address(country, city, street, housenumber, apartmentnumber);
ALTER TABLE userorder ADD FOREIGN KEY (statusname) REFERENCES statusorder(name);
ALTER TABLE userorder ADD FOREIGN KEY (email) REFERENCES profile(email);
ALTER TABLE productorder ADD FOREIGN KEY (country, city, street, housenumber, apartmentnumber, statusname, email) REFERENCES userorder(country, city, street, housenumber, apartmentnumber, statusname, email);
ALTER TABLE productorder ADD FOREIGN KEY (productname, productdescription, productprice, productamount) REFERENCES product(name, description, price, amount);

DROP TABLE temp_userorder;
DROP TABLE temp_productorder;
DROP TABLE temp_profile;

ALTER TABLE address DROP COLUMN IF EXISTS id;
ALTER TABLE profile DROP COLUMN IF EXISTS id;
ALTER TABLE product DROP COLUMN IF EXISTS id;
ALTER TABLE statusorder DROP COLUMN IF EXISTS id;
ALTER TABLE userorder DROP COLUMN IF EXISTS id;
ALTER TABLE productorder DROP COLUMN IF EXISTS id;



-- rollback
ALTER TABLE address DROP CONSTRAINT IF EXISTS address_pkey CASCADE ;
ALTER TABLE profile DROP CONSTRAINT IF EXISTS profile_pkey CASCADE;
ALTER TABLE product DROP CONSTRAINT IF EXISTS product_pkey CASCADE;
ALTER TABLE statusorder DROP CONSTRAINT IF EXISTS statusorder_pkey CASCADE;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_pkey CASCADE;
ALTER TABLE productorder DROP CONSTRAINT IF EXISTS productorder_pkey CASCADE;

ALTER TABLE address ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE profile ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE product ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE statusorder ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE userorder ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE productorder ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE profile DROP CONSTRAINT IF EXISTS profile_deliveryaddressid_fkey;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_deliveryaddressid_fkey;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_statusid_fkey;
ALTER TABLE userorder DROP CONSTRAINT IF EXISTS userorder_userprofileid_fkey;
ALTER TABLE productorder DROP CONSTRAINT IF EXISTS productorder_orderid_fkey;
ALTER TABLE productorder DROP CONSTRAINT IF EXISTS productorder_productid_fkey;

ALTER TABLE profile ADD COLUMN deliveryaddressid INTEGER;
ALTER TABLE userorder ADD COLUMN deliveryaddressid INTEGER;
ALTER TABLE userorder ADD COLUMN statusid INTEGER;
ALTER TABLE userorder ADD COLUMN userprofileid INTEGER;
ALTER TABLE productorder ADD COLUMN orderid INTEGER;
ALTER TABLE productorder ADD COLUMN productid INTEGER;

UPDATE profile p
SET deliveryaddressid = a.id
FROM address a
WHERE p.country = a.country
  AND p.city = a.city
  AND p.street = a.street
  AND p.housenumber = a.housenumber
  AND p.apartmentnumber = a.apartmentnumber;

UPDATE userorder u
SET deliveryaddressid = a.id,
    statusid = s.id,
    userprofileid = p.id
FROM address a, statusorder s, profile p
WHERE u.country = a.country
  AND u.city = a.city
  AND u.street = a.street
  AND u.housenumber = a.housenumber
  AND u.apartmentnumber = a.apartmentnumber
  AND u.statusname = s.name
  AND u.email = p.email;

UPDATE productorder po
SET orderid = u.id,
    productid = p.id
FROM userorder u, product p
WHERE po.country = u.country
  AND po.city = u.city
  AND po.street = u.street
  AND po.housenumber = u.housenumber
  AND po.apartmentnumber = u.apartmentnumber
  AND po.statusname = u.statusname
  AND po.email = u.email
  AND po.productname = p.name
  AND po.productdescription = p.description
  AND po.productprice = p.price
  AND po.productamount = p.amount;


ALTER TABLE profile ADD CONSTRAINT profile_deliveryaddressid_fkey FOREIGN KEY (deliveryaddressid) REFERENCES address(id);
ALTER TABLE userorder ADD CONSTRAINT userorder_deliveryaddressid_fkey FOREIGN KEY (deliveryaddressid) REFERENCES address(id);
ALTER TABLE userorder ADD CONSTRAINT userorder_statusid_fkey FOREIGN KEY (statusid) REFERENCES statusorder(id);
ALTER TABLE userorder ADD CONSTRAINT userorder_userprofileid_fkey FOREIGN KEY (userprofileid) REFERENCES profile(id);
ALTER TABLE productorder ADD CONSTRAINT productorder_orderid_fkey FOREIGN KEY (orderid) REFERENCES userorder(id);
ALTER TABLE productorder ADD CONSTRAINT productorder_productid_fkey FOREIGN KEY (productid) REFERENCES product(id);

ALTER TABLE productorder DROP COLUMN country;
ALTER TABLE productorder  DROP COLUMN city;
ALTER TABLE productorder  DROP COLUMN street;
ALTER TABLE productorder  DROP COLUMN housenumber;
ALTER TABLE productorder  DROP COLUMN apartmentnumber;
ALTER TABLE productorder  DROP COLUMN statusname;
ALTER TABLE productorder  DROP COLUMN email;
ALTER TABLE productorder  DROP COLUMN productname;
ALTER TABLE productorder  DROP COLUMN productdescription;
ALTER TABLE productorder  DROP COLUMN productprice;
ALTER TABLE productorder  DROP COLUMN productamount;

ALTER TABLE userorder  DROP COLUMN country;
ALTER TABLE userorder  DROP COLUMN city;
ALTER TABLE userorder  DROP COLUMN street;
ALTER TABLE userorder  DROP COLUMN housenumber;
ALTER TABLE userorder  DROP COLUMN apartmentnumber;
ALTER TABLE userorder  DROP COLUMN statusname;
ALTER TABLE userorder  DROP COLUMN email;

ALTER TABLE profile  DROP COLUMN country;
ALTER TABLE profile  DROP COLUMN city;
ALTER TABLE profile  DROP COLUMN street;
ALTER TABLE profile  DROP COLUMN housenumber;
ALTER TABLE profile  DROP COLUMN apartmentnumber;

