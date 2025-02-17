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
set global general_log_file = 'Log_2025_12_09.log';

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