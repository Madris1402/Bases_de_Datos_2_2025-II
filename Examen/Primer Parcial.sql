-- 1.
-- mysqldump --defaults-file="D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\parametros.cnf" --default-character-set=utf8mb4 --add-drop-database credito empleado puesto depto > "D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\Examen\Parcial_2807_RMU_credito.sql"

-- 2. 
-- -- a)
show variables like "%general_log%";
set global general_log_file = Log_2807_RMU; 
set global general_log = 1;

-- -- b)
show variables like '%data%';

-- 3. Ricardo Madrigal Urencio
set SQL_SAFE_UPDATES = 0;

use credito;
start transaction;
	select * from empleado where sueldo >= 1200 and sueldo <= 1300;
	delete from empleado where sueldo >= 1200 and sueldo <= 1300;
    select * from empleado where sueldo >= 1200 and sueldo <= 1300;
rollback;

-- 4. Ricardo Madrigal Urencio

set FOREIGN_KEY_CHECKS = 0;
start transaction;
	savepoint punto1;
	
	insert into tienda values (31, 'FES', 'Value1');
    insert into tienda values (32, 'FES', 'Value2');
    insert into tienda values (33, 'FES', 'Value3');
    insert into tienda values (34, 'FES', 'Value4');
    insert into tienda values (35, 'FES', 'Value5');
    
    select * from tienda;
-- Ricardo Madrigal Urencio
    delete from tienda where tiendano < 5;
    select * from tienda;
    rollback to punto1;
    select * from tienda;

rollback;

-- 5. Ricardo Madrigal Urencio

create role 'lectura', 'escritura';

grant select on credito.empleado to 'lectura';
grant select on credito.puesto to 'lectura';
grant select on credito.tarjeta to 'lectura';

show grants for 'lectura';

grant insert, update, delete on credito.tienda to 'escritura';
grant insert, update, delete on credito.depto to 'escritura';
grant insert, update, delete on credito.cuenta to 'escritura';

show grants for 'escritura';

-- 6. Ricardo Madrigal Urencio

create user 'consultor_RicardoMadrigal_2807'@'localhost'
identified by 'pass123';

grant 'lectura' to 'consultor_RicardoMadrigal_2807'@'localhost' ;

alter user 'consultor_RicardoMadrigal_2807'@'localhost'
with
max_connections_per_hour 3
max_queries_per_hour 10
max_updates_per_hour 10;
select User, max_questions, max_updates, max_connections from mysql.user;

-- 7. Ricardo Madrigal Urencio

create user 'gestor_RicardoMadrigal_2807'@'localhost'
identified by 'pass123';

grant 'lectura' to 'gestor_RicardoMadrigal_2807'@'localhost' ;
grant 'escritura' to 'gestor_RicardoMadrigal_2807'@'localhost' ;

select * from mysql.user;

show grants for 'gestor_RicardoMadrigal_2807'@'localhost';

alter user 'gestor_RicardoMadrigal_2807'@'localhost'
with
max_connections_per_hour 3;

select User, max_connections from mysql.user;

-- 8. Ricardo Madrigal Urencio
show grants for 'consultor_RicardoMadrigal_2807'@'localhost' using 'lectura';


-- 9. Ricardo Madrigal Urencio

-- 10. Ricardo Madrigal Urencio

create or replace view RMU_consumos_empleados as
select e.enombre, sum(c.importe) as total_consumo
from empleado e
join consumo c on e.empno = c.cuentano
group by e.enombre;

select * from RMU_consumos_empleados;
grant select on RMU_consumos_empleados to 'consultor_RicardoMadrigal_2807'@'localhost';
show grants for 'consultor_RicardoMadrigal_2807'@'localhost';