<?php
include_once("AccessBDD.php");

/**
 * Classe de construction des requêtes SQL
 * hérite de AccessBDD qui contient les requêtes de base
 * Pour ajouter une requête :
 * - créer la fonction qui crée une requête (prendre modèle sur les fonctions 
 *   existantes qui ne commencent pas par 'traitement')
 * - ajouter un 'case' dans un des switch des fonctions redéfinies 
 * - appeler la nouvelle fonction dans ce 'case'
 */
class MyAccessBDD extends AccessBDD {
	    
    /**
     * constructeur qui appelle celui de la classe mère
     */
    public function __construct(){
        try{
            parent::__construct();
        }catch(\Exception $e){
            throw $e;
        }
    }

    /**
     * demande de recherche
     * @param string $table
     * @param array|null $champs nom et valeur de chaque champ
     * @return array|null tuples du résultat de la requête ou null si erreur
     * @override
     */	
    protected function traitementSelect(string $table, ?array $champs) : ?array{
        switch($table){  
            case "livre" :
                return $this->selectAllLivres();
            case "dvd" :
                return $this->selectAllDvd();
            case "revue" :
                return $this->selectAllRevues();
            case "exemplaire" :
                return $this->selectExemplairesRevue($champs);
            case "commandedocument" :
                return $this->selectCommandeDocument($champs);
            case "genre" :
            case "public" :
            case "rayon" :
            case "etat" :
                // select portant sur une table contenant juste id et libelle
                return $this->selectTableSimple($table);
            case "" :
                // return $this->uneFonction(parametres);
            default:
                // cas général
                return $this->selectTuplesOneTable($table, $champs);
        }	
    }

    /**
     * demande d'ajout (insert)
     * @param string $table
     * @param array|null $champs nom et valeur de chaque champ
     * @return int|null nombre de tuples ajoutés ou null si erreur
     * @override
     */	
    protected function traitementInsert(string $table, ?array $champs) : ?int{
        switch($table){
            case "" :
                // return $this->uneFonction(parametres);
            case "livre" :
                return $this->insertLivre($champs);
            case "dvd" :
                return $this->insertDvd($champs);
            case "revue" :
                return $this->insertRevue($champs);
            case "commandedocument" :
                return $this->insertCommandeDocument($champs);
            default:                    
                // cas général
                return $this->insertOneTupleOneTable($table, $champs);	
        }
    }
    
    /**
     * demande de modification (update)
     * @param string $table
     * @param string|null $id
     * @param array|null $champs nom et valeur de chaque champ
     * @return int|null nombre de tuples modifiés ou null si erreur
     * @override
     */	
    protected function traitementUpdate(string $table, ?string $id, ?array $champs) : ?int{
        switch($table){
            case "" :
                // return $this->uneFonction(parametres);
            case "livre" :
                return $this->updateLivre($id, $champs);
            case "dvd" :
                return $this->updateDvd($id, $champs);
            case "revue" :
                return $this->updateRevue($id, $champs);
            case "commandedocument" :
                return $this->updateCommandeDocument($id, $champs);
            default:                    
                // cas général
                return $this->updateOneTupleOneTable($table, $id, $champs);
        }	
    }  
    
    /**
     * demande de suppression (delete)
     * @param string $table
     * @param array|null $champs nom et valeur de chaque champ
     * @return int|null nombre de tuples supprimés ou null si erreur
     * @override
     */	
    protected function traitementDelete(string $table, ?array $champs) : ?int{
        switch($table){
            case "" :
                // return $this->uneFonction(parametres);
            case "livre" :
                return $this->deleteOneLivre($champs);
            case "dvd" :
                return $this->deleteOneDvd($champs);
            case "revue" :
                return $this->deleteOneRevue($champs);
            case "commande" :
                return $this->deleteOneCommande($champs);
            default:                    
                // cas général
                return $this->deleteTuplesOneTable($table, $champs);	
        }
    }	    
        
    /**
     * récupère les tuples d'une seule table
     * @param string $table
     * @param array|null $champs
     * @return array|null 
     */
    private function selectTuplesOneTable(string $table, ?array $champs) : ?array{
        if(empty($champs)){
            // tous les tuples d'une table
            $requete = "select * from $table;";
            return $this->conn->queryBDD($requete);  
        }else{
            // tuples spécifiques d'une table
            $requete = "select * from $table where ";
            foreach ($champs as $key => $value){
                $requete .= "$key=:$key and ";
            }
            // (enlève le dernier and)
            $requete = substr($requete, 0, strlen($requete)-5);	          
            return $this->conn->queryBDD($requete, $champs);
        }
    }	

    /**
     * demande d'ajout (insert) d'un tuple dans une table
     * @param string $table
     * @param array|null $champs
     * @return int|null nombre de tuples ajoutés (0 ou 1) ou null si erreur
     */	
    private function insertOneTupleOneTable(string $table, ?array $champs) : ?int{
        if(empty($champs)){
            return null;
        }
        // construction de la requête
        $requete = "insert into $table (";
        foreach ($champs as $key => $value){
            $requete .= "$key,";
        }
        // (enlève la dernière virgule)
        $requete = substr($requete, 0, strlen($requete)-1);
        $requete .= ") values (";
        foreach ($champs as $key => $value){
            $requete .= ":$key,";
        }
        // (enlève la dernière virgule)
        $requete = substr($requete, 0, strlen($requete)-1);
        $requete .= ");";
        return $this->conn->updateBDD($requete, $champs);
    }

    /**
     * demande de modification (update) d'un tuple dans une table
     * @param string $table
     * @param string\null $id
     * @param array|null $champs 
     * @return int|null nombre de tuples modifiés (0 ou 1) ou null si erreur
     */	
    private function updateOneTupleOneTable(string $table, ?string $id, ?array $champs) : ?int {
        if(empty($champs)){
            return null;
        }
        if(is_null($id)){
            return null;
        }
        // construction de la requête
        $requete = "update $table set ";
        foreach ($champs as $key => $value){
            $requete .= "$key=:$key,";
        }
        // (enlève la dernière virgule)
        $requete = substr($requete, 0, strlen($requete)-1);				
        $champs["id"] = $id;
        $requete .= " where id=:id;";		
        return $this->conn->updateBDD($requete, $champs);	        
    }
    
    /**
     * demande de suppression (delete) d'un ou plusieurs tuples dans une table
     * @param string $table
     * @param array|null $champs
     * @return int|null nombre de tuples supprimés ou null si erreur
     */
    private function deleteTuplesOneTable(string $table, ?array $champs) : ?int{
        if(empty($champs)){
            return null;
        }
        // construction de la requête
        $requete = "delete from $table where ";
        foreach ($champs as $key => $value){
            $requete .= "$key=:$key and ";
        }
        // (enlève le dernier and)
        $requete = substr($requete, 0, strlen($requete)-5);   
        return $this->conn->updateBDD($requete, $champs);	        
    }
 
    /**
     * récupère toutes les lignes d'une table simple (qui contient juste id et libelle)
     * @param string $table
     * @return array|null
     */
    private function selectTableSimple(string $table) : ?array{
        $requete = "select * from $table order by libelle;";		
        return $this->conn->queryBDD($requete);	    
    }
    
    /**
     * récupère toutes les lignes de la table Livre et les tables associées
     * @return array|null
     */
    private function selectAllLivres() : ?array{
        $requete = "Select l.id, l.ISBN, l.auteur, d.titre, d.image, l.collection, ";
        $requete .= "d.idrayon, d.idpublic, d.idgenre, g.libelle as genre, p.libelle as lePublic, r.libelle as rayon ";
        $requete .= "from livre l join document d on l.id=d.id ";
        $requete .= "join genre g on g.id=d.idGenre ";
        $requete .= "join public p on p.id=d.idPublic ";
        $requete .= "join rayon r on r.id=d.idRayon ";
        $requete .= "order by titre ";		
        return $this->conn->queryBDD($requete);
    }	

    /**
     * récupère toutes les lignes de la table DVD et les tables associées
     * @return array|null
     */
    private function selectAllDvd() : ?array{
        $requete = "Select l.id, l.duree, l.realisateur, d.titre, d.image, l.synopsis, ";
        $requete .= "d.idrayon, d.idpublic, d.idgenre, g.libelle as genre, p.libelle as lePublic, r.libelle as rayon ";
        $requete .= "from dvd l join document d on l.id=d.id ";
        $requete .= "join genre g on g.id=d.idGenre ";
        $requete .= "join public p on p.id=d.idPublic ";
        $requete .= "join rayon r on r.id=d.idRayon ";
        $requete .= "order by titre ";	
        return $this->conn->queryBDD($requete);
    }	

    /**
     * récupère toutes les lignes de la table Revue et les tables associées
     * @return array|null
     */
    private function selectAllRevues() : ?array{
        $requete = "Select l.id, l.periodicite, d.titre, d.image, l.delaiMiseADispo, ";
        $requete .= "d.idrayon, d.idpublic, d.idgenre, g.libelle as genre, p.libelle as lePublic, r.libelle as rayon ";
        $requete .= "from revue l join document d on l.id=d.id ";
        $requete .= "join genre g on g.id=d.idGenre ";
        $requete .= "join public p on p.id=d.idPublic ";
        $requete .= "join rayon r on r.id=d.idRayon ";
        $requete .= "order by titre ";
        return $this->conn->queryBDD($requete);
    }	

    /**
     * récupère tous les exemplaires d'une revue
     * @param array|null $champs 
     * @return array|null
     */
    private function selectExemplairesRevue(?array $champs) : ?array{
        if(empty($champs)){
            return null;
        }
        if(!array_key_exists('id', $champs)){
            return null;
        }
        $champNecessaire['id'] = $champs['id'];
        $requete = "Select e.id, e.numero, e.dateAchat, e.photo, e.idEtat ";
        $requete .= "from exemplaire e join document d on e.id=d.id ";
        $requete .= "where e.id = :id ";
        $requete .= "order by e.dateAchat DESC";
        return $this->conn->queryBDD($requete, $champNecessaire);
    }
    
    private function selectCommandeDocument(?array $champs) : ?array{
        if(empty($champs)){
            return null;
        }
        if(!array_key_exists('id', $champs)){
            return null;
        }
        $champsNecessaire['id'] = $champs['id'];
        $requete = "SELECT co.id, co.dateCommande, co.montant, ";
        $requete .= "cd.nbExemplaire, cd.idLivreDvd, ";
        $requete .= "cd.idSuivi, s.libelle as libelleSuivi ";
        $requete .= "FROM commandedocument cd ";
        $requete .= "JOIN commande co ON cd.id = co.id ";
        $requete .= "LEFT JOIN suivi s ON cd.idSuivi = s.id ";
        $requete .= "WHERE cd.idLivreDvd = :id ";
        $requete .= "ORDER BY co.dateCommande DESC";
        return $this->conn->queryBDD($requete, $champsNecessaire);
    }
    
    /**
     * Supprime un document de type livre
     * @param array|null $champs
     * @return int|null
     */
    private function deleteOneLivre(?array $champs) :?int{
        
        if(empty($champs) || !isset($champs['id'])){
            return null;
        }
        
        $id = $champs['id'];
        
        try {
            $this->conn->beginTransaction();
            $params = ['id' => $id];
            
            // On vérifie le retour de chaque opération
            $req1 = $this->conn->updateBDD("DELETE FROM livre WHERE id = :id", $params);
            $req2 = $this->conn->updateBDD("DELETE FROM livres_dvd WHERE id = :id", $params);
            $req3 = $this->conn->updateBDD("DELETE FROM document WHERE id = :id", $params);

            // Vérification : si une requête a renvoyé null, on annule
            if ($req1 == 1 && $req2 == 1 && $req3 == 1) {
                $this->conn->commit();
                return 1;
            } else {
                $this->conn->rollBack();
                return null;
            }
        } catch (Exception $e) {
            $this->conn->rollBack();
            return null;
        }
    }
    
    /**
     * Supprime un document de type dvd
     * @param array|null $champs
     * @return int|null
     */
    private function deleteOneDvd(?array $champs) :?int{
        
        if(empty($champs) || !isset($champs['id'])){
            return null;
        }
        
        $id = $champs['id'];
        
        try {
            $this->conn->beginTransaction();
            $params = ['id' => $id];
            
            // On vérifie le retour de chaque opération
            $req1 = $this->conn->updateBDD("DELETE FROM dvd WHERE id = :id", $params);
            $req2 = $this->conn->updateBDD("DELETE FROM livres_dvd WHERE id = :id", $params);
            $req3 = $this->conn->updateBDD("DELETE FROM document WHERE id = :id", $params);

            // Vérification : si une requête a renvoyé null, on annule
            if ($req1 == 1 && $req2 == 1 && $req3 == 1) {
                $this->conn->commit();
                return 1;
            } else {
                $this->conn->rollBack();
                return null;
            }
        } catch (Exception $e) {
            $this->conn->rollBack();
            error_log("ERREUR CRITIQUE updateDvd : " . $ex->getMessage());
            return null;
        }
    }
    
    private function deleteOneRevue(?array $champs) :?int{
        
        if(empty($champs) || !isset($champs['id'])){
            return null;
        }

        $id = $champs['id'];

        try {
            $this->conn->beginTransaction();
            $params = ['id' => $id];

            $req1 = $this->conn->updateBDD("DELETE FROM revue WHERE id = :id", $params);
            $req2 = $this->conn->updateBDD("DELETE FROM document WHERE id = :id", $params);

            // Vérification : si une requête a renvoyé null, on annule
            if ($req1 == 1 && $req2 == 1) {
                $this->conn->commit();
                return 1;
            } else {
                $this->conn->rollBack();
                return null;
            }
        } catch (Exception $e) {
            $this->conn->rollBack();
            error_log("ERREUR CRITIQUE deleteOneRevue : " . $e->getMessage());
            return null;
        }
        
    }
    
    /**
    * Supprime une commande
    * Le trigger se charge de supprimer aussi dans commandedocument
    * @param array|null $champs
    * @return int|null 1 si succès, null si erreur
    */
   private function deleteOneCommande(?array $champs) :?int{

       if(empty($champs) || !isset($champs['id'])){
           return null;
       }

       $id = $champs['id'];

       try {
           $params = ['id' => $id];

           $result = $this->conn->updateBDD("DELETE FROM commande WHERE id = :id", $params);

           if ($result == 1) {
               return 1;
           } else {
               return null;
           }
       } catch (Exception $e) {
           error_log("ERREUR CRITIQUE deleteOneCommande : " . $e->getMessage());
           return null;
       }
   }
    
    /*
     * Modifie un document de type Dvd
     */
    private function updateDvd($id, ?array $champs) :?int{
        
        if (empty($champs) || is_null($id)) {
            error_log("ERREUR: champs vides ou ID null");
            return null;
        }
        
        try {
            $this->conn->beginTransaction();

            $champsDvd = [
                'duree'       => $champs['Duree'] ?? null,
                'realisateur' => $champs['Realisateur'] ?? null,
                'synopsis'    => $champs['Synopsis'] ?? null
            ];

            $champsDocument = [
                'titre'    => $champs['Titre'] ?? null,
                'image'    => $champs['Image'] ?? null,
                'idRayon'  => $champs['IdRayon'] ?? null,
                'idPublic' => $champs['IdPublic'] ?? null,
                'idGenre'  => $champs['IdGenre'] ?? null
            ];

            $resDoc = $this->updateOneTupleOneTable('document', $id, $champsDocument);
            $resDvd = $this->updateOneTupleOneTable('dvd', $id, $champsDvd);

            if ($resDoc === null || $resDvd === null) {
                $this->conn->rollBack();
                return null;
            }

            $this->conn->commit();
            return 1;

        } catch (Exception $ex) {
            $this->conn->rollBack();
            return null;
        }
    }
    
    /*
     * Modifie un document de type Livre
     */
    private function updateLivre($id, ?array $champs) :?int{
        
        if (empty($champs) || is_null($id)) {
        return null;
        }
        
        try{
            $this->conn->beginTransaction();
            
            $champsLivre = [
                'ISBN'       => $champs['Isbn'] ?? null,
                'auteur'     => $champs['Auteur'] ?? null,
                'collection' => $champs['collection'] ?? null
            ];
            $champsDocument = [
                'titre'    => $champs['Titre'] ?? null,
                'image'    => $champs['Image'] ?? null,
                'idRayon'  => $champs['IdRayon'] ?? null,
                'idPublic' => $champs['IdPublic'] ?? null,
                'idGenre'  => $champs['IdGenre'] ?? null
            ];
            
            $resDoc   = $this->updateOneTupleOneTable('document', $id, $champsDocument);
            $resLivre = $this->updateOneTupleOneTable('livre', $id, $champsLivre);

            if ($resDoc === null || $resLivre === null) {
                $this->conn->rollBack();
                return null;
            }

            $this->conn->commit();
            return 1;
        } catch (Exception $ex) {
            $this->conn->rollBack();
            return null;
        }
    }
    
    /**
    * Modifie l'étape de suivi d'une commande de document
    * @param string|null $id
    * @param array|null $champs
    * @return int|null 1 si succès, null si erreur
    */
   private function updateCommandeDocument($id, ?array $champs) :?int{

       if (empty($champs) || is_null($id)) {
           return null;
       }

       if (!isset($champs['IdSuivi'])) {
           error_log("ERREUR: IdSuivi manquant");
           return null;
       }

       try {
           // On ne met à jour que l'idSuivi dans commandedocument
           $champsCommandeDocument = [
               'idSuivi' => $champs['IdSuivi']
           ];

           $res = $this->updateOneTupleOneTable('commandedocument', $id, $champsCommandeDocument);

           if ($res === null) {
               return null;
           }

           return 1;

       } catch (Exception $ex) {
           error_log("ERREUR updateCommandeDocument : " . $ex->getMessage());
           return null;
       }
   }
    
    /**
     * insert un nouveau livre dans la BDD
     * gère l'ajout dans les autres tables
     * @param array|null $champs
     * @return int
     */
    private function insertLivre(?array $champs) :?int{
         
        if (empty($champs)){
            return null;
        }
        
        $champs = array_change_key_case($champs, CASE_LOWER);
        $champsDocument = [
            "id" => $champs["id"] ?? null,
            "titre" => $champs["titre"] ?? "",
            "image" => $champs["image"] ?? "",
            "idGenre" => $champs["idgenre"] ?? null,
            "idPublic" => $champs["idpublic"] ?? null,
            "idRayon" => $champs["idrayon"] ?? null
        ];

        $champsLivreDvd = [
            "id" => $champs["id"] ?? null
        ];

        $champsLivre = [
            "id" => $champs["id"] ?? null,
            "ISBN" => $champs["isbn"] ?? "",
            "auteur" => $champs["auteur"] ?? "",
            "collection" => $champs["collection"] ?? ""
        ];
            try{
            $this->conn->beginTransaction();
            $reqDoc = $this->insertOneTupleOneTable("document", $champsDocument);
            $reqLivreDvd = $this->insertOneTupleOneTable("livres_dvd", $champsLivreDvd);
            $reqLivre = $this->insertOneTupleOneTable("livre", $champsLivre);
            if ($reqDoc === null || $reqLivre === null || $reqLivreDvd === null) {
                $this->conn->rollBack();
                return null;
            }
            $this->conn->commit();
            return 1;
        } catch (Exception $ex) {
            $this->conn->rollBack();
            return null;
        }
    }
    
    /**
    * Insère une nouvelle revue dans la base de données
    * Gère les 2 tables : document, revue
    * @param array|null $champs
    * @return int|null 1 si succès, null si erreur
    */
   private function insertRevue(?array $champs) :?int {

       error_log("=== insertRevue appelé ===");
       error_log("Champs reçus : " . print_r($champs, true));

       if (empty($champs)) {
           return null;
       }

       $champsDocument = [
           "id"       => $champs["Id"] ?? null,
           "titre"    => $champs["Titre"] ?? "",
           "image"    => $champs["Image"] ?? "",
           "idGenre"  => $champs["IdGenre"] ?? null,
           "idPublic" => $champs["IdPublic"] ?? null,
           "idRayon"  => $champs["IdRayon"] ?? null
       ];

       $champsRevue = [
           "id"              => $champs["Id"] ?? null,
           "periodicite"     => $champs["Periodicite"] ?? "",
           "delaiMiseADispo" => $champs["DelaiMiseADispo"] ?? 0
       ];

       try {
           $this->conn->beginTransaction();

           // Insertion dans les 2 tables (hiérarchie d'héritage)
           $reqDoc   = $this->insertOneTupleOneTable("document", $champsDocument);
           $reqRevue = $this->insertOneTupleOneTable("revue", $champsRevue);

           // Si une insertion échoue, rollback complet
           if ($reqDoc === null || $reqRevue === null) {
               $this->conn->rollBack();
               error_log("Échec insertion : reqDoc=" . var_export($reqDoc, true) . ", reqRevue=" . var_export($reqRevue, true));
               return null;
           }

           $this->conn->commit();
           error_log("Revue insérée avec succès");
           return 1;

       } catch (Exception $ex) {
           $this->conn->rollBack();
           error_log("Erreur insertRevue : " . $ex->getMessage());
           return null;
       }
   }
    
    /**
    * Insère un nouveau DVD dans la base de données
    * Gère les 3 tables : document, livres_dvd, dvd
    * @param array|null $champs
    * @return int|null 1 si succès, null si erreur
    */
   private function insertDvd(?array $champs) :?int {
       
       error_log("=== insertDvd appelé ===");
       error_log("Champs reçus : " . print_r($champs, true));

       if (empty($champs)) {
           return null;
       }

       // Pas de array_change_key_case car on reçoit du JSON C# avec majuscules
       // On récupère directement avec les bonnes clés

       $champsDocument = [
           "id"       => $champs["Id"] ?? null,
           "titre"    => $champs["Titre"] ?? "",
           "image"    => $champs["Image"] ?? "",
           "idGenre"  => $champs["IdGenre"] ?? null,
           "idPublic" => $champs["IdPublic"] ?? null,
           "idRayon"  => $champs["IdRayon"] ?? null
       ];

       $champsLivreDvd = [
           "id" => $champs["Id"] ?? null
       ];

       $champsDvd = [
           "id"          => $champs["Id"] ?? null,
           "duree"       => $champs["Duree"] ?? null,
           "realisateur" => $champs["Realisateur"] ?? "",
           "synopsis"    => $champs["Synopsis"] ?? ""
       ];

       try {
           $this->conn->beginTransaction();

           // Insertion dans les 3 tables (hiérarchie d'héritage)
           $reqDoc      = $this->insertOneTupleOneTable("document", $champsDocument);
           $reqLivreDvd = $this->insertOneTupleOneTable("livres_dvd", $champsLivreDvd);
           $reqDvd      = $this->insertOneTupleOneTable("dvd", $champsDvd);

           // Si une insertion échoue, rollback complet
           if ($reqDoc === null || $reqLivreDvd === null || $reqDvd === null) {
               $this->conn->rollBack();
               return null;
           }

           $this->conn->commit();
           return 1;

       } catch (Exception $ex) {
           $this->conn->rollBack();
           error_log("Erreur insertDvd : " . $ex->getMessage());
           return null;
       }
   }
   
   /**
    * Modifie un document de type Revue
    * @param string|null $id
    * @param array|null $champs
    * @return int|null
    */
   private function updateRevue($id, ?array $champs) :?int{

       error_log("=== updateRevue appelé ===");
       error_log("ID : " . $id);
       error_log("Champs reçus : " . print_r($champs, true));

       if (empty($champs) || is_null($id)) {
           error_log("ERREUR: champs vides ou ID null");
           return null;
       }

       try {
           $this->conn->beginTransaction();

           $champsRevue = [
               'periodicite'     => $champs['Periodicite'] ?? null,
               'delaiMiseADispo' => $champs['DelaiMiseADispo'] ?? null
           ];

           $champsDocument = [
               'titre'    => $champs['Titre'] ?? null,
               'image'    => $champs['Image'] ?? null,
               'idRayon'  => $champs['IdRayon'] ?? null,
               'idPublic' => $champs['IdPublic'] ?? null,
               'idGenre'  => $champs['IdGenre'] ?? null
           ];

           $resDoc   = $this->updateOneTupleOneTable('document', $id, $champsDocument);
           $resRevue = $this->updateOneTupleOneTable('revue', $id, $champsRevue);

           if ($resDoc === null || $resRevue === null) {
               $this->conn->rollBack();
               error_log("Échec update : resDoc=" . var_export($resDoc, true) . ", resRevue=" . var_export($resRevue, true));
               return null;
           }

           $this->conn->commit();
           error_log("Revue modifiée avec succès");
           return 1;

       } catch (Exception $ex) {
           $this->conn->rollBack();
           error_log("ERREUR CRITIQUE updateRevue : " . $ex->getMessage());
           return null;
       }
   }
   
   /**
    * Insère une nouvelle commande de document dans la base de données
    * Gère les 2 tables : commande, commandedocument
    * @param array|null $champs
    * @return int|null 1 si succès, null si erreur
    */
   private function insertCommandeDocument(?array $champs) :?int {

       error_log("=== insertCommandeDocument appelé ===");
       error_log("Champs reçus : " . print_r($champs, true));

       if (empty($champs)) {
           return null;
       }

       $champsCommande = [
           "id"           => $champs["Id"] ?? null,
           "dateCommande" => $champs["DateCommande"] ?? null,
           "montant"      => $champs["Montant"] ?? null
       ];

       $champsCommandeDocument = [
           "id"           => $champs["Id"] ?? null,
           "nbExemplaire" => $champs["NbExemplaire"] ?? null,
           "idLivreDvd"   => $champs["IdLivreDvd"] ?? null,
           "idSuivi"      => $champs["IdSuivi"] ?? null
       ];

       try {
           $this->conn->beginTransaction();

           // Insertion dans les 2 tables
           $reqCommande = $this->insertOneTupleOneTable("commande", $champsCommande);
           $reqCommandeDoc = $this->insertOneTupleOneTable("commandedocument", $champsCommandeDocument);

           // Si une insertion échoue, rollback complet
           if ($reqCommande === null || $reqCommandeDoc === null) {
               $this->conn->rollBack();
               error_log("Échec insertion : reqCommande=" . var_export($reqCommande, true) . ", reqCommandeDoc=" . var_export($reqCommandeDoc, true));
               return null;
           }

           $this->conn->commit();
           error_log("Commande insérée avec succès");
           return 1;

       } catch (Exception $ex) {
           $this->conn->rollBack();
           error_log("Erreur insertCommandeDocument : " . $ex->getMessage());
           return null;
       }
   }
    
}
