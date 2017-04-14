## ----setup, include=FALSE------------------------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")

## ----reading_in_image----------------------------------------------------
library(neurobase)
t1_fname = "training01_01_mprage.nii.gz"
t1 = neurobase::readnii(t1_fname)
rt1 = robust_window(t1); 
red0.5 = scales::alpha("red", 0.5) # for plotting later

## ----t1_plot_robust------------------------------------------------------
ortho2(rt1)

## ----t1_naive_ss, eval = FALSE, cache = FALSE, message = FALSE, warning = FALSE----
## library(fslr)
## ss = fslbet(infile = t1_fname)

## ----t1_naive_ss_run, echo = FALSE, cache = FALSE, message = FALSE, warning = FALSE----
library(fslr)
out_fname = "../output/naive_ss.nii.gz"
if (!file.exists(out_fname)) {
  ss = fslbet(infile = t1_fname)
  writenii(ss, out_fname)
} else {
  ss = readnii(out_fname)
}

## ----t1_naive_plot_ss----------------------------------------------------
ortho2(robust_window(ss))

## ----t1_ss_plot----------------------------------------------------------
ortho2(rt1, ss > 0, col.y = red0.5)

## ----bc_show, eval = FALSE-----------------------------------------------
## library(extrantsr)
## bc_img = bias_correct(file = t1, correction = "N4")

## ----bc_show_run, echo = FALSE-------------------------------------------
bc_fname = "../output/training01_01_mprage_n4.nii.gz"
bc_img = readnii(bc_fname)
bc_img = robust_window(bc_img)

## ----bc_bet, eval = FALSE, message = FALSE-------------------------------
## bc_bet = fslbet(bc_img); ortho2(bc_img, bc_bet > 0, col.y = red0.5)

## ----bc_bet_run, message = FALSE, echo = FALSE---------------------------
out_fname = "../output/bc_bet_ss.nii.gz"
if (!file.exists(out_fname)) {
  bc_bet = fslbet(bc_img); 
  writenii(bc_bet, out_fname)
} else {
  bc_bet = readnii(out_fname)
}
ortho2(bc_img, bc_bet > 0, col.y = red0.5)

## ----t1_malf_ss, echo = TRUE, eval = FALSE-------------------------------
## library(malf.templates) # load the data package
## library(extrantsr)
## timgs = mass_images(n_templates = 5) # let's register 5 templates
## ss = extrantsr::malf(
##   infile = bc_img,
##   template.images = timgs$images,
##   template.structs = timgs$masks,
##   keep_images = FALSE # don't keep the registered images
## )
## mask = ss > 0

## ----t1_malf_ss_run, echo = FALSE, message = FALSE-----------------------
library(malf.templates)
library(extrantsr)
timgs = mass_images(n_templates = 5)
outfile = "../output/training01_01_mprage_mask.nii.gz"
if (!file.exists(outfile)) {
  ss = malf(
    infile = bc_fname, 
    template.images = timgs$images, 
    template.structs = timgs$masks,
    keep_images = FALSE,
    verbose = FALSE,
    outfile = outfile
  )
} else {
  ss = readnii(outfile)
}
mask = ss > 0

## ----show_them, eval = FALSE---------------------------------------------
## mask = readnii("training01_01_mprage_mask.nii.gz") # already computed

## ----display_malf_result-------------------------------------------------
ortho2(bc_img, mask, col.y = red0.5)

## ------------------------------------------------------------------------
library(kirby21.t1)
t1_fname = get_t1_filenames()[1]
t1 = readnii(t1_fname)

## ----kirby21_t1_plot-----------------------------------------------------
ortho2(robust_window(t1))

## ----kirby21_t1_naive_ss_run, cache = FALSE, message = FALSE, echo = FALSE----
out_fname = "../output/kirby_naive_ss.nii.gz"
if (!file.exists(out_fname)) {
  ss = fslbet(infile = t1_fname)
  writenii(ss, out_fname)
} else {
  ss = readnii(out_fname)
}
ortho2(robust_window(ss))

## ----kirby21_t1_naive_ss_show, eval = FALSE, cache = FALSE, message = FALSE----
## ss = fslbet(infile = t1_fname); ortho2(robust_window(ss))

## ----kirby21_bc_bet_show, message = FALSE, eval = FALSE------------------
## bc_img = bias_correct(t1, correction = "N4");
## bc_bet = fslbet(bc_img)
## ortho2(robust_window(t1), bc_bet > 0, col.y = red0.5)

## ----kirby21_bc_bet_run, message = FALSE, echo = FALSE-------------------
out_fname = "../output/kirby_bc.nii.gz"
if (!file.exists(out_fname)) {
  bc_img = bias_correct(t1, correction = "N4"); 
  writenii(bc_img, out_fname)
} else {
  bc_img = readnii(out_fname)
}

out_fname = "../output/kirby_bc_bet.nii.gz"
if (!file.exists(out_fname)) {
  bc_bet = fslbet(bc_img)  
  writenii(bc_bet, out_fname)
} else {
  bc_bet = readnii(out_fname)
}
ortho2(robust_window(t1), bc_bet > 0, col.y = red0.5)

## ---- eval = FALSE-------------------------------------------------------
## ss = extrantsr::fslbet_robust(
##   t1,
##   remover = "double_remove_neck",
##   correct = TRUE,
##   correction = "N4",
##   recog = TRUE)

## ----t1_ss, cache = FALSE, echo = FALSE----------------------------------
outfile = nii.stub(t1_fname, bn = TRUE)
outfile = file.path("..", "output", paste0(outfile, "_SS.nii.gz"))
if (!file.exists(outfile)) {
  ss = extrantsr::fslbet_robust(t1_fname,
    remover = "double_remove_neck",
    outfile = outfile)
} else {
  ss = readnii(outfile)
}

## ----kirby21_t1_ss_plot_show, cache = TRUE, eval = FALSE-----------------
## ortho2(ss)

## ----kirby21_t1_ss_plot_run, echo = FALSE, cache = TRUE------------------
ortho2(dropEmptyImageDimensions(ss))

