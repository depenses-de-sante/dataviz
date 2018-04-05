# Storytelling 

**La problématique:**
*Les dépenses de santé "les plus remboursées sont-elles celles qui coûtent" le plus cher?*

On peut décomposer:
* "Les plus remboursées":
    * En pourcentage (taux de remboursement)
    * En valeur absolue : celles qui impliquent le plus de dépenses en valeur absolue pour la sécu
* "Qui coûtent le plus cher": 
    * A l'unité
    * Ou au total, car la quantité consommée est élevée en nombre de boîtes / de visites, ou de consommateurs / patients

Idée qu’on dit souvent que ce qui fait en fait le gros des dépenses de santé ce sont les procédures lourdes, les médicaments chers et rares. Mais en même temps, certains discours portent aussi sur les comportements, à la fois de l’offre et de la demande : dépassements d’honoraires élevés des médecins / "petits bobos" des patients, qui vont sans cesse demander des médicaments contre la toux chez leur médecin… 

*QU’EN EST-IL VRAIMENT ?*

Attention, champ de l’étude : a priori seulement les dépenses "de ville" : médicaments achetés en pharmacie et visites "classiques" chez des médecins (pas hôpital)

**Les graphes : voir pages scannées dégueu ci-après (désolée…) :**
* Montants dépensés et remboursés en fonction du prix unitaires des médicaments, par tranches de prix unitaires :
    * Bar chart, en décomposant la dépense en deux composantes: montant remboursé vs. montant non-remboursé
    * En abscisse des tranches de prix du médicament "au départ" ie. base de remboursement à l'unité
    * A noter que quel que soit le prix unitaire, la dépense pourra être très importante (si bcp de boîtes sont consommées) -> voir dans ces cas quels médicaments *drivent* la dépense vers le haut, éventuellement avec des bulles explicativent qui apparaîssent quand on met le curseur dessus
    * PB: On risque d'avoir un pb d'échelle en avscisse. Il faut choisir notre déccoupage 
    * Intéressant: Si on a une sorte de courbe en U, et si la part remboursée est plus élevée pour les médicaments chers
    * Suggestion : ne pas séparer montant remboursé / non remboursé si cela fait trop d'info
* Montants dépensés et remboursés en fonction du nombre de consommants des médicaments
    * Ici encore on peut décomposer en montant remboursé vs. non-remboursé
    * On décompose en tranches mais cette-fois en fonction du nombre de consommants
    * On peut s'attendre à ce que les médicaments consommés par moins de personnes soient ceux qui impliquent des maladies "plus graves" et donc soient très remboursés (éventuellement faire un focus sur certains, expliquer le système français de rationnement)
    * On peut aussi fair un graphe plus simple en mettant en rapport le prix des médicaments à l'unité et le nombre de consommants (les médicaments les plus chers sont-ils ceuw qui sont consommés par le moins de patients) -> q° du REMBOURSEMENT
* Rentrer dans les détails : pour les classes de médicaments pour lesquelles on observe les + hauts montants dans les deux graphes précédents : donner la composition
    * **Si** on voit un rectangle très haut pour les médicaments qui sont dans la tranche sup du prix à l'unité: donner des détails sur les médicaments composant cette tranche sup : 
        * En donnant la répartition des différents "groupes de médicaments" dans cette tranche ?
        * En donnant les noms des 10 premiers médicaments dans le groupe ?  
    * Idem pour les rectangles du graphe p/ consommants
    
**Ces viz seront, dans l'esprit proches des viz du Monde qui sont sur l'article Open Medic dans l'Excel.**
On passe aux "prestations", et non plus aux médicaments : 

* Montants dépensés / remboursés par spécialité, en mettant la part des dépassements d’honoraires dans les montants dépensés. Et en classant les spécialités par taux moyen de remboursement
    * Plot en valeur absolue sur une année donnée
    * Décomposer les montants dépensés en : dépassements d'honoraires, montants non-remboursés mais hors dépassements d'honoraire, montant remboursé
    * A noter que le montant non-remboursé hors dépassement d'honoraires va dépendre des taux de remboursement réglementés : structurellement, certaines spécialités seront plus remboursées que d'autures
    * On peut se demander si les spécialités a priori les plus "techniques" sont celles pour lesqueles les montants dépensés sont les plus hauts
    * Sur l'axe des abscisses, on peut classer les spécialités par ordre décroissant du taux moyen de remboursement de leurs prestations
* Une viz qui serait hyper cool mais il faut revérifier qu’on peut vraiment la faire (je crois que oui) : nombre de visites ayant impliqué un dépassement d’honoraires en fonction du taux de remboursement de la visite (les visites les + remboursées vont-elles "inciter" les médecins à faire des dépassements ?) ET/OU par spécialité 
    * Idée sous-jascente: pour les presta pour lesquelles le taux de remboursement est haut, le médecin va p-ê être tenté de faire un dépassement d'honoraire, car il sait qu'au départ le patient paie "peu" de sa poche
* CARTE (enfin) des taux de dépassement d’honoraires (ou valeur absolue des dépassements) par département ET mise en regard avec les montants remboursés, toutes spécialités confondues
    * Eventuellement ajouter une part d'interactif avec possibilité de sélectionner des  spécialités et de voir ce que ça donne (comme ça le lecteur a un peu la main)
    * Pb de la mise en regard avec les montants remboursés: il peut être difficile de lire deux cartes à la fois
    * Chercher les tips pour faire tenir plusieurs infos sur une même carte
    * Q° : Taux de dépassement ou montant de dépassement ?
=> Il faut améliorer les viz (j’ai surtout pensé en termes de "barchart" pour l’instant), et je pense que la mise en œuvre peut être reloue pour certains graphes (ex le 1er : comment choisir les «tranches» de prix unitaires ?)

