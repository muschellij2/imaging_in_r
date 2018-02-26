## ----setup, include=FALSE------------------------------------------------
library(methods)
library(ggplot2)
library(pander)
knitr::opts_chunk$set(echo = TRUE, comment = "", cache=TRUE, warning = FALSE)

## ----loading, echo=FALSE, message=FALSE----------------------------------
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
tr_t1s = lapply(tr_files, function(x) readnii(x["T1"]))
tr_t2s = lapply(tr_files, function(x) readnii(x["T2"]))
tr_flairs = lapply(tr_files, function(x) readnii(x["FLAIR"]))
tr_masks = lapply(tr_files, function(x) readnii(x["Brain_Mask"]))
tr_golds = lapply(tr_files, function(x) readnii(x["mask"]))
ts_t1s = lapply(ts_files, function(x) readnii(x["T1"]))
ts_t2s = lapply(ts_files, function(x) readnii(x["T2"]))
tr_pds = ts_pds = NULL
ts_flairs = lapply(ts_files, function(x) readnii(x["FLAIR"]))
ts_masks = lapply(ts_files, function(x) readnii(x["Brain_Mask"]))
# John added for code to work

## ----over_show_run, echo=FALSE-------------------------------------------
les_mask = tr_golds$training05

# john code for choosing z-slice with highest # of voxels
w = which(les_mask > 0, arr.ind = TRUE)
w = as.data.frame(w, stringsAsFactors = FALSE)
keep_dim = w %>% group_by(dim3) %>% 
  tally() %>% 
  arrange(desc(n)) %>% 
  ungroup %>% slice(1) 
keep_dim = keep_dim$dim3
w = w[ w$dim3 %in% keep_dim, ]
xyz = floor(colMeans(w))
ortho2(robust_window(tr_flairs$training05), les_mask, xyz = xyz, col.y = scales::alpha("red", 0.5))

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

## ----default_predict_run, eval=TRUE, echo=FALSE--------------------------
default_ts = lapply(ts_files, 
	function(x) readnii(x["Default_OASIS"]))

## ----viz_01, echo=FALSE--------------------------------------------------
les_mask = default_ts[[1]]
les_mask[les_mask<.05] = 0
ortho2(ts_flairs$test01, les_mask, xyz = xyz)

## ----viz_02, echo=FALSE--------------------------------------------------
les_mask = default_ts[[1]] > 0.16
ortho2(ts_flairs$test01, les_mask, col.y=alpha("red", 0.5), xyz = xyz)

## ----default_predict_tr_show, eval=FALSE---------------------------------
## default_predict_tr = function(x){
##   res = oasis_predict(
##       flair=tr_flairs[[x]], t1=tr_t1s[[x]],
##       t2=tr_t2s[[x]], pd=tr_pds[[x]],
##       brain_mask=tr_masks[[x]],
##       preproc=FALSE, normalize=TRUE,
##       model=oasis::oasis_model, binary=TRUE)
##   return(res)
## }
## default_probs_tr = lapply(1:5, default_predict_tr)

## ----default_predict_tr_run, eval=TRUE, echo=FALSE-----------------------
default_tr = lapply(tr_files, 
	function(x){
		img = readnii(x["Default_OASIS"])
		img = img > 0.16
		return(img)
	})

## ----over_05_run, echo=FALSE---------------------------------------------
les_mask = default_tr[[5]]
ortho2(tr_flairs$training05, les_mask, col.y = alpha("red", 0.5))

## ----table1, echo=FALSE--------------------------------------------------
dice = function(x){
  return((2*x[2,2])/(2*x[2,2] + x[1,2] + x[2,1]))
}
tbls_df = lapply(1:5, function(x) table(
  c(tr_golds[[x]]), c(default_tr[[x]]))
  )
dfDice = sapply(tbls_df, dice)


diceDF = data.frame(Subject=factor(rep(1:5)), 
                    Dice=c(dfDice))
g = ggplot(diceDF, aes(x=Subject, y=Dice)) + 
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

## ----trained_predict_tr_run, eval=TRUE, echo=FALSE-----------------------
trained_tr = lapply(tr_files, 
  function(x){
    img = readnii(x["Trained_OASIS"])
    img = img > 0.16
    return(img)
  })

## ----table3, echo=FALSE--------------------------------------------------
tbls_tr = lapply(1:5, function(x) 
  table(c(tr_golds[[x]]), c(trained_tr[[x]])))
trDice = sapply(tbls_tr, dice)

diceTR = data.frame('Subject'=factor(1:5),
                    'Dice'=c(trDice))
diceDF$Model = "Default"
diceTR$Model = "Trained"
diceAll = rbind(diceDF, diceTR)
diceAll$Model = factor(diceAll$Model)

g = ggplot(diceAll, aes(x=Subject, y=Dice)) + 
  geom_histogram(position="dodge", stat="identity") + 
  facet_wrap(~Model)
print(g)

## ----dice_mat, echo = FALSE----------------------------------------------
df = cbind(id = sprintf("%02.0f", 1:5),
           r1 = round((trDice - dfDice) / dfDice * 100, 1))
df = data.frame(df, stringsAsFactors = FALSE)
colnames(df) = c("ID", "Dice")

## ---- echo = FALSE-------------------------------------------------------
pander(df)

