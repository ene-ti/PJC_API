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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
INSERT INTO `album` VALUES (1,'Harakiri',1),(2,'Black Blooms',1),(3,'The Rough Dog',1),(4,'The Rising Tied',2),(6,'Post Traumatic EP',2),(7,'Where\'d You Go',2),(8,'Bem Sertanejo',3),(9,'Bem Sertanejo - O Show (Ao Vivo)',3),(10,'Bem Sertanejo - (1ª Temporada) - EP',3),(11,'Use Your IIIlusion I',4),(12,'Use Your IIIlusion II',4),(13,'ALBUM alterado',22),(15,'ALBUM novo nome',2),(16,'NOVO ALBUM',2),(17,'NOVO ALBUM',2),(18,'MAIS UM NOVO ALBUM',2),(19,'NOVO ALBUM final',3),(20,'NOVO ALBUM final',3),(26,'NOVO ALBUM finDDDDDal',3);
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artista`
--

LOCK TABLES `artista` WRITE;
/*!40000 ALTER TABLE `artista` DISABLE KEYS */;
INSERT INTO `artista` VALUES (1,'Serj tankian','Cantor'),(2,'Mike Shinoda','Cantor'),(3,'Michel Teló','Cantor'),(4,'Guns N´Roses','Banda'),(5,'Luan Santana','Cantor'),(6,'Leonardo','Cantor'),(7,'Raca Negra','Banda'),(8,'Caetano Veloso','Cantor'),(9,'Marilia Mendonça','Cantor'),(10,'Roberta Miranda','Cantor'),(11,'Raça Negra','Banda'),(12,'Daniel','Cantor'),(13,'Zeze de Camargo e Luciano','Banda'),(14,'Chitaozinho e Xororo','Dupla'),(15,'Roberto Carlos','Cantor'),(16,'Sula Miranda','Cantor'),(17,'Alcione','Cantor'),(18,'Tonico e Tinoco','Dupla'),(19,'Liu e Leo','Dupla'),(20,'Tião Carreiro e Pardinho','Dupla'),(21,'Pena Branca e Xavantinho','Dupla'),(22,'Legiao Urbana','Banda'),(23,'Titãs','Banda'),(24,'Os Paralamos do Sucesso','Banda'),(25,'Capital Inicial','Banda'),(26,'Barao Vermelho','Banda'),(27,'Kid Abelha','Banda'),(28,'Blitz','Banda'),(29,'Jota Quest','Banda'),(31,'Skank','Banda'),(32,'Nelsimar','Cantor'),(33,'alterado Nelsimar','tudo'),(34,'Novo Nelsimar','Cantor'),(38,'Novo Nelsimar','Cantor');
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
  `id_alb` int(11) NOT NULL,
  `cp_nome` varchar(100) NOT NULL,
  `cp_url` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`cp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `capa`
--

LOCK TABLES `capa` WRITE;
/*!40000 ALTER TABLE `capa` DISABLE KEYS */;
INSERT INTO `capa` VALUES (1,1,'Serj Tankian - Harakiri.jpg','https://play.min.io/pjc-artistaxalbum/Serj%20Tankian%20-%20Harakiri.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010700Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=805a427dc9165a7998ab746ff04ea319425ddc62665062b8e4371195683e240e'),(2,2,'Serj Tankian - Black Blooms.jpg','https://play.min.io/pjc-artistaxalbum/Serj%20Tankian%20-%20Black%20Blooms.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010715Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=3a62665af586f3d9c1d0c052fa0a2ce6ebc2978e9572856b765423538e4c4809'),(3,3,'Serj Tankian - The Rough Dog.jpg','https://play.min.io/pjc-artistaxalbum/Serj%20Tankian%20-%20The%20Rough%20Dog.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010634Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=ee8e62dd90a5b59b67c13b3a2bef851556214f46c745dc4498d146f4d196c8e4'),(4,4,'Mike Shinoda - The Rising Tied.jpg','https://play.min.io/pjc-artistaxalbum/Mike%20Shinoda%20-%20The%20Rising%20Tied.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010737Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=b99d39bec0aea221def3dca4b0e2d04986db9e0158997642bd2488680d00e31a'),(5,5,'Mike Shinoda - Post Traumatic.jpg','https://play.min.io/pjc-artistaxalbum/Mike%20Shinoda%20-%20Post%20Traumatic.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010759Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=306c2e390840aaad52bdd97c07f3e696be5e76ddd30dbe77aff08922b589bdd8'),(6,8,'Michel Teló - Bem Sertanejo.jpg','https://play.min.io/pjc-artistaxalbum/Michel%20Tel%C3%B3%20-%20Bem%20Sertanejo.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010831Z&X-Amz-Expires=518400&X-Amz-SignedHeaders=host&X-Amz-Signature=e7062d3d77207adcee4d206560ac57f520b364d8abf71e716895078c0b9e07a9'),(7,9,'Michel Teló - Bem Sertanejo o Show.jpg','https://play.min.io/pjc-artistaxalbum/Michel%20Tel%C3%B3%20-%20Bem%20Sertanejo%20o%20Show.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010850Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=db38d6a91d41dcf79ff6e76eae4ca6480438883f1d4ae2c68914b40d41e4737d'),(8,11,'Guns N Roses - Use Your IIIlusion I.jpg','https://play.min.io/pjc-artistaxalbum/Guns%20N%20Roses%20-%20Use%20Your%20IIIlusion%20I.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010916Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=b25fbf83ce8c529d891227ef0fc5aa7eb3e596ab86b50cfc426d000578586fd8'),(9,12,'Guns N Roses - Use Your IIIlusion II.jpg','https://play.min.io/pjc-artistaxalbum/Guns%20N%20Roses%20-%20Use%20Your%20IIIlusion%20II.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010903Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=b8882c80071e23146f45a2f0b9349adec4c2acae0ad77a761d66df8c64709608'),(10,13,'Guns N Roses - Greatest Hits.jpg','https://play.min.io/pjc-artistaxalbum/Guns%20N%20Roses%20-%20Greatest%20Hits.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010948Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=1760997cb3a4264603c954cdeeeaba8f331f9ebe2ac11e881c2f391c01db9fde'),(11,13,'Guns N Roses - Greatest Hits-2.jpg','https://play.min.io/pjc-artistaxalbum/Guns%20N%20Roses%20-%20Greatest%20Hits-2.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010937Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=92601fcfec66ced6f7497f9ae31979bb808206e94891265b4162cfeb9192bbe3'),(12,13,'Guns N Roses - Greatest Hits-3.jpg','https://play.min.io/pjc-artistaxalbum/Guns%20N%20Roses%20-%20Greatest%20Hits-3.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=Q3AM3UQ867SPQQA43P2F%2F20210201%2F%2Fs3%2Faws4_request&X-Amz-Date=20210201T010927Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=840cd47bc5eeb832b568b374747f1ad7d06e788b70a5ff0952633daf54437bfd'),(20,16,'noma da capa','url da capa');
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

-- Dump completed on 2021-02-04 13:01:26
