import re
import csv

from snakemake.utils import update_config

from functions import *

default_config = {
    'group': 'fungi'
}

update_config(default_config, config)
config = default_config

rule all:
    input:
        config['group']+"/genome_urls.txt"

rule assembly_summary:
    output:
        temp("{group}/assembly_summary.txt")
    shell:
        """
        mkdir -p {wildcards.group}
        curl 'ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/{wildcards.group}/assembly_summary.txt' > {output}
        """

rule genome_urls:
    input:
        "{group}/assembly_summary.txt"
    output:
        "{group}/genome_urls.txt"
    run:
        header = []
        with open(input[0]) as infile:
            infile.readline() # skip garbage line
            header = infile.readline().strip().split('\t')
            csvfile = csv.DictReader(infile, fieldnames=header, delimiter='\t')
            with open(output[0], 'w') as out:
                writer = csv.DictWriter(
                    out, fieldnames=['taxid', 'url'], delimiter='\t')
                for row in csvfile:
                    if row.get('ftp_path'):
                        genome_url = convert_to_genome_path(row['ftp_path'])
                        writer.writerow(
                            {'taxid': row['taxid'], 'url':genome_url})

rule download_genome:
    input:
        "{group}/genome_urls.txt"
    output:
        "{group}/{taxid}/{taxid}.fna.gz"
    run:
        urls = csv.DictReader(open(input[0]), fieldnames=['taxid','url'], delimiter='\t')
        for row in urls:
            if row['taxid'] == wildcards.taxid:
                shell("curl {row[url]} > {output}")
                break

rule download_group:
    input:
        config['group']+"/genome_urls.txt",
        expand(
            "{group}/{taxid}/{taxid}.fna.gz",
            group=config['group'],
            taxid=generate_list(config['group']+'/genome_urls.txt'))
                    
                        
                    
            
