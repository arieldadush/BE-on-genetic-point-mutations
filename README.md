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
