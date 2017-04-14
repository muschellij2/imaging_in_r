## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, comment = "", fig.height = 5.5, fig.width = 5.5, cache = TRUE)
options(fsl.path = "/usr/local/fsl/")
options(fsl.outputtype = "NIFTI_GZ")

## ----t1, echo=FALSE, warning=FALSE, message=FALSE------------------------
library(ms.lesion)
library(neurobase)
library(WhiteStripe)
fnames = get_image_filenames_list_by_subject(group = "training", 
  type = "coregistered")
t1s = lapply(fnames, function(x) readnii(x["MPRAGE"]))
tissues = lapply(fnames, function(x) readnii(x["Tissue_Classes"]))
masks = lapply(fnames, function(x) readnii(x["Brain_Mask"]))

vals = mapply(function(t1, mask){
  mask_vals(t1, mask)
}, t1s, masks, SIMPLIFY = FALSE)

dens = lapply(vals, density)

plot_densities = function(dens, xlab = "Raw Intensities", 
                          main = "Whole Brain") {
  range_x = sapply(dens, function(d) range(d$x))
  range_x = range(range_x)
  range_y = sapply(dens, function(d) range(d$y))
  range_y = range(range_y)
  plot(dens[[1]], xlim = range_x, ylim = range_y, 
       xlab = xlab, main = main)
  for (idens in 2:length(dens)) {
    lines(dens[[idens]], col = idens)
  }
}
plot_boxplots = function(vals, 
                          main = "Whole Brain") {
  boxplots <- lapply(vals, boxplot, outline = FALSE, plot = FALSE)
  boxplots = lapply(boxplots, function(x) x$stats)
  boxplots <- do.call(cbind, boxplots)
  boxplot(boxplots, main = main)
}

## ----t1viz, warning=FALSE, message=FALSE, echo = FALSE-------------------
plot_densities(dens, main = "Distribution of all Voxels in Brain Mask")

## ----threeway, warning=FALSE, message=FALSE, echo = FALSE, fig.height = 4, fig.width = 10----
csf_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 1)
}, t1s, tissues, SIMPLIFY = FALSE)
csf_dens = lapply(csf_vals, density)

wm_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 3)
}, t1s, tissues, SIMPLIFY = FALSE)
wm_dens = lapply(wm_vals, density)

gm_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 2)
}, t1s, tissues, SIMPLIFY = FALSE)
gm_dens = lapply(gm_vals, density)

par(mfrow = c(1, 3))
plot_densities(csf_dens, main = "CSF")
plot_densities(gm_dens, main = "Gray Matter")
plot_densities(wm_dens, main = "White Matter")
par(mfrow = c(1, 1))

## ----wbViz, echo=FALSE, warning=FALSE, message=FALSE---------------------
t1_norm = mapply(function(img, mask){
  zscore_img(img = img, mask = mask)
}, t1s, masks, SIMPLIFY = FALSE)

## ----wbViz_show, eval=FALSE, warning=FALSE, message=FALSE----------------
## zscore_img(img = img, mask = mask)

## ----t1viz1a, warning=FALSE, message=FALSE, echo = FALSE-----------------
csf_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 1)
}, t1s, tissues, SIMPLIFY = FALSE)
csf_dens = lapply(csf_vals, density)
plot_densities(csf_dens, main = "CSF Before")

## ----wbViz1, warning=FALSE, message=FALSE, echo = FALSE------------------
csf_norm_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 1)
}, t1_norm, tissues, SIMPLIFY = FALSE)
csf_norm_dens = lapply(csf_norm_vals, density)
plot_densities(csf_norm_dens, 
               xlab = "Whole-brain Normalized Intensities", 
               main = "CSF After")

## ----t1viz2a, warning=FALSE, message=FALSE, echo = FALSE-----------------
gm_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 2)
}, t1s, tissues, SIMPLIFY = FALSE)
gm_dens = lapply(gm_vals, density)
plot_densities(gm_dens, main = "Gray Matter Before")

## ----wbViz2, warning=FALSE, message=FALSE, echo = FALSE------------------
gm_norm_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 2)
}, t1_norm, tissues, SIMPLIFY = FALSE)
gm_norm_dens = lapply(gm_norm_vals, density)
plot_densities(gm_norm_dens, 
               xlab = "Whole-brain Normalized Intensities", 
               main = "Gray Matter After")

## ----t1viz3a, warning=FALSE, message=FALSE, echo = FALSE-----------------
wm_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 3)
}, t1s, tissues, SIMPLIFY = FALSE)
wm_dens = lapply(wm_vals, density)
plot_densities(wm_dens, main = "White Matter Before")

## ----wbViz3, warning=FALSE, message=FALSE, echo = FALSE------------------
wm_norm_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 3)
}, t1_norm, tissues, SIMPLIFY = FALSE)
wm_norm_dens = lapply(wm_norm_vals, density)
plot_densities(wm_norm_dens, 
               xlab = "Whole-brain Normalized Intensities", 
               main = "White Matter After")

## ----ws_show, eval=FALSE, warning = FALSE, message = FALSE, results='hide'----
## library(WhiteStripe)
## ind = whitestripe(img = t1, type = "T1", stripped = TRUE)$whitestripe.ind
## ws_t1 = whitestripe_norm(t1, indices = ind)

## ----ws, echo=FALSE, warning = FALSE, message = FALSE, results='hide'----
ws_norm = function(t1) {
  ind = whitestripe(img = t1,
                    type = "T1", 
                    stripped = TRUE)$whitestripe.ind
  whitestripe_norm(t1, indices = ind)
}
t1_ws_norm = lapply(t1s, ws_norm)

## ----wbViz1a, warning=FALSE, message=FALSE, echo = FALSE-----------------
plot_densities(csf_norm_dens, 
               xlab = "Whole-brain Normalized Intensities", main = "Whole-brain: CSF")

## ----ws_viz_csf, warning=FALSE, message=FALSE, echo = FALSE--------------
csf_ws_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 1)
}, t1_ws_norm, tissues, SIMPLIFY = FALSE)
csf_ws_dens = lapply(csf_ws_vals, density)
plot_densities(csf_ws_dens, 
               xlab = "WhiteStripe Normalized Intensities", main = "White Stripe: CSF")

## ----wbViz2a, warning=FALSE, message=FALSE, echo = FALSE-----------------
plot_densities(gm_norm_dens, 
               xlab = "Whole-brain Normalized Intensities", main = "Whole-brain: Gray Matter")

## ----ws_viz_gm, warning=FALSE, message=FALSE, echo = FALSE---------------
gm_ws_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 2)
}, t1_ws_norm, tissues, SIMPLIFY = FALSE)
gm_ws_dens = lapply(gm_ws_vals, density)
plot_densities(gm_ws_dens, 
               xlab = "WhiteStripe Normalized Intensities", main = "White Stripe: Gray Matter")

## ----wbViz3a, warning=FALSE, message=FALSE, echo = FALSE-----------------
plot_densities(wm_norm_dens, 
               xlab = "Whole-brain Normalized Intensities", main = "Whole-brain: White Matter")

## ----ws_viz_wm, warning=FALSE, message=FALSE, echo = FALSE---------------
wm_ws_vals = mapply(function(t1, mask){
  mask_vals(t1, mask == 3)
}, t1_ws_norm, tissues, SIMPLIFY = FALSE)
wm_ws_dens = lapply(wm_ws_vals, density)
plot_densities(wm_ws_dens, 
               xlab = "WhiteStripe Normalized Intensities", main = "White Stripe: White Matter")

