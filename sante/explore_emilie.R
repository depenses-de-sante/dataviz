library(haven)
library(foreign)
#install.packages("Hmisc")
library(Hmisc)
library(ggplot2)
#install.packages("base")
library(base)
#install.packages("reshape")
library(reshape)

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

#********************************************************************************************#
# --- Plot des dépassements/remboursements/dépenses par spécialités - niv moins agrege ----- #
#********************************************************************************************#

#### selection des specialites qui nous interesse ##########################

DATA <- data2017[data2017$l_exe_spe1 == "Dentistes Omnipraticiens" |
                   data2017$l_exe_spe1 == "Infirmiers"|
                   data2017$l_exe_spe1 == "Orthoptistes" |
                   data2017$l_exe_spe1 == "Médecins Spécialistes"|
                   data2017$l_exe_spe1 == "Dentistes Spécialistes"|
                   data2017$l_exe_spe1 == "Masseurs-Kinésithérapeutes"|
                 data2017$l_exe_spe1 ==  "Orthophonistes"|
                   data2017$l_exe_spe1 ==  "Sages-Femmes" |
                   data2017$l_exe_spe1 == "Médecins Omnipraticiens",]

#liste des valeurs (integer) prises par exe_spe (liste desagregee des specialites)
list <- levels(as.factor(DATA$exe_spe))
list <- as.integer(list) #length(list) = 58

#### mise en forme des variables de montants depenses ########################################

#bases de remboursement
DATA$rec_mon2 <- as.character(DATA$rec_mon)
DATA$rec_mon2 <- substr(DATA$rec_mon2, 1, nchar(DATA$rec_mon2)-3)
DATA$rec_mon2 <- gsub("[^0123456789]", "", DATA$rec_mon2)
DATA$rec_mon2 <- as.numeric(DATA$rec_mon2)
#on a transforme en positif les chiffres inscrits en negatif

#depassements d'honoraires
DATA$dep_mon2 <- as.character(DATA$dep_mon)
DATA$dep_mon2 <- substr(DATA$dep_mon2, 1, nchar(DATA$dep_mon2)-3)
DATA$dep_mon2 <- gsub("[^0123456789]", "", DATA$dep_mon2)
DATA$dep_mon2 <- as.numeric(DATA$dep_mon2)

#montant rembourse
DATA$rem_mon2 <- as.character(DATA$rem_mon)
DATA$rem_mon2 <- substr(DATA$rem_mon2, 1, nchar(DATA$rem_mon2)-3)
DATA$rem_mon2 <- gsub("[^0123456789]", "", DATA$rem_mon2)
DATA$rem_mon2 <- as.numeric(DATA$rem_mon2)

#reste a charge hors depassements
DATA$reste <- DATA$rec_mon2 - DATA$rem_mon2

#### somme des valeurs par specialite ########################################

#somme des montants rembourses par specialite (exe_spe)
DATA$rem_sumspe <- NA
for(i in list) {
  DATA[DATA$exe_spe==i,]$rem_sumspe <- sum(DATA[DATA$exe_spe==i,]$rem_mon2)
}

#somme des restes a charge par specialite (exe_spe)
DATA$reste_sumspe <- NA
for(i in list) {
  DATA[DATA$exe_spe==i,]$reste_sumspe <- sum(DATA[DATA$exe_spe==i,]$reste)
}

#somme des depassements d'honoraires par specialite (exe_spe)
DATA$dep_sumspe <- NA
for(i in list) {
  DATA[DATA$exe_spe==i,]$dep_sumspe <- sum(DATA[DATA$exe_spe==i,]$dep_mon2)
}

#### mise en forme des donnees pour le plot #############################################

rem_sumspe <- aggregate(DATA$rem_sumspe, list(DATA$l_exe_spe, DATA$exe_spe), mean)
reste_sumspe <- aggregate(DATA$reste_sumspe, list(DATA$l_exe_spe, DATA$exe_spe), mean)
dep_sumspe <- aggregate(DATA$dep_sumspe, list(DATA$l_exe_spe, DATA$exe_spe), mean)

tot <- cbind(rem_sumspe, reste_sumspe[,3], dep_sumspe[,3])
colnames(tot) <- c("l_exe_spe", "exe_spe", "rem", "reste", "dep")

tot2 <- melt(tot, id=c("l_exe_spe", "exe_spe")) 

#### realisation du plot #################################################################

ggplot(data=tot2, aes(x=reorder(l_exe_spe, value), y=value, fill=variable)) +
  geom_bar(stat="identity") +
  coord_flip() +
  xlab("Specialites") +
  ylab("Montants dépensés") +
  ggtitle("Montants remboursés, restes à charge hors dépassements et dépassements par specialites")


#******************************************************************************************#
# ---------------------------- Focus sur les CONSULTATIONS ------------------------------- #
#******************************************************************************************#

#on choisit de ne garder que les prestations appelees "CONSULTATIONS" par l'assu maladie
DATA <- DATA[DATA$l_serie == "C autres" | DATA$l_serie == "C bilan"|
               DATA$l_serie == "C Dentistes"| DATA$l_serie == "C Neuropsychiatres"|
               DATA$l_serie == "C Omnipraticiens"| DATA$l_serie ==  "C Sages-femmes"|
               DATA$l_serie ==  "C Spécialistes"| 
               DATA$l_serie == "C Spécifique des Cardiologues",]

#liste des valeurs (integer) prises par exe_spe (liste desagregee des specialites)
list <- levels(as.factor(DATA$exe_spe))
list <- as.integer(list) #length(list) = 54

#### somme des valeurs par specialite ########################################

#somme des montants rembourses par specialite (exe_spe)
DATA$rem_sumspe <- NA
for(i in list) {
  DATA[DATA$exe_spe==i,]$rem_sumspe <- sum(DATA[DATA$exe_spe==i,]$rem_mon2)
}

#somme des restes a charge par specialite (exe_spe)
DATA$reste_sumspe <- NA
for(i in list) {
  DATA[DATA$exe_spe==i,]$reste_sumspe <- sum(DATA[DATA$exe_spe==i,]$reste)
}

#somme des depassements d'honoraires par specialite (exe_spe1)
DATA$dep_sumspe <- NA
for(i in list) {
  DATA[DATA$exe_spe==i,]$dep_sumspe <- sum(DATA[DATA$exe_spe==i,]$dep_mon2)
}

#### mise en forme des donnees pour le plot #############################################

rem_sumspe <- aggregate(DATA$rem_sumspe, list(DATA$l_exe_spe, DATA$exe_spe), mean)
reste_sumspe <- aggregate(DATA$reste_sumspe, list(DATA$l_exe_spe, DATA$exe_spe), mean)
dep_sumspe <- aggregate(DATA$dep_sumspe, list(DATA$l_exe_spe, DATA$exe_spe), mean)

tot <- cbind(rem_sumspe, reste_sumspe[,3], dep_sumspe[,3])
colnames(tot) <- c("l_exe_spe", "exe_spe", "rem", "reste", "dep")

tot2 <- melt(tot, id=c("l_exe_spe", "exe_spe")) 

#### realisation du plot #################################################################

ggplot(data=tot2, aes(x=reorder(l_exe_spe, value), y=value, fill=variable)) +
  geom_bar(stat="identity") +
  coord_flip() +
  xlab("Specialites") +
  ylab("Montants dépensés") +
  ggtitle("Montants remboursés, restes à charge hors dépassements et dépassements EN NE GARDANT QUE LES CONSULT")

#### on essaie de denombrer les consultations pour chaque specialites #######################

#nettoyage var act_dnb
DATA$act_dnb2 <- as.character(DATA$act_dnb)
DATA$act_dnb2 <- gsub("\\..*","", DATA$act_dnb2)
DATA$act_dnb2 <- as.numeric(DATA$act_dnb2)

#somme des consulations par specialites
DATA$nb <- NA
for(i in list) {
  DATA[DATA$exe_spe==i,]$nb <- sum(DATA[DATA$exe_spe==i,]$act_dnb2)
}

#agregation
nb <- aggregate(DATA$nb, list(DATA$l_exe_spe, DATA$exe_spe), sum)

#creation du vecteur des taux de depassement
txdep <-  (dep_sumspe[,3]/(rem_sumspe[,3] + reste_sumspe[,3]))*100

#fusion des vecteurs taux de depassement et nb de consultations

tot3 <- cbind(nb, txdep)
colnames(tot3) <- c("l_exe_spe", "exe_spe", "nb", "txdep")

tot4 <- melt(tot3, id=c("l_exe_spe", "exe_spe")) 

#on va essayer de faire deux barres : nb de consultations et taux de depassement

ggplot(data=tot4, aes(x=reorder(l_exe_spe, value), y=value, fill=variable)) +
  geom_bar(stat="identity", position=position_dodge()) +
  coord_flip() +
  xlab("Specialites") +
  ylab("Tx dep et nb consult") +
  ggtitle("Tx dep des consult et nb consult par spe")
#echec

#on essaie juste la barre des taux dep
ggplot(data=tot3, aes(x=reorder(l_exe_spe, txdep), y=txdep)) +
  geom_bar(stat="identity") +
  coord_flip() +
  xlab("Specialites") +
  ylab("Tx dep") +
  ggtitle("Tx dep des consult par spe")
















#********************************************************************************************#
# ------------------------------------- Focus dentistes ------------------------------------ #
#********************************************************************************************#







#********************************************************************************************#
# ---------- Plot des taux de dépassements en fonction des taux de remboursement ----------- #
#********************************************************************************************#


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


















