## ----setup, include=FALSE, message = FALSE-------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")
library(ggplot2)
library(ms.lesion)
library(neurobase)
library(extrantsr)
library(scales)

## ----colon_twice---------------------------------------------------------
t1 = neurobase::readnii("training01_01_mprage.nii.gz")

## ----dens----------------------------------------------------------------
plot(density(t1))

## ----dens_with_mask------------------------------------------------------
plot(density(t1, mask = t1 > 0))

## ----histog, echo = FALSE------------------------------------------------
hist(t1)

## ----ortho2--------------------------------------------------------------
neurobase::ortho2(t1)

## ----ortho2_rob----------------------------------------------------------
ortho2(robust_window(t1))

## ----ortho2_noorient-----------------------------------------------------
neurobase::ortho2(robust_window(t1), add.orient = FALSE)

## ----ortho_nona----------------------------------------------------------
ortho2(robust_window(t1), y = t1 > 100)

## ----double_ortho--------------------------------------------------------
double_ortho(robust_window(t1), y = t1 > 100)

## ----all_slices----------------------------------------------------------
image(t1, useRaster = TRUE) # look at average brightness over each slice

## ----two_slicewslice-----------------------------------------------------
oro.nifti::slice(t1, z = c(60, 80))

## ----one_slice_sag-------------------------------------------------------
oro.nifti::slice(t1, z = 125, plane = "sagittal")

## ----one_slice_overlay---------------------------------------------------
slice_overlay(t1, y = t1 > 100, z = 80)

