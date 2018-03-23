library(haven)
library(foreign)
#install.packages("Hmisc")
library(Hmisc)
library(ggplot2)

##################################################################################
######################### Donnees "prestations centrees" #########################
##################################################################################

############################ Niveau national mensuel #############################

#Source donnees:
#https://www.data.gouv.fr/fr/datasets/depenses-d-assurance-maladie-hors-prestations-hospitalieres-donnees-nationales/

#working directory
setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments/Prestations/Non\ hosp/National\ -\ dispo\ 2014-17")

#chargement des donnees pour janvier 2018
d_1801 <- read.csv2("N201801.csv", header = TRUE, encoding = "latin1")

# ---------------------------- Focus psychiatres ------------------------------- #

#examen des modalites de la var "specialite de l'executant"
levels(d_1801$l_exe_spe)

#creation base psychiatres
d_1801_psy <- d_1801[d_1801$l_exe_spe == "17-Neuropsychiatrie" |d_1801$l_exe_spe == "33-Psychiatrie générale" | d_1801$l_exe_spe == "75-Psychiatrie de l\"enfant et de l\"adolescent",]
#NB "32-Neurologie" exclue

#verification pas de duplicats des n-uplets type prestation - statut de l'executant etc
length(unique(subset(d_1801_psy, select = - c(rem_mon, rec_mon, dep_mon)))[,1])
#ok, pas de duplicats

#mise en forme des variables bases de remboursement et depassements honoraires
d_1801_psy$rec_mon2 <- as.character(d_1801_psy$rec_mon)
d_1801_psy$rec_mon2 <- substr(d_1801_psy$rec_mon2, 1, nchar(d_1801_psy$rec_mon2)-3)
d_1801_psy$rec_mon2 <- gsub("[^0123456789]", "", d_1801_psy$rec_mon2)
d_1801_psy$rec_mon2 <- as.numeric(d_1801_psy$rec_mon2)
#transformation en positif des chiffres inscrits en negatif

d_1801_psy$dep_mon2 <- as.character(d_1801_psy$dep_mon)
d_1801_psy$dep_mon2 <- substr(d_1801_psy$dep_mon2, 1, nchar(d_1801_psy$dep_mon2)-3)
d_1801_psy$dep_mon2 <- gsub("[^0123456789]", "", d_1801_psy$dep_mon2)
d_1801_psy$dep_mon2 <- as.numeric(d_1801_psy$dep_mon2)

#liste des valeurs (integer) prises par prs_nat (type de prestation)
list <- levels(as.factor(d_1801_psy$prs_nat))
list <- as.integer(list)

#somme des bases de remboursement par type de prestation
d_1801_psy$rec_sumprs <- NA
for(i in list) {
  d_1801_psy[d_1801_psy$prs_nat==i,]$rec_sumprs <- sum(d_1801_psy[d_1801_psy$prs_nat==i,]$rec_mon2)
}

#somme des depassements d'honoraires par type de prestation
d_1801_psy$dep_sumprs <- NA
for(i in list) {
  d_1801_psy[d_1801_psy$prs_nat==i,]$dep_sumprs <- sum(d_1801_psy[d_1801_psy$prs_nat==i,]$dep_mon2)
}

#calcul des taux de depassement par type de prestation
d_1801_psy$txdep_prs <- (d_1801_psy$dep_sumprs/d_1801_psy$rec_sumprs)*100

#quels types de prestations ont les plus hauts taux de depassement ?
txdep_prs <- aggregate(d_1801_psy$txdep_prs, list(d_1801_psy$l_prs_nat, d_1801_psy$prs_nat), mean)
max(txdep_prs[!is.na(txdep_prs[,3]), 3]) #10527.27 -> valeur aberrante
txdep_prs[txdep_prs[, 3] == max(txdep_prs[!is.na(txdep_prs[,3]), 3]), ]
#la valeur aberrrante concerne la prestation 1331 = "actes de radiologie"
#denombrement de ce type de prestation pour jan 2018 : 9.

#on supprime la prestation "actes de radiologie" de nos analyses :
txdep_prs <- txdep_prs[txdep_prs$Group.2 != 1331 & txdep_prs$x > 0, ]
txdep_prs <- txdep_prs[!is.na(txdep_prs$x),]

#plot des taux de depassement par prestations
ggplot(txdep_prs, aes(x=reorder(txdep_prs$Group.1, txdep_prs$x), y=txdep_prs$x)) +
  geom_bar(stat='identity') +
  coord_flip() +
  xlab("Taux de dépassement des honoraires") +
  ylab("Type de prestation") +
  ggtitle("Taux de depassement par type de prestation")

#regarder le DENOMBREMENT des prestations ? variable act_dnb 
#(attention, cette var n'est pas dispo pour tous les types de prestation)
View(d_1801_psy[d_1801_psy$l_prs_nat == "ACTE DE RADIOLOGIE MAMMOGRAPHIE", ]$act_dnb)View(d_1801_psy[d_1801_psy$l_prs_nat == "ACTE DE RADIOLOGIE MAMMOGRAPHIE", ])
#4 occurrences de "ACTE DE RADIOLOGIE MAMMOGRAPHIE" sur janvier 2008




