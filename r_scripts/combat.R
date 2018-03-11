## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, comment = "", fig.height = 5.5, fig.width = 5.5, cache = TRUE)

## ---- echo=FALSE, warning=FALSE------------------------------------------
library(dplyr)
labels = data.frame('label'=names(read.csv('imageData.csv'))[-1])
rois = read.csv('labels.csv', header=FALSE, stringsAsFactors=FALSE)
colnames(rois) = c('label', 'roi')
regions = left_join(labels, rois, by='label')
regions[1:15,]

## ------------------------------------------------------------------------
source('utils.R')
source('combat.R')

## ------------------------------------------------------------------------
modelData = read.csv('modelData.csv')
head(modelData)

## ------------------------------------------------------------------------
mod = model.matrix(~age+factor(sex)+factor(dx), data=modelData)

## ------------------------------------------------------------------------
ctData = read.csv('imageData.csv')
head(ctData)[,1:10]

## ------------------------------------------------------------------------
img = t(ctData[,-1])
head(img)[,1:10]

## ------------------------------------------------------------------------
harmonized = combat(dat=img, batch=modelData$scanner, mod=mod)

## ------------------------------------------------------------------------
head(harmonized$dat.combat)[,1:10]

## ------------------------------------------------------------------------
modelData$sex = factor(modelData$sex)
modelData$dx = factor(modelData$dx)
modelData$scanner = factor(modelData$scanner)

## ------------------------------------------------------------------------
preComBat = left_join(modelData, ctData, by='subject')
preRInsula = lm(X2035 ~ age + sex + dx + scanner, data=preComBat)
summary(aov(preRInsula))

## ------------------------------------------------------------------------
harmonizedData = as.data.frame(t(harmonized$dat.combat))
harmonizedData$subject = ctData$subject

## ------------------------------------------------------------------------
postComBat = left_join(modelData, harmonizedData, by='subject')
postRInsula = lm(X2035 ~ age + sex + dx + scanner, data=postComBat)
summary(aov(postRInsula))

