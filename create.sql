CREATE SCHEMA check_book DEFAULT CHARACTER SET utf8;

CREATE TABLE person
(
    person_id SMALLINT UNSIGNED,
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
    food VARCHAR(20),
    CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_person_id FOREIGN KEY (person_id)
        REFERENCES person (person_id)
);


-- Нужно сделать автоинкремент id, но из-за ограничения foreign key нельзя.
-- Поэтому сначала сбрасываю ограничение, потом modify, и опять возвращаю ограничение
ALTER TABLE favorite_food
    DROP FOREIGN KEY fk_person_id,
    MODIFY person_id SMALLINT UNSIGNED;

ALTER TABLE person MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;

ALTER TABLE favorite_food
    ADD CONSTRAINT fk_person_id FOREIGN KEY (person_id)
          REFERENCES person (person_id);



          /* ЗАПОЛНЕНИЕ И ИЗМЕНЕНИЕ */
-- INSERT
INSERT INTO person (person_id, fname, lname, gender, birth_date)
VALUES (null, 'William','Turner', 'M', '1972-05-27');

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

-- DELETE
DELETE FROM person WHERE person_id = 2;