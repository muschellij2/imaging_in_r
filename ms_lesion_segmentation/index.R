## ----setup, include=FALSE------------------------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")

## ----loading-------------------------------------------------------------
library(ms.lesion)
library(neurobase)
library(fslr)
library(scales)
library(extrantsr)
files = get_image_filenames_list_by_subject(
  group = "training", 
  type = "coregistered")
t1s = lapply(files, function(x) readnii(x["MPRAGE"]))
masks = lapply(files, function(x) readnii(x["Brain_Mask"]))

## ----readnii_show_run----------------------------------------------------
t2s = lapply(files, function(x) readnii(x["T2"]))
flairs = lapply(files, function(x) readnii(x["FLAIR"]))
pds = lapply(files, function(x) readnii(x["PD"]))
golds = lapply(files, function(x) readnii(x["mask2"]))

## ----over_show_run-------------------------------------------------------
les_mask = golds$training05
ortho2(t1s$training05, les_mask, col.y = "orange")

## ----oasis_df_show, eval=FALSE-------------------------------------------
## library(oasis)
## make_df = function(x){
##   res = oasis_train_dataframe(
##       flair=flairs[[x]], t1=t1s[[x]],
##       t2=t2s[[x]], pd=pds[[x]],
##       gold_standard=golds[[x]],
##       brain_mask=masks[[x]],
##       preproc=FALSE, normalize=TRUE,
##       return_preproc=FALSE)
##   return(res$oasis_dataframe)
## }
## oasis_dfs = lapply(1:5, make_df)

## ----oasis_run_show, eval=FALSE------------------------------------------
## oasis_model = do.call("oasis_training", args = oasis_dfs)

