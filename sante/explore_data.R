library(haven)
library(foreign)

setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments")

data <- read.csv2("OPEN_MEDIC_2016.CSV", header = TRUE, encoding = "latin1")
#on peut avoir ces donnees pour 2014 et 2015 aussi
#slmt medicament delivre en pharmacie de ville
#Une observation = 
#une combinaison medicament-sexe beneficiaire-age beneficiaire-type de prescripteur-region de residence du beneficiaire

summary.default(data)
#1.799.650 observations
head(data)

#ATC1 = Goupe Principal Anatomique
head(data$CIP13)

#pour les donnees "prestations centrees"
setwd("/Users/emiliecupillard/Documents/ENSAE/ENSAE\ 3A/Dataviz/Médicaments/R2016")
data_prs <- read.csv2("R201601.CSV", header = TRUE, encoding = "latin1")

summary.default(data_prs)

levels(data_prs$l_exe_spe)


