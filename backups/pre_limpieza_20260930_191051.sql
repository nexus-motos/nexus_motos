-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: centerbeam.proxy.rlwy.net    Database: nexus_motos
-- ------------------------------------------------------
-- Server version	9.7.2

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `tbl_venta`
--

DROP TABLE IF EXISTS `tbl_venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_venta` (
  `venta_id` int NOT NULL AUTO_INCREMENT,
  `venta_fecha_venta` datetime NOT NULL,
  `venta_tipo_comprobante` varchar(7) NOT NULL,
  `venta_monto_efectivo` decimal(8,2) DEFAULT NULL,
  `venta_subtotal` decimal(8,2) NOT NULL,
  `venta_costo_igv` decimal(8,2) NOT NULL,
  `venta_igv` decimal(8,2) NOT NULL,
  `venta_total` decimal(8,2) NOT NULL,
  `venta_nro_documento` varchar(45) NOT NULL,
  `venta_eliminado` tinyint(1) DEFAULT '0',
  `metodo_pago_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `venta_cliente_ruc` varchar(45) DEFAULT NULL,
  `venta_cliente_ruc_razon_social` varchar(245) DEFAULT NULL,
  `venta_cliente_ruc_direccion` varchar(245) DEFAULT NULL,
  `venta_cliente_ruc_telefono` varchar(45) DEFAULT NULL,
  `venta_cliente_ruc_correo` varchar(245) DEFAULT NULL,
  `venta_online` tinyint DEFAULT '0',
  `venta_online_entregado` tinyint DEFAULT '0',
  PRIMARY KEY (`venta_id`),
  KEY `fk_tbl_venta_tbl_metodo_pago1_idx` (`metodo_pago_id`),
  KEY `fk_tbl_venta_tbl_cliente1_idx` (`cliente_id`),
  KEY `fk_tbl_venta_tbl_usuario1_idx` (`usuario_id`),
  CONSTRAINT `fk_tbl_venta_tbl_cliente1` FOREIGN KEY (`cliente_id`) REFERENCES `tbl_cliente` (`cliente_id`),
  CONSTRAINT `fk_tbl_venta_tbl_metodo_pago1` FOREIGN KEY (`metodo_pago_id`) REFERENCES `tbl_metodo_pago` (`metodo_pago_id`),
  CONSTRAINT `fk_tbl_venta_tbl_usuario1` FOREIGN KEY (`usuario_id`) REFERENCES `tbl_usuario` (`usuario_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_venta`
--

LOCK TABLES `tbl_venta` WRITE;
/*!40000 ALTER TABLE `tbl_venta` DISABLE KEYS */;
INSERT INTO `tbl_venta` VALUES (1,'2025-06-20 01:29:56','Factura',5294.40,4486.78,807.62,18.00,5294.40,'F001-00000001',0,1,1,4,NULL,NULL,NULL,NULL,NULL,0,0),(2,'2025-06-20 01:37:34','Factura',6157.44,5218.17,939.27,18.00,6157.44,'F001-00000002',0,1,2,4,NULL,NULL,NULL,NULL,NULL,0,0),(3,'2025-06-20 01:46:32','Boleta',5472.96,4638.10,834.86,18.00,5472.96,'B001-00000001',0,1,3,4,NULL,NULL,NULL,NULL,NULL,0,0),(4,'2025-06-20 01:49:40','Boleta',8124.48,6885.15,1239.33,18.00,8124.48,'B001-00000002',0,1,4,5,NULL,NULL,NULL,NULL,NULL,0,0),(5,'2025-06-20 01:53:32','Boleta',7915.20,6707.80,1207.40,18.00,7915.20,'B001-00000003',0,1,5,6,NULL,NULL,NULL,NULL,NULL,0,0),(6,'2025-07-03 16:43:59','Boleta',5000.00,11389.02,2050.02,18.00,13439.04,'B001-00000004',0,3,1,2,NULL,NULL,NULL,NULL,NULL,0,0),(10,'2025-08-30 20:36:03','Boleta',230.00,194.92,35.09,18.00,230.00,'B001-00000005',0,1,6,14,NULL,NULL,NULL,NULL,NULL,1,1),(11,'2025-08-31 23:11:06','Boleta',280.00,237.29,42.71,18.00,280.00,'B001-00000006',0,1,6,14,NULL,NULL,NULL,NULL,NULL,1,0),(12,'2025-09-02 16:41:34','Boleta',336.00,284.75,51.25,18.00,336.00,'B001-00000007',0,1,1,2,NULL,NULL,NULL,NULL,NULL,0,0),(13,'2025-09-03 07:16:31','Boleta',1000.00,5548.47,998.73,18.00,6547.20,'B001-00000008',0,3,1,2,NULL,NULL,NULL,NULL,NULL,0,0),(14,'2025-09-03 07:19:18','Boleta',360.00,305.08,54.92,18.00,360.00,'B001-00000009',0,1,2,2,NULL,NULL,NULL,NULL,NULL,0,0),(15,'2025-09-03 19:30:05','Boleta',336.00,284.75,51.25,18.00,336.00,'B001-00000010',0,1,2,2,NULL,NULL,NULL,NULL,NULL,0,0),(16,'2025-09-05 01:05:51','Factura',6600.00,5593.22,1006.78,18.00,6600.00,'F001-00000003',0,1,2,2,NULL,NULL,NULL,NULL,NULL,0,0),(17,'2025-09-05 01:55:51','Boleta',260.00,220.34,39.66,18.00,260.00,'B001-00000011',0,1,6,14,NULL,NULL,NULL,NULL,NULL,1,0),(18,'2025-09-05 02:04:19','Boleta',400.00,338.98,61.02,18.00,400.00,'B001-00000012',0,1,11,14,NULL,NULL,NULL,NULL,NULL,1,0),(19,'2025-09-05 02:11:18','Boleta',400.00,338.98,61.02,18.00,400.00,'B001-00000013',0,1,11,14,NULL,NULL,NULL,NULL,NULL,1,0),(20,'2025-09-05 02:40:55','Boleta',290.00,245.76,44.24,18.00,290.00,'B001-00000014',0,1,11,14,NULL,NULL,NULL,NULL,NULL,1,0),(21,'2025-09-05 03:11:12','Boleta',340.00,288.14,51.87,18.00,340.00,'B001-00000015',0,1,11,14,NULL,NULL,NULL,NULL,NULL,1,0),(22,'2025-09-05 03:23:02','Boleta',270.00,228.81,41.19,18.00,270.00,'B001-00000016',0,1,18,14,NULL,NULL,NULL,NULL,NULL,1,0),(23,'2025-09-05 03:40:37','Boleta',400.00,338.98,61.02,18.00,400.00,'B001-00000017',0,1,19,14,NULL,NULL,NULL,NULL,NULL,1,0),(24,'2025-09-05 19:44:59','Boleta',230.00,194.92,35.09,18.00,230.00,'B001-00000018',0,1,11,14,NULL,NULL,NULL,NULL,NULL,1,0),(25,'2026-09-28 00:36:22','Boleta',400.00,338.98,61.02,18.00,400.00,'B001-00000019',0,1,20,14,NULL,NULL,NULL,NULL,NULL,1,0),(26,'2026-09-28 00:47:46','Boleta',230.00,194.92,35.09,18.00,230.00,'B001-00000020',0,1,20,14,NULL,NULL,NULL,NULL,NULL,1,0),(27,'2026-09-28 01:54:58','Boleta',200.00,169.49,30.51,18.00,200.00,'B001-00000021',0,1,22,14,NULL,NULL,NULL,NULL,NULL,1,0),(28,'2026-09-28 04:20:37','Boleta',340.00,288.14,51.87,18.00,340.00,'B001-00000022',0,1,23,14,NULL,NULL,NULL,NULL,NULL,1,0);
/*!40000 ALTER TABLE `tbl_venta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_det_venta`
--

DROP TABLE IF EXISTS `tbl_det_venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_det_venta` (
  `det_venta_id` int NOT NULL AUTO_INCREMENT,
  `det_venta_cantidad` int NOT NULL,
  `det_venta_precio_unitario` decimal(8,2) NOT NULL,
  `det_venta_subtotal` decimal(8,2) NOT NULL,
  `det_venta_dcto` decimal(8,2) NOT NULL,
  `det_venta_total` decimal(8,2) NOT NULL,
  `det_venta_precio_costo` decimal(8,2) NOT NULL DEFAULT '0.00',
  `venta_id` int NOT NULL,
  `prod_id` int NOT NULL,
  PRIMARY KEY (`det_venta_id`),
  KEY `fk_tbl_det_venta_tbl_venta1_idx` (`venta_id`),
  KEY `fk_tbl_det_venta_tbl_producto1_idx` (`prod_id`),
  CONSTRAINT `fk_tbl_det_venta_tbl_producto1` FOREIGN KEY (`prod_id`) REFERENCES `tbl_producto` (`prod_id`),
  CONSTRAINT `fk_tbl_det_venta_tbl_venta1` FOREIGN KEY (`venta_id`) REFERENCES `tbl_venta` (`venta_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_det_venta`
--

LOCK TABLES `tbl_det_venta` WRITE;
/*!40000 ALTER TABLE `tbl_det_venta` DISABLE KEYS */;
INSERT INTO `tbl_det_venta` VALUES (1,1,5294.40,5294.40,0.00,5294.40,0.00,1,1),(2,1,6157.44,6157.44,0.00,6157.44,0.00,2,8),(3,1,5472.96,5472.96,0.00,5472.96,0.00,3,7),(4,1,8124.48,8124.48,0.00,8124.48,0.00,4,2),(5,1,7915.20,7915.20,0.00,7915.20,0.00,5,4),(6,1,13439.04,13439.04,0.00,13439.04,0.00,6,3),(13,1,230.00,230.00,0.00,230.00,0.00,10,27),(14,1,280.00,280.00,0.00,280.00,0.00,11,25),(15,1,336.00,336.00,0.00,336.00,0.00,12,25),(16,1,6547.20,6547.20,0.00,6547.20,0.00,13,1),(17,2,180.00,360.00,0.00,360.00,0.00,14,34),(18,1,336.00,336.00,0.00,336.00,0.00,15,28),(19,1,6600.00,6600.00,0.00,6600.00,0.00,16,10),(20,1,260.00,260.00,0.00,260.00,0.00,17,32),(21,1,400.00,400.00,0.00,400.00,0.00,18,26),(22,1,400.00,400.00,0.00,400.00,0.00,19,26),(23,1,290.00,290.00,0.00,290.00,0.00,20,33),(24,1,340.00,340.00,0.00,340.00,0.00,21,39),(25,1,270.00,270.00,0.00,270.00,0.00,22,29),(26,1,400.00,400.00,0.00,400.00,0.00,23,26),(27,1,230.00,230.00,0.00,230.00,0.00,24,27),(28,2,200.00,400.00,0.00,400.00,0.00,25,38),(29,1,230.00,230.00,0.00,230.00,0.00,26,27),(30,1,200.00,200.00,0.00,200.00,0.00,27,38),(31,1,340.00,340.00,0.00,340.00,0.00,28,39);
/*!40000 ALTER TABLE `tbl_det_venta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_salida`
--

DROP TABLE IF EXISTS `tbl_salida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_salida` (
  `salida_id` int NOT NULL AUTO_INCREMENT,
  `salida_fecha` datetime NOT NULL,
  `salida_subtotal` decimal(8,2) DEFAULT NULL,
  `salida_costo_igv` decimal(8,2) DEFAULT NULL,
  `salida_igv` decimal(8,2) DEFAULT NULL,
  `salida_costo_total` decimal(8,2) DEFAULT NULL,
  `salida_num_doc` varchar(45) NOT NULL,
  `salida_motivo` varchar(200) DEFAULT NULL,
  `salida_eliminado` tinyint(1) DEFAULT '0',
  `tipo_doc_almacen_id` int NOT NULL,
  `venta_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `salida_online` tinyint DEFAULT '0',
  `salida_online_entregado` tinyint DEFAULT '0',
  PRIMARY KEY (`salida_id`),
  KEY `fk_tbl_salida_tbl_tipo_doc_almacen1_idx` (`tipo_doc_almacen_id`),
  KEY `fk_tbl_salida_tbl_venta1_idx` (`venta_id`),
  KEY `fk_tbl_salida_tbl_usuario1_idx` (`usuario_id`),
  CONSTRAINT `fk_tbl_salida_tbl_tipo_doc_almacen1` FOREIGN KEY (`tipo_doc_almacen_id`) REFERENCES `tbl_tipo_doc_almacen` (`tipo_doc_almacen_id`),
  CONSTRAINT `fk_tbl_salida_tbl_usuario1` FOREIGN KEY (`usuario_id`) REFERENCES `tbl_usuario` (`usuario_id`),
  CONSTRAINT `fk_tbl_salida_tbl_venta1` FOREIGN KEY (`venta_id`) REFERENCES `tbl_venta` (`venta_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_salida`
--

LOCK TABLES `tbl_salida` WRITE;
/*!40000 ALTER TABLE `tbl_salida` DISABLE KEYS */;
INSERT INTO `tbl_salida` VALUES (1,'2025-06-20 01:29:56',4486.78,807.62,18.00,5294.40,'F001-00000001','VENTA',0,2,1,4,0,0),(2,'2025-06-20 01:37:34',5218.17,939.27,18.00,6157.44,'F001-00000002','VENTA',0,2,2,4,0,0),(3,'2025-06-20 01:46:32',4638.10,834.86,18.00,5472.96,'B001-00000001','VENTA',0,1,3,4,0,0),(4,'2025-06-20 01:49:40',6885.15,1239.33,18.00,8124.48,'B001-00000002','VENTA',0,1,4,5,0,0),(5,'2025-06-20 01:53:32',6707.80,1207.40,18.00,7915.20,'B001-00000003','VENTA',0,1,5,6,0,0),(6,'2025-07-03 16:43:59',11389.02,2050.02,18.00,13439.04,'B001-00000004','VENTA',0,1,6,2,0,0),(10,'2025-08-30 20:36:03',194.92,35.09,18.00,230.00,'B001-00000005','VENTA',0,1,10,14,1,1),(11,'2025-08-31 23:11:06',237.29,42.71,18.00,280.00,'B001-00000006','VENTA',0,1,11,14,1,0),(12,'2025-09-02 16:41:34',284.75,51.25,18.00,336.00,'B001-00000007','VENTA',0,1,12,2,0,0),(13,'2025-09-03 07:16:31',5548.47,998.73,18.00,6547.20,'B001-00000008','VENTA',0,1,13,2,0,0),(14,'2025-09-03 07:19:18',305.08,54.92,18.00,360.00,'B001-00000009','VENTA',0,1,14,2,0,0),(15,'2025-09-03 19:30:05',284.75,51.25,18.00,336.00,'B001-00000010','VENTA',0,1,15,2,0,0),(16,'2025-09-05 01:05:51',5593.22,1006.78,18.00,6600.00,'F001-00000003','VENTA',0,2,16,2,0,0),(17,'2025-09-05 01:55:51',220.34,39.66,18.00,260.00,'B001-00000011','VENTA',0,1,17,14,1,0),(18,'2025-09-05 02:04:19',338.98,61.02,18.00,400.00,'B001-00000012','VENTA',0,1,18,14,1,0),(19,'2025-09-05 02:11:18',338.98,61.02,18.00,400.00,'B001-00000013','VENTA',0,1,19,14,1,0),(20,'2025-09-05 02:40:55',245.76,44.24,18.00,290.00,'B001-00000014','VENTA',0,1,20,14,1,0),(21,'2025-09-05 03:11:12',288.14,51.87,18.00,340.00,'B001-00000015','VENTA',0,1,21,14,1,0),(22,'2025-09-05 03:23:02',228.81,41.19,18.00,270.00,'B001-00000016','VENTA',0,1,22,14,1,0),(23,'2025-09-05 03:40:37',338.98,61.02,18.00,400.00,'B001-00000017','VENTA',0,1,23,14,1,0),(24,'2025-09-05 19:44:59',194.92,35.09,18.00,230.00,'B001-00000018','VENTA',0,1,24,14,1,0),(25,'2026-09-28 00:36:22',338.98,61.02,18.00,400.00,'B001-00000019','VENTA',0,1,25,14,1,0),(26,'2026-09-28 00:47:46',194.92,35.09,18.00,230.00,'B001-00000020','VENTA',0,1,26,14,1,0),(27,'2026-09-28 01:54:58',169.49,30.51,18.00,200.00,'B001-00000021','VENTA',0,1,27,14,1,0),(28,'2026-09-28 04:20:37',288.14,51.87,18.00,340.00,'B001-00000022','VENTA',0,1,28,14,1,0);
/*!40000 ALTER TABLE `tbl_salida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_det_salida`
--

DROP TABLE IF EXISTS `tbl_det_salida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_det_salida` (
  `det_salida_id` int NOT NULL AUTO_INCREMENT,
  `det_salida_cantidad` int DEFAULT NULL,
  `det_salida_precio_salida` decimal(8,2) DEFAULT NULL,
  `det_salida_sub_total` decimal(8,2) DEFAULT NULL,
  `prod_id` int NOT NULL,
  `salida_id` int NOT NULL,
  PRIMARY KEY (`det_salida_id`),
  KEY `fk_tbl_det_salida_tbl_producto1_idx` (`prod_id`),
  KEY `fk_tbl_det_salida_tbl_salida1_idx` (`salida_id`),
  CONSTRAINT `fk_tbl_det_salida_tbl_producto1` FOREIGN KEY (`prod_id`) REFERENCES `tbl_producto` (`prod_id`),
  CONSTRAINT `fk_tbl_det_salida_tbl_salida1` FOREIGN KEY (`salida_id`) REFERENCES `tbl_salida` (`salida_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_det_salida`
--

LOCK TABLES `tbl_det_salida` WRITE;
/*!40000 ALTER TABLE `tbl_det_salida` DISABLE KEYS */;
INSERT INTO `tbl_det_salida` VALUES (1,1,5294.40,5294.40,1,1),(2,1,6157.44,6157.44,8,2),(3,1,5472.96,5472.96,7,3),(4,1,8124.48,8124.48,2,4),(5,1,7915.20,7915.20,4,5),(6,1,13439.04,13439.04,3,6),(13,1,230.00,230.00,27,10),(14,1,280.00,280.00,25,11),(15,1,336.00,336.00,25,12),(16,1,6547.20,6547.20,1,13),(17,2,180.00,360.00,34,14),(18,1,336.00,336.00,28,15),(19,1,6600.00,6600.00,10,16),(20,1,260.00,260.00,32,17),(21,1,400.00,400.00,26,18),(22,1,400.00,400.00,26,19),(23,1,290.00,290.00,33,20),(24,1,340.00,340.00,39,21),(25,1,270.00,270.00,29,22),(26,1,400.00,400.00,26,23),(27,1,230.00,230.00,27,24),(28,2,200.00,400.00,38,25),(29,1,230.00,230.00,27,26),(30,1,200.00,200.00,38,27),(31,1,340.00,340.00,39,28);
/*!40000 ALTER TABLE `tbl_det_salida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_kardex`
--

DROP TABLE IF EXISTS `tbl_kardex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_kardex` (
  `prod_id` int NOT NULL,
  `kardex_fecha_mov` datetime NOT NULL,
  `kardex_cantidad_total_entrada` int DEFAULT NULL,
  `kardex_ultimo_precio_entrada` decimal(7,2) DEFAULT NULL,
  `kardex_cantidad_total_salida` int DEFAULT NULL,
  `kardex_ultimo_precio_salida` decimal(7,2) DEFAULT NULL,
  `kardex_stock_actual` int NOT NULL,
  `kardex_precio_vigente` decimal(7,2) NOT NULL,
  `kardex_costo_total_saldo` decimal(8,2) NOT NULL,
  `kardex_stock_minimo` int NOT NULL,
  `kardex_porcentaje_utilidad` decimal(5,2) NOT NULL,
  PRIMARY KEY (`prod_id`),
  CONSTRAINT `fk_kardex_producto` FOREIGN KEY (`prod_id`) REFERENCES `tbl_producto` (`prod_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_kardex`
--

LOCK TABLES `tbl_kardex` WRITE;
/*!40000 ALTER TABLE `tbl_kardex` DISABLE KEYS */;
INSERT INTO `tbl_kardex` VALUES (1,'2025-09-03 07:16:31',0,0.00,1,5456.00,3,5456.00,16368.00,2,20.00),(2,'2025-06-20 01:49:41',0,0.00,1,6770.40,2,6770.40,13540.80,2,20.00),(3,'2025-07-03 16:43:55',0,0.00,1,11199.20,2,11199.20,22398.40,2,20.00),(4,'2025-06-20 01:53:32',0,0.00,1,6596.00,2,6596.00,13192.00,2,20.00),(7,'2025-06-20 01:46:33',0,0.00,1,4560.80,2,4560.80,9121.60,2,20.00),(8,'2025-06-20 01:37:35',0,0.00,1,5131.20,2,5131.20,10262.40,2,20.00),(9,'2025-07-11 14:54:48',2,6000.00,0,0.00,2,6000.00,12000.00,2,20.00),(10,'2025-09-05 01:05:50',0,0.00,1,5500.00,2,5500.00,11000.00,2,20.00),(11,'2025-07-11 14:54:52',2,7000.00,0,0.00,2,7000.00,14000.00,2,20.00),(12,'2025-07-11 14:54:53',2,5000.00,0,0.00,2,5000.00,10000.00,2,20.00),(13,'2025-07-11 14:54:55',3,4500.00,0,0.00,3,4500.00,13500.00,2,20.00),(16,'2025-06-19 22:53:49',2,15421.12,0,0.00,2,15421.12,30842.24,2,20.00),(25,'2025-09-02 16:41:34',0,0.00,1,280.00,3,280.00,840.00,2,20.00),(26,'2025-09-05 03:40:37',0,0.00,1,400.00,6,400.00,2400.00,2,20.00),(27,'2026-09-28 00:47:46',0,0.00,1,230.00,1,230.00,230.00,2,20.00),(28,'2025-09-03 19:30:05',0,0.00,1,280.00,2,280.00,560.00,2,20.00),(29,'2025-09-05 03:23:01',0,0.00,1,270.00,4,270.00,1080.00,2,20.00),(30,'2025-08-08 01:14:08',3,340.00,0,0.00,3,340.00,1020.00,2,20.00),(31,'2025-08-08 01:10:40',5,270.00,0,0.00,5,270.00,1350.00,2,20.00),(32,'2025-09-05 01:55:51',0,0.00,1,260.00,2,260.00,520.00,2,20.00),(33,'2025-09-05 02:40:54',0,0.00,1,290.00,3,290.00,870.00,2,20.00),(34,'2025-09-03 07:19:19',0,0.00,2,150.00,3,150.00,450.00,2,20.00),(35,'2025-08-08 01:14:09',3,60.00,0,0.00,3,60.00,180.00,2,20.00),(36,'2025-08-08 01:10:42',5,180.00,0,0.00,5,180.00,900.00,2,20.00),(38,'2026-09-28 01:54:58',0,0.00,1,200.00,0,0.00,0.00,2,20.00),(39,'2026-09-28 04:20:36',0,0.00,1,340.00,3,340.00,1020.00,2,20.00),(40,'2025-08-08 01:14:10',3,250.00,0,0.00,3,250.00,750.00,2,20.00),(41,'2025-09-05 01:00:20',1,5000.00,0,0.00,1,5000.00,5000.00,2,20.00);
/*!40000 ALTER TABLE `tbl_kardex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_financiamiento`
--

DROP TABLE IF EXISTS `tbl_financiamiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_financiamiento` (
  `financia_id` int NOT NULL AUTO_INCREMENT,
  `financia_monto_financiado` decimal(7,2) NOT NULL,
  `financia_numero_cuotas` int NOT NULL,
  `financia_tasa_interes` decimal(4,2) NOT NULL,
  `financia_total_interes` decimal(7,2) NOT NULL,
  `financia_monto_total` decimal(7,2) NOT NULL,
  `financia_fecha_registro` date NOT NULL,
  `financia_estado` varchar(9) NOT NULL,
  `venta_id` int NOT NULL,
  PRIMARY KEY (`financia_id`),
  KEY `fk_tbl_financiamiento_tbl_venta1_idx` (`venta_id`),
  CONSTRAINT `fk_tbl_financiamiento_tbl_venta1` FOREIGN KEY (`venta_id`) REFERENCES `tbl_venta` (`venta_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_financiamiento`
--

LOCK TABLES `tbl_financiamiento` WRITE;
/*!40000 ALTER TABLE `tbl_financiamiento` DISABLE KEYS */;
INSERT INTO `tbl_financiamiento` VALUES (1,8439.04,12,5.00,421.95,8860.99,'2025-07-03','PAGADO',6),(2,5547.20,1,0.50,27.74,5574.94,'2025-09-03','PENDIENTE',13);
/*!40000 ALTER TABLE `tbl_financiamiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_det_financiamiento`
--

DROP TABLE IF EXISTS `tbl_det_financiamiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_det_financiamiento` (
  `det_finan_id` int NOT NULL AUTO_INCREMENT,
  `det_finan_num_cuota` int NOT NULL,
  `det_finan_monto_cuota` decimal(7,2) NOT NULL,
  `det_finan_fch_pago_max` date NOT NULL,
  `det_finan_fch_pago_realiza` date DEFAULT NULL,
  `det_finan_estado_pago` varchar(9) NOT NULL,
  `det_finan_comprob_imagen` varchar(255) DEFAULT NULL,
  `financia_id` int NOT NULL,
  PRIMARY KEY (`det_finan_id`),
  KEY `fk_tbl_det_financiamiento_tbl_financiamiento1_idx` (`financia_id`),
  CONSTRAINT `fk_tbl_det_financiamiento_tbl_financiamiento1` FOREIGN KEY (`financia_id`) REFERENCES `tbl_financiamiento` (`financia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_det_financiamiento`
--

LOCK TABLES `tbl_det_financiamiento` WRITE;
/*!40000 ALTER TABLE `tbl_det_financiamiento` DISABLE KEYS */;
INSERT INTO `tbl_det_financiamiento` VALUES (1,1,738.42,'2025-08-15','2025-07-05','PAGADO','boucher1.jpg',1),(2,2,738.42,'2025-09-15','2025-07-05','PAGADO','boucher2.jpg',1),(3,3,738.42,'2025-10-15','2025-07-06','PAGADO','boucher3.jpg',1),(4,4,738.42,'2025-11-15','2025-07-06','PAGADO','boucher4.jpg',1),(5,5,738.42,'2025-12-15','2025-07-06','PAGADO','boucher5.jpg',1),(6,6,738.42,'2026-01-15','2025-07-06','PAGADO','boucher6.jpg',1),(7,7,738.42,'2026-02-15','2025-07-06','PAGADO','boucher7.jpg',1),(8,8,738.42,'2026-03-15','2025-07-06','PAGADO','boucher8.jpg',1),(9,9,738.42,'2026-04-15','2025-07-08','PAGADO','boucher9.jpg',1),(10,10,738.42,'2026-05-15','2025-07-08','PAGADO','boucher10.jpg',1),(11,11,738.42,'2026-06-15','2025-07-08','PAGADO','boucher11.jpg',1),(12,12,738.42,'2026-07-15','2025-07-08','PAGADO','boucher12.jpg',1),(13,1,5574.94,'2025-10-05',NULL,'PENDIENTE',NULL,2);
/*!40000 ALTER TABLE `tbl_det_financiamiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_producto_serie`
--

DROP TABLE IF EXISTS `tbl_producto_serie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_producto_serie` (
  `prod_ser_id` int NOT NULL AUTO_INCREMENT,
  `prod_ser_serie` varchar(40) NOT NULL,
  `prod_ser_estado` int NOT NULL,
  `prod_ser_fecha_sit` datetime NOT NULL,
  `det_entrada_id` int NOT NULL,
  `det_salida_id` int DEFAULT NULL,
  PRIMARY KEY (`prod_ser_id`),
  KEY `fk_tbl_producto_serie_tbl_det_entrada1_idx` (`det_entrada_id`),
  KEY `fk_tbl_producto_serie_tbl_det_salida1_idx` (`det_salida_id`),
  CONSTRAINT `fk_tbl_producto_serie_tbl_det_entrada1` FOREIGN KEY (`det_entrada_id`) REFERENCES `tbl_det_entrada` (`det_entrada_id`),
  CONSTRAINT `fk_tbl_producto_serie_tbl_det_salida1` FOREIGN KEY (`det_salida_id`) REFERENCES `tbl_det_salida` (`det_salida_id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_producto_serie`
--

LOCK TABLES `tbl_producto_serie` WRITE;
/*!40000 ALTER TABLE `tbl_producto_serie` DISABLE KEYS */;
INSERT INTO `tbl_producto_serie` VALUES (1,'118-2023-10-196317_IT.242',2,'2025-06-20 01:29:56',2,1),(2,'118-2023-10-196317_IT.243',1,'2025-06-19 21:52:44',2,NULL),(3,'118-2023-10-196317_IT.244',2,'2025-09-03 07:16:31',2,16),(4,'118-2024-08-173422_IT.345',2,'2025-06-20 01:49:40',3,4),(5,'118-2024-08-173422_IT.346',1,'2025-06-19 21:52:44',3,NULL),(6,'118-2024-08-173422_IT.347',1,'2025-06-19 21:52:44',3,NULL),(7,'118-2023-12-181732_IT.477',2,'2025-07-03 16:43:59',4,6),(8,'118-2023-12-181732_IT.478',1,'2025-06-19 21:59:28',4,NULL),(9,'118-2023-12-181732_IT.479',1,'2025-06-19 21:59:28',4,NULL),(10,'118-2024-01-181732_IT.187',2,'2025-06-20 01:53:32',5,5),(11,'118-2024-01-181732_IT.188',1,'2025-06-19 21:59:28',5,NULL),(12,'118-2024-01-181732_IT.189',1,'2025-06-19 21:59:28',5,NULL),(13,'119-2025-01-112815_IT.014',2,'2025-06-20 01:46:32',6,3),(14,'119-2025-01-112815_IT.015',1,'2025-06-19 22:03:14',6,NULL),(15,'119-2025-01-112815_IT.016',1,'2025-06-19 22:03:14',6,NULL),(16,'119-2025-01-112815_IT.011',2,'2025-06-20 01:37:34',7,2),(17,'119-2025-01-112815_IT.012',1,'2025-06-19 22:03:14',7,NULL),(18,'119-2025-01-112815_IT.013',1,'2025-06-19 22:03:14',7,NULL),(19,'119-2024-11-157456_IT.022',1,'2025-06-19 22:53:49',8,NULL),(20,'119-2024-11-157456_IT.023',1,'2025-06-19 22:53:49',8,NULL),(21,'101-2024-11-196310_IT.113',1,'2025-07-11 14:54:46',9,NULL),(22,'101-2024-11-196310_IT.114',1,'2025-07-11 14:54:46',9,NULL),(23,'101-2024-11-196310_IT.111',1,'2025-07-11 14:54:46',10,NULL),(24,'101-2024-11-196310_IT.112',1,'2025-07-11 14:54:46',10,NULL),(25,'101-2024-11-196310_IT.108',2,'2025-09-05 01:05:51',11,19),(26,'101-2024-11-196310_IT.109',1,'2025-07-11 14:54:46',11,NULL),(27,'101-2024-11-196310_IT.110',1,'2025-07-11 14:54:46',11,NULL),(28,'101-2024-11-196310_IT.115',1,'2025-07-11 14:54:46',12,NULL),(29,'101-2024-11-196310_IT.116',1,'2025-07-11 14:54:46',12,NULL),(30,'101-2024-11-196310_IT.106',1,'2025-07-11 14:54:46',13,NULL),(31,'101-2024-11-196310_IT.107',1,'2025-07-11 14:54:46',13,NULL),(32,'101-2024-11-196310_IT.103',1,'2025-07-11 14:54:46',14,NULL),(33,'101-2024-11-196310_IT.104',1,'2025-07-11 14:54:46',14,NULL),(34,'101-2024-11-196310_IT.105',1,'2025-07-11 14:54:46',14,NULL),(40,'100001',1,'2025-08-08 01:00:08',16,NULL),(41,'100002',1,'2025-08-08 01:00:08',16,NULL),(42,'100003',1,'2025-08-08 01:00:08',16,NULL),(43,'100004',1,'2025-08-08 01:00:08',16,NULL),(44,'100005',1,'2025-08-08 01:00:08',16,NULL),(45,'100026',1,'2025-08-08 01:10:38',17,NULL),(46,'100027',1,'2025-08-08 01:10:38',17,NULL),(47,'100028',2,'2025-09-02 16:41:34',17,15),(48,'100029',1,'2025-08-08 01:10:38',17,NULL),(49,'100030',1,'2025-08-08 01:10:38',17,NULL),(50,'100011',1,'2025-08-08 01:10:38',18,NULL),(51,'100012',1,'2025-08-08 01:10:38',18,NULL),(52,'100013',1,'2025-08-08 01:10:38',18,NULL),(53,'100014',1,'2025-08-08 01:10:38',18,NULL),(54,'100015',1,'2025-08-08 01:10:38',18,NULL),(55,'100031',1,'2025-08-08 01:10:38',19,NULL),(56,'100032',1,'2025-08-08 01:10:38',19,NULL),(57,'100033',1,'2025-08-08 01:10:38',19,NULL),(58,'100034',1,'2025-08-08 01:10:38',19,NULL),(59,'100035',1,'2025-08-08 01:10:38',19,NULL),(60,'100036',2,'2025-09-03 07:19:18',20,17),(61,'100037',2,'2025-09-03 07:19:18',20,17),(62,'100038',1,'2025-08-08 01:10:38',20,NULL),(63,'100039',1,'2025-08-08 01:10:38',20,NULL),(64,'100040',1,'2025-08-08 01:10:38',20,NULL),(65,'100016',1,'2025-08-08 01:10:38',21,NULL),(66,'100017',1,'2025-08-08 01:10:38',21,NULL),(67,'100018',1,'2025-08-08 01:10:38',21,NULL),(68,'100019',1,'2025-08-08 01:10:38',21,NULL),(69,'100020',1,'2025-08-08 01:10:38',21,NULL),(70,'100021',1,'2025-08-08 01:10:38',22,NULL),(71,'100022',1,'2025-08-08 01:10:38',22,NULL),(72,'100023',1,'2025-08-08 01:10:38',22,NULL),(73,'100024',1,'2025-08-08 01:10:38',22,NULL),(74,'100025',1,'2025-08-08 01:10:38',22,NULL),(75,'100050',2,'2025-09-03 19:30:05',23,18),(76,'100051',1,'2025-08-08 01:14:07',23,NULL),(77,'100052',1,'2025-08-08 01:14:07',23,NULL),(78,'100056',1,'2025-08-08 01:14:07',24,NULL),(79,'100057',1,'2025-08-08 01:14:07',24,NULL),(80,'100058',1,'2025-08-08 01:14:07',24,NULL),(81,'100053',1,'2025-08-08 01:14:07',25,NULL),(82,'100054',1,'2025-08-08 01:14:07',25,NULL),(83,'100055',1,'2025-08-08 01:14:07',25,NULL),(84,'100047',1,'2025-08-08 01:14:07',26,NULL),(85,'100048',1,'2025-08-08 01:14:07',26,NULL),(86,'100049',1,'2025-08-08 01:14:07',26,NULL),(87,'100041',1,'2025-08-08 01:14:07',27,NULL),(88,'100042',1,'2025-08-08 01:14:07',27,NULL),(89,'100043',1,'2025-08-08 01:14:07',27,NULL),(90,'100044',1,'2025-08-08 01:14:07',28,NULL),(91,'100045',1,'2025-08-08 01:14:07',28,NULL),(92,'100046',1,'2025-08-08 01:14:07',28,NULL),(93,'100075',1,'2025-08-08 01:16:43',29,NULL),(94,'100076',1,'2025-08-08 01:16:43',29,NULL),(95,'100077',1,'2025-08-08 01:16:43',29,NULL),(96,'100078',1,'2025-08-08 01:16:43',29,NULL),(97,'100059',1,'2025-08-08 01:16:43',30,NULL),(98,'100060',1,'2025-08-08 01:16:43',30,NULL),(99,'100061',1,'2025-08-08 01:16:43',30,NULL),(100,'100062',1,'2025-08-08 01:16:43',30,NULL),(101,'100071',1,'2025-08-08 01:16:43',31,NULL),(102,'100072',1,'2025-08-08 01:16:43',31,NULL),(103,'100073',1,'2025-08-08 01:16:43',31,NULL),(104,'100074',1,'2025-08-08 01:16:43',31,NULL),(105,'117-2024-10-196317_IT.873',1,'2025-09-05 01:00:20',32,NULL);
/*!40000 ALTER TABLE `tbl_producto_serie` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-30 19:11:08
