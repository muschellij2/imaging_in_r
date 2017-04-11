####################################
# Getting functions for cheatsheet
####################################
rm(list= ls())
library(NCmisc)
all_r = list.files(pattern = ".R", path = "r_scripts", full.names = TRUE)
all_func = sapply(all_r, list.functions.in.file)

all_func = unlist(all_func)
all_func = sort(unique(all_func))

all_functions_created = c(
  "aes", "all", "alpha", "applyEmptyImageDimensions", "arrange", 
  "as.data.frame", "basename", "bias_correct", "biocLite", "boxplot", 
  "brewer_pal", "c", "cbind", "check_nifti", "class", "colMeans", 
  "cut", "data.frame", "density", "desc", "dicom2nifti", "dicomTable", 
  "dim", "do.call", "double_ortho", "download_img_data", "dropEmptyImageDimensions", 
  "example", "fast", "file.exists", "file.path", "file.remove", 
  "floor", "format_sci", "fslbet", "fslbet_robust", "geom_line", 
  "get_image_filenames_list_by_subject", "get_t1_filenames", "ggplot", 
  "gradient_n_pal", "gray", "grep", "group_by", "have_fsl", "head", 
  "hi_latex", "hist", "image", "install_dcm2nii", "install_github", 
  "install.packages", "is.numeric", "lapply", "length", "library", 
  "lines", "list", "list.files", "malf", "mapply", "mask_vals", 
  "mass_images", "matrix", "max", "multi_overlay", "names", "nii.stub", 
  "oMask", "options", "ortho2", "orthographic", "otropos", "overlay", 
  "pandoc.table", "par", "paste", "paste0", "plot", "plot_densities", 
  "print", "quantile", "range", "readDICOM", "readnii", "return", 
  "rm", "robust_window", "rownames", "sapply", "seq", "set", "slice", 
  "source", "strsplit", "system.file", "t", "table", "tally", "text", 
  "unique", "voxres", "which", "whitestripe", "whitestripe_norm", 
  "within_visit_registration", "writenii", "xyz", "zscore_img")

# all_func = setdiff(all_func, all_functions_created)

if (length(all_func) > 0 ) {
  printed = gsub("_", "\\\\_", all_func)
  printed = paste0("\\code{", printed, "} & \\pkg{} & \\\\")
  print(all_func)
  cat("\n")
  cat(printed, sep = "\n")
} else {
  print("No New friends")
}
