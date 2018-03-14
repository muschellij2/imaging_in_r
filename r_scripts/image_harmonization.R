## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, comment = "", fig.height = 5.5, fig.width = 5.5, cache = TRUE)
library(tidyr)
library(dplyr)
library(tibble)
library(ggplot2)

## ---- echo=FALSE, warning=FALSE, message=FALSE---------------------------
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

## ---- echo = FALSE-------------------------------------------------------
pre_df = inner_join(ctData, modelData, by = "subject")
pre_df = pre_df %>% 
  gather(key = "roi", value = "thickness", starts_with("X"))
pre_df = pre_df %>% 
  mutate(roi = sub("^X", "", roi)) %>% 
  arrange(subject, roi, thickness) %>% 
  as_data_frame()
pre_df$combat = "before"

df = as_data_frame(t(harmonized$dat.combat))
df = bind_cols(df, modelData)

df = df %>% 
  gather(key = "roi", value = "thickness", starts_with("X"))
df = df %>% 
  mutate(roi = sub("^X", "", roi)) %>% 
  arrange(subject, roi, thickness)
df$combat = "after"

all_df = bind_rows(df, pre_df) %>% 
  arrange(subject, roi, combat, thickness)

no_xlabs = theme(axis.text.x=element_blank())
pre_medians = pre_df %>% 
  group_by(subject) %>% 
  summarize(med = median(thickness)) %>% 
  arrange(med)
post_medians = df %>% 
  group_by(subject) %>% 
  summarize(med = median(thickness)) %>% 
  arrange(med)
df = df %>% 
  mutate(sorted_subj = as.character(subject),
         sorted_subj = factor(sorted_subj, 
                              levels = pre_medians$subject),
         post_sorted_subj = as.character(subject),
         post_sorted_subj = factor(post_sorted_subj, 
                                   levels = post_medians$subject)
  )

pre_df = pre_df %>% 
  mutate(sorted_subj = as.character(subject),
         sorted_subj = factor(sorted_subj, 
                              levels = pre_medians$subject))

g = df %>% 
  ggplot(aes(x = sorted_subj, y = thickness, colour = scanner)) + 
  geom_boxplot() + 
  no_xlabs
pre_g = g %+% pre_df
png("avg_med_pre.png",
    height = 7, width = 14, res = 600, units = "in")
  pre_g
dev.off()
png("avg_med_post_sortedByPre.png", 
    height = 7, width = 14, res = 600, units = "in")
  g
dev.off()
gpost = df %>% 
  ggplot(aes(x = post_sorted_subj, y = thickness, colour = scanner)) + 
  geom_boxplot() + 
  no_xlabs
png("avg_med_post.png", height = 7, width = 14, res = 600, units = "in")
gpost
dev.off()

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

