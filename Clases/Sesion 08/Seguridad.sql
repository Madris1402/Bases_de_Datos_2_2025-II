select * from mysql.user;

show privileges;

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

create user 'ustest'@'localhost' identified by 'local123';
grant all privileges on credito.* to 'ustest'@'localhost';
flush privileges;

grant all privileges on bdconcurrencia.* to 'ustest'@'localhost';
flush privileges;

revoke all privileges on bdconcurrencia.* from 'ustest'@'localhost';
flush privileges;

show grants for 'ustest'@'localhost';