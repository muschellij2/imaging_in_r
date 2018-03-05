## ----setup, include=FALSE, message = FALSE-------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")
library(methods)
library(ggplot2)
library(ms.lesion)
library(neurobase)
library(extrantsr)
library(scales)

## ----reading_in_image, eval = FALSE--------------------------------------
## t1 = neurobase::readnii("training01_01_t1.nii.gz")
## t1[ t1 < 0 ] = 0

## ----reading_in_image_run, echo = FALSE----------------------------------
t1 = neurobase::readnii("../training01_01_t1.nii.gz")
t1[ t1 < 0 ] = 0

## ----ortho2_show---------------------------------------------------------
ortho2(robust_window(t1))

## ----ortho2_show_flair, eval = FALSE-------------------------------------
## flair = neurobase::readnii("training01_01_flair.nii.gz")
## ortho2(robust_window(flair))

## ----ortho2_run_flair, echo = FALSE--------------------------------------
flair = neurobase::readnii("../training01_01_flair.nii.gz")
flair[ flair < 0 ] = 0
flair = drop_empty_dim(flair > 50, other.imgs = flair)
flair = flair$other.imgs
ortho2(robust_window(flair))

## ----lightbox------------------------------------------------------------
image(robust_window(t1), useRaster = TRUE)

## ----bc_show, message = FALSE, eval = FALSE------------------------------
## library(extrantsr)
## bc_t1 = bias_correct(file = t1, correction = "N4")

## ----bc_run, echo = FALSE------------------------------------------------
out_fname = "../output/training01_01_t1_n4.nii.gz"
if (!file.exists(out_fname)) {
  bc_t1 = bias_correct(file = t1, correction = "N4")
} else {
  bc_t1 = readnii(out_fname)
}

## ---- eval = FALSE-------------------------------------------------------
## bc_t1 = bias_correct(file = "training01_01_t1.nii.gz", correction = "N4")

## ----ratio_plot----------------------------------------------------------
ratio = t1 / bc_t1; ortho2(t1, ratio)

## ----making_scales, echo = FALSE-----------------------------------------
library(scales)
in_mask = (ratio < 0.999 | ratio > 1.0001) & ratio != 0

# get the quantiles
quantiles = quantile(ratio[ in_mask ], na.rm = TRUE,
             probs = seq(0, 1, by = 0.1) )
quantiles = unique(quantiles)

# get a diverging gradient palette
fcol = scales::brewer_pal(type = "div", palette = "Spectral")(10)
 # need one fewer color than breaks/quantiles
colors = gradient_n_pal(fcol)(seq(0,1, length = length(quantiles) - 1))
colors = scales::alpha(colors, 0.5) # colors are created

## ----better_ratio_plot---------------------------------------------------
ortho2(t1, ratio, col.y = colors, ybreaks = quantiles, ycolorbar = TRUE)

