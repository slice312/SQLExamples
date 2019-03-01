CREATE SCHEMA dudes DEFAULT CHARACTER SET utf8;
-- DROP DATABASE dudes;
-- DROP TABLE person;

CREATE TABLE person
(
    person_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    fname VARCHAR(20),
    lname VARCHAR(20),
    gender ENUM('M','F'),
    birth_date DATE,
    address VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20),
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);



CREATE TABLE favorite_food
(
    person_id SMALLINT UNSIGNED,
    food VARCHAR(30),
    CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),  -- compound key
    CONSTRAINT fk_person_id FOREIGN KEY (person_id)
        REFERENCES person (person_id)
);


-- ЕСЛИ ЗАБЫЛ AUTO_INCREMENT:
-- Нужно сделать автоинкремент person_id, но из-за ограничения foreign_key нельзя.
-- Поэтому сначала сбрасываю ограничение, потом modify, и опять возвращаю ограничение.
ALTER TABLE favorite_food DROP FOREIGN KEY fk_person_id,
ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE favorite_food
    ADD CONSTRAINT fk_person_id FOREIGN KEY (person_id)
          REFERENCES person (person_id);



/* ЗАПОЛНЕНИЕ И ИЗМЕНЕНИЕ */
-- INSERT
INSERT INTO person (person_id, fname, lname, gender, birth_date)
VALUES (null, 'William','Turner', 'M', '1972-05-27');

INSERT INTO person (fname, lname, gender)
VALUES ('Mark', 'Miller', 'M'),
       ('BoJack', 'Horseman', 'M'),
       ('Sara', 'Conor', 'F');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'pizza'), (1, 'cookies'), (1, 'nachos');


INSERT INTO person (fname, lname, gender, birth_date,
    address, city, state, country, postal_code)
VALUES ('Susan','Smith', 'F', '1975-11-02', '23 Maple St.', 
     'Arlington', 'VA', 'USA', '20220');


-- UPDATE
UPDATE person SET address = '1225 Tremont St.', city = 'Boston',
    state = 'MA', country = 'USA', postal_code = '02138'
WHERE person_id = 1;

UPDATE person SET birth_date = '2014-02-03' 
WHERE fname = 'BoJack';

-- DELETE
DELETE FROM person WHERE person_id = 2;



-- чуть посложнее:
INSERT INTO favorite_food (person_id, food)
VALUES ((SELECT person_id FROM person WHERE fname = 'BoJack'), 'taco');


--не работает если подзапрос возвращает больше 1 строки
INSERT INTO favorite_food (person_id, food)
VALUES ((SELECT person_id FROM person WHERE gender = 'F'), 'rolls');




--------------------------------------------
SELECT LENGTH(fname) name_len, fname FROM person;
