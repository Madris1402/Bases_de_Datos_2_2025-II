use credito;
show tables;

show variables like '%autocommit%';
set autocommit = 0; -- Apagar Autocommit

-- Transacciones
select * from depto;
commit;

update depto set loc = 'NEZA' where deptono = 8;
select * from depto;

-- TRX
update depto set loc = 'SLP' where deptono = 7;
select * from depto;
rollback;

select * from depto;
rollback;

-- Bloqueos por renglon
select * from depno;
update depto set loc = 'YUC' where deptono = 7;
rollback;

select * from depno;
update depto set loc = 'YUC' where deptono = 7;
commit;

-- -- For Update para bloquear actualizaciones cuando se realizan lecturas
select * from depto where deptono = 7 for update;
commit;

select * from depto where loc = 'MER' for update; -- El bloqueo se puede aplicar a multiples elementos
rollback;

-- -- Bloquear Tablas
lock tables depto write;
unlock tables;

-- -- Flush suelta todos los bloqueos
flush tables with read lock;