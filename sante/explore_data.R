library(haven)
library(foreign)
#install.packages("Hmisc")
library(Hmisc)
library(ggplot2)

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

####################### Exploration au niv dpartemental ##########################

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

####################### Exploration au niv national ##########################

setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments/Prestations/Non\ hosp/National\ -\ dispo\ 2014-17")
data_prs <- read.csv2("N201801.csv", header = TRUE, encoding = "latin1")

#modalites de la var "l_serie" qui est une var codee par l'Assu maladie
#pour etablir ses series stat et qui est obtenue par croisement entre la specialite
#de l'executant de la prestation et la nature de la prestation

levels(data_prs$l_serie)
length(levels(data_prs$l_serie)) #173
length(levels(data_prs[data_prs$l_serie == "C Omnipraticiens", ]$l_prs_nat)) #434

#geriatre ? cf http://www.lemonde.fr/les-decodeurs/article/2017/11/29/depassements-d-honoraires-quelles-specialites-medicales-et-chirurgicales-sont-les-plus-concernees_5222160_4355770.html
levels(data_prs$l_exe_spe)

# -------------------- Focus gyneco -------------------- #
  
length(data_prs[data_prs$l_exe_spe == "07-Gynécologie obstétrique" | data_prs$l_exe_spe == "70-Gynécologie médicale" | data_prs$l_exe_spe == "79-Gynécologie obstétricale",1])
#8113
data_gyn <- data_prs[data_prs$l_exe_spe == "07-Gynécologie obstétrique" | data_prs$l_exe_spe == "70-Gynécologie médicale" | data_prs$l_exe_spe == "79-Gynécologie obstétricale",]

length(unique(subset(data_gyn, select = - c(rem_mon, rec_mon, dep_mon)))[,1])
# donc ok, pas de duplicats

#sur quelles prestations se focaliser, pour les gyneco, pour montrer 
#les montants de depassemnts d'honoraires ?

#nettoyage var bases de remboursement et depassements honoraires
data_gyn$rec_mon2 <- as.character(data_gyn$rec_mon)
data_gyn$rec_mon2 <- substr(data_gyn$rec_mon2, 1,nchar(data_gyn$rec_mon2)-3)
data_gyn$rec_mon2 <- as.numeric(data_gyn$rec_mon)

data_gyn$dep_mon2 <- as.character(data_gyn$dep_mon)
data_gyn$dep_mon2 <- substr(data_gyn$dep_mon2, 1,nchar(data_gyn$dep_mon2)-3)
data_gyn$dep_mon2 <- as.numeric(data_gyn$dep_mon)

#somme des bases de remboursements et des depassements par prestations
str(data_gyn$prs_nat)

list <- levels(as.factor(data_gyn$prs_nat))
list2 <- as.integer(list)

data_gyn$depsum_prs <- NA
for(i in list2) {
  data_gyn[data_gyn$prs_nat==i,]$depsum_prs <- sum(data_gyn[data_gyn$prs_nat==i,]$dep_mon2)
}

data_gyn$recsum_prs <- NA
for(i in list2) {
  data_gyn[data_gyn$prs_nat==i,]$recsum_prs <- sum(data_gyn[data_gyn$prs_nat==i,]$rec_mon2)
}

#calcul des taux de depassement par type de prestation

data_gyn$txdep_prs <- (data_gyn$depsum_prs/data_gyn$recsum_prs)*100

barplot(data_gyn$txdep_prs)



length(levels(data_gyn$l_prs_nat)) #434
length(levels(data_gyn$l_serie)) #173

str(data_gyn)

#histogramme par prestations ? 
#on aimerait que le + de prestations possibles aient un denombrement..
data_gyn$act_dnb2 <- as.numeric(as.character(data_gyn$act_dnb))

#on met en positif les occurrences negatives ?
data_gyn$act_dnb2 <- ifelse(data_gyn$act_dnb2 < 0, -data_gyn$act_dnb2, data_gyn$act_dnb2) 
min(data_gyn$act_dnb2)

length(levels(data_gyn[data_gyn$act_dnb2==0,]$l_prs_nat))
length(levels(data_gyn$l_prs_nat))





#"34-Gériatrie" 
length(data_prs[data_prs$l_exe_spe == "34-Gériatrie",1])
#710

