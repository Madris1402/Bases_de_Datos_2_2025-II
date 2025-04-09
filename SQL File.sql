-- Respaldos (10 - 86)
-- Logs (102 - 131)
-- Transacciones (133 - 157)
-- Concurrencia y Bloqueos (159 - 217)
-- Privilegios (219 - 306)
-- Accesos (308 - 337)
-- Roles (339 - 383)


-- Respaldos

-- -- Crear un Archivo de Configuración
``` shell
[client]
host = localhost
user = root
password = 123456
```

-- -- Aplicar el archivo de configuración
```bash
mysql --defaults-file="[ruta del archivo de configuracion]"
```

-- -- Generar un Respaldo
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
[base a respaldar] > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)_[base a respldar].sql"
```

-- -- Especificar el Char-Set
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4 [base a respaldar] > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)[base a respaldar]_charset.sql"
```

-- -- Crear Directamente la Base a partir del Respaldo
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4
--add-drop-database --databases [nombre para la base a recuperar] > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)[base a respaldar].sql"
```

-- -- Escoger Tablas Específicas para el respaldo
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4 
--add-drop-database [base a respaldar] [tabla] [tabla] > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)[base a respaldar]_tablas.sql"
```

-- -- Montar la base sin datos
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4 
--add-drop-database --no-data [nombre para la base a recuperar] > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)[base a respaldar]_esquema.sql"
```

-- -- Montar la base sin estructura
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4 
--add-drop-database --databases 
--no-create-info [nombre para la base a recuperar] > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)[base a respaldar]_datos.sql"
```

-- -- Crear respaldos de Múltiples Bases de Datos**
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4 
--add-drop-database 
--databases [base a respaldar] [base a respaldar] > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)_[base a respaldar]_[base a respaldar].sql"
```

-- -- Crear Respaldo filtrando los datos
``` bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4 --no-create-info [base a respaldar] [tabla] 
--where="fecha >= CURRENT_DATE()" > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)_[base a respaldar]_[tabla]_where.sql"
```

-- -- Tomar un Intervalo de Meses
```bash
mysqldump --defaults-file="[ruta del archivo de configuracion]" 
--default-character-set=utf8mb4 --no-create-info [base a respaldar] [tabla] 
--where="fecha >= DATE_SUB(NOW(), INTERVAL 1 MONTH)" > "[ruta del archivo]\$(get-date -f yyyyMMddHHmmss)_[base a respaldar]_[tabla]_month.sql"
```

-- -- Formas de Crear respaldos
create table cuentas_temp as select * from cuentas; -- Usando tablas temporales
show tables;

desc cuentas;
desc cuentas_temp;  -- No mantiene el esquema de la tabla

create table cuentas_dos like cuentas;
insert into cuentas_dos select * from cuentas; -- Crear una copia con todo y esquema de la tabla

desc cuentas;
desc cuentas_temp;
desc cuentas_dos;

-- Logs

-- -- Ver registros Binarios
show variables like '%log_bin%'; -- Mostrar Registros Binarios

```bash
type .\MADRIS-THINKPAD-bin.index | Select-Object -First 100 
```

```bash
type .\MADRIS-THINKPAD-bin.000003 | Select-Object -First 100
```

```bash
mysqlbinlog .\MADRIS-THINKPAD-bin.000065
```
-- -- Registro General
show variables like '%log_file%';
show variables like '%general_log%';

set global general_log = 1;
set global general_log_file = '.log';

set global general_log = 0;

-- -- Registros Slow
show variables like '%slow%';

set global slow_query_log = 1;
set global slow_query_log_file = 'Log_slow_2025_12_41.log';

-- Transacciones
use credito; 
select * from depto;

-- -- Iniciar Transacciones
start transaction;
insert into depto values (18, 'ICO', 'ICO');
insert into depto values (19, 'CIMA', 'CIMA');
commit;

start transaction;
update depto set loc = 'MEXICO' where deptono in (18, 19);
commit;

-- -- Uso del Rollback para evitar los cambios
start transaction;
update depto set loc = 'MEXICO' where deptono> 0;
select * from depto;
rollback;

select * from depto;

show variables like '%commit%';

show binary logs;

-- Concurrenia y Bloqueos

-- -- Desactivar el auto-commit en la sesion
set autocommit = 0; 
show variables like '%commit%';

-- -- Bloqueos

``` MySQL -- En otra sesion correr los coandos
select * from information_schema.INNODB_TRX; -- Nos muestra las transacciones en progeso
show processlist;
show variables like '%lock%';
```

-- -- -- For Update para bloquear actualizaciones cuando se realizan lecturas
select * from depto where deptono = 7 for update;
commit;

select * from depto where loc = 'MER' for update; -- El bloqueo se puede aplicar a multiples elementos
rollback;

-- -- -- Bloquear Tablas
lock tables depto write;
unlock tables;

-- -- -- Ver Procesos
show processlist;
kill `[num. proceso]`

-- -- -- Flush suelta todos los bloqueos
flush tables with read lock;

-- -- Aislamiento
show variables like '%isolation%'; -- READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE

-- -- -- Busacr Variables a nivel Global o nivel Sesion
select @@GLOBAL.transaction_isolation;

select @@SESSION.transaction_isolation;

-- -- -- Comando para Ajustar el Aislamiento de la Sesion
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- Permite leer desde el buffer los datos de las transacciones en proceso

-- -- -- Hacer Rollback a puntos anteriores
select * from cuentas;

rollback to punto_2;

select * from cuentas;

rollback to punto_1;

select * from cuentas;

rollback to punto_2; -- Solo se puede regresar de un punto en un punto y de forma escalonada

rollback;

select * from cuentas;

-- Privilegios
show privileges;

-- -- Crear Usuarios en diferentes ubicaciones
create user '[usuario]'@'localhost' identified by '[contraseña]'; -- local
create user '[usuario]'@'%' identified by '[contraseña]'; -- remoto
create user '[usuario]'@'123.7.90.122' identified by '[contraseña]'; -- direccion IP
create user '[usuario]'@'123.7.90.*' identified by '[contraseña]'; -- Red IP

-- -- Administrar Privilegios
-- -- -- Asignar todos los privilegios sobre una base
create user '[usuario]'@'[ubiacion]' identified by 'local123';
grant all privileges on `[base]`.`[tabla]` to '[usuario]'@'[ubiacion]'; 
flush privileges;

-- -- -- Quitar todos los privelegios sobre una base
revoke all privileges on `[base]`.`[tabla]` from '[usuario]'@'[ubiacion]'; -- Error Falso 
flush privileges;

-- -- -- Mostrar los permisos de un usuario
show grants for '[usuario]'@'[ubiacion]'; 

-- -- Generar usuarios con contraseñas temporales
create user '[usuario]'@'[ubiacion]' identified by '[contraseña]' 
password expire interval 4 day 
account lock;

select * from mysql.user; -- Ver que se haya aplicado la contraseña temporal

-- -- Desbloquear una cuenta
alter user '[usuario]'@'[ubiacion]' account unlock;

-- -- Generar usuario con bloqueo de intentos
create user '[usuario]'@'[ubiacion]' identified by 'local123' 
failed_login_attempts 3 password_lock_time 10; -- Error Falso

select * from mysql.user where user = '[usuario]'; -- Ver que se haya aplicado el bloqueo por intentos

-- -- Generar usuario con verificacion específica
create user '[usuario]'@'[ubiacion]' 
identified with mysql_native_password 
by '[contraseña]';

select * from mysql.user where user = '[usuario]'; -- Ver que se haya aplicado el cambio

-- -- -- Cambiar el tipo de verificacion
alter user '[usuario]'@'[ubiacion]' 
identified with caching_sha2_password 
by '[contraseña]';

select * from mysql.user where user = '[usuario]';

-- -- Privilegios a Usuarios
show grants for '[usuario]'@'[ubiacion]';
use `[base]`;
show privileges;

grant all privileges on `[base]`.`[tabla]` to '[usuario]'@'[ubiacion]';
flush privileges;
show grants for '[usuario]'@'[ubiacion]';

revoke all privileges on credito.* from  '[usuario]'@'[ubiacion]'; -- Error Falso

-- -- -- Asignar privilegios especificos a un usuario
grant select on `[base]`.`[tabla]` to '[usuario]'@'[ubiacion]';
flush privileges;
show grants for '[usuario]'@'[ubiacion]';

grant insert, update, delete on `[base]`.`[tabla]` to '[usuario]'@'[ubiacion]';
flush privileges;
show grants for '[usuario]'@'[ubiacion]';

-- -- -- Revocar privilegios rspecificos
revoke insert on `[base]`.`[tabla]` from  '[usuario]'@'[ubiacion]';
flush privileges;
show grants for '[usuario]'@'[ubiacion]';

-- -- Privilegios sobre vistas

create or replace view `[vista]` as
select `[columna]`, `[columna]`, `[columna]`, `[columna]`, `[columna]`
from `[tabla]`
where sexo = 'F';

select * from `[vista]`;

grant select on `[base]`.`[vista]` to '[usuario]'@'[ubiacion]';
flush privileges;

-- -- Accesos
-- -- -- Crear usuario con limites
create user '[usuario]'@'[ubiacion]' 
identified by '[contraseña]'
with
max_user_connections 2
max_connections_per_hour 5
max_queries_per_hour 10
max_updates_per_hour 3;

-- -- -- Alterar los Limites
alter user '[usuario]'@'[ubiacion]'  
with
max_user_connections 2
max_connections_per_hour 8
max_queries_per_hour 10
max_updates_per_hour 3;

select * from mysql.user where user = '[usuario]'; -- Ver las limitaciones del usuario

-- -- Crear un Evento
use credito;
create event limitar_consultas_ustest
on schedule every 1 day starts '[yyyy-MM-dd] [HH:mm:ss]'
do
	alter user '[usuario]'@'[ubiacion]'
        with
        max_queries_per_hour 5;
        
select * from information_schema.events; -- Ver que se haya creado el evento

-- Roles
-- -- Crear Roles
create role '[Rol1]', '[Rol2]', '[Rol3]';
flush privileges;

-- -- Asignar Privilegios a los roles
show grants for '[Rol1]';
grant all privileges on `[base]`.`[tabla]` to '[Rol1]'; -- Todos los privilegios
show privileges;

-- -- -- Asignar Privilegios Individuales
grant select on credito.* to '[Rol2]';
grant insert, update, delete on credito.* to '[Rol3]';

show variables like '%roles%'; -- Mostrar los Roles creados

grant '[Rol1]' to '[usuario]'@'[ubiacion]';
grant '[Rol2]' to '[usuario]'@'[ubiacion]';
grant '[Rol3]' to '[usuario]'@'[ubiacion]';

show grants for '[usuario]'@'[ubiacion]' using '[Rol]'; -- Mostrar los permisos del usuario con un rol

-- -- -- Escoger un Rol en Terminal
``` MySQL -- Ver el Rol actual
SELECT CURRENT_ROLE();
```

``` MySQL -- Activar todos los roles asignados
set role all 
```

``` MySQL -- Seleccionar el Rol por Defecto
set role default
```

``` MySQL -- Seleccionar un Rol Especifico
set role [Rol]
```

``` MySQL -- Deseleccionar todos los roles
set role none
```

-- -- -- Eliminar un Rol de un Usuario
revoke '[Rol]' from '[usuario]'@'[ubiacion]';