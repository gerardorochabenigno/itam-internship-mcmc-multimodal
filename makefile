all:
	quarto render quarto

clean:
	rm -rf docs quarto/_freeze quarto/.quarto