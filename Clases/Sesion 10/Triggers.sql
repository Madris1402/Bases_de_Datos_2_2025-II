use credito;
-- Triggers
-- -- Eventos de lanzamiento
-- -- BEFORE: corre antes de ejecutar la accion 
-- -- AFTER: corre despues de ejecutar la accion
-- -- Objetos OLD: lo que ya esta escrito en la base de datos
-- -- NEW: el nuevo dato agregado

select * from depto;

show triggers;

-- Trigger para
delimiter $$

drop trigger if exists bi_depto;
create trigger bi_depto
before insert onn depto
for each row
begin
	set NEW.dnombre = UPPER(NEW.dnombre);
    if(NEW.loc like '%MEX%') then
		set NEW.loc = 'MEXICO'
	end if;
    
    insert into puesto set puestono = NEW.deptono + 10000, pnombre = CONCAT('DEPTO ', NEW.dnombre);
end $$

delimiter ;

select * from depto;
insert into depto values(210, 'base de datos', 'edomex');
    
-- 05 - 05 - 2025
-- Trigger para condicionar incersiones
delimiter $$
drop trigger if exists bi_empleado;
create trigger bi_empleado
before insert on empleado
for each row
begin
	set NEW.enombre = UPPER(NEW.enombre);
	set NEW.epaterno = UPPER(NEW.epaterno);
	set NEW.ematerno = UPPER(NEW.ematerno);

	if(NEW.sueldo<8340) then
		signal sqlstate'45000'
		set message_text = 'Sueldo no puede ser menos que el minimo';
	end if;

end $$
delimiter ;

show triggers;

insert into empleado values (13001, 'juan', 'lopez', 'diaz', 3, 'M', current_date(), 10000, 4);

insert into empleado values (13001, 'juana', 'lopez', 'diaz', 3, 'M', current_date(), 1000, 4);

select * from puesto;

insert into depto values(300, 'becario', 'edomex');

select * from depto;


delimiter $$
drop trigger if exists bi_empleado;
create trigger bi_empleado
before insert on empleado
for each row
begin
	set NEW.enombre = UPPER(NEW.enombre);
	set NEW.epaterno = UPPER(NEW.epaterno);
	set NEW.ematerno = UPPER(NEW.ematerno);

	if(NEW.puestono != 10300 and new.sueldo < 8340) then
		signal sqlstate'45000'
		set message_text = 'Sueldo no puede ser menos que el minimo para empleado';
	end if;
    
    if(NEW.puestono = 10300 and new.sueldo < 6000) then
		signal sqlstate'45000'
		set message_text = 'Sueldo no puede ser menos que el minimo para beca';
	end if;

end $$
delimiter ;

insert into empleado values (15002, 'juana', 'lopez', 'diaz', '10300' , 'M', current_date(), 6000, 4);


create table bitacora(
	id int not null auto_increment primary key,
	fecha datetime not null,
    usuario varchar(50) not null,
    tabla varchar(50) not null,
    accion text null
);


-- Trigger usando NEW y OLD
delimiter $$
drop trigger if exists bu_empleado $$

create trigger bu_empleado
    before update on empleado
	for each row 
    begin
		set  NEW.enombre = UPPER(NEW.enombre);
		set  NEW.epaterno = UPPER(NEW.epaterno);
		set  NEW.ematerno = UPPER(NEW.ematerno);
        
        if( NEW.sueldo < OLD.sueldo) then
			signal sqlstate '45000'
            set message_text = 'El nuevo sueldo no puede ser menor que el sueldo anterior';
		else 
			insert into bitacora  values(null, sysdate(), user(), 'empleado', 
										json_object('accion', 'ACTUALIZACION', 
													'old_empleado', old.empno, 'new_empleado', new.empno,
                                                    'old_nombre', old.enombre, 'new_nombre', new.enombre, 
                                                    'old_epaterno', old.epaterno, 'new_epaterno', new.epaterno, 
                                                    'old_ematerno', old.ematerno, 'new_ematerno', new.ematerno, 
                                                    'old_fingreso', old.fingreso, 'new_fingreso', new.fingreso, 
                                                    'old_sueldo', old.sueldo, 'new_sueldo', new.sueldo, 
                                                    'old_deptono', old.deptono, 'new_deptono', new.deptono)
										);
		end if;
    end $$
delimiter ;

show triggers;

select * from empleado;


-- Trigger Before Update
delimiter $$
drop trigger if exists bu_empleado $$

create trigger bu_empleado
    before update on empleado
	for each row 
    begin
		declare msg varchar(250) default '';
        
		set  NEW.enombre = UPPER(NEW.enombre);
		set  NEW.epaterno = UPPER(NEW.epaterno);
		set  NEW.ematerno = UPPER(NEW.ematerno);
        
        if( NEW.sueldo < OLD.sueldo) then
			set msg = CONCAT('El nuevo sueldo [', new.sueldo, '] no puede ser menor que el sueldo anterior [', old.sueldo, ']');
			signal sqlstate '45000'
            set message_text = msg;
		else 
			insert into bitacora  values(null, sysdate(), user(), 'empleado', 
			json_object('accion', 'ACTUALIZACION', 
			'old_empleado', old.empno, 'new_empleado', new.empno,
			'old_nombre', old.enombre, 'new_nombre', new.enombre, 
			'old_epaterno', old.epaterno, 'new_epaterno', new.epaterno, 
			'old_ematerno', old.ematerno, 'new_ematerno', new.ematerno, 
			'old_fingreso', old.fingreso, 'new_fingreso', new.fingreso, 
			'old_sueldo', old.sueldo, 'new_sueldo', new.sueldo, 
			'old_deptono', old.deptono, 'new_deptono', new.deptono)
			);
		end if;
    end $$
delimiter ;

update empleado set sueldo = 9000 where empno = 13001;
select * from bitacora;

update empleado set epaterno = 'reyes', ematerno = 'garcia', enombre = 'roberto',
puestono = 11, sexo = 'X', fingreso = current_date(), sueldo = 13000, deptono = 1
where empno = 13001;

-- Trigger After Delete
delimiter $$
drop trigger if exists ad_empleado $$

create trigger ad_empleado
    after delete on empleado
	for each row 
    begin
		insert into bitacora  values(null, sysdate(), user(), 'empleado', 
		json_object('accion', 'ELIMINACION', 
		'old_empleado', old.empno,
		'old_nombre', old.enombre,
		'old_epaterno', old.epaterno, 
		'old_ematerno', old.ematerno,
		'old_fingreso', old.fingreso, 
		'old_sueldo', old.sueldo,
		'old_deptono', old.deptono)
		);
    end $$
delimiter ;

delete from empleado where empno >= 13001;

select * from bitacora;