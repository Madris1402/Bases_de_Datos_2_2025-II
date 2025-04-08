-- Concurrencia y Bloqueos

show variables like '%commit%';
use credito;
select * from depto;
update depto set loc = "MTY" where deptono = 8; -- Cambiar la ubicación del dpto con auto commit.

rollback;

-- Desactivar el auto-commit en la sesion
set autocommit = 0; 
show variables like '%commit%';

-- Hacer Cambios con commit
update depto set loc = "GDL" where deptono = 8;
select * from depto;
commit;

select * from depto; -- Los cambios se guardaron de forma permanente

-- Hecr un rollback
update depto set loc = "SNL" where deptono = 8;
select * from depto; -- Cambios en el Buffer
rollback;

select * from depto;  -- Los cambios no fueron guardados

select database();


-- Hacer Cambios con commit
update depto set loc = "CHI" where deptono = 8;
select * from depto;
commit;

-- Hacer Cambios con commit
update depto set loc = "CAM" where deptono = 8;
select * from depto;
commit;

rollback;