/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 5.5.24 : Database - swms
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`swms` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `swms`;

/*Table structure for table `assignment` */

DROP TABLE IF EXISTS `assignment`;

CREATE TABLE `assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '作业ID',
  `title` varchar(128) DEFAULT NULL COMMENT '标题',
  `course` int(11) DEFAULT NULL COMMENT '所属课程',
  `teacher` int(11) DEFAULT NULL COMMENT '部署作业的教师',
  `descr` text COMMENT '作业描述',
  `timeCreated` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `assignment` */

insert  into `assignment`(`id`,`title`,`course`,`teacher`,`descr`,`timeCreated`) values (5,'20180120test3',1001,51,'test3','2018-01-20 10:58:17'),(6,'20180120test4',1001,51,'test4','2018-01-20 10:59:33'),(10,'10180121test4',1001,51,'test4','2018-01-21 11:17:42'),(11,'20180121test1',1002,52,'test1','2018-01-21 12:04:01'),(12,'20180121test2',1002,52,'test2','2018-01-21 12:04:10'),(13,'20180121test3',1003,52,'test3','2018-01-21 12:04:20'),(14,'20180121test4',1003,52,'test4','2018-01-21 12:04:27'),(15,'20180124test1',1002,52,'test1','2018-01-24 12:47:46'),(16,'20180128test1',1002,52,'test1','2018-01-28 13:42:05'),(17,'20180128test2',1003,52,'test2','2018-01-28 13:42:16'),(18,'20180130test1',1004,53,'test1','2018-01-30 16:40:33');

/*Table structure for table `course` */

DROP TABLE IF EXISTS `course`;

CREATE TABLE `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(128) DEFAULT NULL COMMENT '课程名',
  `teacher` int(11) DEFAULT NULL COMMENT '代课教师',
  `timeCreated` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1005 DEFAULT CHARSET=utf8;

/*Data for the table `course` */

insert  into `course`(`id`,`title`,`teacher`,`timeCreated`) values (1001,'数字电路',51,'2017-06-27 18:21:28'),(1002,'编译原理',52,'2017-06-27 18:21:43'),(1003,'C语言',52,'2017-06-27 18:22:11'),(1004,'大学英语',53,'2017-06-27 18:24:38');

/*Table structure for table `exercise` */

DROP TABLE IF EXISTS `exercise`;

CREATE TABLE `exercise` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '学生提交的作业ID',
  `title` varchar(128) DEFAULT NULL COMMENT '与assignment一致',
  `assignment` int(11) DEFAULT NULL COMMENT '题目ID',
  `course` int(11) DEFAULT NULL COMMENT '课程ID',
  `teachear` int(11) DEFAULT NULL COMMENT '教师ID',
  `student` varchar(64) DEFAULT NULL COMMENT '学生ID',
  `status` tinyint(4) DEFAULT NULL COMMENT '状态: 0, 普通; 1, 已经提交;100,已经验收;-1,退回',
  `score` tinyint(4) DEFAULT NULL COMMENT '分数。0-100',
  `timeCreated` datetime DEFAULT NULL COMMENT '创建时间',
  `timeCommit` datetime DEFAULT NULL COMMENT '提交时间',
  `storePath` varchar(256) DEFAULT NULL COMMENT '附件存储位置',
  `files` varchar(512) DEFAULT NULL COMMENT '附件列表',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `exercise` */

insert  into `exercise`(`id`,`title`,`assignment`,`course`,`teachear`,`student`,`status`,`score`,`timeCreated`,`timeCommit`,`storePath`,`files`) values (5,'20180128test1',16,1002,52,'20170001',100,12,'2018-01-28 13:42:06',NULL,'files/201801/28/456.log',NULL),(6,'20180128test1',16,1002,52,'20170002',100,21,'2018-01-28 13:42:06',NULL,NULL,NULL),(8,'20180128test2',17,1003,52,'20170001',1,0,'2018-01-28 13:42:16',NULL,'files/201801/28/123.txt',NULL),(9,'20180128test2',17,1003,52,'20170002',1,0,'2018-01-28 13:42:16',NULL,'files/17/20170002/123.txt',NULL),(10,'20180128test2',17,1003,52,'20170003',0,0,'2018-01-28 13:42:16',NULL,NULL,NULL),(11,'20180130test1',18,1004,53,'20170001',0,0,'2018-01-30 16:40:33',NULL,NULL,NULL),(12,'20180130test1',18,1004,53,'20170002',100,99,'2018-01-30 16:40:33',NULL,'files/18/20170002/456.log',NULL),(13,'20180130test1',18,1004,53,'20170003',0,0,'2018-01-30 16:40:33',NULL,NULL,NULL);

/*Table structure for table `student` */

DROP TABLE IF EXISTS `student`;

CREATE TABLE `student` (
  `id` varchar(64) NOT NULL COMMENT '学生ID (登录ID)',
  `password` varchar(64) DEFAULT NULL COMMENT '登录密码',
  `displayName` varchar(64) DEFAULT NULL COMMENT '显示名称',
  `cellphone` varchar(16) DEFAULT NULL COMMENT '手机号',
  `timeCreated` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `student` */

insert  into `student`(`id`,`password`,`displayName`,`cellphone`,`timeCreated`) values ('20170001','1','学生A','13810012345','2017-06-27 18:25:42'),('20170002','1','学生B','13810012345','2017-06-27 18:25:44'),('20170003','1','学生C','13810012345','2017-06-27 18:25:46');

/*Table structure for table `teacher` */

DROP TABLE IF EXISTS `teacher`;

CREATE TABLE `teacher` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '教师ID',
  `username` varchar(64) DEFAULT NULL COMMENT '登录名',
  `password` varchar(64) DEFAULT NULL,
  `displayName` varchar(64) DEFAULT NULL COMMENT '显示名称(汉字名称)',
  `cellphone` varchar(16) DEFAULT NULL COMMENT '手机号',
  `timeCreated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

/*Data for the table `teacher` */

insert  into `teacher`(`id`,`username`,`password`,`displayName`,`cellphone`,`timeCreated`) values (51,'wang','1','王老师','18600000000','2017-06-27 18:22:47'),(52,'shaofa','1','邵老师','18600000001','2017-06-27 18:23:11'),(53,'xx','1','XX老师','18600000002','2017-06-27 18:23:56');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
