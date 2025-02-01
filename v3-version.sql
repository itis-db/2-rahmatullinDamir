-- v.2
ALTER TABLE profile ADD COLUMN dtime TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE profile ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE address ALTER COLUMN housenumber TYPE NUMERIC(10, 1) USING housenumber::NUMERIC(10, 1);
ALTER TABLE profile ALTER COLUMN name TYPE INTEGER USING
    CASE
        WHEN name = 'Alice' THEN 1
        WHEN name = 'Bob' THEN 2
        WHEN name = 'Charlie' THEN 3
        WHEN name = 'David' THEN 4
        WHEN name = 'Emma' THEN 5
        WHEN name = 'Frank' THEN 6
        WHEN name = 'Grace' THEN 7
        WHEN name = 'Hannah' THEN 8
        WHEN name = 'Ivan' THEN 9
        WHEN name = 'Julia' THEN 10
END;

-- rollback
ALTER TABLE profile DROP COLUMN dtime;
ALTER TABLE profile DROP CONSTRAINT unique_email;
ALTER TABLE address ALTER COLUMN housenumber TYPE INTEGER USING housenumber::INTEGER;
ALTER TABLE profile ALTER COLUMN name TYPE VARCHAR(20) USING
    CASE
        WHEN name = 1 THEN 'Alice'
        WHEN name = 2 THEN 'Bob'
        WHEN name = 3 THEN 'Charlie'
        WHEN name = 4 THEN 'David'
        WHEN name = 5 THEN 'Emma'
        WHEN name = 6 THEN 'Frank'
        WHEN name = 7 THEN 'Grace'
        WHEN name = 8 THEN 'Hannah'
        WHEN name = 9 THEN 'Ivan'
        WHEN name = 10 THEN 'Julia'
END;
