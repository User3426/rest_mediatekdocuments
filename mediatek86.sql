-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 01 mai 2026 à 10:45
-- Version du serveur : 9.1.0
-- Version de PHP : 8.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `mediatek86`
--

-- --------------------------------------------------------

--
-- Structure de la table `abonnement`
--

DROP TABLE IF EXISTS `abonnement`;
CREATE TABLE IF NOT EXISTS `abonnement` (
  `id` varchar(5) NOT NULL,
  `dateFinAbonnement` date DEFAULT NULL,
  `idRevue` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idRevue` (`idRevue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `abonnement`
--

INSERT INTO `abonnement` (`id`, `dateFinAbonnement`, `idRevue`) VALUES
('00013', '2025-12-31', '10012'),
('AB291', '2026-03-07', '10003'),
('AB527', '2026-02-26', '10001'),
('AB654', '2026-03-15', '10004'),
('AB843', '2026-03-02', '10002'),
('AB912', '2026-03-23', '10005'),
('AB999', '2026-12-31', '10001'),
('ABO_A', '2026-02-26', '10001'),
('ABO02', '2026-03-05', '10002'),
('ABO03', '2026-03-15', '10003'),
('ABO04', '2025-01-01', '10004'),
('ABO06', '2026-02-23', '10007'),
('ABO07', '2026-03-30', '10008');

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

DROP TABLE IF EXISTS `commande`;
CREATE TABLE IF NOT EXISTS `commande` (
  `id` varchar(5) NOT NULL,
  `dateCommande` date DEFAULT NULL,
  `montant` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`id`, `dateCommande`, `montant`) VALUES
('00005', '2024-03-15', 45),
('00006', '2024-09-10', 30),
('00007', '2025-01-20', 60),
('00008', '2025-11-05', 30),
('00009', '2023-06-01', 35),
('00010', '2026-01-15', 52.5),
('00011', '2023-03-10', 42),
('00012', '2025-10-05', 28),
('00013', '2025-01-10', 119),
('11111', '2026-02-16', 12),
('48794', '2026-02-16', 3),
('77777', '2026-02-17', 25),
('78921', '2026-03-23', 21),
('78922', '2026-03-24', 15),
('99994', '2026-01-01', 50),
('AB291', '2025-03-07', 88),
('AB527', '2025-02-26', 95),
('AB654', '2025-03-15', 125),
('AB843', '2025-03-02', 110.5),
('AB912', '2025-03-23', 99.9),
('AB999', '2026-01-01', 100),
('ABO_A', '2025-02-26', 95),
('ABO02', '2025-03-05', 95.5),
('ABO03', '2025-03-15', 110),
('ABO04', '2024-01-01', 100),
('ABO06', '2025-02-23', 89.9),
('ABO07', '2025-03-30', 105),
('COM02', '2025-02-01', 200),
('COM03', '2025-02-10', 75),
('COM04', '2024-12-20', 300),
('DVD01', '2026-01-10', 45),
('DVD02', '2025-11-20', 90),
('DVD03', '2025-09-05', 22.5),
('DVD04', '2025-06-15', 67),
('TEST_', '2026-01-01', 50);

--
-- Déclencheurs `commande`
--
DROP TRIGGER IF EXISTS `before_delete_commande`;
DELIMITER $$
CREATE TRIGGER `before_delete_commande` BEFORE DELETE ON `commande` FOR EACH ROW BEGIN
    -- Suppression dans commandedocument si existe
    DELETE FROM commandedocument WHERE id = OLD.id;
    
    -- Suppression dans abonnement si existe
    DELETE FROM abonnement WHERE id = OLD.id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commandedocument`
--

DROP TABLE IF EXISTS `commandedocument`;
CREATE TABLE IF NOT EXISTS `commandedocument` (
  `id` varchar(5) NOT NULL,
  `nbExemplaire` int DEFAULT NULL,
  `idLivreDvd` varchar(10) NOT NULL,
  `idSuivi` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idLivreDvd` (`idLivreDvd`),
  KEY `idSuivi` (`idSuivi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `commandedocument`
--

INSERT INTO `commandedocument` (`id`, `nbExemplaire`, `idLivreDvd`, `idSuivi`) VALUES
('00005', 3, '00002', '00004'),
('00006', 2, '00002', '00003'),
('00007', 4, '00002', '00002'),
('00008', 2, '00002', '00001'),
('00009', 2, '00028', '00004'),
('00010', 3, '00028', '00001'),
('00011', 3, '20003', '00004'),
('00012', 2, '20003', '00003'),
('11111', 4, '00001', '00003'),
('48794', 2, '00001', '00003'),
('77777', 5, '20002', '00003'),
('78921', 3, '00028', '00003'),
('78922', 3, '00028', '00004'),
('99994', 2, '00001', '00002'),
('COM02', 5, '00001', '00002'),
('COM03', 2, '00001', '00003'),
('COM04', 8, '00001', '00004'),
('DVD01', 2, '20002', '00001'),
('DVD02', 4, '20002', '00002'),
('DVD03', 1, '20002', '00003'),
('DVD04', 3, '20002', '00004'),
('TEST_', 2, '00001', '00001');

--
-- Déclencheurs `commandedocument`
--
DROP TRIGGER IF EXISTS `after_commande_livree`;
DELIMITER $$
CREATE TRIGGER `after_commande_livree` AFTER UPDATE ON `commandedocument` FOR EACH ROW BEGIN
    DECLARE v_dateCommande DATE;
    DECLARE v_numeroMax INT;
    DECLARE v_counter INT;
    
    -- Vérifier si on passe à l'état "livrée" (et qu'on ne venait pas déjà de cet état)
    IF NEW.idSuivi = '00003' AND OLD.idSuivi != '00003' THEN
        
        -- Récupérer la date de commande depuis la table commande
        SELECT dateCommande INTO v_dateCommande
        FROM commande
        WHERE id = NEW.id;
        
        -- Récupérer le numéro max actuel pour ce livre/DVD
        -- Si aucun exemplaire n'existe, on commence à 0
        SELECT IFNULL(MAX(numero), 0) INTO v_numeroMax
        FROM exemplaire
        WHERE id = NEW.idLivreDvd;
        
        -- Initialiser le compteur
        SET v_counter = 1;
        
        -- Boucle pour créer les exemplaires
        WHILE v_counter <= NEW.nbExemplaire DO
            INSERT INTO exemplaire (id, numero, dateAchat, photo, idEtat)
            VALUES (
                NEW.idLivreDvd,                    -- id du livre/DVD
                v_numeroMax + v_counter,           -- numéro séquentiel
                v_dateCommande,                    -- date d'achat = date de commande
                '',                                -- photo vide par défaut
                '00001'                            -- état "neuf"
            );
            
            SET v_counter = v_counter + 1;
        END WHILE;
        
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `document`
--

DROP TABLE IF EXISTS `document`;
CREATE TABLE IF NOT EXISTS `document` (
  `id` varchar(10) NOT NULL,
  `titre` varchar(60) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `idRayon` varchar(5) NOT NULL,
  `idPublic` varchar(5) NOT NULL,
  `idGenre` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idRayon` (`idRayon`),
  KEY `idPublic` (`idPublic`),
  KEY `idGenre` (`idGenre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `document`
--

INSERT INTO `document` (`id`, `titre`, `image`, `idRayon`, `idPublic`, `idGenre`) VALUES
('00001', 'Titre Test', '', 'LV001', '00001', '10001'),
('00002', 'Un pays à l\'aube', '', 'LV001', '00002', '10004'),
('00009', 'Pars vite et reviens tard', '', 'LV003', '00002', '10014'),
('00010', 'Le vestibule des causes perdues', '', 'LV001', '00002', '10006'),
('00013', 'Sacré Pêre Noël', '', 'JN001', '00001', '10001'),
('00014', 'Mauvaise étoile', '', 'LV003', '00003', '10014'),
('00015', 'La confrérie des téméraires', '', 'JN002', '00004', '10014'),
('00016', 'Le butin du requin', '', 'JN002', '00004', '10014'),
('00018', 'Le Routard - Maroc', '', 'DV005', '00003', '10011'),
('00021', 'Les déferlantes', '', 'LV002', '00002', '10006'),
('00022', 'Une part de Ciel', '', 'LV002', '00002', '10006'),
('00023', 'Le secret du janissaire', '', 'BD001', '00002', '10001'),
('00024', 'Pavillon noir', '', 'BD001', '00002', '10001'),
('00026', 'La planète des singess', '', 'LV002', '00003', '10002'),
('00028', 'Les heures souterraines', '', 'LV002', '00002', '10006'),
('00100', 'Le Comte de Monte-Cristo', '', 'JN002', '00002', '10007'),
('10001', 'Arts Magazine', '', 'PR002', '00002', '10016'),
('10002', 'Alternatives Economiquesss', '', 'PR002', '00002', '10015'),
('10003', 'Challenges', '', 'PR002', '00002', '10015'),
('10004', 'Rock and Folk', '', 'PR002', '00002', '10016'),
('10005', 'Les Echos', '', 'PR001', '00002', '10015'),
('10007', 'Telerama', '', 'PR002', '00002', '10016'),
('10008', 'L\'Obs', '', 'PR002', '00002', '10018'),
('10010', 'L\'Equipe Magazine', '', 'PR002', '00002', '10017'),
('10011', 'Geo', '', 'PR002', '00003', '10016'),
('10012', 'Philosophie Magazine', '', 'PR002', '00002', '10016'),
('14597', 'tesAjoutRevue', '', 'PR002', '00003', '10017'),
('20001', 'Star Wars', '', 'DF001', '00003', '10002'),
('20002', 'Le seigneur des anneaux : la communauté de l\'anneau', '', 'DF001', '00003', '10019'),
('20003', 'Le Fabuleux Destin d\'Amélie Poulain', '', 'DF001', '00003', '10013'),
('45678', 'Interstellar', '', 'DF001', '00003', '10002'),
('52149', 'Lucky Luke', '', 'DF001', '00003', '10007'),
('63122', 'Revue POST test', '', 'PR001', '00003', '10016'),
('78945', 'Revue POST test', '', 'PR001', '00003', '10016'),
('891247', 'Fear', '', 'DF001', '00004', '10012'),
('99991', 'Livre après PUT', '', 'LV001', '00002', '10006'),
('99993', 'Revue après PUT', '', 'PR001', '00003', '10018'),
('TEST_DVD_9', 'DVD de Test Suppressionnnn', '', 'DF001', '00002', '10003'),
('TEST_POST', 'Livre POST test', '', 'LV001', '00002', '10006'),
('TEST01', 'DVD Test', '', 'DF001', '00003', '10002');

--
-- Déclencheurs `document`
--
DROP TRIGGER IF EXISTS `before_delete_document_check`;
DELIMITER $$
CREATE TRIGGER `before_delete_document_check` BEFORE DELETE ON `document` FOR EACH ROW BEGIN
    DECLARE nb_exemplaires INT;
    DECLARE nb_commandes INT;

    -- Exemplaires
    SELECT COUNT(*) INTO nb_exemplaires
    FROM exemplaire
    WHERE id = OLD.id;

    IF nb_exemplaires > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suppression interdite : exemplaires existants';
    END IF;

    -- Commandes (uniquement pour livres/DVD)
    SELECT COUNT(*) INTO nb_commandes
    FROM commandedocument
    WHERE idLivreDvd = OLD.id;

    IF nb_commandes > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Suppression interdite : commandes existantes';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `dvd`
--

DROP TABLE IF EXISTS `dvd`;
CREATE TABLE IF NOT EXISTS `dvd` (
  `id` varchar(10) NOT NULL,
  `synopsis` text,
  `realisateur` varchar(20) DEFAULT NULL,
  `duree` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `dvd`
--

INSERT INTO `dvd` (`id`, `synopsis`, `realisateur`, `duree`) VALUES
('20001', 'Test', 'Test', 120),
('20002', 'L\'anneau unique, forgé par Sauron, est porté par Fraudon qui l\'amène à Foncombe. De là, des représentants de peuples différents vont s\'unir pour aider Fraudon à amener l\'anneau à la montagne du Destin.', 'Peter Jackson', 228),
('20003', 'Amélie Poulain, jeune serveuse timide, décide de changer la vie des gens qui l\'entourent tout en refusant de s\'occuper de son propre bonheur.', 'Jean-Pierre Jeunet', 122),
('45678', 'des trucs dans l\'espace', 'Christopher Nolan', 200),
('52149', 'yhdfhtjdjdgfjdgj', 'Robert Flamand', 145),
('891247', 'La jeune et innocente Nicole Walker (Reese Witherspoon) a récemment rejoint son père Steve (William Petersen) qui vit maintenant avec sa seconde femme Laura (Amy Brenneman) et son fils. À 16 ans, elle et sa copine Margo Masse (Alyssa Milano) ne pensent qu\'à sortir et s\'amuser. Dans un café, elle tombe sous le charme de David McCall (Mark Wahlberg), qui lui évite une bousculade dans une discothèque et semble être le petit ami idéal. Mais il va se révéler être en réalité un dangereux psychopathe.', 'James Foley', 97);

-- --------------------------------------------------------

--
-- Structure de la table `etat`
--

DROP TABLE IF EXISTS `etat`;
CREATE TABLE IF NOT EXISTS `etat` (
  `id` char(5) NOT NULL,
  `libelle` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `etat`
--

INSERT INTO `etat` (`id`, `libelle`) VALUES
('00001', 'neuf'),
('00002', 'usagé'),
('00003', 'détérioré'),
('00004', 'inutilisable');

-- --------------------------------------------------------

--
-- Structure de la table `exemplaire`
--

DROP TABLE IF EXISTS `exemplaire`;
CREATE TABLE IF NOT EXISTS `exemplaire` (
  `id` varchar(10) NOT NULL,
  `numero` int NOT NULL,
  `dateAchat` date DEFAULT NULL,
  `photo` varchar(500) NOT NULL,
  `idEtat` char(5) NOT NULL,
  PRIMARY KEY (`id`,`numero`),
  KEY `idEtat` (`idEtat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `exemplaire`
--

INSERT INTO `exemplaire` (`id`, `numero`, `dateAchat`, `photo`, `idEtat`) VALUES
('00001', 1, '2026-02-16', '', '00001'),
('00001', 2, '2026-02-16', '', '00001'),
('00001', 3, '2026-02-16', '', '00001'),
('00001', 4, '2026-02-16', '', '00001'),
('00001', 5, '2026-02-16', '', '00001'),
('00001', 6, '2026-02-16', '', '00001'),
('00002', 1, '2024-04-02', '', '00002'),
('00002', 2, '2024-04-02', '', '00002'),
('00002', 3, '2024-04-02', '', '00001'),
('00002', 4, '2024-09-25', '', '00001'),
('00002', 5, '2024-09-25', '', '00001'),
('00028', 1, '2023-06-20', '', '00002'),
('00028', 2, '2023-06-20', '', '00003'),
('00028', 3, '2026-03-23', '', '00001'),
('00028', 4, '2026-03-23', '', '00001'),
('00028', 5, '2026-03-23', '', '00001'),
('00028', 6, '2026-03-24', '', '00001'),
('00028', 7, '2026-03-24', '', '00001'),
('00028', 8, '2026-03-24', '', '00001'),
('10001', 1, '2026-03-05', '', '00001'),
('10001', 997, '2026-01-01', '', '00001'),
('10002', 418, '2021-12-01', '', '00001'),
('10007', 3237, '2021-11-23', '', '00001'),
('10007', 3238, '2021-11-30', '', '00001'),
('10007', 3239, '2021-12-07', '', '00001'),
('10007', 3240, '2021-12-21', '', '00001'),
('10007', 3241, '2026-03-19', '', '00001'),
('10007', 3242, '2026-03-23', '', '00001'),
('10007', 3243, '2026-03-24', '', '00001'),
('10007', 3244, '2026-03-24', '', '00001'),
('10007', 3245, '2026-03-25', '', '00001'),
('10007', 3246, '2026-03-25', '', '00001'),
('10007', 3247, '2026-03-25', '', '00001'),
('10007', 3248, '2026-03-25', '', '00001'),
('10011', 505, '2022-10-16', '', '00001'),
('10011', 506, '2021-04-01', '', '00001'),
('10011', 507, '2021-05-03', '', '00001'),
('10011', 508, '2021-06-05', '', '00001'),
('10011', 509, '2021-07-01', '', '00001'),
('10011', 510, '2021-08-04', '', '00001'),
('10011', 511, '2021-09-01', '', '00001'),
('10011', 512, '2021-10-06', '', '00001'),
('10011', 513, '2021-11-01', '', '00001'),
('10011', 514, '2021-12-01', '', '00001'),
('10012', 1, '2025-02-01', '', '00002'),
('10012', 2, '2025-04-01', '', '00002'),
('10012', 3, '2025-06-01', '', '00001'),
('20002', 1, '2026-02-17', '', '00001'),
('20002', 2, '2026-02-17', '', '00001'),
('20002', 3, '2026-02-17', '', '00001'),
('20002', 4, '2026-02-17', '', '00001'),
('20002', 5, '2026-02-17', '', '00001'),
('20003', 1, '2023-03-28', '', '00002'),
('20003', 2, '2023-03-28', '', '00002'),
('20003', 3, '2023-03-28', '', '00003'),
('20003', 4, '2025-10-20', '', '00001'),
('20003', 5, '2025-10-20', '', '00001');

-- --------------------------------------------------------

--
-- Structure de la table `genre`
--

DROP TABLE IF EXISTS `genre`;
CREATE TABLE IF NOT EXISTS `genre` (
  `id` varchar(5) NOT NULL,
  `libelle` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `genre`
--

INSERT INTO `genre` (`id`, `libelle`) VALUES
('10000', 'Humour'),
('10001', 'Bande dessinée'),
('10002', 'Science Fiction'),
('10003', 'Biographie'),
('10004', 'Historique'),
('10006', 'Roman'),
('10007', 'Aventures'),
('10008', 'Essai'),
('10009', 'Documentaire'),
('10010', 'Technique'),
('10011', 'Voyages'),
('10012', 'Drame'),
('10013', 'Comédie'),
('10014', 'Policier'),
('10015', 'Presse Economique'),
('10016', 'Presse Culturelle'),
('10017', 'Presse sportive'),
('10018', 'Actualités'),
('10019', 'Fantazy');

-- --------------------------------------------------------

--
-- Structure de la table `livre`
--

DROP TABLE IF EXISTS `livre`;
CREATE TABLE IF NOT EXISTS `livre` (
  `id` varchar(10) NOT NULL,
  `ISBN` varchar(13) DEFAULT NULL,
  `auteur` varchar(20) DEFAULT NULL,
  `collection` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `livre`
--

INSERT INTO `livre` (`id`, `ISBN`, `auteur`, `collection`) VALUES
('00002', '1236547896541', 'Dennis Lehanne', ''),
('00009', '', 'Fred Vargas', 'Commissaire Adamsberg'),
('00010', '', 'Manon Moreau', ''),
('00013', '', 'Raymond Briggs', ''),
('00014', '', 'RJ Ellory', ''),
('00015', '', 'Floriane Turmeau', NULL),
('00016', '', 'Julian Press', ''),
('00018', '', '', 'Guide du Routard'),
('00021', '', 'Claudie Gallay', ''),
('00022', '', 'Claudie Gallay', ''),
('00023', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00024', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00026', '', 'Pierre Boulle', NULL),
('00028', '9782246745013', 'Delphine de Vigan', ''),
('00100', '978', 'Alexandre Dumas', 'Classique'),
('99991', '9999999999999', 'Auteur après', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `livres_dvd`
--

DROP TABLE IF EXISTS `livres_dvd`;
CREATE TABLE IF NOT EXISTS `livres_dvd` (
  `id` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `livres_dvd`
--

INSERT INTO `livres_dvd` (`id`) VALUES
('00001'),
('00002'),
('00009'),
('00010'),
('00013'),
('00014'),
('00015'),
('00016'),
('00018'),
('00021'),
('00022'),
('00023'),
('00024'),
('00026'),
('00028'),
('00100'),
('20001'),
('20002'),
('20003'),
('45678'),
('52149'),
('891247'),
('99991'),
('TEST_POST'),
('TEST01');

-- --------------------------------------------------------

--
-- Structure de la table `public`
--

DROP TABLE IF EXISTS `public`;
CREATE TABLE IF NOT EXISTS `public` (
  `id` varchar(5) NOT NULL,
  `libelle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `public`
--

INSERT INTO `public` (`id`, `libelle`) VALUES
('00001', 'Jeunesse'),
('00002', 'Adultes'),
('00003', 'Tous publics'),
('00004', 'Ados');

-- --------------------------------------------------------

--
-- Structure de la table `rayon`
--

DROP TABLE IF EXISTS `rayon`;
CREATE TABLE IF NOT EXISTS `rayon` (
  `id` char(5) NOT NULL,
  `libelle` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `rayon`
--

INSERT INTO `rayon` (`id`, `libelle`) VALUES
('BD001', 'BD Adultes'),
('BL001', 'Beaux Livres'),
('DF001', 'DVD films'),
('DV001', 'Sciences'),
('DV002', 'Maison'),
('DV003', 'Santé'),
('DV004', 'Littérature classique'),
('DV005', 'Voyages'),
('JN001', 'Jeunesse BD'),
('JN002', 'Jeunesse romans'),
('LV001', 'Littérature étrangère'),
('LV002', 'Littérature française'),
('LV003', 'Policiers français étrangers'),
('PR001', 'Presse quotidienne'),
('PR002', 'Magazines');

-- --------------------------------------------------------

--
-- Structure de la table `revue`
--

DROP TABLE IF EXISTS `revue`;
CREATE TABLE IF NOT EXISTS `revue` (
  `id` varchar(10) NOT NULL,
  `periodicite` varchar(2) DEFAULT NULL,
  `delaiMiseADispo` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `revue`
--

INSERT INTO `revue` (`id`, `periodicite`, `delaiMiseADispo`) VALUES
('10001', 'MS', 52),
('10002', 'HB', 52),
('10003', 'HB', 15),
('10004', 'HB', 15),
('10005', 'QT', 5),
('10007', 'HB', 26),
('10008', 'HB', 26),
('10010', 'HB', 12),
('10011', 'MS', 52),
('10012', 'HB', 30),
('14597', 'MS', 45),
('63122', 'MS', 30),
('78945', 'MS', 30),
('99993', 'HB', 15);

-- --------------------------------------------------------

--
-- Structure de la table `service`
--

DROP TABLE IF EXISTS `service`;
CREATE TABLE IF NOT EXISTS `service` (
  `idservice` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  PRIMARY KEY (`idservice`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `service`
--

INSERT INTO `service` (`idservice`, `nom`) VALUES
(1, 'Administratif'),
(2, 'Prêts'),
(3, 'Culture');

-- --------------------------------------------------------

--
-- Structure de la table `suivi`
--

DROP TABLE IF EXISTS `suivi`;
CREATE TABLE IF NOT EXISTS `suivi` (
  `id` varchar(5) NOT NULL,
  `libelle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `suivi`
--

INSERT INTO `suivi` (`id`, `libelle`) VALUES
('00001', 'en cours'),
('00002', 'relancée'),
('00003', 'livrée'),
('00004', 'réglée');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE IF NOT EXISTS `utilisateur` (
  `idutilisateur` int NOT NULL AUTO_INCREMENT,
  `login` varchar(50) NOT NULL,
  `pwd` varchar(64) NOT NULL,
  `idservice` int NOT NULL,
  PRIMARY KEY (`idutilisateur`),
  KEY `idservice` (`idservice`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`idutilisateur`, `login`, `pwd`, `idservice`) VALUES
(1, 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
(2, 'jdupont', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 2),
(3, 'mmartin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 3);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `abonnement`
--
ALTER TABLE `abonnement`
  ADD CONSTRAINT `abonnement_ibfk_1` FOREIGN KEY (`id`) REFERENCES `commande` (`id`),
  ADD CONSTRAINT `abonnement_ibfk_2` FOREIGN KEY (`idRevue`) REFERENCES `revue` (`id`);

--
-- Contraintes pour la table `commandedocument`
--
ALTER TABLE `commandedocument`
  ADD CONSTRAINT `commandedocument_ibfk_1` FOREIGN KEY (`id`) REFERENCES `commande` (`id`),
  ADD CONSTRAINT `commandedocument_ibfk_2` FOREIGN KEY (`idLivreDvd`) REFERENCES `livres_dvd` (`id`),
  ADD CONSTRAINT `commandedocument_ibfk_3` FOREIGN KEY (`idSuivi`) REFERENCES `suivi` (`id`);

--
-- Contraintes pour la table `document`
--
ALTER TABLE `document`
  ADD CONSTRAINT `document_ibfk_1` FOREIGN KEY (`idRayon`) REFERENCES `rayon` (`id`),
  ADD CONSTRAINT `document_ibfk_2` FOREIGN KEY (`idPublic`) REFERENCES `public` (`id`),
  ADD CONSTRAINT `document_ibfk_3` FOREIGN KEY (`idGenre`) REFERENCES `genre` (`id`);

--
-- Contraintes pour la table `dvd`
--
ALTER TABLE `dvd`
  ADD CONSTRAINT `dvd_ibfk_1` FOREIGN KEY (`id`) REFERENCES `livres_dvd` (`id`);

--
-- Contraintes pour la table `exemplaire`
--
ALTER TABLE `exemplaire`
  ADD CONSTRAINT `exemplaire_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`),
  ADD CONSTRAINT `exemplaire_ibfk_2` FOREIGN KEY (`idEtat`) REFERENCES `etat` (`id`);

--
-- Contraintes pour la table `livre`
--
ALTER TABLE `livre`
  ADD CONSTRAINT `livre_ibfk_1` FOREIGN KEY (`id`) REFERENCES `livres_dvd` (`id`);

--
-- Contraintes pour la table `livres_dvd`
--
ALTER TABLE `livres_dvd`
  ADD CONSTRAINT `livres_dvd_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`);

--
-- Contraintes pour la table `revue`
--
ALTER TABLE `revue`
  ADD CONSTRAINT `revue_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`);

--
-- Contraintes pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD CONSTRAINT `utilisateur_ibfk_1` FOREIGN KEY (`idservice`) REFERENCES `service` (`idservice`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
