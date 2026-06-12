# target to make the file report
all: 05_final_report.html 05_final_report.pdf

googlebooks-eng-all-1gram-20120701-1.gz:
	./01_download_1grams.sh # run script to download the 1grams data

year_counts.tsv: googlebooks-eng-all-1gram-20120701-1.gz # filenames for data and/or code this output depends on
	./02_filter_1grams.sh # run script to filter the 1grams data

googlebooks-eng-all-totalcounts-20120701.txt:
	./03_download_totals.sh # run script to download the total counts data

total_counts.csv: googlebooks-eng-all-totalcounts-20120701.txt # filenames for data and/or code this output depends on
	./04_reformat_totals.sh # run script to reformat the total counts data

05_final_report.html: year_counts.tsv total_counts.csv 05_final_report.Rmd ngram_plot_verification.png # filenames for data and/or code this output depends on
	Rscript -e "rmarkdown::render('05_final_report.Rmd')"

05_final_report.pdf: year_counts.tsv total_counts.csv 05_final_report.Rmd ngram_plot_verification.png
	Rscript -e "rmarkdown::render('05_final_report.Rmd', output_format='pdf_document')"