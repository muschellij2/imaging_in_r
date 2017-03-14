# Image Segmentation
Kristin Linn  
`r Sys.Date()`  



## Overview 
In this tutorial we will discuss segmentation of the brain into tissue classes and automatic MS lesion segmentation using OASIS. 

## Loading Data


```r
library(ms.lesion)
library(neurobase)
library(fslr)
library(oasis)
library(scales)
files = get_image_filenames_list_by_subject(
  type = "coregistered")$training01
t1file = files["MPRAGE"]
maskfile = files["Brain_Mask"]
mask = readnii(maskfile)
t1 = readnii(t1file)
```


## Tissue Segmentation using FSL FAST

The fslr function fast calls fast from FSL [@fast].  The `--nobias` option tells FSL to not perform inhomogeneity correction. 


```r
t1file = files["MPRAGE"]
t1fast = fast(t1, outfile = paste0(nii.stub(t1file), "_FAST"), opts = "--nobias")
```




```r
separate = lapply(1:3, function(x){
  t1fast == x
})
L = c(MPRAGE = list(t1), separate)
L$MPRAGE = robust_window(L$MPRAGE)
r = range(L$MPRAGE)
L$MPRAGE = (L$MPRAGE - r[1])/(r[2] - r[1])
multi_overlay(L, z = 60)
```

### Results

FAST assumes three tissue classes and produces an image with the three labels, ordered by increasing within-class mean intensities. In a T1 image, this results in 1: CSF, 2: Gray Matter, 3: White Matter.  

## White Matter


```r
ortho2(t1, t1fast == 3, col.y = alpha("red", 0.5), text = "White Matter")
```

![](index_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

## Gray Matter


```r
ortho2(t1, t1fast == 2, col.y = alpha("red", 0.5), text="Gray Matter")
```

![](index_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

## CSF


```r
ortho2(t1, t1fast == 1, col.y = alpha("red", 0.5), text="CSF")
```

![](index_files/figure-html/unnamed-chunk-5-1.png)<!-- -->


## Tissue Segmentation using ANTsR, extrantsr

- Uses Atropos (CITE)


```r
t1_otropos = otropos(a = t1, x = mask)
t1seg = t1_otropos$segmentation
```



## White Matter


```r
ortho2(t1, t1seg == 3, col.y = alpha("red", 0.5), text = "White Matter")
```

![](index_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

## Gray Matter


```r
ortho2(t1, t1seg == 2, col.y = alpha("red", 0.5), text="Gray Matter")
```

![](index_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

## CSF


```r
ortho2(t1, t1seg == 1, col.y = alpha("red", 0.5), text="CSF")
```

![](index_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

### Estimating the Volume of Each Class

We can create a table which will count the number of voxels in each category:


```r
tab_fsl = table(t1seg[ t1seg != 0])
tab_fsl
```

```

     1      2      3 
400383 781550 603259 
```

```r
tab_ants = table(t1fast[ t1fast != 0])
tab_ants
```

```

     1      2      3 
470017 748218 566588 
```

```r
names(tab_fsl) = names(tab_ants) = c("CSF", "GM", "WM")
```

### Estimating the Volume of Each Class

By multiplying by the voxel resolution (in cubic centimeters), we can get volumes


```r
vres = voxres(t1seg, units = "cm")
vol_fsl = tab_fsl * vres
vol_fsl
```

```
     CSF       GM       WM 
321.2575 627.0965 484.0402 
```

```r
vol_ants = tab_ants * vres
vol_ants
```

```
     CSF       GM       WM 
377.1301 600.3518 454.6163 
```


