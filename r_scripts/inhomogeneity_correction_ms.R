## ----setup, include=FALSE, message = FALSE-------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")
library(methods)
library(ggplot2)
library(ms.lesion)
library(neurobase)
library(extrantsr)
library(scales)

## ----reading_in_image----------------------------------------------------
t1 = neurobase::readnii("training01_01_mprage.nii.gz")

## ----ortho2_show---------------------------------------------------------
ortho2(robust_window(t1))

## ----lightbox------------------------------------------------------------
image(robust_window(t1), useRaster = TRUE)

## ----bc_show, message = FALSE, eval = FALSE------------------------------
## library(extrantsr)
## bc_t1 = bias_correct(file = t1, correction = "N4")

## ----bc_run, echo = FALSE------------------------------------------------
out_fname = "../output/training01_01_mprage_n4.nii.gz"
if (!file.exists(out_fname)) {
  bc_t1 = bias_correct(file = t1, correction = "N4")
} else {
  bc_t1 = readnii(out_fname)
}

## ---- eval = FALSE-------------------------------------------------------
## bc_t1 = bias_correct(file = "training01_01_mprage.nii.gz", correction = "N4")

## ----ratio_plot----------------------------------------------------------
ratio = t1 / bc_t1; ortho2(t1, ratio)

## ----making_scales, echo = FALSE-----------------------------------------
library(scales)
in_mask = (ratio < 0.999 | ratio > 1.0001) & ratio != 0

# get the quantiles
quants = quantile(ratio[ in_mask ], na.rm = TRUE,
             probs = seq(0, 1, by = 0.1) )
quants = unique(quants)

# get a diverging gradient palette
fcol = scales::brewer_pal(type = "div", palette = "Spectral")(10)
 # need one fewer color than breaks/quantiles
colors = gradient_n_pal(fcol)(seq(0,1, length = length(quants) - 1))
colors = scales::alpha(colors, 0.5) # colors are created

## ----better_ratio_plot---------------------------------------------------
ortho2(t1, ratio, col.y = colors, ybreaks = quants, ycolorbar = TRUE)

