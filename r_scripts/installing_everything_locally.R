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
# DICOM converter
devtools::install_github("muschellij2/dcm2niir")
library(dcm2niir); install_dcm2nii()
# HCP database connector
devtools::install_github("muschellij2/hcp")
# dcm2nii Rcpp implementation
install.packages(c("RNifti", "divest", "oro.dicom", "oro.nifti", "WhiteStripe"))
# data for whitestripe
library(WhiteStripe); download_img_data()

# neurobase package
devtools::install_github("muschellij2/neurobase")
devtools::install_github("muschellij2/fslr")

## ------------------------------------------------------------------------
##########################################
# ANTs
##########################################
devtools::install_github("stnava/ITKR")
devtools::install_github("stnava/ANTsRCore", upgrade_dependencies = FALSE)
devtools::install_github("stnava/ANTsR", upgrade_dependencies = FALSE)
devtools::install_github("muschellij2/extrantsr", 
                         upgrade_dependencies = FALSE)

## ------------------------------------------------------------------------
install.packages(c("formatR", "caTools", "rprojroot", "rmarkdown"))

## ------------------------------------------------------------------------
##############################
# Install MS LESION DATA!
# INSTALL KIRBY21
##############################
devtools::install_github("muschellij2/papayar")
devtools::install_github("emsweene/oasis")
devtools::install_github("muschellij2/malf.templates")
devtools::install_github("muschellij2/kirby21.t1")

## ------------------------------------------------------------------------
library(fslr)
have_fsl()
example("fsl_smooth")

## ------------------------------------------------------------------------
library(extrantsr)
example("smooth_image")

