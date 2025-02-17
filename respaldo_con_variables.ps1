param (
    [string]$BaseDatos
)
 
# Configuración
$ArchivoConfiguracion = "D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\parametros.cnf"
$RutaRespaldo = "D:\Files\Git\Semestre 08\Bases_de_Datos_2_2025-II\Clases\Sesion 04"
 
# Obtener la fecha y hora en formato YYYYMMDDHHMMSS
$FechaHora = Get-Date -Format "yyyyMMddHHmmss"
 
# Nombre del archivo de respaldo
$ArchivoRespaldo = "$FechaHora`_$BaseDatos.sql"
$RutaArchivoRespaldo = "$RutaRespaldo\$ArchivoRespaldo"
 
# Ejecutar mysqldump
Write-Host "Iniciando respaldo de la base de datos: $BaseDatos..."
mysqldump --defaults-file="$ArchivoConfiguracion" $BaseDatos > "$RutaArchivoRespaldo"
 
if ($?) {
    Write-Host "Respaldo completado con éxito: $RutaArchivoRespaldo"
} else {
    Write-Host "Error al realizar el respaldo."
}