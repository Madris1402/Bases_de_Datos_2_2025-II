show variables; -- Muestra todas las variables en el sistema.
show variables like '%dir%'; -- Muestra el directorio de las Bases de Datos.


-- Madrigal Urencio Ricardo - 2807
show variables like '%error%'; -- Muestra las variables que se encargan de manejar errores
set global log_error = '.\mysql.local.err'; -- Cambiar la variable de errores

show processlist; -- Mostrar todos los procesos activos en el sistema

kill 11; -- Matar un proceso por su número de id


show variables like '%connec%'; -- Buscar los valores de conecciones

-- Madrigal Urencio Ricardo - 2807
show variables like '%log_file%';
show variables like '%general_log%';

set global general_log = 1;
set global general_log_file = '.log';

set global general_log = 0;

-- Madrigal Urencio Ricardo - 2807
show variables like '%slow%';

set global slow_query_log = 1;
set global slow_query_log_file = 'Log_slow_2025_12_41.log';

select * from
credito.consumo join credito.cuenta 
join credito.empleado 
join credito.estado
join credito.tarjeta;



-- 21-02-2025
show variables like '%log_bin%'; -- Mostrar Registros Binarios

show binary logs;


-- Transacciones
use credito; 
select * from depto;

select version();
start transaction;
insert into depto values (18, 'ICO', 'ICO');
insert into depto values (19, 'CIMA', 'CIMA');
commit;

start transaction;
update depto set loc = 'MEXICO' where deptono in (18, 19);
commit;

-- Uso del Rollback para evitar los cambios
start transaction;
update depto set loc = 'MEXICO' where deptono> 0;
select * from depto;
rollback;

select * from depto;

show variables like '%commit%';

show binary logs;