CREATE SCHEMA shop DEFAULT CHARACTER SET utf8;


CREATE TABLE shop.category 
(
    id INT NOT NULL,
    name VARCHAR(128) NOT NULL,
    discount TINYINT NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE shop.category 
    ADD COLUMN alias_name VARCHAR(128) NULL AFTER discount;

--DROP TABLE shop.category;
--DROP DATABASE shop;



CREATE TABLE shop.type 
(
    id INT NOT NULL,
    name VARCHAR(128) NOT NULL
);

ALTER TABLE shop.type 
    ADD PRIMARY KEY (id);

ALTER TABLE shop.type 
	RENAME TO shop.product_type;



CREATE TABLE shop.brand
(
    id INT NOT NULL,
    name VARCHAR(128) NOT NULL,
    PRIMARY KEY (id)
);


/* ЗАПОЛНЕНИЕ ТАБЛИЦЫ */
INSERT INTO shop.category (id, name, discount) 
VALUES (1, 'Женская одежда', 5), (2, 'Мужская одежда', 0);

INSERT INTO shop.category (id, name, discount, alias_name) VALUES (3, 'Женская обувь', 10, NULL);
INSERT INTO shop.category (id, name, discount, alias_name) VALUES (4, 'Мужская обувь', 15, 'man''s shoes');

ALTER TABLE shop.category 
	CHANGE COLUMN id id INT(11) NOT NULL AUTO_INCREMENT;  --поле id само будет увеличиваться

INSERT INTO shop.category (name, discount) VALUES ('Шляпы', 0);



/*  ВЫБОРКА, СОРТИРОВКА, ФИЛЬТРАЦИЯ     */
SELECT name, discount FROM category ORDER BY discount;