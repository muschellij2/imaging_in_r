all: index.html index.R index.pdf
    
index.html index.pdf: index.Rmd 
	Rscript -e "rmarkdown::render('index.Rmd', output_format = 'all')"

index.R: index.Rmd
	Rscript -e "knitr::purl('index.Rmd')"

clean: 
	rm index.html index.R 
