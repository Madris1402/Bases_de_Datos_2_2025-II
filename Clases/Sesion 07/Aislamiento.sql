-- Aislamiento
show variables like '%isolation%'; -- READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE

-- Busacr Variables a nivel Global o nivel Sesion
select @@GLOBAL.transaction_isolation;

select @@SESSION.transaction_isolation;


-- Crear Base bdconcurrencia
DROP DATABASE IF EXISTS bdconcurrencia;
CREATE DATABASE bdconcurrencia CHARACTER SET utf8mb4;
USE bdconcurrencia;
CREATE TABLE cuentas ( id INTEGER UNSIGNED PRIMARY KEY, saldo DECIMAL(11,2) CHECK (saldo >= 0) );
INSERT INTO cuentas VALUES (1, 1000);
INSERT INTO cuentas VALUES (2, 2000);
INSERT INTO cuentas VALUES (3, 0);

use bdconcurrencia;
select * from cuentas;

update cuentas set saldo = 100 where id = 3;

-- -- Inciciar Transacciones Manuales
start transaction;
update cuentas set saldo = saldo + 100 where id >= 1;
select * from cuentas;
commit;

start transaction;
update cuentas set saldo = saldo + 100 where id >= 1;
select * from cuentas;
rollback;

-- Comando para Ajustar el Aislamiento de la Sesion
-- -- SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- -- -- Permite leer desde el buffer los datos de las transacciones en proceso
start transaction;
update cuentas set saldo = saldo + 100 where id >= 1;
select * from cuentas;
rollback;

start transaction;
update cuentas set saldo = 500 where id >= 3;
select * from cuentas;
rollback;

start transaction;
select * from cuentas;
savepoint punto_1; -- 900, 1900, 200 -- guarda un estado dentro de la transaccion

delete from cuentas where id = 1;
select * from cuentas;
savepoint punto_2; -- 1900, 200

update cuentas set saldo = saldo + 100 where id >= 1;
select * from cuentas;
savepoint punto_3; -- 2000, 300


-- Hacer Rollback a puntos anteriores
select * from cuentas;

rollback to punto_2;

select * from cuentas;

rollback to punto_1;

select * from cuentas;

rollback to punto_2; -- Solo se puede regresar de un punto en un punto y de forma escalonada

rollback;

select * from cuentas;


-- Formas de Crear respaldos
create table cuentas_temp as select * from cuentas; -- Usando tablas temporales
show tables;

desc cuentas;
desc cuentas_temp;  -- No mantiene el esquema de la tabla

create table cuentas_dos like cuentas;
insert into cuentas_dos select * from cuentas; -- Crear una copia con todo y esquema de la tabla

desc cuentas;
desc cuentas_temp;
desc cuentas_dos;

