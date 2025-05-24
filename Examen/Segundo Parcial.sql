use credito;

/* 
1. Procedimiento de Carga Inicial (cargar_datos_dimensionales_iniciales) 
o Crear un procedimiento almacenado que extraiga y transforme los datos necesarios desde las tablas  de la base credito hacia las tablas de dimensión y hechos en credito_cubo. 
o Asegurar que se evite duplicidad de registros. 
o Incluir transformaciones necesarias como la concatenación de nombre completo del empleado, la  obtención del nombre del estado y ciudad, la fecha de activación de la cuenta y la inserción de los  registros en la tabla de hechos. 
o 70 % (14 para cada tabla) 
*/
set foreign_key_checks = 0;

delimiter $$

drop procedure if exists etl_credito $$
create procedure etl_credito()
begin
	declare terminado int default 0;
	declare i int default 1;
	declare vimporte int;

	declare importe_cur cursor for select importe from credito.consumo;
	declare continue handler for not found set terminado = 1;

	open importe_cur;

	importe_loop: loop
	fetch importe_cur into vimporte;
	if terminado then
	leave importe_loop;
	end if;

	insert into credito_cubo.hechos (id_tiempo, id_empleado, id_tienda, id_cuenta, importe)
	values (i, i, i, i, vimporte);

	set i = i + 1;
	end loop;

	close importe_cur;

	-- Preparar Tienda para el modelo dimensional
	insert into credito_cubo.dim_tienda (
	select null, tipo, tnombre from credito.tienda
	);

	-- Preparar Empleado
	insert into credito_cubo.dim_empleado (
	select null, concat_ws(' ', e.enombre, e.epaterno, e.ematerno) nombre_completo, sexo, fingreso, sueldo, dnombre departamento, pnombre puesto, ciudad, es.enombre
	from credito.empleado e
	left join credito.depto d on(e.deptono = d.deptono)
	left join credito.puesto p on(e.puestono = p.puestono)
	left join credito.info_empleado ie on (e.empno = ie.empno)
	left join credito.estado es on (ie.estadono = es.estadono)
	);
    
    -- Preparar Cuenta
    insert into credito_cubo.dim_cuenta (
    select null, estatus, factivacion, tarjeta
    from credito.cuenta c
    join credito.tarjeta t on (c.cuentano = t.cuentano)
    );
    
	-- Prerparar Tiempo
    insert into credito_cubo.dim_tiempo (
    select distinct null, fecha, YEAR(fecha) anio, MONTH(fecha) mes, DAY(fecha) dia, QUARTER(fecha) trimestre, monthname(fecha) nombre_mes, dayname(fecha)
	from credito.consumo
    );
end $$

delimiter ;

call etl_credito();
select * from credito_cubo.dim_empleado;
select * from credito_cubo.dim_cuenta;
select * from credito_cubo.dim_tiempo;
select * from credito_cubo.dim_tienda;
select * from credito_cubo.hechos;

/* 
2. Trigger de Monitoreo en la tabla consumo 
o Crear un trigger AFTER INSERT sobre la tabla consumo de la base credito. 
o Este trigger debe actualizar en tiempo real la tabla hechos en la base credito_cubo, identificando  correctamente las llaves foráneas a partir de los datos insertados. 
o 15 % 
*/

delimiter $$
drop procedure if exists revisarFecha $$
create procedure revisarFecha()
begin
	declare fecha_actual date;
    declare terminado int default 0;
	declare cursor_fecha cursor for select distinct fecha from consumo;
    declare continue handler for not found set terminado = 1;
    
    open cursor_fecha;
    
    fechas: loop
		fetch cursor_fecha into fecha_actual;
        
        if terminado = 1 then
			leave fechas;
        end if;
        
        if not exists (select 1 from credito_cubo.dim_tiempo where fecha = fecha_actual) then 
			insert into credito_cubo.dim_tiempo (fecha, dia, mes, anio, trimestre, nombre_mes, nombre_dia)
            values(fecha_actual, DAY(fecha_actual), MONTH(fecha_actual), YEAR(fecha_actual), QUARTER(fecha_actual), 
            MONTHNAME(fecha_actual), DAYNAME(fecha_actual));
        end if;
    end loop fechas;
    close cursor_fecha;
end $$
delimiter ;

call revisarFecha();
select * from credito_cubo.dim_tiempo;

/* 
3. Procedimiento para actualizar la dimensión de tiempo (actualizar_dim_tiempo) o Crear un procedimiento que revise las fechas en la tabla consumo y agregue nuevas entradas a la  tabla dim_tiempo si no existen. 
o La tabla debe registrar día, mes, año, trimestre, nombre del mes y nombre del día. o 15 %
*/

delimiter $$
drop procedure if exists revisarFecha $$
create procedure revisarFecha()
begin
	declare fecha_actual date;
    declare terminado int default 0;
	declare cursor_fecha cursor for select distinct fecha from consumo;
    declare continue handler for not found set terminado = 1;
    
    open cursor_fecha;
    
    fechas: loop
		fetch cursor_fecha into fecha_actual;
        
        if terminado = 1 then
			leave fechas;
        end if;
        
        if not exists (select 1 from credito_cubo.dim_tiempo where fecha = fecha_actual) then 
			insert into credito_cubo.dim_tiempo (fecha, dia, mes, anio, trimestre, nombre_mes, nombre_dia)
            values(fecha_actual, DAY(fecha_actual), MONTH(fecha_actual), YEAR(fecha_actual), QUARTER(fecha_actual), 
            MONTHNAME(fecha_actual), DAYNAME(fecha_actual));
        end if;
    end loop fechas;
    close cursor_fecha;
end $$
delimiter ;

call revisarFecha();
select * from credito_cubo.dim_tiempo;