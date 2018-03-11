## ---- echo = FALSE-------------------------------------------------------
library(methods)
library(knitr)
opts_chunk$set(eval = FALSE)

## ------------------------------------------------------------------------
# Installing Bioconductor
library(utils); 
source("http://bioconductor.org/biocLite.R"); 
biocLite(pkgs = c("Biobase"), suppressUpdates = TRUE, suppressAutoUpdate = TRUE, ask = FALSE)

## ------------------------------------------------------------------------
source("https://neuroconductor.org/neurocLite.R")
# DICOM converter
neuro_install("dcm2niir")
library(dcm2niir); install_dcm2nii()
# HCP database connector
neuro_install("neurohcp")
# dcm2nii Rcpp implementation
neuro_install(c("RNifti", "divest", "oro.dicom", "oro.nifti", "WhiteStripe"))
# data for whitestripe
library(WhiteStripe); download_img_data()

# neurobase package
neuro_install("neurobase")
neuro_install("fslr")

## ------------------------------------------------------------------------
##########################################
# ANTs
##########################################
neuro_install("ITKR")
neuro_install("ANTsRCore", upgrade_dependencies = FALSE)
neuro_install("ANTsR", upgrade_dependencies = FALSE)
neuro_install("extrantsr", upgrade_dependencies = FALSE)

## ------------------------------------------------------------------------
install.packages(c("formatR", "caTools", "rprojroot", "rmarkdown"))

## ------------------------------------------------------------------------
##############################
# Install MS LESION DATA!
# INSTALL KIRBY21
##############################
neuro_install("papayar")
neuro_install("oasis")
neuro_install("malf.templates")
neuro_install("kirby21.t1")

## ------------------------------------------------------------------------
library(fslr)
have_fsl()
example("fsl_smooth")

## ------------------------------------------------------------------------
library(extrantsr)
example("smooth_image")

