LIST = intro
LIST += starting_with_raw_data
LIST += visualization
LIST += inhomogeneity_correction_ms
LIST += brain_extraction_malf
LIST += segmentation
LIST += coregistration
# LIST += intensity_normalization

all:
	for fol in $(LIST) ; do \
		pwd && echo $$fol && cp makefile.copy $$fol/makefile && cd $$fol && make all && cd ../; \
	done
	Rscript -e "rmarkdown::render('index.Rmd')"
#  

index.html: index.Rmd 
	Rscript -e "rmarkdown::render('index.Rmd')"

clean: 
	rm index.html
