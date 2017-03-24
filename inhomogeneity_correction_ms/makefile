all: index.html index.R 
    
index.html: index.Rmd 
	Rscript -e "rmarkdown::render('index.Rmd')"

index.R: index.Rmd
	Rscript -e "knitr::purl('index.Rmd')"

clean: 
	rm index.html index.R 
