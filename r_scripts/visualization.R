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
plot(density(t1)) # large spike at 0

## ----dens_with_mask------------------------------------------------------
plot(density(t1, mask = t1 > 0))

## ----histog, echo = FALSE------------------------------------------------
hist(t1)

## ----ortho2--------------------------------------------------------------
neurobase::ortho2(t1)

## ----ortho2_rob----------------------------------------------------------
ortho2(robust_window(t1))

## ----dens_robust, echo = FALSE-------------------------------------------
par(mfrow = c(1,2))
plot(density(t1), main = "Density of T1") 
plot(density(robust_window(t1)), main = "Density of Windowed T1")
par(mfrow = c(1,1))

## ----robust_final, echo = FALSE------------------------------------------
t1 = robust_window(t1)

## ----ortho_nona----------------------------------------------------------
ortho2(t1, y = t1 > 150)

## ----double_ortho--------------------------------------------------------
double_ortho(t1, y = t1 > 150, col.y = "white")

## ----all_slices----------------------------------------------------------
image(t1, useRaster = TRUE) # look at average brightness over each slice

## ----two_slicewslice-----------------------------------------------------
oro.nifti::slice(t1, z = c(60, 80))

## ----one_slice_sag-------------------------------------------------------
oro.nifti::slice(t1, z = 125, plane = "sagittal")

## ----one_slice_overlay---------------------------------------------------
slice_overlay(t1, y = t1 > 150, z = 80)

## ----smoothed------------------------------------------------------------
library(extrantsr)
sm_img = smooth_image(t1, sigma = 2)
double_ortho(t1, sm_img)

