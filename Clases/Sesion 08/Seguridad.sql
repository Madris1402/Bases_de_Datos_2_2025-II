-- Seguridad

select * from mysql.user;

show privileges;

-- -- Crear Usuarios en diferentes ubicaciones
create user 'ustest'@'localhost' identified by 'local123';
create user 'ustest'@'%' identified by 'remoto123';
create user 'ustest'@'123.7.90.122' identified by 'direccion123';
create user 'ustest'@'123.7.90.*' identified by 'redes123';

show databases;
use credito2807;
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

revoke all privileges on bdconcurrencia.* from 'ustest'@'localhost';
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
show grants for 'ustest'@'localhost';
flush privileges;
