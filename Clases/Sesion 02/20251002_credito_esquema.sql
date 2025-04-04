-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: credito
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `consumo`
--

DROP TABLE IF EXISTS `consumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consumo` (
  `cuentano` varchar(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `tiendano` smallint DEFAULT NULL,
  `movimiento` char(1) DEFAULT NULL,
  `importe` smallint DEFAULT NULL,
  KEY `cuentano` (`cuentano`),
  KEY `tiendano` (`tiendano`),
  CONSTRAINT `consumo_ibfk_1` FOREIGN KEY (`cuentano`) REFERENCES `cuenta` (`cuentano`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `consumo_ibfk_2` FOREIGN KEY (`tiendano`) REFERENCES `tienda` (`tiendano`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cuenta`
--

DROP TABLE IF EXISTS `cuenta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuenta` (
  `cuentano` varchar(11) NOT NULL DEFAULT '',
  `empno` smallint DEFAULT NULL,
  `estatus` char(1) DEFAULT NULL,
  `factivacion` date DEFAULT NULL,
  PRIMARY KEY (`cuentano`),
  KEY `empno` (`empno`),
  CONSTRAINT `cuenta_ibfk_1` FOREIGN KEY (`empno`) REFERENCES `empleado` (`empno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `depto`
--

DROP TABLE IF EXISTS `depto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `depto` (
  `deptono` smallint NOT NULL DEFAULT '0',
  `dnombre` varchar(30) DEFAULT NULL,
  `loc` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`deptono`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `empleado`
--

DROP TABLE IF EXISTS `empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleado` (
  `empno` smallint NOT NULL DEFAULT '0',
  `epaterno` varchar(30) DEFAULT NULL,
  `ematerno` varchar(30) NOT NULL,
  `enombre` varchar(100) NOT NULL,
  `puestono` int DEFAULT NULL,
  `sexo` char(1) DEFAULT NULL,
  `fingreso` date DEFAULT NULL,
  `sueldo` smallint DEFAULT NULL,
  `deptono` smallint DEFAULT NULL,
  PRIMARY KEY (`empno`),
  KEY `deptono` (`deptono`),
  KEY `puestono` (`puestono`),
  CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`deptono`) REFERENCES `depto` (`deptono`) ON UPDATE CASCADE,
  CONSTRAINT `empleado_ibfk_2` FOREIGN KEY (`puestono`) REFERENCES `puesto` (`puestono`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estado`
--

DROP TABLE IF EXISTS `estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado` (
  `estadono` smallint NOT NULL DEFAULT '0',
  `enombre` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`estadono`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `info_empleado`
--

DROP TABLE IF EXISTS `info_empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `info_empleado` (
  `empno` smallint DEFAULT NULL,
  `curp` varchar(18) DEFAULT NULL,
  `calle` varchar(80) DEFAULT NULL,
  `colonia` varchar(40) DEFAULT NULL,
  `ciudad` varchar(40) DEFAULT NULL,
  `municipio` varchar(40) DEFAULT NULL,
  `estadono` smallint DEFAULT NULL,
  `cp` varchar(15) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `telefono` varchar(25) DEFAULT NULL,
  UNIQUE KEY `empno` (`empno`),
  CONSTRAINT `info_empleado_ibfk_1` FOREIGN KEY (`empno`) REFERENCES `empleado` (`empno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `puesto`
--

DROP TABLE IF EXISTS `puesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `puesto` (
  `puestono` int NOT NULL AUTO_INCREMENT,
  `pnombre` varchar(30) NOT NULL,
  PRIMARY KEY (`puestono`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tarjeta`
--

DROP TABLE IF EXISTS `tarjeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarjeta` (
  `cuentano` varchar(11) DEFAULT NULL,
  `tarjeta` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tienda`
--

DROP TABLE IF EXISTS `tienda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tienda` (
  `tiendano` smallint NOT NULL DEFAULT '0',
  `tipo` varchar(20) NOT NULL DEFAULT '',
  `tnombre` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`tiendano`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-10 12:46:46
