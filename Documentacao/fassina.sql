-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: fassina
-- ------------------------------------------------------
-- Server version	8.0.28

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
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `CodEmp` int NOT NULL,
  `Codigo` int NOT NULL,
  `Nome` varchar(60) NOT NULL,
  `Cidade` varchar(60) DEFAULT NULL,
  `UF` char(2) DEFAULT NULL,
  `Ativo` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`CodEmp`,`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,1,'Mercado do Lucas','Sinop','MT',1),(1,2,'Padaria do João','Sorriso','MT',1),(1,3,'Fran','Sinop','MT',1),(1,4,'Thiago Fassina','Sinop','MT',1),(1,5,'Itamar Fassina','Sinop','MT',1),(1,6,'Ederson','Sinop','MT',1),(1,7,'Plinio','Cuiabá','MT',1),(1,8,'Nazare','Sorriso','MT',1),(1,9,'João','Cuiabá','MT',1),(1,10,'Heber','São Paulo','SP',1),(1,11,'Edson','Sinop','MT',1),(1,12,'Maria','Sinop','MT',1),(1,13,'José','Sinop','MT',1),(1,14,'Diogo','Sorriso','MT',1),(1,15,'Bruno','Sorriso','MT',1),(1,16,'Delcivan','Sorriso','MT',1),(1,17,'Cleyton','Sorriso','MT',1),(1,18,'Jeovani','Sorriso','MT',1),(1,19,'Luar','Sinop','MT',1),(1,20,'Rodrigo','Sinop','MT',1),(2,1,'Casa do construtor','Sinop','MT',1),(2,2,'Google','São Paulo','SP',1);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresas`
--

DROP TABLE IF EXISTS `empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresas` (
  `Codigo` int NOT NULL AUTO_INCREMENT,
  `Descricao` varchar(40) NOT NULL,
  `Cnpj` varchar(18) DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresas`
--

LOCK TABLES `empresas` WRITE;
/*!40000 ALTER TABLE `empresas` DISABLE KEYS */;
INSERT INTO `empresas` VALUES (1,'Fassina Sistemas','99.999.999/0001-01'),(2,'WK Technology','05.345.992/0001-02');
/*!40000 ALTER TABLE `empresas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `CodEmp` int NOT NULL,
  `Codigo` int NOT NULL,
  `Descricao` varchar(60) NOT NULL,
  `Valor` decimal(18,5) NOT NULL DEFAULT '0.00000',
  `Ativo` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`CodEmp`,`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,1,'Software Erp',5000.00000,1),(1,2,'Migração BD',3000.00000,1),(1,3,'Alteração Simples',1500.00000,1),(1,4,'Camera Monitoramento',500.00000,1),(1,5,'Monitor',500.00000,1),(1,6,'Teclado',500.00000,1),(1,7,'Mouse',100.00000,1),(1,8,'Processador',5000.00000,1),(1,9,'Monitor Dell',1000.00000,1),(1,10,'Processador I5',15000.00000,1),(1,11,'Pc Gamer',1000.00000,1),(1,12,'Mouse Pad',10.00000,1),(1,13,'Banana',15.00000,1),(1,14,'Melancia',500.00000,1),(1,15,'Corda',5.00000,1),(1,16,'Pilha',10.00000,1),(1,17,'Celular Samsung',1500.00000,1),(1,18,'Celular Apple',3000.00000,1),(1,19,'Acerola',15.00000,1),(1,20,'Graviola',5.00000,1),(2,1,'Teclado Dell',500.00000,1),(2,2,'Monitor Dell',4000.00000,1);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sequencial`
--

DROP TABLE IF EXISTS `sequencial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sequencial` (
  `CodEmp` int NOT NULL,
  `Seq_Clientes` int NOT NULL DEFAULT '0',
  `Seq_Produtos` int NOT NULL DEFAULT '0',
  `Seq_Usuarios` int NOT NULL DEFAULT '0',
  `Seq_Venda` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`CodEmp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sequencial`
--

LOCK TABLES `sequencial` WRITE;
/*!40000 ALTER TABLE `sequencial` DISABLE KEYS */;
INSERT INTO `sequencial` VALUES (1,0,0,0,7),(2,0,0,0,0);
/*!40000 ALTER TABLE `sequencial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `CodEmp` int NOT NULL,
  `Codigo` int NOT NULL,
  `Nome` varchar(60) NOT NULL,
  `Senha` varchar(60) NOT NULL,
  `Ativo` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`CodEmp`,`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,1,'Thiago','Thiago',1),(1,2,'Fran','123',1),(1,3,'Fassina','123',1),(2,1,'Adm','Adm',1),(2,2,'Luar','589',1);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venda_cab`
--

DROP TABLE IF EXISTS `venda_cab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venda_cab` (
  `CodEmp` int NOT NULL,
  `Cod_Venda` int NOT NULL,
  `Dt_Emissao` date NOT NULL,
  `Cod_Cliente` int NOT NULL,
  `Valor_Total` decimal(18,5) NOT NULL,
  PRIMARY KEY (`CodEmp`,`Cod_Venda`),
  KEY `FK_venda_clientes` (`CodEmp`,`Cod_Cliente`),
  CONSTRAINT `FK_venda_clientes` FOREIGN KEY (`CodEmp`, `Cod_Cliente`) REFERENCES `clientes` (`CodEmp`, `Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venda_cab`
--

LOCK TABLES `venda_cab` WRITE;
/*!40000 ALTER TABLE `venda_cab` DISABLE KEYS */;
INSERT INTO `venda_cab` VALUES (1,1,'2022-04-17',1,38500.00000),(1,2,'2022-04-17',9,1000.00000),(1,3,'2022-04-17',8,16500.00000),(1,4,'2022-04-17',5,86500.00000),(1,6,'2022-04-17',1,57000.00000),(1,7,'2022-04-17',2,23000.00000);
/*!40000 ALTER TABLE `venda_cab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venda_pro`
--

DROP TABLE IF EXISTS `venda_pro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venda_pro` (
  `Sequencia` int NOT NULL AUTO_INCREMENT,
  `CodEmp` int NOT NULL,
  `Cod_Venda` int NOT NULL,
  `Cod_Produto` int NOT NULL,
  `Quantidade` decimal(18,5) NOT NULL,
  `Vlr_Uni` decimal(18,5) NOT NULL,
  `Vlr_Total` decimal(18,5) NOT NULL,
  PRIMARY KEY (`Sequencia`,`CodEmp`,`Cod_Venda`),
  UNIQUE KEY `AutoIncrem` (`Sequencia`),
  KEY `FK_venda` (`CodEmp`,`Cod_Venda`),
  KEY `FK_venda_produtos` (`CodEmp`,`Cod_Produto`),
  CONSTRAINT `FK_venda` FOREIGN KEY (`CodEmp`, `Cod_Venda`) REFERENCES `venda_cab` (`CodEmp`, `Cod_Venda`),
  CONSTRAINT `FK_venda_produtos` FOREIGN KEY (`CodEmp`, `Cod_Produto`) REFERENCES `produtos` (`CodEmp`, `Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venda_pro`
--

LOCK TABLES `venda_pro` WRITE;
/*!40000 ALTER TABLE `venda_pro` DISABLE KEYS */;
INSERT INTO `venda_pro` VALUES (1,1,1,1,2.00000,5000.00000,10000.00000),(2,1,1,1,2.00000,5000.00000,10000.00000),(3,1,1,1,0.50000,5000.00000,2500.00000),(4,1,1,2,2.00000,3000.00000,6000.00000),(5,1,1,1,2.00000,5000.00000,10000.00000),(18,1,3,5,5.00000,500.00000,2500.00000),(19,1,3,5,4.00000,500.00000,2000.00000),(20,1,3,2,3.00000,3000.00000,9000.00000),(21,1,3,5,6.00000,500.00000,3000.00000),(22,1,2,5,2.00000,500.00000,1000.00000),(23,1,4,5,18.00000,500.00000,9000.00000),(24,1,4,9,75.00000,1000.00000,75000.00000),(25,1,4,14,5.00000,500.00000,2500.00000),(38,1,7,1,2.00000,5000.00000,10000.00000),(39,1,7,5,6.00000,500.00000,3000.00000),(40,1,7,1,2.00000,5000.00000,10000.00000),(41,1,6,2,3.00000,3000.00000,9000.00000),(42,1,6,5,6.00000,500.00000,3000.00000),(43,1,6,8,9.00000,5000.00000,45000.00000);
/*!40000 ALTER TABLE `venda_pro` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-17 11:15:50
