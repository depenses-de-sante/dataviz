# Storytelling 

**La problématique:**
*Les dépenses de santé "les plus remboursées" sont-elles "celles qui coûtent le plus cher?"*

* Medicaments : question de l'effet volume / effet prix :
    * Les médicaments pour lesquels la Sécu donne le plus d'argent sont ceux qui sont chers à l'unité ou plutôt ceux qui sont pas chers à l'unité ?
    * Les médicaments pour lesquels la Sécu donne le plus d'argent sont ceux qui sont consommés par peu de personnes ou plutôt par beaucoup de personnes ?
* Médecins : 
    * Les spécialités ou les prestations pour lesquelles la Sécu donne le plus d'argent sont celles qui sont a priori les plus "techniques" ?
    * Les spécialités ou les prestations pour lesquelles la Sécu donne le plus d'argent sont celles qui sont les + sujettes aux dépassements d'honoaires ?

Idée qu’on dit souvent que ce qui fait en fait le gros des dépenses de santé ce sont les procédures lourdes, les médicaments chers et rares. Mais en même temps, certains discours portent aussi sur les comportements, à la fois de l’offre et de la demande : dépassements d’honoraires élevés des médecins / "petits bobos" des patients, qui vont sans cesse demander des médicaments contre la toux chez leur médecin… 

*QU’EN EST-IL VRAIMENT ?*

Attention, champ de l’étude : a priori seulement les dépenses "de ville" : médicaments achetés en pharmacie et visites "classiques" chez des médecins (pas hôpital)

**Les graphes :**

*Partie MEDICAMENTS*

1. Montants dépensés et remboursés en fonction du prix unitaires des médicaments, par tranches de prix unitaires :
    * Bar chart, en décomposant la dépense en deux composantes : montant remboursé vs. montant non-remboursé
    * En abscisse des tranches de prix du médicament "au départ" ie. base de remboursement à l'unité
    * A noter que quel que soit le prix unitaire, la dépense pourra être très importante (si bcp de boîtes sont consommées) -> voir dans ces cas quels médicaments *drivent* la dépense vers le haut, éventuellement avec des bulles explicativent qui apparaîssent quand on met le curseur dessus
    * Choix du découpage en abscisse : déciles des prix unitaires ? 10% les plus chers à l'unité, 20% les plus chers, etc. 
    * Intéressant : Si on a une sorte de courbe en U, et si la part remboursée est plus élevée pour les médicaments chers
    * Suggestion : ne pas séparer montant remboursé / non remboursé si cela fait trop d'info
2. Montants dépensés et remboursés en fonction du nombre de consommants des médicaments
    * Ici encore on peut décomposer en montant remboursé vs. non-remboursé
    * On décompose en tranches mais cette-fois en fonction du nombre de consommants
    * On peut s'attendre à ce que les médicaments consommés par moins de personnes soient ceux qui impliquent des maladies "plus graves" et donc soient très remboursés (éventuellement faire un focus sur certains, expliquer le système français de rationnement)
    * On peut aussi fair un graphe plus simple en mettant en rapport le prix des médicaments à l'unité et le nombre de consommants (les médicaments les plus chers sont-ils ceuw qui sont consommés par le moins de patients) -> q° du REMBOURSEMENT
3. Rentrer dans les détails : pour les classes de médicaments pour lesquelles on observe les + hauts montants dans les deux graphes précédents : donner la composition
    * **Si** on voit un rectangle très haut pour les médicaments qui sont dans la tranche sup du prix à l'unité: donner des détails sur les médicaments composant cette tranche sup : 
        * En donnant la répartition des différents "groupes de médicaments" dans cette tranche ?
        * En donnant les noms des 10 premiers médicaments dans le groupe ?  
        * En donnant la répartition des différents "types de prescripteurs" dans cette tranche ?
    * Idem pour les rectangles du graphe p/ consommants
    * On peut rentrer dans les détails de manière interactive : barre de recherche dans laquelle les gens peuvent rentrer le nom d'un médicament et on voit dans quelle tranche des prix unitaires le médicament se trouve, et / ou dans quelle tranche en termes de nombre de consommants
    
**Ces viz seront, dans l'esprit proches des viz du Monde qui sont sur l'article Open Medic dans l'Excel.**

*Partie DOCTEURS*

4. Montants dépensés / remboursés par spécialité, en mettant la part des dépassements d’honoraires dans les montants dépensés. Et en classant les spécialités par taux moyen de remboursement
    * Plot en valeur absolue sur une année donnée
    * Décomposer les montants dépensés en : dépassements d'honoraires, montants non-remboursés mais hors dépassements d'honoraire, montant remboursé
    * À noter que le montant non-remboursé hors dépassement d'honoraires va dépendre des taux de remboursement réglementés : structurellement, certaines spécialités seront plus remboursées que d'autures
    * On peut se demander si les spécialités a priori les plus "techniques" sont celles pour lesqueles les montants dépensés sont les plus hauts
    * Sur l'axe des abscisses, on peut classer les spécialités par ordre décroissant du taux moyen de remboursement de leurs prestations
5. Viz mettant en rapport taux de dépassement et taux de remboursement. Idée sous-jascente: pour les presta pour lesquelles le taux de remboursement est haut, le médecin va p-ê être tenté de faire un dépassement d'honoraire, car il sait qu'au départ le patient paie "peu" de sa poche.
      * SUGGESTION : le message de cette viz est potentiellement complexe. Idée : la remplacer par une viz affichant l'evolution des taux de depassement d'honoraires de 2009 à 2017 (éventuellement en intégrant les mois)
    
6. CARTE des taux de dépassement d’honoraires (ou valeur absolue des dépassements) par département ET mise en regard avec les montants totaux remboursés, toutes spécialités confondues
    * Éventuellement ajouter une part d'interactif avec possibilité de sélectionner des spécialités et de voir ce que ça donne (comme ça le lecteur a un peu la main)
    * Part d'interactif en laissant le lecteur choisir la région et avoir + d'infos ?
    * Pb de la mise en regard avec les montants remboursés : il peut être difficile de lire deux cartes à la fois
    * Chercher les tips pour faire tenir plusieurs infos sur une même carte
    * Q° : Taux de dépassement ou montant de dépassement ?


=> Il faut améliorer les viz (j’ai surtout pensé en termes de "barchart" pour l’instant), et je pense que la mise en œuvre peut être reloue pour certains graphes (ex le 1er : comment choisir les «tranches» de prix unitaires ?)

Idée en plus : Si à un moment on décide de faire un focus sur les médicaments très chers, on pourrait éventuellement donner leur prix en nombre de quelque chose de plus parlant (par exemple en années de SMIC, ou quelque chose de plus visuel - ça serait mieux).

