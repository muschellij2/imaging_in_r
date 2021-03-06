## ----setup, include=FALSE------------------------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")

## ---- message=FALSE------------------------------------------------------
library(oro.nifti)
library(neurobase)

## ---- eval = FALSE-------------------------------------------------------
## t1 = readnii("training01_01_t1.nii.gz")

## ---- echo = FALSE-------------------------------------------------------
t1 = readnii("../training01_01_t1.nii.gz")

## ----t1class-------------------------------------------------------------
class(t1)

## ---- echo = FALSE-------------------------------------------------------
ortho2(robust_window(t1))

## ------------------------------------------------------------------------
t1

## ----adding_t1-----------------------------------------------------------
t1 + t1 + 2 # still a nifti

## ------------------------------------------------------------------------
class(t1 > 400) # still a nifti
head(t1 > 400) # values are now logical vs. numeric

## ------------------------------------------------------------------------
t1[5, 4, 3]

## ---- eval = FALSE-------------------------------------------------------
## t1[5, 4, ] # returns a vector of numbers (1-d)
## t1[, 4, ] # returns a 2-d matrix
## t1[1, , ] # returns a 2-d matrix

## ------------------------------------------------------------------------
head(t1[ t1 > 400 ]) # produces a vector of numbers

## ------------------------------------------------------------------------
head(which(t1 > 400, arr.ind = TRUE))

## ------------------------------------------------------------------------
head(which(t1 > 400, arr.ind = FALSE))

## ------------------------------------------------------------------------
t1_copy = t1
t1_copy[ t1_copy > 400 ] = 400 # replaced these values!
max(t1_copy) # should be 400
max(t1) 

## ------------------------------------------------------------------------
writenii(nim = t1_copy, 
         filename = "training01_t1_under400.nii.gz")
file.exists("training01_t1_under400.nii.gz")

## ----vec_nifti, cache=FALSE----------------------------------------------
vals = c(t1)
class(vals)

## ----df------------------------------------------------------------------
df = data.frame(t1 = c(t1), mask = c(t1 > 400)); head(df)

## ------------------------------------------------------------------------
c(paste("img", ".nii.gz"), paste0("img", ".nii.gz"))
x = file.path("output_directory", paste0("img", ".nii.gz")); print(x)

## ------------------------------------------------------------------------
c(nii.stub(x), nii.stub(x, bn = TRUE))

