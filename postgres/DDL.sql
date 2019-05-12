CREATE DATABASE test OWNER 'slice' ENCODING = 'UTF8'
  LC_COLLATE = 'en_US.UTF8'  LC_CTYPE = 'en_US.UTF8' template template0;

CREATE SCHEMA bookings; 
#DROP SCHEMA bookings CASCADE:
SET search_path TO bookings;    -- сменить текущю схему;



CREATE TABLE bookings.aircrafts_data
(
  aircraft_code char(3) NOT NULL,
  model text NOT NULL,
  range int NOT NULL,
  CONSTRAINT pk_aircrafts_data PRIMARY KEY (aircraft_code),
  CONSTRAINT chk_aircrafts_data__range CHECK (range > 0)
);

ALTER TABLE table_name
  RENAME COLUMN old_name TO new_name;



CREATE TABLE bookings.seats
(
  aircraft_code char(3) NOT NULL,
  seat_no varchar(4) NOT NULL,
  fare_conditions varchar(10) NOT NULL,
  CONSTRAINT pk_seats PRIMARY KEY (aircraft_code, seat_no),
  CONSTRAINT fk_seats__aircrafts_data FOREIGN KEY (aircraft_code)
    REFERENCES aircrafts_data (aircraft_code)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_seats__fare_conditions CHECK 
    (fare_conditions IN ('Economy', 'Comfort', 'Business'))
);



#тип serial - это как автоинкремент
CREATE table nana
(
  id serial
);

#или если самому прописать все
CREATE SEQUENCE pooh_id_seq;
CREATE TABLE pooh
(
  id int NOT NULL
    DEFAULT nextval('pooh_id_seq')
);

ALTER SEQUENCE pooh_id_seq
  OWNED BY pooh.id;






INSERT INTO aircrafts_data (aircrafts_code, model, range)
VALUES 
  ('SU9', 'Sukhoi SuperJet-100', 3000),
  ('773', 'Boeing 777-300', 11100),
  ('763', 'Boeing 767-300', 7900),
  ('733', 'Boeing 737-300', 4200),
  ('320', 'Airbus A320-200', 5700),
  ('321', 'Airbus A321-200', 5600),
  ('319', 'Airbus A319-100', 6700),
  ('CN1', 'Cessna 208 Caravan', 1200),
  ('CR2', 'Bombardier CRJ-200', 2700);


UPDATE aircrafts_data 
SET range = range * 2
WHERE aircraft_code = 'SU9';


DELETE FROM aircrafts_data
WHERE aircraft_code = 'CN1';



INSERT INTO seats (aircraft_code, seat_no, fare_conditions)
VALUES
  ('SU9', '1A', 'Business'),
  ('SU9', '1B', 'Business'),
  ('SU9', '10A', 'Economy'),
  ('SU9', '10B', 'Economy'),
  ('SU9', '10F', 'Economy'),
  ('SU9', '20F', 'Economy');