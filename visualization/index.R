## ----setup, include=FALSE, message = FALSE-------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE)
library(ggplot2)
library(ms.lesion)
library(neurobase)
library(extrantsr)
library(scales)

## ---- message=FALSE------------------------------------------------------
library(oro.nifti)
library(neurobase)

## ------------------------------------------------------------------------
t1 = readnii("training01_01_mprage.nii.gz")

## ---- eval = FALSE-------------------------------------------------------
## t1 <- readnii("training01_01_mprage.nii.gz")

## ------------------------------------------------------------------------
class(t1)
t1

## ----help, eval = FALSE--------------------------------------------------
## ?readnii
## help(topic = "readnii")

## ----help2, eval = FALSE-------------------------------------------------
## ??readnii
## help.search(pattern = "readnii")

## ----colon_twice, eval=FALSE---------------------------------------------
## t1 = neurobase::readnii("training01_01_mprage.nii.gz")

## ------------------------------------------------------------------------
library(ms.lesion)
files = get_image_filenames_list_by_subject()
length(files); names(files); 
head(files$training01)

## ------------------------------------------------------------------------
library(ms.lesion)
library(neurobase)
files = get_image_filenames_list_by_subject()$training01
t1_fname = files["MPRAGE"]
t1 = readnii(t1_fname)

## ----ortho---------------------------------------------------------------
oro.nifti::orthographic(t1)

## ----ortho2--------------------------------------------------------------
neurobase::ortho2(t1)

## ----ortho2_noorient-----------------------------------------------------
neurobase::ortho2(t1, add.orient = FALSE)

## ----ortho_nona----------------------------------------------------------
orthographic(t1, y = t1 > quantile(t1, 0.9))

## ----ortho2_nona---------------------------------------------------------
ortho2(t1, y = t1 > quantile(t1, 0.9))

## ----eve2, cache=FALSE---------------------------------------------------
ortho2(t1)

## ----ortho2_rob----------------------------------------------------------
ortho2(robust_window(t1))

## ----ortho2_zlim---------------------------------------------------------
ortho2(t1, zlim = quantile(t1, probs = c(0, 0.999)))

## ---- echo = FALSE-------------------------------------------------------
t1 = robust_window(t1)

## ----mask----------------------------------------------------------------
mask = oMask(t1)

## ----double_ortho--------------------------------------------------------
double_ortho(t1, mask)

## ----all_slices----------------------------------------------------------
image(t1, z = 80)

## ----one_slice-----------------------------------------------------------
image(t1, z = 80, plot.type = "single")

## ----two_slice-----------------------------------------------------------
image(t1, z = c(60, 80), plot.type = "single")

## ----one_slice_sag-------------------------------------------------------
image(t1, z = 125, plot.type = "single", plane = "sagittal")

## ----one_slice_overlay---------------------------------------------------
overlay(t1, y = t1 > quantile(t1, 0.9), z = 80, plot.type = "single")

## ----one_slice_overlay_right---------------------------------------------
mask = t1 > quantile(t1, 0.9); mask[ mask == 0] = NA
overlay(t1, y = mask, z = 90, plot.type = "single")

## ----dd, cache=FALSE-----------------------------------------------------
reduced = dropEmptyImageDimensions(t1)
dim(t1)
dim(reduced)

## ----plot_red------------------------------------------------------------
ortho2(reduced)

## ----vec, cache=FALSE----------------------------------------------------
vals = c(t1)
class(vals)

## ----dens----------------------------------------------------------------
plot(density(vals))

## ----dens_with_mask------------------------------------------------------
plot(density(t1, mask = t1 > 0))

