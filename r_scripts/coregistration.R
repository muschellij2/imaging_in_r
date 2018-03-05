## ----setup, include=FALSE------------------------------------------------
library(methods)
library(neurobase)
library(extrantsr)
knitr::opts_chunk$set(echo = TRUE, comment = "")

## ----list----------------------------------------------------------------
l = list()
l[[1]] = c(1, 2, 4, 5)
l[[2]] = matrix(1:10, nrow = 2)
print(l)

## ----listSub-------------------------------------------------------------
print(l[[1]])

## ----named_vec-----------------------------------------------------------
x = c(one = 1, three = 14, two = 5)
print(x)
x[c("three")]

## ----named_lst-----------------------------------------------------------
names(l) = c("V", "m"); l[["V"]]

## ----named_lst_v---------------------------------------------------------
l$V

## ----t1, message=FALSE---------------------------------------------------
library(ms.lesion)
all_files = get_image_filenames_list_by_subject()
class(all_files); names(all_files)
files = all_files$training01; class(files); names(files)
t1_fname = files["T1"]
t1 = readnii(t1_fname)
rt1 = robust_window(t1)

## ---- eval = TRUE, cache = TRUE, message=FALSE---------------------------
library(extrantsr)
reg = registration(filename = files["FLAIR"], 
                   template.file = files["T1"],
                   typeofTransform = "Rigid", 
                   interpolator = "Linear")
names(reg)

## ----plot_reg, eval = FALSE, cache = FALSE, message=FALSE----------------
## double_ortho(rt1, reg$outfile)

## ----plot_reg_show, echo = FALSE, eval = TRUE, cache = TRUE, message=FALSE----
reg$outfile = robust_window(reg$outfile)
double_ortho(rt1, reg$outfile)

## ---- eval = FALSE-------------------------------------------------------
## res = within_visit_registration(
##   fixed = files["T1"], moving = files[c("T2", "FLAIR")],
##   correct = TRUE, correction = "N4",
##   typeofTransform = "Rigid", interpolator = "Linear")
## output_imgs = lapply(res, function(x) x$outfile)
## out = c(T1 = list(t1), output_imgs)

## ----registration, eval = TRUE, echo = FALSE-----------------------------
mods = c("T2", "FLAIR")
outfiles = file.path("..", "output", basename(files[mods]))
names(outfiles) = mods
if (!all(file.exists(outfiles))) {
  res = within_visit_registration(
    fixed = files["T1"],
    moving = files[c("T2", "FLAIR")],
    correct = TRUE, correction = "N4",
    typeofTransform = "Rigid", 
    interpolator = "Linear"
  )
  output_imgs = lapply(res, function(x) x$outfile)
  names(output_imgs) = mods
  mapply(writenii, output_imgs, outfiles)
} else {
  output_imgs = check_nifti(outfiles)
}
xout = c(T1 = list(t1), output_imgs)
mask = xout$T1 > quantile( xout$T1[ xout$T1 > 0], probs = 0.25)
dd = dropEmptyImageDimensions(mask, 
                               other.imgs = xout)
xout = dd$other.imgs
out = lapply(xout, zscore_img, mask = dd$outimg)
out = lapply(out, window_img, window = c(-3, 3))

## ----reg_plot_ortho2_show, eval = FALSE----------------------------------
## double_ortho(out$T1, out$T2 )

## ----reg_plot_ortho2_run, echo = FALSE-----------------------------------
double_ortho(robust_window(xout$T1), robust_window(xout$T2 ))

## ----multi_overlay, echo = TRUE------------------------------------------
multi_overlay(out)

## ----bet_t1_show, echo = TRUE, eval = FALSE------------------------------
## mask = readnii("../output/training01_01_t1_mask.nii.gz") # MALF mask
## masked_imgs = lapply(out, mask_img, mask)

## ----bet_t1, echo = FALSE------------------------------------------------
mask = readnii("../output/training01_01_t1_mask.nii.gz")
sub_mask = applyEmptyImageDimensions(mask, inds = dd$inds)
masked_imgs = lapply(xout, mask_img, sub_mask)

## ----mimgs_2-------------------------------------------------------------
ortho2(masked_imgs$FLAIR)

## ----mimgs_T2------------------------------------------------------------
ortho2(masked_imgs$T2)

