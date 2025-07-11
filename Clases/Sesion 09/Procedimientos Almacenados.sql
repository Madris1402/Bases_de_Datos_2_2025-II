-- Procedimientos Almacenados

use credito;

show tables;

show procedure status where db = database(); -- Mostrar los procediminetos almacenados

-- establecer el delimiter
delimiter $$ 

drop procedure if exists nombrecompletoempleado $$
create procedure nombrecompletoempleado()
begin
	select concat_ws(' ', enombre, epaterno, ematerno) empleado, 
		dnombre departamento from empleado e join depto d on(e.deptono = d.deptono);
end $$

 -- restaurar el delimitador original
delimiter ;


-- Uso de Parametros
delimiter $$ 
drop procedure if exists nombrecompletoempleado $$
create procedure nombrecompletoempleado(IN pdepto varchar(50))
begin
	select concat_ws(' ', enombre, epaterno, ematerno) empleado, 
		dnombre departamento from empleado e join depto d on(e.deptono = d.deptono)
        where dnombre = pdepto;
end $$
delimiter ;

call  nombrecompletoempleado('[nombre del depto]');

-- Uso de Condicionales
delimiter $$ 
drop procedure if exists nombrecompletoempleado $$
create procedure nombrecompletoempleado(IN pdepto varchar(50))
begin
	if(pdepto is null or pdepto = 'todos' or pdepto = '') then
    select concat_ws(' ', enombre, epaterno, ematerno) empleado, 
		dnombre departamento from empleado e join depto d on(e.deptono = d.deptono);
	else
		select concat_ws(' ', enombre, epaterno, ematerno) empleado, 
		dnombre departamento from empleado e join depto d on(e.deptono = d.deptono)
        where dnombre = pdepto;
	end if;
end $$
delimiter ;


call  nombrecompletoempleado('todos');
call  nombrecompletoempleado('');
call  nombrecompletoempleado(null);

-- Uso de Variables, Parametros de entrada y de salida
delimiter $$ 
drop procedure if exists nivelEmpleado $$
create procedure nivelEmpleado(IN pempleado int, out pnivel varchar(10), out ptconsumo decimal(10,2))
begin
	declare vempno int;
    
    -- into asigna los valores a las variables
    select empno, ifnull(sum(importe), 0) into vempno, ptconsumo
    from consumo c join cuenta t on(c.cuentano = t.cuentano)
    where t.empno = pempleado
    group by empno;
    
    if(ptconsumo > 3000) then
		set pnivel = 'PLATINO';
	elseif (ptconsumo <= 3000 and ptconsumo > 2000 ) then
		set pnivel = 'ORO';
	elseif (ptconsumo <= 2000 and ptconsumo > 0 ) then
		set pnivel = 'PLATA';
	else
        set pnivel = 'SIN NIVEL';
	end if;
end $$
delimiter ;

select * from consumo;
select * from cuenta;

-- -- Declarar una variable de entorno
set @cveempleado = 12038;

select @cveempleado;

-- Llamar a la funcion
call nivelEmpleado(@cveempleado, @nivelempleado, @totalconsumo);
select *, @nivelempleado, @totalconsumo
from empleado where empno = @cveempleado;

-- Uso de Loop

delimiter $$ 
drop procedure if exists listaEmail $$
create procedure listaEmail(INOUT plista TEXT)
begin
	declare  vclave int;
    declare vnombre varchar(250);
     declare vemail varchar(250);
     declare terminado int default 0;
     declare email_cursor cursor for
		select e.empno, concat_ws('', enombre, epaterno, ematerno) empleado, email
        from empleado e join info_empleado i on(e.empno = i.empno);
	declare continue handler for not found set terminado = 1;
    
    set plista = '';
    open email_cursor;
    getEmail: loop
		fetch email_cursor into vclave, vnombre, vemail;
        if(terminado = 1) then
			leave getEmail;
		end if;
        if(vemail <> '' and vemail is not null) then
			set plista = concat(vnombre, ' <', vemail, '>; ', plista);
		end if;
    end loop getEmail;
    close email_cursor;
end $$
delimiter ;

set @Lista = '';
call listaEmail(@Lista);

select @Lista;

-- 28/04/25

-- Exportar JSONS usando While

delimiter $$ 
drop procedure if exists listaEmail $$
create procedure listaEmail(IN pdepto varchar(50), INOUT plista JSON)
begin
	declare  vclave int;
    declare vnombre varchar(250);
     declare vemail varchar(250);
     declare terminado int default 0;
     declare totalRegistros int default 0;
     declare msg varchar(250);
     
     declare email_cursor cursor for
		select e.empno, concat_ws('', enombre, epaterno, ematerno) empleado, email
        from empleado e join info_empleado i on(e.empno = i.empno)
        join depto d on(e.deptono = d.deptono)
        where dnombre = pdepto and email like '%@%';
	declare continue handler for not found set terminado = 1;
    
    select count(*) into totalRegistros
		from empleado e join info_empleado i on(e.empno = i.empno)
        join depto d on(e.deptono = d.deptono)
        where dnombre = pdepto and email like '%@%';
    
    if(totalRegistros > 0) then
		open email_cursor;
        fetch email_cursor into vclave, vnombre, vemail;
		
        set plista = JSON_OBJECT('totalRegistros', totalRegistros, 'emails', JSON_ARRAY());
        while terminado = 0 do
			set plista = JSON_SET(
				plista,
                '$.totalRegistros', totalRegistros,
                '$.emails', JSON_ARRAY_APPEND(
					JSON_EXTRACT(plista, '$.emails'),
                    '$', JSON_OBJECT('nombre', vnombre, 'email', vemail)
                )
            );
            fetch email_cursor into vclave, vnombre, vemail;
        end while;
		close email_cursor;
    else
		set msg = concat('No existen registros para: ', pdepto);
        signal sqlstate '40500' set message_text = msg;
    end if;
    
end $$
delimiter ;

set @Lista = null;
call listaEmail('cajas', @Lista);
call listaEmail('sistemas', @Lista);
call listaEmail('patito23', @Lista);

select @Lista;


-- Crear Vista de Clientes
create or replace view cliente as
select empno + 3000 nocliente, epaterno cpaterno, ematerno cmaterno, enombre cnombre, sexo, sueldo consumo
from empleado;

select * from cliente;

-- Procedimiento para Consultas Dinamicas
delimiter $$ 
drop procedure if exists consultaDinamica $$
create procedure consultaDinamica(IN tabla varchar(50), IN sexo varchar(1), in orden int)
begin
	set @query = concat(
		'SELECT * FROM ('
        'SELECT CONCAT_WS(\' \', ',
        if(tabla = 'empleado', 'enombre, epaterno, ematerno', 
			'cnombre, cpaterno, cmaterno'),
            ') as ', tabla, ', ',
		if(tabla = 'empleado', 'fingreso, sexo, sueldo', 'sexo, consumo'),
        ' FROM ', tabla,
        if(sexo in('F', 'M'), CONCAT(' Where sexo = \'', sexo, '\''), ''),
        ') as s ORDER BY 1 ', if(orden = 0, 'ASC', 'DESC') 
    );
    -- select @query;
    prepare stmt from @query;
    execute stmt;
    deallocate prepare stmt;
end $$
delimiter ;

call consultaDinamica('empleado', 'M', '0');

call consultaDinamica('cliente', 'F', '1');

call consultaDinamica('cliente', 'X', '1');