-- MariaDB dump 10.17  Distrib 10.4.14-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: db_pjc
-- ------------------------------------------------------
-- Server version	10.4.14-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `db_pjc`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `db_pjc` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `db_pjc`;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `album` (
  `alb_id` int(11) NOT NULL AUTO_INCREMENT,
  `alb_nome` varchar(50) NOT NULL,
  `id_art` int(11) NOT NULL,
  PRIMARY KEY (`alb_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
INSERT INTO `album` VALUES (1,'Harakiri',1),(2,'Black Blooms',1),(3,'The Rough Dog',1),(4,'The Rising Tied',2),(5,'Post Traumatic',2),(6,'Post Traumatic EP',2),(7,'Where\'d You Go',2),(8,'Bem Sertanejo',3),(9,'Bem Sertanejo - O Show (Ao Vivo)',3),(10,'Bem Sertanejo - (1ª Temporada) - EP',3),(11,'Use Your IIIlusion I',4),(12,'Use Your IIIlusion II',4),(13,'Greatest Hits',4),(15,'NOVO ALBUM',1),(16,'NOVO ALBUM',2);
/*!40000 ALTER TABLE `album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artista`
--

DROP TABLE IF EXISTS `artista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `artista` (
  `art_id` int(11) NOT NULL AUTO_INCREMENT,
  `art_nome` varchar(50) NOT NULL,
  `art_categoria` varchar(50) NOT NULL,
  PRIMARY KEY (`art_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artista`
--

LOCK TABLES `artista` WRITE;
/*!40000 ALTER TABLE `artista` DISABLE KEYS */;
INSERT INTO `artista` VALUES (1,'Serj tankian','Cantor'),(2,'Mike Shinoda','Cantor'),(3,'Michel Teló','Cantor'),(4,'Guns N´Roses','Banda'),(5,'Luan Santana','Cantor'),(6,'Leonardo','Cantor'),(7,'Raca Negra','Banda'),(8,'Caetano Veloso','Cantor'),(9,'Marilia Mendonça','Cantor'),(10,'Roberta Miranda','Cantor'),(11,'Raça Negra','Banda'),(12,'Daniel','Cantor'),(13,'Zeze de Camargo e Luciano','Banda'),(14,'Chitaozinho e Xororo','Dupla'),(15,'Roberto Carlos','Cantor'),(16,'Sula Miranda','Cantor'),(17,'Alcione','Cantor'),(18,'Tonico e Tinoco','Dupla'),(19,'Liu e Leo','Dupla'),(20,'Tião Carreiro e Pardinho','Dupla'),(21,'Pena Branca e Xavantinho','Dupla'),(22,'Legiao Urbana','Banda'),(23,'Titãs','Banda'),(24,'Os Paralamos do Sucesso','Banda'),(25,'Capital Inicial','Banda'),(26,'Barao Vermelho','Banda'),(27,'Kid Abelha','Banda'),(28,'Blitz','Banda'),(29,'Jota Quest','Banda'),(30,'Roupa Nova','Banda'),(31,'Skank','Banda'),(32,'Nelsimar','Cantor'),(33,'alterado Nelsimar','tudo'),(34,'Novo Nelsimar','Cantor');
/*!40000 ALTER TABLE `artista` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `capa`
--

DROP TABLE IF EXISTS `capa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `capa` (
  `cp_id` int(11) NOT NULL AUTO_INCREMENT,
  `albid` int(11) NOT NULL,
  `cp_url` varchar(100) NOT NULL,
  PRIMARY KEY (`cp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `capa`
--

LOCK TABLES `capa` WRITE;
/*!40000 ALTER TABLE `capa` DISABLE KEYS */;
/*!40000 ALTER TABLE `capa` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-16 19:54:18
