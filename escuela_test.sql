-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.3.32-MariaDB-1:10.3.32+maria~focal - mariadb.org binary distribution
-- SO del servidor:              debian-linux-gnu
-- HeidiSQL Versión:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Volcando estructura para tabla escuela.alumnos
CREATE TABLE IF NOT EXISTS `alumnos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  `ap_materno` varchar(45) DEFAULT NULL,
  `ap_paterno` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla escuela.alumnos: ~2 rows (aproximadamente)
INSERT INTO `alumnos` (`id`, `nombre`, `ap_materno`, `ap_paterno`) VALUES
	(1, 'Domingo', 'Trejo', 'Fernandez'),
	(2, 'Gerardo', 'Trejo', 'Fernandez'),
	(3, 'Juan', 'Hernandez', 'Hernandez');

-- Volcando estructura para tabla escuela.alumno_grupo
CREATE TABLE IF NOT EXISTS `alumno_grupo` (
  `idalumno` int(11) NOT NULL,
  `idgrupo` int(11) NOT NULL,
  KEY `idalumno` (`idalumno`),
  KEY `idgrupo` (`idgrupo`),
  CONSTRAINT `alumno_grupo_ibfk_1` FOREIGN KEY (`idalumno`) REFERENCES `alumnos` (`id`),
  CONSTRAINT `alumno_grupo_ibfk_2` FOREIGN KEY (`idgrupo`) REFERENCES `grupo` (`idgrupo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla escuela.alumno_grupo: ~2 rows (aproximadamente)
INSERT INTO `alumno_grupo` (`idalumno`, `idgrupo`) VALUES
	(1, 1),
	(2, 1),
	(3, 1);

-- Volcando estructura para tabla escuela.calificaciones
CREATE TABLE IF NOT EXISTS `calificaciones` (
  `idcalificacion` int(11) NOT NULL AUTO_INCREMENT,
  `parcial1` varchar(45) DEFAULT NULL,
  `parcial2` varchar(45) DEFAULT NULL,
  `parcial3` varchar(45) DEFAULT NULL,
  `idalumno` int(11) NOT NULL,
  `idperiodo` int(11) NOT NULL,
  `idmateria` int(11) NOT NULL,
  PRIMARY KEY (`idcalificacion`),
  KEY `calificaciones_FK` (`idalumno`),
  KEY `calificaciones_FK_1` (`idperiodo`),
  KEY `calificaciones_FK_2` (`idmateria`),
  CONSTRAINT `calificaciones_FK` FOREIGN KEY (`idalumno`) REFERENCES `alumnos` (`id`),
  CONSTRAINT `calificaciones_FK_1` FOREIGN KEY (`idperiodo`) REFERENCES `periodo` (`idperiodo`),
  CONSTRAINT `calificaciones_FK_2` FOREIGN KEY (`idmateria`) REFERENCES `materia` (`idmateria`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla escuela.calificaciones: ~7 rows (aproximadamente)
INSERT INTO `calificaciones` (`idcalificacion`, `parcial1`, `parcial2`, `parcial3`, `idalumno`, `idperiodo`, `idmateria`) VALUES
	(1, '9.4', '8.3', '7', 1, 2, 1),
	(2, '8', '9.4', '9', 2, 2, 1),
	(3, '7', '10', '8', 3, 2, 1),
	(4, '8', '9', '10', 1, 2, 2),
	(5, '6', '9', '7', 1, 2, 3),
	(6, '8', '8', '8', 1, 1, 1),
	(7, '9', '9', '9', 1, 1, 2);

-- Volcando estructura para tabla escuela.carrera
CREATE TABLE IF NOT EXISTS `carrera` (
  `idcarrera` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idcarrera`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla escuela.carrera: ~0 rows (aproximadamente)
INSERT INTO `carrera` (`idcarrera`, `nombre`) VALUES
	(1, 'Tecnologias de la información y comunicación');

-- Volcando estructura para procedimiento escuela.GetCalificacionesBySemestre
DELIMITER //
CREATE PROCEDURE `GetCalificacionesBySemestre`(IN semestre VARCHAR(200))
BEGIN
	SELECT carrera.nombre AS 'Carrera', m.nombre as 'Materia',g.nombre as 'GRUPO', CONCAT(a.nombre, ' ',  a.ap_paterno) as 'ALUMNO', 
	ROUND( (CAST(c.parcial1 as DECIMAL(10,2)) + CAST(c.parcial2 as DECIMAL(10,2)) + CAST(c.parcial3 as DECIMAL(10,2))) / 3, 1)  as 'Calificacion Final'
	FROM alumno_grupo ag
	INNER JOIN alumnos a ON a.id = ag.idalumno
	INNER JOIN grupo g ON g.idgrupo = ag.idgrupo
	INNER JOIN calificaciones c ON c.idalumno = ag.idalumno
	INNER JOIN materia m ON m.idmateria = c.idmateria 
	INNER JOIN periodo p ON p.idperiodo = m.idperiodo 
	INNER JOIN carrera ON carrera.idcarrera = p.idcarrera 
	WHERE p.nombre = semestre;
END//
DELIMITER ;

-- Volcando estructura para procedimiento escuela.GetCalificacionFinal
DELIMITER //
CREATE PROCEDURE `GetCalificacionFinal`()
BEGIN
	SELECT p.idperiodo, p.nombre, CONCAT(a.nombre, ' ',  a.ap_paterno) as 'ALUMNO', 
	ROUND(avg(ROUND( (CAST(c.parcial1 as DECIMAL(10,2)) + CAST(c.parcial2 as DECIMAL(10,2)) + CAST(c.parcial3 as DECIMAL(10,2))) / 3, 1)), 1)  as 'Calificacion Final'
	FROM alumno_grupo ag
	INNER JOIN alumnos a ON a.id = ag.idalumno
	INNER JOIN grupo g ON g.idgrupo = ag.idgrupo
	INNER JOIN calificaciones c ON c.idalumno = ag.idalumno
	INNER JOIN materia m ON m.idmateria = c.idmateria 
	INNER JOIN periodo p ON p.idperiodo = c.idperiodo 
	INNER JOIN carrera ON carrera.idcarrera = p.idcarrera
    GROUP BY c.idperiodo, ag.idalumno;
END//
DELIMITER ;

-- Volcando estructura para tabla escuela.grupo
CREATE TABLE IF NOT EXISTS `grupo` (
  `idgrupo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  `idperiodo` int(11) DEFAULT NULL,
  PRIMARY KEY (`idgrupo`),
  KEY `fk_grupo_1_idx` (`idperiodo`),
  CONSTRAINT `fk_grupo_1` FOREIGN KEY (`idperiodo`) REFERENCES `periodo` (`idperiodo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla escuela.grupo: ~0 rows (aproximadamente)
INSERT INTO `grupo` (`idgrupo`, `nombre`, `idperiodo`) VALUES
	(1, '1 - A', 1);

-- Volcando estructura para tabla escuela.materia
CREATE TABLE IF NOT EXISTS `materia` (
  `idmateria` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `idperiodo` int(11) DEFAULT NULL,
  PRIMARY KEY (`idmateria`),
  KEY `fk_materia_1_idx` (`idperiodo`),
  CONSTRAINT `fk_materia_1` FOREIGN KEY (`idperiodo`) REFERENCES `periodo` (`idperiodo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla escuela.materia: ~6 rows (aproximadamente)
INSERT INTO `materia` (`idmateria`, `nombre`, `idperiodo`) VALUES
	(1, 'Matematicas', 2),
	(2, 'Español', 2),
	(3, 'Ciencias', 2),
	(4, 'Quimica', 2),
	(5, 'Psicologia', 2),
	(6, 'Historia', 2);

-- Volcando estructura para tabla escuela.periodo
CREATE TABLE IF NOT EXISTS `periodo` (
  `idperiodo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) DEFAULT NULL,
  `idcarrera` int(11) DEFAULT NULL,
  PRIMARY KEY (`idperiodo`),
  KEY `fk_periodo_1_idx` (`idcarrera`),
  CONSTRAINT `periodo_FK` FOREIGN KEY (`idcarrera`) REFERENCES `carrera` (`idcarrera`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla escuela.periodo: ~2 rows (aproximadamente)
INSERT INTO `periodo` (`idperiodo`, `nombre`, `idcarrera`) VALUES
	(1, '1sem. 2016', 1),
	(2, '2sem. 2016', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
