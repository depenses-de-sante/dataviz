library(haven)
library(foreign)
#install.packages("Hmisc")
library(Hmisc)

##################################################################################
######################### Donnees "medicaments centrees" #########################
##################################################################################

setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments")

data <- read.csv2("OPEN_MEDIC_2016.CSV", header = TRUE, encoding = "latin1")
#base qui se trouve sur https://www.data.gouv.fr/fr/datasets/open-medic-base-complete-sur-les-depenses-de-medicaments-interregimes/
#on peut avoir ces donnees pour 2014 et 2015 aussi
#slmt medicament delivre en pharmacie de ville, et rembourse par assu maladie
#Une observation = 
#une combinaison medicament-sexe beneficiaire-age beneficiaire-type de prescripteur-region de residence du beneficiaire

summary.default(data)
#1.799.650 observations
head(data)

#ATC1 = Goupe Principal Anatomique
head(data$CIP13)

##################################################################################
######################### Donnees "prestations centrees" #########################
##################################################################################

setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments/R2016")
data_prs <- read.csv2("R201601.CSV", header = TRUE, encoding = "latin1")
#base qui se trouve sur : https://www.data.gouv.fr/fr/datasets/depenses-d-assurance-maladie-hors-prestations-hospitalieres-par-caisse-primaire-departement/
#cette base = ensemble des prestations de sante des francais remboursees par l'assu maladie
#pour janvier 2016
#agrege au niv du departement et type de prestation

summary.default(data_prs)

#variable qui nous donne les specialites des executants (gyneco, ophtalmo...):
levels(data_prs$l_exe_spe)
#variable montant des depassements d'honoraires :
describe(data_prs$dep_mon)
#variable departement:
levels(data_prs$dpt)

#objectif: sortir un tableau avec les depassements d'honoraires par departement pour jan 2016

#etude de la variable dep_mon : pas de missing mais on a des valeurs aberrantes

#on remplace les valeurs negatives par 0
data_prs$dep_mon2 <- as.character(data_prs$dep_mon)
data_prs$dep_mon2 <- substr(data_prs$dep_mon2, 1,nchar(data_prs$dep_mon2)-3)
data_prs$dep_mon2 <- as.numeric(data_prs$dep_mon2)

data_prs$dep_mon2 <- ifelse(data_prs$dep_mon2 < 0, 0, data_prs$dep_mon2)
describe(data_prs$dep_mon2)

#traitement des valeurs trop hautes pour etre pertinentes
data_prs$dep_mon3 <- ifelse(data_prs$dep_mon2 == 0, NA, data_prs$dep_mon2)
quantile(data_prs$dep_mon3, 0.75, na.rm = TRUE)
Fn <- ecdf(data_prs$dep_mon3)
plot(Fn, lwd = 2) 
#je ne suis pas capable de dire, au niv agrege, quelles valeurs apparaissent aberrantes ou non

#si on se concentre sur les gyneco:
df_gyn <-  data_prs[data_prs$l_exe_spe == "07-TOTAL Gynécologie", ]
Fn_gyn <- ecdf(df_gyn$dep_mon3)
plot(Fn_gyn, lwd = 2)

quantile(df_gyn$dep_mon3, 0.90, na.rm = TRUE)
#ca vaut 300

#-> se renseigner + pour voir a quel point cest plausible


