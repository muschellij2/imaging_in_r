LIST = intro
LIST += visualization
LIST += general_r
LIST += imaging_r_packages
LIST += inhomogeneity_correction_ms
# malf must be before coreg
LIST += brain_extraction_malf
LIST += segmentation
LIST += coregistration
LIST += intensity_normalization
LIST += starting_with_raw_data
LIST += installing_everything_locally
LIST += ms_lesion_segmentation
LIST += image_harmonization

all:
	for fol in $(LIST) ; do \
		pwd && echo $$fol && cp makefile.copy $$fol/makefile && cd $$fol && make all && cd ../; \
	done
	for fol in $(LIST) ; do \
		pwd && echo $$fol && cp $$fol/index.pdf pdfs/$$fol.pdf; \
	done
	make index.html
#  

index.html: index.Rmd 
	Rscript -e "rmarkdown::render('index.Rmd')"

clean: 
	rm index.html
