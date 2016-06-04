# refseq_dl
Download refseq genomes for a group using Snakemake

## install
```sh
conda install -c bioconda snakemake
git clone https://github.com/eclarke/refseq_dl
cd refseq_dl
```

## usage
To download all the fungal refseq genomes:
```sh
# First, downloads the list of all the genomes
snakemake --config group=fungi
# Next, actually download the genomes (named by their taxid)
snakemake --config group=fungi download_group
```
