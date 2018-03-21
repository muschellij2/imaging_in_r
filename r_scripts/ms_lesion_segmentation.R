## ----setup, include=FALSE------------------------------------------------
library(methods)
library(ggplot2)
# library(pander)
library(knitr)
knitr::opts_chunk$set(echo = TRUE, comment = "", cache=TRUE, warning = FALSE)

## ----loading, echo=FALSE, message=FALSE, cache = FALSE-------------------
library(ms.lesion)
library(neurobase)
library(fslr)
library(scales)
library(oasis)
library(dplyr)
tr_files = get_image_filenames_list_by_subject(
  group = "training", type = "coregistered")
ts_files = get_image_filenames_list_by_subject(
  group = "test", type = "coregistered")
#tr_t1s = lapply(tr_files, function(x) readnii(x["T1"]))
#tr_t2s = lapply(tr_files, function(x) readnii(x["T2"]))
#tr_flairs = lapply(tr_files, function(x) readnii(x["FLAIR"]))
#tr_masks = lapply(tr_files, function(x) readnii(x["Brain_Mask"]))
#tr_golds = lapply(tr_files, function(x) readnii(x["mask"]))
#tr_oasis = lapply(tr_files, function(x) readnii(x["Default_OASIS"]))
#ts_t1s = lapply(ts_files, function(x) readnii(x["T1"]))
#ts_t2s = lapply(ts_files, function(x) readnii(x["T2"]))
#tr_pds = ts_pds = NULL
#ts_flairs = lapply(ts_files, function(x) readnii(x["FLAIR"]))
#ts_masks = lapply(ts_files, function(x) readnii(x["Brain_Mask"]))
#ts_golds = lapply(ts_files, function(x) readnii(x["mask"]))
#ts_oasis = lapply(ts_files, function(x) readnii(x["Default_OASIS"]))

## ----default_predict_ts_show, eval=FALSE---------------------------------
## library(oasis)
## default_predict_ts = function(x){
##   res = oasis_predict(
##       flair=ts_flairs[[x]], t1=ts_t1s[[x]],
##       t2=ts_t2s[[x]], pd=ts_pds[[x]],
##       brain_mask = ts_masks[[x]],
##       preproc=FALSE, normalize=TRUE,
##       model=oasis::oasis_model)
##   return(res)
## }
## default_probs_ts = lapply(1:3, default_predict_ts)

## ----viz_01, echo=FALSE--------------------------------------------------
tsflair = readnii(ts_files$test01["FLAIR"])
les_mask = readnii(ts_files$test01["Default_OASIS"])
les_mask[les_mask < .05] = 0
vx = c(122,257,341)
ortho2(tsflair, les_mask, xyz = vx)

## ----viz_02, echo=FALSE--------------------------------------------------
les_mask[les_mask > 0.16] = 1
les_mask[les_mask < 1] = 0
ortho2(tsflair, les_mask, xyz=vx, col.y=alpha("red", 0.5))

## ----default_predict_tr_run, eval=FALSE, echo=FALSE----------------------
## ts_oasis = lapply(ts_files, function(x) readnii(x["Default_OASIS"]))
## default_ts = lapply(ts_oasis,
## 	function(x){
## 		x = x > 0.16
## 		return(x)
## 	})

## ----table1, echo=FALSE, eval=FALSE--------------------------------------
## dice = function(x){
##   return((2*x[2,2])/(2*x[2,2] + x[1,2] + x[2,1]))
## }
## tbls_df = lapply(1:3, function(x) table(
##   c(round(ts_golds[[x]], 0)), c(round(default_ts[[x]], 0))
##   ))
## dfDice = sapply(tbls_df, dice)
## diceDF = data.frame(Subject=factor(rep(1:3)),
##                     Dice=c(dfDice))
## write.csv(diceDF, file='testDice.csv', row.names=FALSE)

## ----table1_run, echo=FALSE----------------------------------------------
diceDF = read.csv('testDice.csv')
g = ggplot(diceDF, aes(x=Subject, y=Dice)) + 
       geom_histogram(position="dodge", stat="identity")
print(g)

## ----seq_show, echo=FALSE, eval=FALSE------------------------------------
## tr_golds = lapply(tr_files, function(x) readnii(x["mask"]))
## tr_oasis = lapply(tr_files, function(x) readnii(x["Default_OASIS"]))
## th = seq(0.05, 0.3, by=0.05)
## dice_tr = lapply(1:5,
## 	function(x){
## 		img = tr_oasis[[x]]
## 	  gold = tr_golds[[x]]
## 		diceTh = unlist(lapply(th, function(y){
##   		binimg = img > y
## 		  tbl = table(c(binimg), c(gold))
## 		  return(dice(tbl))
## 		}))
## 		return(diceTh)
## 	})
## avgDice = Reduce('+', dice_tr)/length(dice_tr[[1]])
## write.csv(rbind(th, avgDice), file='avgDice.csv', row.names=FALSE)

## ----seq_run, echo=FALSE-------------------------------------------------
diceDf = read.csv('avgDice.csv')
colnames(diceDf) = NULL
rownames(diceDf) = c("Threshold", "Average Dice")
print(round(diceDf, 3))

## ----seq_show_15, echo=FALSE, eval=FALSE---------------------------------
## default_ts15 = lapply(ts_oasis,
## 	function(x){
## 		x = x > 0.15
## 		return(x)
## 	})
## tbls_df15 = lapply(1:3, function(x) table(
##   c(round(ts_golds[[x]], 0)), c(round(default_ts15[[x]], 0))))
## dfDice15 = sapply(tbls_df15, dice)
## diceDF15 = data.frame(Subject=factor(rep(1:3)),
##                     Dice=c(dfDice15))
## write.csv(diceDF15, file='testDice15.csv', row.names=FALSE)

## ----seq_run_15, echo=FALSE----------------------------------------------
diceDF15 = read.csv('testDice15.csv')
g = ggplot(diceDF15, aes(x=Subject, y=Dice)) + 
       geom_histogram(position="dodge", stat="identity")
print(g)

## ----oasis_df_show, eval=FALSE-------------------------------------------
## make_df = function(x){
##   res = oasis_train_dataframe(
##       flair=tr_flairs[[x]], t1=tr_t1s[[x]], t2=tr_t2s[[x]],
##       pd=tr_pds[[x]], gold_standard=tr_golds[[x]],
##       brain_mask=tr_masks[[x]],
##       preproc=FALSE, normalize=TRUE, return_preproc=FALSE)
##   return(res$oasis_dataframe)
## }
## oasis_dfs = lapply(1:5, make_df)

## ----oasis_model_show, eval=FALSE----------------------------------------
## ms_model = do.call("oasis_training", oasis_dfs)

## ----oasis_model_show2---------------------------------------------------
print(ms.lesion::ms_model)

## ----trained_predict_tr_show, eval=FALSE, echo=FALSE---------------------
## tr_golds = lapply(tr_files, function(x) readnii(x["mask"]))
## tr_oasis = lapply(tr_files, function(x) readnii(x["Trained_OASIS"]))
## th = seq(0.05, 0.3, by=0.05)
## dice_tr = lapply(1:5,
## 	function(x){
## 		img = tr_oasis[[x]]
## 	  gold = tr_golds[[x]]
## 		diceTh = unlist(lapply(th, function(y){
##   		binimg = img > y
## 		  tbl = table(c(binimg), c(gold))
## 		  return(dice(tbl))
## 		}))
## 		return(diceTh)
## 	})
## avgDice = Reduce('+', dice_tr)/length(dice_tr[[1]])
## write.csv(rbind(th, avgDice), file='avgDiceReTrain.csv', row.names=FALSE)

## ----trained_predict_tr_dice, eval=TRUE, echo=FALSE----------------------
diceDf = read.csv('avgDiceReTrain.csv')
colnames(diceDf) = NULL
rownames(diceDf) = c("Threshold", "Average Dice")
print(round(diceDf, 3))

## ----trained_predict_tr_run, eval=TRUE, echo=FALSE-----------------------
trained_ts = lapply(ts_files, 
  function(x){
    img = readnii(x["Trained_OASIS"])
    img = img > 0.15
    return(img)
  })

## ----table3, echo=FALSE--------------------------------------------------
ts_golds = lapply(ts_files, function(x) readnii(x["mask"]))
tbls_ts = lapply(1:3, function(x) 
  table(c(ts_golds[[x]]), c(trained_ts[[x]])))
tsDice = sapply(tbls_ts, dice)

diceTS = data.frame('Subject'=factor(1:3),
                    'Dice'=c(tsDice))
diceDF$Model = "Default"
diceTS$Model = "Trained"
diceAll = rbind(diceDF, diceTS)
diceAll$Model = factor(diceAll$Model)

g = ggplot(diceAll, aes(x=Subject, y=Dice)) + 
  geom_histogram(position="dodge", stat="identity") + 
  facet_wrap(~Model)
print(g)

## ----dice_mat, echo = FALSE----------------------------------------------
df = cbind(id = sprintf("%02.0f", 1:3),
           r1 = round((tsDice - diceDF$Dice) / diceDF$Dice * 100, 1))
df = data.frame(df, stringsAsFactors = FALSE)
colnames(df) = c("ID", "Dice")

## ---- echo = FALSE-------------------------------------------------------
knitr::kable(df)

