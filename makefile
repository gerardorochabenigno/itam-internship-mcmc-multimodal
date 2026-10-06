all:
	quarto render quarto
	rm -rf docs
	cp -R quarto/_site docs
	touch docs/.nojekyll

clean:
	rm -rf docs quarto/_site quarto/.quarto