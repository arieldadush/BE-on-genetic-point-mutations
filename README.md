# BE-on-genetic-point-mutations
As genome-editing approaches are rapidly progressing, it stands to reason that a revolution in the field of genetic diseases is just around the corner. Hopefully, this work will help scientists and clinicians design successful targets for therapies, marching medicine to a future in which curing genetic diseases is feasible.  

# Installation and Requirements
## Dependencies
bigBedToBed

[Python 3.10.4](https://www.python.org/downloads/release/python-3104/)

## Human point mutations data
We downloaded the database from two websites:
1. UCSC table browser
2. clinVar FTP site

**UCSC table browser:**

We downloaded this database because it contains a lot of fields and information. In addition it contains the refseq id of each mutation and the location on the gene, so you can easily find the codon of the mutation.

We downloaded the database as a bigBED file, using the following bash command:
```wget http://hgdownload-euro.soe.ucsc.edu/gbdb/hg38/bbi/clinvar/clinvarMain.bb```

The downloaded file is bigBED fromat, so I converted it to a BED file using the command:
```bigBedToBed "/private5/Projects/dadush/clinvar_base_editing/clinvarMain.bb" "/private5/Projects/dadush/clinvar_base_editing/clinvarMain.bed"```

**clinVar FTP site**

From the official website of clinVar you can reach the FTP site where you can download the database as a VCF file. The file itself contains less information than the database we downloaded at UCSC, but it is updated every month and also contains information about the distribution of the submitters' interpretation in cases where there is a conflict.
download command:
``` wget https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/archive_2.0/2021/clinvar_20211107.vcf.gz```

## Filtering the database

Filtering the original database so that it contains only the target that is relevant to us - pathogenic SNV mutations that are located on genes.

```create_ff_14_02_23.ipynb```

## Adding information

1. Adding a base before and after the mutation and the strand

  ```add_base_before_base_after_Erez_with_nAn_values_15_3_23.sh```

2. Arranging the database and adding a reading frame

  Download the table ![image](https://user-images.githubusercontent.com/73337793/233617219-234a54d7-7776-4187-bb9d-b159171879e7.png)
  Using the table we calculate the reading frame in which the mutation is located
  
  ```order_FF_27.03.ipynb```
  
3. Adding a DNA sequence of 20 bases before and after the mutation
  
  ```20_seq_before_after_Erez.sh```
  
4. Adding a RNA sequence of 20 bases before and after the mutation
  Download all CDS in FASTA format, in order to use the sequences to find the RNA sequences around the pamutation.
  
  ```add_rna_seq_28.03.ipynb```


