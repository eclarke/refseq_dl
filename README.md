# refseq_dl
Download refseq genomes for a group using Snakemake

## install
```sh
conda install -c bioconda snakemake
git clone https://github.com/eclarke/refseq_dl
cd refseq_dl
```

## usage
This can be used with any group listed under the genomes/refseq directory, but recommended groups would be:

- fungi
- archaea
- protozoa

### example
To download all the fungal refseq genomes:
```sh
# First, downloads the list of all the genomes
snakemake --config group=fungi
# Next, actually download the genomes (named by their taxid)
snakemake --config group=fungi download_group
# Thrid, add seqeucnes to existing kraken db
snakemake --config group=fungi add_group_to_kraken_db
```

## output
The genomes are listed under `{group}/{taxid}/{taxid}.fna.gz`.
