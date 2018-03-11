## ----setup, results='hide', echo=FALSE, message = FALSE, warning=FALSE, include=FALSE----
library(methods)
library(knitr)
library(highr)
opts_chunk$set(echo = TRUE, prompt = FALSE, 
               message = FALSE, warning = FALSE, comment = "", dev = 'png')
knit_hooks$set(inline = function(x) { 
  if (is.numeric(x)) return(knitr:::format_sci(x, 'latex')) 
  hi_latex(x) 
}) 

## ----read_dicom----------------------------------------------------------
library(oro.dicom)
library(divest)
dcm_file = system.file("extdata", "testdata", 
                       "01.dcm", package = "divest")
slice = readDICOM(dcm_file)
class(slice)

## ----hdr_dicom-----------------------------------------------------------
names(slice)
class(slice[["hdr"]])
class(slice$hdr[[1]])
class(slice$img)
class(slice$img[[1]])

## ----display_dicom-------------------------------------------------------
image(t(slice$img[[1]]), col=gray(0:64/64))

## ----pixelspacing_dicom--------------------------------------------------
hdr = slice$hdr[[1]]
hdr[ hdr$name == 'PixelSpacing', "value"]

## ----head_hdr------------------------------------------------------------
head(hdr)

## ----reshape_hdr---------------------------------------------------------
wide = oro.dicom::dicomTable(slice$hdr)
wide[, 1:5]

## ----multi_dicom, cache=FALSE--------------------------------------------
dcm_fol = system.file("extdata", "testdata", package = "divest")
all_slices = readDICOM(dcm_fol)
n = names(all_slices$hdr)
keep = grep("0(1|2).dcm", n)
all_slices$hdr = all_slices$hdr[keep]
all_slices$img = all_slices$img[keep]

## ----reshape_echo, echo = TRUE, eval = FALSE-----------------------------
## wide = oro.dicom::dicomTable(all_slices$hdr)
## wide[, 1:5]

## ----reshape_eval, echo = FALSE, eval = TRUE-----------------------------
wide = oro.dicom::dicomTable(all_slices$hdr)
rownames(wide) = basename(rownames(wide))
wide[, 1:5]

## ----mat, echo = FALSE, eval = TRUE, results="asis"----------------------
library(pander)
m = matrix(c("", "DICOM", "NIfTI",
"File extension:", ".dcm", ".nii or .nii.gz (compressed)",
"Each file is a:", "slice of the brain", "3D image of brain",
"Header information:", " Many fields, protected health information, hospital-related meta-data", "Image meta-data, no patient information",
"Different Images", "Different Folders", "Different Files (can be same directory)"), ncol = 3, byrow = TRUE)
# pander(m, split.cells = c(10, 10, 20))
knitr::kable(m, align = rep("c", 3))

## ----nifti, warning=FALSE------------------------------------------------
nii = dicom2nifti(all_slices)
dim(nii); class(nii)

## ----writenifti----------------------------------------------------------
library(neurobase)
writenii(nim = nii, filename = "Output_3D_File")
list.files(pattern = "Output_3D_File")

## ---- eval = FALSE-------------------------------------------------------
## library(dcm2niir)
## d = dcm2nii(path)
## library(divest)
## res = readDicom(path, interactive = FALSE)

## ---- include = FALSE----------------------------------------------------
file.remove("Output_3D_File.nii.gz")

