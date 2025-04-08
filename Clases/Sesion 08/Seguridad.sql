-- Seguridad

select * from mysql.user;

show privileges;

-- -- Crear Usuarios en diferentes ubicaciones
create user 'ustest'@'localhost' identified by 'local123';
create user 'ustest'@'%' identified by 'remoto123';
create user 'ustest'@'123.7.90.122' identified by 'direccion123';
create user 'ustest'@'123.7.90.*' identified by 'redes123';

show databases;
use credito;
use patito23;

show processlist;
kill 11;

drop user 'ustest'@'localhost';
drop user 'ustest'@'%';
drop user 'ustest'@'123.7.90.122';
drop user 'ustest'@'123.7.90.*';

-- -- Administrar Privilegios
create user 'ustest'@'localhost' identified by 'local123';
grant all privileges on credito.* to 'ustest'@'localhost';
flush privileges;

grant all privileges on bdconcurrencia.* to 'ustest'@'localhost';
flush privileges;

revoke all privileges on bdconcurrencia.* from 'ustest'@'localhost'; -- Error Falso
flush privileges;

show grants for 'ustest'@'localhost';

-- -- Generar usuarios con contraseñas temporales
create user 'ustest'@'localhost' identified by 'local123' 
password expire interval 4 day 
account lock;

select * from mysql.user;

-- -- Desbloquear la cuenta
alter user 'ustest'@'localhost' account unlock;

drop user 'ustest'@'localhost';

-- -- Generar usuario con bloqueo de intentos
create user 'ustest'@'localhost' identified by 'local123' 
failed_login_attempts 3 password_lock_time 10;

alter user 'ustest'@'localhost' account unlock;

select version();

select * from mysql.user where user = 'ustest';

drop user 'ustest'@'localhost';

-- -- Generar usuario con verificación específica
create user 'ustest'@'localhost' 
identified with mysql_native_password 
by 'local123';

select * from mysql.user where user = 'ustest';

alter user 'ustest'@'localhost' 
identified with caching_sha2_password 
by 'local123';

select * from mysql.user where user = 'ustest';

drop user 'ustest'@'localhost';

-- Manejo de Recursos

-- -- Crear usuario con limites
create user 'ustest'@'localhost' 
identified by 'local123'
with
max_user_connections 2
max_connections_per_hour 5
max_queries_per_hour 10
max_updates_per_hour 3;


alter user 'ustest'@'localhost' 
with
max_user_connections 2
max_connections_per_hour 8
max_queries_per_hour 10
max_updates_per_hour 3;

alter user 'ustest'@'localhost' 
with
max_queries_per_hour 100;

select * from mysql.user where user = 'ustest';


-- -- Crear un Evento
use credito;
create event limitar_consultas_ustest
on schedule every 1 day starts '2025-03-28 12:51:00'
do
	alter user 'ustest'@'localhost'
        with
        max_queries_per_hour 5;
        
select * from information_schema.events;

-- Privilegios a Usuarios
drop user 'ustest'@'localhost';
create user 'ustest'@'localhost' identified by 'local123';

show grants for 'ustest'@'localhost';
USE credito2807;

show privileges;

grant all privileges on credito.* to 'ustest'@'localhost';
flush privileges;
show grants for 'ustest'@'localhost';

revoke all privileges on credito.* from  'ustest'@'localhost'; -- Error Falso

-- -- Asignar privilegios especificos a un usuario
grant select on credito.* to 'ustest'@'localhost';
flush privileges;
show grants for 'ustest'@'localhost';

grant insert, update, delete on credito.* to 'ustest'@'localhost';
flush privileges;
show grants for 'ustest'@'localhost';

-- -- Revocar privilegios rspecificos
revoke insert on credito.* from  'ustest'@'localhost';
flush privileges;
show grants for 'ustest'@'localhost';

-- -- Dar privilegios especificos sobre una sola tabla
grant insert on credito.depto to 'ustest'@'localhost';
flush privileges;
show grants for 'ustest'@'localhost';

revoke select on credito.* from 'ustest'@'localhost';
flush privileges;
show grants for 'ustest'@'localhost';


-- -- Privilegios sobre vistas

create or replace view empleadas as
select empno, epaterno, ematerno, enombre, fingreso
from empleado
where sexo = 'F';

select * from empleadas;

grant select on credito.empleadas to 'ustest'@'localhost';
flush privileges;

select deptono, count(*) from empleado group by deptono;
select * from depto;


create or replace view empleados_ventas as
select * from empleado where deptono = 3;

select * from empleados_ventas;

grant select on credito.empleados_ventas to 'ustest'@'localhost';
flush privileges;

-- Privilegios por Roles
drop user 'ustest'@'localhost';
select * from mysql.user;

create user 'ustest'@'localhost' identified by 'local123';
show grants for 'ustest'@'localhost';

create role 'developerapp', 'readapp', 'writeapp';
flush privileges;

show grants for 'developerapp';
grant all privileges on *.* to 'developerapp';
show privileges;

grant select on credito.* to 'readapp';

grant insert, update, delete on credito.* to 'writeapp';

show grants for 'ustest'@'loacalhost';

show variables like '%roles%';

grant 'developerapp' to 'ustest'@'localhost';
grant 'writeapp' to 'ustest'@'localhost';
grant 'readapp' to 'ustest'@'localhost';


show grants for 'ustest'@'localhost';
show grants for 'ustest'@'localhost' using 'developerapp';

revoke 'developerapp' from 'ustest'@'localhost';
revoke 'writeapp' from 'ustest'@'localhost';
revoke 'readapp' from 'ustest'@'localhost';

-- -- Script para sacar todas las tablas de una base
use credito;
select * from information_schema.tables where TABLE_SCHEMA = database();

create role 'selector';

select concat('GRANT SELECT ON ', database(), '.', TABLE_NAME, ' TO \'selector\';')
from information_schema.TABLES
where TABLE_SCHEMA = database()
and TABLE_NAME not like '%empleado%';

grant 'selector' to 'ustest'@'localhost';