LIST = intro
LIST += starting_with_raw_data
LIST += visualization
LIST += inhomogeneity_correction_ms
LIST += brain_extraction_malf
LIST += segmentation
LIST += coregistration
# LIST += ms_lesion_segmentation
LIST += installing_everything_locally
# LIST += intensity_normalization

all:
	for fol in $(LIST) ; do \
		pwd && echo $$fol && cp makefile.copy $$fol/makefile && cd $$fol && make all && cd ../; \
	done
	Rscript -e "rmarkdown::render('index.Rmd', output_format = 'all')"
#  

index.html index.pdf: index.Rmd 
	Rscript -e "rmarkdown::render('index.Rmd', output_format = 'all')"

clean: 
	rm index.html
