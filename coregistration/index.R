## ----setup, include=FALSE------------------------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")
options(fsl.path = "/usr/local/fsl/")
options(fsl.outputtype = "NIFTI_GZ")

## ----t1------------------------------------------------------------------
library(ms.lesion)
library(neurobase)
files = get_image_filenames_list_by_subject()$training01
t1_fname = files["MPRAGE"]
t1 = readnii(t1_fname)

## ----eval = FALSE--------------------------------------------------------
## library(extrantsr)
## reg = registration(filename = files["FLAIR"],
##                    template.file = files["MPRAGE"],
##                    typeofTransform = "Rigid",
##                    interpolator = "linear")

## ---- eval = FALSE-------------------------------------------------------
## res = within_visit_registration(
##   fixed = files["MPRAGE"],
##   moving = files[c("T2", "FLAIR", "PD")],
##   correct = TRUE, correction = "N4",
##   typeofTransform = "Rigid",
##   interpolator = "Linear"
## )
## output_imgs = lapply(res, function(x) x$outfile)
## names(output_imgs) = c("T2", "FLAIR", "PD")
## out = c(MPRAGE = list(t1), output_imgs)

## ----registration, eval = TRUE, echo = FALSE-----------------------------
mods = c("T2", "FLAIR", "PD")
outfiles = file.path("..", "output", basename(files[mods]))
names(outfiles) = mods
if (!all(file.exists(outfiles))) {
  res = within_visit_registration(
    fixed = files["MPRAGE"],
    moving = files[c("T2", "FLAIR", "PD")],
    correct = TRUE, correction = "N4",
    typeofTransform = "Rigid", 
    interpolator = "Linear"
  )
  output_imgs = lapply(res, function(x) x$outfile)
  names(output_imgs) = mods
} else {
  output_imgs = check_nifti(outfiles)
}
xout = c(MPRAGE = list(t1), output_imgs)
mask = xout$MPRAGE > quantile( xout$MPRAGE[ xout$MPRAGE > 0], probs = 0.25)
dd = dropEmptyImageDimensions(mask, 
                               other.imgs = xout)
xout = dd$other.imgs
out = lapply(xout, zscore_img, mask = dd$outimg)
out = lapply(out, window_img, window = c(-4, 4))

## ----multi_overlay, echo = FALSE-----------------------------------------
multi_overlay(out)

## ----reg_plot_ortho2_show, eval = FALSE----------------------------------
## double_ortho(out$MPRAGE, out$T2 )

## ----reg_plot_ortho2_run, echo = FALSE-----------------------------------
double_ortho(robust_window(xout$MPRAGE), robust_window(xout$T2 ))

## ----bet_t1_show, echo = TRUE, eval = FALSE------------------------------
## mask = readnii("../output/training01_01_mprage_mask.nii.gz")
## masked_imgs = lapply(out, mask_img, sub_mask)

## ----bet_t1, echo = FALSE------------------------------------------------
mask = readnii("../output/training01_01_mprage_mask.nii.gz")
sub_mask = applyEmptyImageDimensions(mask, inds = dd$inds)
masked_imgs = lapply(xout, mask_img, sub_mask)

## ----mimgs_2-------------------------------------------------------------
orthographic(masked_imgs$FLAIR)

