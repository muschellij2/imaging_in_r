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
t1 = readnii(files["T1"])
rt1 = robust_window(t1)
mask = readnii(files["Brain_Mask"])

## ----window, echo = FALSE------------------------------------------------
# t1 = robust_window(t1, probs = c(0, 0.9999))
# t1 = window_img(t1, window = c(0, 300))

## ----reduce--------------------------------------------------------------
run_mask = t1 > 100
dd_orig = drop_empty_dim(run_mask, keep_ind = TRUE)

## ----hist_vals-----------------------------------------------------------
hist(t1, mask = mask, breaks = 2000); text(x = 600, y = 3000, '"outliers"')

## ----which_big, eval = FALSE---------------------------------------------
## ortho2(rt1, t1 > 450, xyz = xyz(t1 > 450)) # xyz - cog of a region

## ----which_big_show, echo = FALSE----------------------------------------
xrt1 = apply_empty_dim(rt1, inds = dd_orig$inds)
xt1 = apply_empty_dim(t1, inds = dd_orig$inds)
ortho2(xrt1, xt1 > 450, xyz = xyz(xt1 > 450)) 

## ----run_window----------------------------------------------------------
t1[ t1 < 0 ] = 0
t1 = mask_img(t1, mask)
rt1 = robust_window(t1)

## ----which_big_after_robust----------------------------------------------
hist(rt1, mask = mask, breaks = 2000); 

## ----fast_show, eval = FALSE---------------------------------------------
## t1file = files["T1"]
## t1fast = fast(t1,
##               outfile = paste0(nii.stub(t1file), "_FAST"),
##               opts = "--nobias")

## ----fast_show_run, echo = FALSE-----------------------------------------
t1file = files["T1"]
outfile = paste0(nii.stub(t1file, bn = TRUE), "_FAST.nii.gz")
if (!file.exists(outfile)) {
  t1fast = fast(t1, 
                opts = "--nobias")
  writenii(t1fast, filename = outfile)
} else {
  t1fast = readnii(outfile)
}

## ----fast_wm_nonrobust, eval = FALSE-------------------------------------
## ortho2(rt1, t1fast == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----fast_wm_nonrobust_show, echo = FALSE--------------------------------
xrt1 = apply_empty_dim(rt1, inds = dd_orig$inds)
xt1fast = apply_empty_dim(t1fast, inds = dd_orig$inds)
ortho2(xrt1, xt1fast == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----fast_gm_nonrobust, eval = FALSE-------------------------------------
## ortho2(rt1, t1fast == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----fast_gm_nonrobust_show, echo = FALSE--------------------------------
ortho2(xrt1, xt1fast == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----fast_csf_nonrobust, eval = FALSE------------------------------------
## ortho2(rt1, t1fast == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----fast_csf_nonrobust_show, echo = FALSE-------------------------------
ortho2(xrt1, xt1fast == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----fast_better_show, eval = FALSE--------------------------------------
## robust_fast = fast(rt1, # the robust_window(t1)
##               outfile = paste0(nii.stub(t1file), "_FAST"),
##               opts = "--nobias")

## ----fast_better_run, echo = FALSE---------------------------------------
robust_fast = readnii(files["FAST"])

## ----multi_overlay, eval = FALSE, echo = FALSE---------------------------
## separate = separate_img(robust_fast, levels = 1:3)
## names(separate) = c("CSF", "GM", "WM")
## L = c(T1 = list(t1), separate)
## L$T1 = robust_window(L$T1)
## r = range(L$T1)
## L$T1 = (L$T1 - r[1])/(r[2] - r[1])
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
t1file = files["T1"]
outfile = paste0(nii.stub(t1file, bn = TRUE), "_Atropos.nii.gz")
if (!file.exists(outfile)) {
  t1_otropos = otropos(a = t1, x = mask) # using robust
  t1seg = t1_otropos$segmentation
  writenii(t1seg, filename = outfile)
} else {
  t1seg = readnii(outfile)
}

## ----otropos_wm, eval = FALSE--------------------------------------------
## ortho2(rt1, t1seg == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----otropos_wm_show, echo = FALSE---------------------------------------
xt1seg = apply_empty_dim(t1seg, inds = dd_orig$inds)
ortho2(xrt1, xt1seg == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----otropos_gm, eval = FALSE--------------------------------------------
## ortho2(rt1, t1seg == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----otropos_gm_show, echo = FALSE---------------------------------------
ortho2(xrt1, xt1seg == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----otropos_csf, eval = FALSE-------------------------------------------
## ortho2(rt1, t1seg == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----otropos_csf_show, echo = FALSE--------------------------------------
ortho2(xrt1, xt1seg == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----robust_otropos_show, eval = FALSE-----------------------------------
## robust_t1_otropos = otropos(a = rt1, x = mask) # using robust
## robust_t1seg = robust_t1_otropos$segmentation

## ----robust_otropos_run, echo = FALSE------------------------------------
robust_t1seg = readnii(files["Tissue_Classes"])

## ----atropos_robust_overall_show, eval = FALSE---------------------------
## double_ortho(rt1, robust_t1seg)

## ----atropos_robust_overall, echo = FALSE--------------------------------
xrobust_t1seg = apply_empty_dim(
  robust_t1seg, 
  inds = dd_orig$inds)
double_ortho(xrt1, xrobust_t1seg)

## ----otropos_wm_robust_show, eval = FALSE--------------------------------
## ortho2(rt1, robust_t1seg == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----otropos_wm_robust, echo = FALSE-------------------------------------
ortho2(xrt1, xrobust_t1seg == 3, col.y = alpha("red", 0.5), text = "White Matter")

## ----otropos_gm_robust_show, eval = FALSE--------------------------------
## ortho2(rt1, robust_t1seg == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----otropos_gm_robust, echo = FALSE-------------------------------------
ortho2(xrt1, xrobust_t1seg == 2, col.y = alpha("red", 0.5), text = "Gray Matter")

## ----otropos_csf_robust_show, eval = FALSE-------------------------------
## ortho2(rt1, robust_t1seg == 1, col.y = alpha("red", 0.5), text = "CSF")

## ----otropos_csf_robust, echo = FALSE------------------------------------
ortho2(xrt1, xrobust_t1seg == 1, col.y = alpha("red", 0.5), text = "CSF")

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
out_mask = robust_fast != 0 | robust_t1seg != 0 
table(robust_fast[ out_mask ], robust_t1seg[ out_mask ])

## ----volumes-------------------------------------------------------------
vres = oro.nifti::voxres(t1, units = "cm")
print(vres)
vol_fsl = tab_fsl * vres
vol_fsl
vol_ants = tab_ants * vres
vol_ants

