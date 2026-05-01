<h1>Présentation de l'API</h1>
Cette API est basée sur le dépôt d'origine suivant :<br>
https://github.com/CNED-SLAM/rest_mediatekdocuments<br>
Le readme de ce dépôt présente la structure de l'API (rôle de chaque fichier), comment l'exploiter, et les fonctionnalités déjà présentes.<br>
Les ajouts faits dans cette API ne concernent que le fichier 'MyAccessBDD.php' (dans lequel de nouvelles fonctions ont été ajoutées pour répondre aux demandes de l'application) et la base de données (ajout des tables <em>suivi</em> et <em>utilisateur</em>, ainsi qu'un trigger de contrôle sur la table <em>document</em>).<br>
Cette API permet d'exécuter des requêtes SQL sur la BDD Mediatek86 créée avec le SGBDR MySQL.<br>
Elle est accessible via une authentification "basique" (avec login="admin", pwd="adminpwd").<br>
Sa vocation actuelle est de répondre aux demandes de l'application MediaTekDocuments, mise en ligne sur le dépôt :<br>
https://github.com/User3426/MediaTekDocuments

<h1>Installation de l'API en local</h1>
Pour tester l'API REST en local, voici le mode opératoire (similaire à celui donné dans le dépôt d'origine) :
<ul>
   <li>Installer les outils nécessaires (WampServer ou équivalent, NetBeans ou équivalent pour gérer l'API dans un IDE, Postman pour les tests).</li>
   <li>Télécharger le zip du code de l'API et le dézipper dans le dossier www de WampServer (renommer le dossier en "rest_mediatekdocuments").</li>
   <li>Si 'Composer' n'est pas installé, le télécharger et l'installer depuis ce lien : https://getcomposer.org/Composer-Setup.exe</li>
   <li>Dans une fenêtre de commandes ouverte en mode admin, aller dans le dossier de l'API et taper 'composer install' puis valider pour recréer le vendor.</li>
   <li>Récupérer le script mediatek86.sql en racine du projet puis, avec phpMyAdmin, créer la BDD mediatek86 et, dans cette BDD, exécuter le script pour créer et remplir la BDD.</li>
   <li>Ouvrir l'API dans NetBeans pour pouvoir analyser le code et le faire évoluer suivant les besoins.</li>
   <li>Pour tester l'API avec Postman, ne pas oublier de configurer l'authentification (onglet "Authorization", Type "Basic Auth", Username "admin", Password "adminpwd").</li>
</ul>

<h1>Les fonctionnalités ajoutées</h1>
Dans MyAccessBDD, plusieurs fonctions ont été ajoutées pour répondre aux nouvelles demandes de l'application C# MediaTekDocuments :<br>

<h2>Authentification</h2>
<ul>
   <li><strong>selectUtilisateur : </strong>vérifie le login et le mot de passe d'un utilisateur (le mot de passe est stocké en SHA-256 dans la BDD) et retourne son service si l'authentification réussit. Cette fonction est appelée lors de la connexion à l'application.</li>
</ul>

<h2>Gestion des livres</h2>
<ul>
   <li><strong>insertLivre : </strong>insère un nouveau livre dans les tables <em>document</em>, <em>livres_dvd</em> et <em>livre</em> en une seule transaction. Si l'une des insertions échoue, toutes sont annulées.</li>
   <li><strong>updateLivre : </strong>modifie un livre existant dans les tables <em>document</em> et <em>livre</em> en une seule transaction.</li>
   <li><strong>deleteOneLivre : </strong>supprime un livre dans les tables <em>livre</em>, <em>livres_dvd</em> et <em>document</em> en une seule transaction. Un trigger BDD empêche la suppression si des exemplaires ou des commandes sont rattachés au document.</li>
</ul>

<h2>Gestion des DVD</h2>
<ul>
   <li><strong>insertDvd : </strong>insère un nouveau DVD dans les tables <em>document</em>, <em>livres_dvd</em> et <em>dvd</em> en une seule transaction.</li>
   <li><strong>updateDvd : </strong>modifie un DVD existant dans les tables <em>document</em> et <em>dvd</em> en une seule transaction.</li>
   <li><strong>deleteOneDvd : </strong>supprime un DVD dans les tables <em>dvd</em>, <em>livres_dvd</em> et <em>document</em> en une seule transaction. Soumis au même trigger de contrôle que les livres.</li>
</ul>

<h2>Gestion des revues</h2>
<ul>
   <li><strong>insertRevue : </strong>insère une nouvelle revue dans les tables <em>document</em> et <em>revue</em> en une seule transaction.</li>
   <li><strong>updateRevue : </strong>modifie une revue existante dans les tables <em>document</em> et <em>revue</em> en une seule transaction.</li>
   <li><strong>deleteOneRevue : </strong>supprime une revue dans les tables <em>revue</em> et <em>document</em> en une seule transaction. La suppression est impossible si des exemplaires sont rattachés à la revue.</li>
</ul>

<h2>Gestion des commandes de livres et DVD</h2>
<ul>
   <li><strong>selectCommandeDocument : </strong>récupère toutes les commandes associées à un livre ou un DVD (identifié par son id), avec jointure sur la table <em>suivi</em> pour afficher le libellé de l'étape de suivi. Les commandes sont triées par date décroissante.</li>
   <li><strong>insertCommandeDocument : </strong>insère une nouvelle commande dans les tables <em>commande</em> et <em>commandedocument</em> en une seule transaction.</li>
   <li><strong>updateCommandeDocument : </strong>met à jour l'étape de suivi d'une commande (champ <em>idSuivi</em> dans la table <em>commandedocument</em>).</li>
   <li><strong>deleteOneCommande : </strong>supprime une commande dans la table <em>commande</em> (la suppression en cascade gère automatiquement la ligne associée dans <em>commandedocument</em> ou <em>abonnement</em>).</li>
</ul>

<h2>Gestion des abonnements aux revues</h2>
<ul>
   <li><strong>selectAbonnement : </strong>récupère tous les abonnements associés à une revue dont l'id est donné, avec jointure sur la table <em>commande</em>. Les abonnements sont triés par date de commande décroissante.</li>
   <li><strong>insertAbonnement : </strong>insère un nouvel abonnement dans les tables <em>commande</em> et <em>abonnement</em> en une seule transaction.</li>
   <li><strong>selectAbonnementProcheFin : </strong>récupère les abonnements dont la date de fin est comprise entre aujourd'hui et dans 30 jours, avec le titre de la revue correspondante. Cette fonction est appelée au démarrage de l'application pour afficher une alerte au personnel administratif.</li>
</ul>
