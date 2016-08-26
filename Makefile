all: move rmd2md

move:
		cp inst/vign/etseed-vignette.md vignettes

rmd2md:
		cd vignettes;\
		mv etseed-vignette.md etseed-vignette.Rmd
