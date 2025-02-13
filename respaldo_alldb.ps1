# Configurar variables

$BackupDir = "D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\Clases\Sesion 03"

$ParamFile = "D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\parametros.cnf"

$Timestamp = Get-Date -Format "yyyyMMddHHmmss"

# Obtener lista de bases de datos excluyendo las de sistema

$Databases = mysql --defaults-file="$ParamFile" -s -N -e "SHOW DATABASES" | Where-Object {$_ -notmatch "^(information_schema|performance_schema|mysql|sys)$"}

# Respaldar cada base de datos

foreach ($Db in $Databases) {

$BackupFile = "$BackupDir\$Timestamp`_$Db.sql"

Write-Host "Respaldando $Db en $BackupFile..."

mysqldump.exe --defaults-file="$ParamFile" $Db | Out-File -Encoding utf8 "$BackupFile"

}

Write-Host "Respaldo completado."