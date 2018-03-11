all: index.html index.R index.pdf
	
index.html: index.Rmd 
	Rscript -e "rmarkdown::render('index.Rmd')"

index.R: index.Rmd
	Rscript -e "knitr::purl('index.Rmd')"
	cp index.R ../r_scripts/$(shell basename $(CURDIR)).R; 

index.pdf: index.html index.Rmd 
	electron-pdf index.html index.pdf --landscape

clean: 
	rm index.html index.R 
