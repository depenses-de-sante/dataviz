library(haven)
library(foreign)
#install.packages("Hmisc")
library(Hmisc)
library(ggplot2)
#install.packages("base")
library(base)

##################################################################################
######################### Donnees "medicament centrees" #########################
##################################################################################

setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments/Medic")

df <- read.csv2("OPEN_MEDIC_2016.csv", header = TRUE, encoding = "latin1")

describe(df$L_CIP13)
describe(df$CIP13)

print(df[1,]$CIP13, digits = 20)

length(unique(df$CIP13))
length(unique(df$L_CIP13))

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

# --------- Plot des dépassements / remboursements / dépenses par spécialités -------------- #

#### nb de specialites differentes des executants ############################################
length(levels(data2017$l_exe_spe1)) #12

#### mise en forme des variables de montants depenses ########################################

#bases de remboursement
data2017$rec_mon2 <- as.character(data2017$rec_mon)
data2017$rec_mon2 <- substr(data2017$rec_mon2, 1, nchar(data2017$rec_mon2)-3)
data2017$rec_mon2 <- gsub("[^0123456789]", "", data2017$rec_mon2)
data2017$rec_mon2 <- as.numeric(data2017$rec_mon2)
#on a transforme en positif les chiffres inscrits en negatif

#depassements d'honoraires
data2017$dep_mon2 <- as.character(data2017$dep_mon)
data2017$dep_mon2 <- substr(data2017$dep_mon2, 1, nchar(data2017$dep_mon2)-3)
data2017$dep_mon2 <- gsub("[^0123456789]", "", data2017$dep_mon2)
data2017$dep_mon2 <- as.numeric(data2017$dep_mon2)

#montant rembourse
data2017$rem_mon2 <- as.character(data2017$rem_mon)
data2017$rem_mon2 <- substr(data2017$rem_mon2, 1, nchar(data2017$rem_mon2)-3)
data2017$rem_mon2 <- gsub("[^0123456789]", "", data2017$rem_mon2)
data2017$rem_mon2 <- as.numeric(data2017$rem_mon2)

#reste a charge hors depassements
data2017$reste <- data2017$rec_mon2 - data2017$rem_mon2

#### creation des variables remboursements/restes a charge/depassements par specialite ########

#liste des valeurs (integer) prises par exe_spe (liste des specialites)
list <- levels(as.factor(data2017$exe_spe1))
list <- as.integer(list) #length(list) = 12

#somme des montants rembourses par specialite (exe_spe1)
data2017$rem_sumspe <- NA
for(i in list) {
  data2017[data2017$exe_spe1==i,]$rem_sumspe <- sum(data2017[data2017$exe_spe1==i,]$rem_mon2)
}

#somme des restes a charge par specialite (exe_spe1)
data2017$reste_sumspe <- NA
for(i in list) {
  data2017[data2017$exe_spe1==i,]$reste_sumspe <- sum(data2017[data2017$exe_spe1==i,]$reste)
}

#somme des depassements d'honoraires par specialite (exe_spe1)
data2017$dep_sumspe <- NA
for(i in list) {
  data2017[data2017$exe_spe1==i,]$dep_sumspe <- sum(data2017[data2017$exe_spe1==i,]$dep_mon2)
}

#### mise en forme des donnees pour le plot #############################################

rem_sumspe <- aggregate(data2017$rem_sumspe, list(data2017$l_exe_spe1, data2017$exe_spe1), mean)
reste_sumspe <- aggregate(data2017$reste_sumspe, list(data2017$l_exe_spe1, data2017$exe_spe1), mean)
dep_sumspe <- aggregate(data2017$dep_sumspe, list(data2017$l_exe_spe1, data2017$exe_spe1), mean)

tot <- rbind()









# ------- Plot des taux de dépassements en fonction des taux de remboursement --------- #

#### mise en forme des variables bases de remboursement et depassements honoraires ####

data2017$rec_mon2 <- as.character(data2017$rec_mon)
data2017$rec_mon2 <- substr(data2017$rec_mon2, 1, nchar(data2017$rec_mon2)-3)
data2017$rec_mon2 <- gsub("[^0123456789]", "", data2017$rec_mon2)
data2017$rec_mon2 <- as.numeric(data2017$rec_mon2)
#on a transforme en positif les chiffres inscrits en negatif

data2017$dep_mon2 <- as.character(data2017$dep_mon)
data2017$dep_mon2 <- substr(data2017$dep_mon2, 1, nchar(data2017$dep_mon2)-3)
data2017$dep_mon2 <- gsub("[^0123456789]", "", data2017$dep_mon2)
data2017$dep_mon2 <- as.numeric(data2017$dep_mon2)

#### creation de la variable taux de depassement par taux de remboursement ####

#liste des valeurs (integer) prises par REM_TAU (taux de remboursement)
list <- levels(as.factor(data2017$REM_TAU))
list <- as.integer(list)

#somme des bases de remboursement par taux de remboursement
data2017$rec_sumtx <- NA
for(i in list) {
  data2017[data2017$REM_TAU==i,]$rec_sumtx <- sum(data2017[data2017$REM_TAU==i,]$rec_mon2)
}

#somme des depassements d'honoraires par type de prestation
data2017$dep_sumtx <- NA
for(i in list) {
  data2017[data2017$REM_TAU==i,]$dep_sumtx <- sum(data2017[data2017$REM_TAU==i,]$dep_mon2)
}

#creation de la variable taux de depassement par taux de remboursement
data2017$txdep_tx <- (data2017$dep_sumtx/data2017$rec_sumtx)*100

#### plot des taux de depassement par taux de remboursement ####

txdep_tx <- aggregate(data2017$txdep_tx, list(data2017$REM_TAU), mean)

ggplot(txdep_tx, aes(x=txdep_tx$Group.1, y=txdep_tx$x)) +
  geom_bar(stat='identity') +
  xlab("Taux de remboursement des prestations") +
  ylab("Taux de dépassement des honoraires") +
  ggtitle("Taux de depassement par taux de remboursement")

# -- Plot taux de dépassements - taux de remboursement en se focus sur qq prestations -- #














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




