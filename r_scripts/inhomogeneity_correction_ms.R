## ----setup, include=FALSE, message = FALSE-------------------------------
library(methods)
knitr::opts_chunk$set(echo = TRUE, comment = "")
library(methods)
library(ggplot2)
library(ms.lesion)
library(neurobase)
library(extrantsr)
library(scales)

## ------------------------------------------------------------------------
library(ms.lesion)
library(neurobase)
files = get_image_filenames_list_by_subject()$training01
t1_fname = files["MPRAGE"]
t1 = readnii(t1_fname)

## ------------------------------------------------------------------------
ortho2(robust_window(t1))

## ---- message = FALSE----------------------------------------------------
library(extrantsr)
bc_t1 = bias_correct(file = t1, correction = "N4")

## ---- eval = FALSE-------------------------------------------------------
## bc_t1 = bias_correct(file = t1_fname, correction = "N4")

## ----ratio_plot----------------------------------------------------------
ratio = t1 / bc_t1; ortho2(t1, ratio)

## ----making_scales-------------------------------------------------------
library(scales)
q = quantile(ratio[ (ratio < 0.999 | ratio > 1.0001) & ratio != 0 ], probs = seq(0, 1, by = 0.1), na.rm = TRUE)
q = unique(q)
# get a diverging gradient palette
# fcol = scales::div_gradient_pal(low = "blue", mid = "orange", high = "red") 
fcol = scales::brewer_pal(type = "div", palette = "Spectral")(10)
colors =  scales::alpha(gradient_n_pal(fcol)(seq(0,1, length = length(q) - 1)), 0.5)

## ----better_ratio_plot---------------------------------------------------
ortho2(t1, ratio, col.y = colors, ybreaks = q, ycolorbar = TRUE)

## ----ratio_hist_plot, echo = FALSE---------------------------------------
hist(ratio, breaks = 200)

## ----ratio_hist_plot_no1-------------------------------------------------
hist(ratio[ratio < 0.999 | ratio > 1.0001], breaks = 200)

## ----make_df-------------------------------------------------------------
df = which(ratio < 0.999 | ratio > 1.0001, arr.ind = TRUE)
df = cbind(df, value = ratio[df])
df = data.frame(df, stringsAsFactors = FALSE)
df$location = cut(df$dim3, breaks = c(0, 38, 76, 115),
                  labels = c("bottom", "middle", "top"))

## ---- echo = FALSE-------------------------------------------------------
head(df)

## ----ratio_hist_plot_slices----------------------------------------------
ggplot(df, aes(x = value, colour = location)) + geom_line(stat = "density")

## ----saving_out, echo = FALSE--------------------------------------------
writenii(bc_t1, filename = "../output/training01_01_mprage_n4.nii.gz")

