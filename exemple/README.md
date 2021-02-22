# Exemple data

Go to the NCBI [GEO accession link](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE165691) and download the supplementary file "GSE165691_DEG_result_table.xlsx" (or directly click [here](ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE165nnn/GSE165691/suppl/GSE165691%5FDEG%5Fresult%5Ftable%2Exlsx) to download). 

Convert the file in csv format (manually or in bash command).

In the folder where the file .csv is, run : 

```bash
name_file=GSE165691_DEG_result_table

# Create exemple.csv from GSE165691_DEG_result_table.csv
# echo : prints the header
# awk : prints column of interest if they are non-empty
# tail : removes the "original" header of the file
echo "GeneName;ID;baseMean;log2FC;pval;padj" > exemple.csv ; awk -F ';' '{if ($6 && $1 && $13 && $2 && $3 && $4) print $6,$1,$13,$2,$3,$4;}' FS=';' OFS=';' $name_file.csv | tail -n+2 >> exemple.csv

# Use . in numeric columns instead of ,
cat exemple.csv | tr ',' '.' > temp.csv; mv temp.csv exemple.csv

# Create exemple.tsv from exemple.csv
cat exemple.csv | tr ';' ',' > temp.csv; mv temp.csv exemple.csv
cat exemple.csv | tr ';' '\t' > exemple.tsv 



# Create very small datasets
head exemple.csv > small_exemple.csv
head exemple.tsv > small_exemple.tsv
```

