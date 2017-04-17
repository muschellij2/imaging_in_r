## ----setup, include=FALSE------------------------------------------------
library(methods)
library(scales)
library(fslr)
library(extrantsr)
knitr::opts_chunk$set(
  message = FALSE, echo = TRUE, 
  comment = "", 
  warning = FALSE)

## ----loading-------------------------------------------------------------
library(ms.lesion)
library(neurobase)
all_files = get_image_filenames_list_by_subject(
  group = "training", 
  type = "coregistered")
files = all_files$training05 # NOT training subject 1!
t1 = readnii(files["MPRAGE"])
rt1 = robust_window(t1)
mask = readnii(files["Brain_Mask"])

## ----window, echo = FALSE------------------------------------------------
# t1 = robust_window(t1, probs = c(0, 0.9999))
# t1 = window_img(t1, window = c(0, 300))

## ----hist_vals-----------------------------------------------------------
hist(t1, mask = mask, breaks = 2000); text(x = 800, y = 3000, "outliers!")

## ----which_big-----------------------------------------------------------
ortho2(rt1, t1 > 400, xyz = xyz(t1 > 400)) # xyz - cog of a region

## ----fast_show, eval = FALSE---------------------------------------------
## t1file = files["MPRAGE"]
## t1fast = fast(t1,
##               outfile = paste0(nii.stub(t1file), "_FAST"),
##               opts = "--nobias")

## ----fast_show_run, echo = FALSE-----------------------------------------
t1file = files["MPRAGE"]
outfile = paste0(nii.stub(t1file, bn = TRUE), "_FAST.nii.gz")
if (!file.exists(outfile)) {
  t1fast = fast(t1file, 
                opts = "--nobias")
  writenii(t1fast, filename = outfile)
} else {
  t1fast = readnii(outfile)
}

## ----fast_wm_nonrobust---------------------------------------------------
ortho2(rt1, t1fast == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----fast_gm_nonrobust---------------------------------------------------
ortho2(rt1, t1fast == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----fast_csf_nonrobust--------------------------------------------------
ortho2(rt1, t1fast == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----fast_better_show, eval = FALSE--------------------------------------
## robust_fast = fast(rt1, # the robust_window(t1)
##               outfile = paste0(nii.stub(t1file), "_FAST"),
##               opts = "--nobias")

## ----fast_better_run, echo = FALSE---------------------------------------
robust_fast = readnii(files["FAST"])

## ----multi_overlay, eval = FALSE, echo = FALSE---------------------------
## separate = separate_img(robust_fast, levels = 1:3)
## names(separate) = c("CSF", "GM", "WM")
## L = c(MPRAGE = list(t1), separate)
## L$MPRAGE = robust_window(L$MPRAGE)
## r = range(L$MPRAGE)
## L$MPRAGE = (L$MPRAGE - r[1])/(r[2] - r[1])
## dd = dropEmptyImageDimensions(t1fast > 0, other.imgs = L)
## L = dd$other.imgs
## multi_overlay(L, z = 58, text = names(L), text.x = 0.5, text.y = 1.4,
##               text.cex = 2.5)

## ----prep_wm, echo = FALSE-----------------------------------------------
rt1_list = list(rt1, rt1)
m_list = list((t1fast==3), (robust_fast==3))

## ----fast_wm, echo = FALSE-----------------------------------------------
multi_overlay(x=rt1_list, y=m_list, col.y=alpha("red", 0.5), text=c("Raw", "Robust"), text.x=c(.3, .7), text.y=c(.1, .1))

## ----prep_gm, echo = FALSE-----------------------------------------------
m_list = list((t1fast==2), (robust_fast==2))

## ----fast_gm, echo = FALSE-----------------------------------------------
multi_overlay(x=rt1_list, y=m_list, col.y=alpha("red", 0.5), text=c("Raw", "Robust"), text.x=c(.3, .7), text.y=c(.1, .1))

## ----prep_csf, echo = FALSE----------------------------------------------
m_list = list((t1fast==1), (robust_fast==1))

## ----fast_csf, echo = FALSE----------------------------------------------
multi_overlay(x=rt1_list, y=m_list, col.y=alpha("red", 0.5), text=c("Raw", "Robust"), text.x=c(.3, .7), text.y=c(.1, .1))

## ----otropos_show, eval = FALSE------------------------------------------
## t1_otropos = otropos(a = t1, x = mask) # using original data
## t1seg = t1_otropos$segmentation

## ----otropos_run, echo = FALSE-------------------------------------------
t1file = files["MPRAGE"]
outfile = paste0(nii.stub(t1file, bn = TRUE), "_Atropos.nii.gz")
if (!file.exists(outfile)) {
  t1_otropos = otropos(a = t1, x = mask) # using robust
  t1seg = t1_otropos$segmentation
  writenii(t1seg, filename = outfile)
} else {
  t1seg = readnii(outfile)
}

## ----otropos_wm----------------------------------------------------------
ortho2(rt1, t1seg == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----otropos_gm----------------------------------------------------------
ortho2(rt1, t1seg == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----otropos_csf---------------------------------------------------------
ortho2(rt1, t1seg == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----robust_otropos_show, eval = FALSE-----------------------------------
## robust_t1_otropos = otropos(a = rt1, x = mask) # using robust
## robust_t1seg = robust_t1_otropos$segmentation

## ----robust_otropos_run, echo = FALSE------------------------------------
robust_t1seg = readnii(files["Tissue_Classes"])

## ----atropos_robust_overall----------------------------------------------
double_ortho(rt1, robust_t1seg)

## ----otropos_wm_robust---------------------------------------------------
ortho2(rt1, robust_t1seg == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----otropos_gm_robust---------------------------------------------------
ortho2(rt1, robust_t1seg == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----otropos_csf_robust--------------------------------------------------
ortho2(rt1, robust_t1seg == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----prep_wm_atropos, echo = FALSE---------------------------------------
m_list = list(t1seg == 3, robust_t1seg==3)

## ----prep_wm_atropos_show, echo = FALSE----------------------------------
multi_overlay(x=rt1_list, y=m_list, col.y=alpha("red", 0.5), text=c("Raw", "Robust"), text.x=c(.3, .7), text.y=c(.1, .1))

## ----prep_wm_atropos_fast, echo = FALSE----------------------------------
m_list = list(t1fast == 3, robust_t1seg==3)

## ----prep_wm_atropos_fast_show, echo = FALSE-----------------------------
multi_overlay(x=rt1_list, y=m_list, col.y=alpha("red", 0.5), text=c("FAST", "Atropos"), text.x=c(.3, .7), text.y=c(.1, .1))

## ----tabs----------------------------------------------------------------
tab_fsl = table(robust_fast[ robust_fast != 0])
tab_ants = table(robust_t1seg[ robust_t1seg != 0])
names(tab_fsl) = names(tab_ants) = c("CSF", "GM", "WM")
tab_fsl
tab_ants

## ----volumes-------------------------------------------------------------
vres = oro.nifti::voxres(t1, units = "cm")
print(vres)
vol_fsl = tab_fsl * vres
vol_fsl
vol_ants = tab_ants * vres
vol_ants

