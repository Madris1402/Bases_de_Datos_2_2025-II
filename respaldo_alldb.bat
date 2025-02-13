@echo off
setlocal enabledelayedexpansion
set BACKUP_DIR="D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\Clases\Sesion 03"
set TIMESTAMP=%date:~6,4%%date:~3,2%%date:~0,2%%time:~0,2%%time:~3,2%%time:~6,2%
 
for /F "tokens=*" %%D in ('mysql --defaults-file="D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\parametros.cnf" -s -N -e "SHOW DATABASES" ^| findstr /V "information_schema performance_schema mysql sys"') do (
    echo Haciendo respaldo de %%D...
    mysqldump --defaults-file="D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\parametros.cnf" %%D > "!BACKUP_DIR!\!TIMESTAMP!_%%D.sql"
)
 
echo Respaldo completado.
endlocal