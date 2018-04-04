library(haven)
library(foreign)
#install.packages("Hmisc")
library(Hmisc)
library(ggplot2)
#install.packages("base")
library(base)

##################################################################################
######################### Donnees "prestations centrees" #########################
##################################################################################

############################ Niveau national mensuel #############################

#Source donnees:
#https://www.data.gouv.fr/fr/datasets/depenses-d-assurance-maladie-hors-prestations-hospitalieres-donnees-nationales/

#working directory
setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments/Prestations/Non\ hosp/National\ -\ dispo\ 2014-17")

#chargement des donnees pour chaque mois de l'annee 2017
for (i in 1:9) {
  assign(paste("df", i, sep = "_"), read.csv2(paste0("N20170", i, ".csv"), header = TRUE, encoding = "latin1"))
}

for (i in 0:2) {
  assign(paste("df_1", i, sep = ""), read.csv2(paste0("N20171", i, ".csv"), header = TRUE, encoding = "latin1"))
}

#fusion en une seule base pour 2017
data2017 <- df_1
for (i in 2:12) {
  data2017 <- rbind(data2017, get(paste("df", i, sep = "_")))
}

# ---------------------------- Focus psychiatres ------------------------------- #

#examen des modalites de la var "specialite de l'executant"
levels(data2017$l_exe_spe)

#creation base psychiatres
data2017_psy <- data2017[data2017$l_exe_spe == "17-Neuropsychiatrie" |data2017$l_exe_spe == "33-Psychiatrie générale" | data2017$l_exe_spe == "75-Psychiatrie de l\"enfant et de l\"adolescent",]
#NB "32-Neurologie" exclue
length(data2017[data2017$l_exe_spe == "17-Neuropsychiatrie", ]) #seulement 28
#àp 1968: Neuro et Psychiatrie sont separees

#verification pas de duplicats des n-uplets type prestation - statut de l'executant etc
length(unique(subset(data2017_psy, select = - c(rem_mon, rec_mon, dep_mon)))[,1])
#il y a des duplicats

#suppression des duplicats
data2017_psy <- data2017_psy[duplicated(subset(data2017_psy, select = - c(rem_mon, rec_mon, dep_mon))) == FALSE, ]

#mise en forme des variables bases de remboursement et depassements honoraires
data2017_psy$rec_mon2 <- as.character(data2017_psy$rec_mon)
data2017_psy$rec_mon2 <- substr(data2017_psy$rec_mon2, 1, nchar(data2017_psy$rec_mon2)-3)
data2017_psy$rec_mon2 <- gsub("[^0123456789]", "", data2017_psy$rec_mon2)
data2017_psy$rec_mon2 <- as.numeric(data2017_psy$rec_mon2)
#transformation en positif des chiffres inscrits en negatif

data2017_psy$dep_mon2 <- as.character(data2017_psy$dep_mon)
data2017_psy$dep_mon2 <- substr(data2017_psy$dep_mon2, 1, nchar(data2017_psy$dep_mon2)-3)
data2017_psy$dep_mon2 <- gsub("[^0123456789]", "", data2017_psy$dep_mon2)
data2017_psy$dep_mon2 <- as.numeric(data2017_psy$dep_mon2)

#liste des valeurs (integer) prises par prs_nat (type de prestation)
list <- levels(as.factor(data2017_psy$prs_nat))
list <- as.integer(list)

#somme des bases de remboursement par type de prestation
data2017_psy$rec_sumprs <- NA
for(i in list) {
  data2017_psy[data2017_psy$prs_nat==i,]$rec_sumprs <- sum(data2017_psy[data2017_psy$prs_nat==i,]$rec_mon2)
}

#somme des depassements d'honoraires par type de prestation
data2017_psy$dep_sumprs <- NA
for(i in list) {
  data2017_psy[data2017_psy$prs_nat==i,]$dep_sumprs <- sum(data2017_psy[data2017_psy$prs_nat==i,]$dep_mon2)
}

#calcul des taux de depassement par type de prestation
data2017_psy$txdep_prs <- (data2017_psy$dep_sumprs/data2017_psy$rec_sumprs)*100

#quels types de prestations ont les plus hauts taux de depassement ?
txdep_prs <- aggregate(data2017_psy$txdep_prs, list(data2017_psy$l_prs_nat, data2017_psy$prs_nat), mean)

max(txdep_prs[!is.na(txdep_prs[,3]), 3]) 

#plot des taux de depassement par prestations
ggplot(txdep_prs, aes(x=reorder(txdep_prs$Group.1, txdep_prs$x), y=txdep_prs$x)) +
  geom_bar(stat='identity') +
  coord_flip() +
  xlab("Taux de dépassement des honoraires") +
  ylab("Type de prestation") +
  ggtitle("Taux de depassement par type de prestation")

#regarder le DENOMBREMENT des prestations ? variable act_dnb 
#(attention, cette var n'est pas dispo pour tous les types de prestation)
View(data2017_psy[data2017_psy$l_prs_nat == "ACTE DE RADIOLOGIE MAMMOGRAPHIE", ]$act_dnb)View(data2017_psy[data2017_psy$l_prs_nat == "ACTE DE RADIOLOGIE MAMMOGRAPHIE", ])




