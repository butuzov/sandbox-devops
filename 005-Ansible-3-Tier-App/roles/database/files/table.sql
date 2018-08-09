DROP TABLE IF EXISTS `visits`;
CREATE TABLE IF NOT EXISTS `visits` (
  `ip` varchar(15) NOT NULL,
  `visits` int(11) NOT NULL DEFAULT '1',
  UNIQUE KEY `ip` (`ip`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
