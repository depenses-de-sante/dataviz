library(haven)
library(foreign)
#install.packages("Hmisc")
library(Hmisc)

##################################################################################
######################### Donnees "medicaments centrees" #########################
##################################################################################

setwd("C:/Users/user/Documents/3A/3AS2/dataviz/sante/data")

data <- read.csv2("OPEN_MEDIC_2016.CSV", header = TRUE, encoding = "latin1")
#base qui se trouve sur https://www.data.gouv.fr/fr/datasets/open-medic-base-complete-sur-les-depenses-de-medicaments-interregimes/
#on peut avoir ces donnees pour 2014 et 2015 aussi
#slmt medicament delivre en pharmacie de ville, et rembourse par assu maladie
#Une observation = une combinaison medicament-sexe beneficiaire-age beneficiaire-type de 
#prescripteur-region de residence du beneficiaire

summary.default(data)
#1.799.650 observations


# virer les points dans les montants
data$REM <- gsub("[^0123456789,]", "", data$REM)
data$BSE <- gsub("[^0123456789,]", "", data$BSE)

data$REM <- gsub(",", ".", data$REM)
data$BSE <- gsub(",", ".", data$BSE)

data$BOITES <- as.numeric(data$BOITES)
data$BSE <- as.numeric(data$BSE)
data$REM <- as.numeric(data$REM)

data$dep_agreg <- data$BSE * data$BOITES
data$dep_pub <- data$REM * data$BOITES
data$taux_remb <- data$REM / data$BSE
data$reste_a_charge <- data$BSE - data$REM

data <- subset(data, !(data$BOITES < 0))
# 3 observations avec nb boites négatif

head(data)
#write.csv(data, file="openmedic2016.csv")

deciles <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
quantiledep <- quantile(data$dep_agreg, probs = deciles)
quantiledepub <- quantile(data$dep_pub, probs = deciles)
quantileprix <- quantile(data$BSE, probs = deciles)
quantileremb <- quantile(data$REM, probs = deciles)
quantiletxrem <- quantile(data$taux_remb, prob = deciles)

#TODO: create variables quantiles à partir des listes
data$quantiledep <- cut(data$dep_agreg, breaks = quantiledep)  
data$quantiledepub <- cut(data$dep_pub, breaks = quantiledepub)
data$quantileprix <- cut(data$BSE, breaks = quantileprix)
data$quantileremb <- cut(data$REM, breaks = quantileremb)
data$quantiletxrem <- cut(data$taux_remb, breaks = quantiletxrem)

varstoagg <- c("REM","BSE","dep_agreg","dep_pub","taux_remb", "reste_a_charge")
vars1 <- c("REM","BSE","dep_agreg","dep_pub","taux_remb", "reste_a_charge", "quantiledep")
vars2 <- c("REM","BSE","dep_agreg","dep_pub","taux_remb", "reste_a_charge", "quantiledepub")
vars3 <- c("REM","BSE","dep_agreg","dep_pub","taux_remb", "reste_a_charge", "quantileprix")
vars4 <- c("REM","BSE","dep_agreg","dep_pub","taux_remb", "reste_a_charge", "quantileremb")
vars5 <- c("REM","BSE","dep_agreg","dep_pub","taux_remb", "reste_a_charge", "quantiletxrem")

datadep <- data[vars1]
datadep <- aggregate(datadep[varstoagg], by=list(data$quantiledep), FUN=mean)

datadepub <- data[vars2]
datadepub <- aggregate(datadepub[varstoagg], by=list(data$quantiledepub), FUN=mean)

dataprix <- data[vars3]
dataprix <- aggregate(dataprix[varstoagg], by=list(data$quantileprix), FUN=mean)

dataremb <- data[vars4]
dataremb <- aggregate(dataremb[varstoagg], by=list(data$quantileremb), FUN=mean)

datatxrmb <- data[vars5]
datatxrmb <- aggregate(datatxrmb[varstoagg], by=list(data$quantiletxrem), FUN=mean)
