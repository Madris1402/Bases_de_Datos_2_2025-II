DROP SCHEMA IF EXISTS credito_cubo;
CREATE DATABASE IF NOT EXISTS credito_cubo;
USE credito_cubo;

CREATE TABLE dim_empleado (
  id_empleado SMALLINT PRIMARY KEY AUTO_INCREMENT,
  nombre_completo VARCHAR(160),
  sexo CHAR(1),
  fingreso DATE,
  sueldo SMALLINT,
  depto VARCHAR(30),
  puesto VARCHAR(30),
  ciudad VARCHAR(40),
  estado VARCHAR(25)
);

CREATE TABLE dim_tienda (
  id_tienda SMALLINT PRIMARY KEY AUTO_INCREMENT,
  tipo VARCHAR(20),
  nombre VARCHAR(30)
);

CREATE TABLE dim_tiempo (
  id_tiempo SMALLINT PRIMARY KEY AUTO_INCREMENT,
  fecha DATE,
  anio INT,
  mes INT,
  dia INT,
  trimestre INT,
  nombre_mes VARCHAR(15),
  nombre_dia VARCHAR(15)
);

CREATE TABLE dim_cuenta (
  id_cuenta SMALLINT PRIMARY KEY AUTO_INCREMENT,
  estatus CHAR(1),
  fecha_activacion DATE,
  tarjeta VARCHAR(16)
);

CREATE TABLE hechos (
  id INT AUTO_INCREMENT PRIMARY KEY AUTO_INCREMENT,
  id_tiempo SMALLINT,
  id_empleado SMALLINT,
  id_tienda SMALLINT,
  id_cuenta SMALLINT,
  importe SMALLINT,
  FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo),
  FOREIGN KEY (id_empleado) REFERENCES dim_empleado(id_empleado),
  FOREIGN KEY (id_tienda) REFERENCES dim_tienda(id_tienda),
  FOREIGN KEY (id_cuenta) REFERENCES dim_cuenta(id_cuenta)
);


