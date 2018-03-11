## ---- echo = FALSE-------------------------------------------------------
library(methods)
library(knitr)
opts_chunk$set(comment = "")

## ----readin, echo = FALSE, message=FALSE---------------------------------
library(ms.lesion)
library(neurobase)
files = get_image_filenames_list_by_subject(type = "coregistered")
files = files$training02
img_fnames = files[c("T1", "T2", "FLAIR")]
mask_fname = files["mask"]
brain_mask = readnii(files["Brain_Mask"])
imgs = check_nifti(img_fnames)
mask = readnii(mask_fname)
zimgs = lapply(imgs, zscore_img, mask = brain_mask)
inds = getEmptyImageDimensions(brain_mask)
zimgs = lapply(zimgs, applyEmptyImageDimensions, inds = inds)
mask = applyEmptyImageDimensions(mask, inds = inds)
zimgs = c(zimgs, Lesion_Mask = list(mask * 10))
xyz = xyz(mask)
multi_overlay(zimgs, z = xyz[3], text = names(zimgs), 
              text.x = 0.5, text.y = 2.25, text.cex = 2)

