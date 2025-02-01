create table if not exists address
(
    id serial
    primary key,
    country varchar(20),
    city varchar(20),
    street varchar(30),
    housenumber integer,
    apartmentnumber integer
    );

create table if not exists profile
(
    id serial
    primary key,
    name varchar(20),
    email varchar(50)
    unique,
    dateofregistration timestamp default CURRENT_TIMESTAMP,
    deliveryaddressid integer
    references address
    );

create table if not exists product
(
    id serial
    primary key,
    name varchar(50),
    description text,
    price integer,
    amount integer
    );

create table if not exists statusorder
(
    id serial
    primary key,
    name varchar(15),
    description text
    );

create table if not exists userorder
(
    id serial
    primary key,
    deliveryaddressid integer
    references address,
    statusid integer
    references statusorder,
    userprofileid integer
    references profile
);

create table if not exists productorder
(
    id serial
    primary key,
    orderid integer
    references userorder,
    productid integer
    references product,
    UNIQUE(orderid, productid)
);