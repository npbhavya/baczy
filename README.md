[![Edwards Lab](https://img.shields.io/badge/Bioinformatics-EdwardsLab-03A9F4)](https://edwards.flinders.edu.au)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![GitHub language count](https://img.shields.io/github/languages/count/npbhavya/sphaehost)
[![](https://img.shields.io/static/v1?label=CLI&message=Snaketool&color=blueviolet)](https://github.com/beardymcjohnface/Snaketool)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/npbhavya/sphaehost)

# sphaehost
<p align="center">
  <img src="sphaehostlogo.png#gh-light-mode-only" width="300">
  <img src="sphaehostlogo.png#gh-dark-mode-only" width="300">
</p>

## Overview

**SphaeHost** is a **Snakemake-based workflow** for **assembling and annotating bacterial host genomes**. It extends **[Sphae](https://github.com/linsalrob/sphae)**, which assembles and annotates phage genomes, by enabling host genome assembly and functional annotation. 

🔹 **Features:**  
✔ **Quality control** ([Fastp](https://github.com/OpenGene/fastp))  
✔ **Genome assembly** ([MEGAHIT](https://github.com/voutcn/megahit), [Hybracter](https://github.com/gbouras13/hybracter))  
✔ **Functional annotation** ([Bakta](https://github.com/oschwengers/bakta))  
✔ **Taxonomic classification** ([GTDB-Tk](https://github.com/Ecogenomics/GTDBTk))  
✔ **Taxonomic tree** ([GTDB-Tk](https://github.com/Ecogenomics/GTDBTk)) 
✔ **Defense & resistance profiling** ([Defense-Finder](https://github.com/mdmparis/defense-finder), [AMRFinderPlus](https://github.com/ncbi/amr), [CapsuleDB](https://research.pasteur.fr/en/tool/capsulefinder/))  
✔ **Prophage detection** ([PhiSpy](https://github.com/linsalrob/PhiSpy))  
✔ **Pan-genome analysis** ([Panaroo](https://github.com/gtonkinhill/panaroo))  

## Installion

Steps for installing sphae workflow 

  ```bash
  #clone sphae repository
  git clone https://github.com/npbhavya/sphaehost.git

  #move to sphae folder
  cd sphaehost

  #install sphae
  pip install -e .

  #confirm the workflow is installed by running the below command 
  sphaehost --help
  ```

### Manual installation 
- Install singularity or load the module
    On deepthought cluster \
    `module load apptainer`

- Install miniconda
    Download and install Miniconda:
    [Miniconda Installation Guide](https://docs.anaconda.com/miniconda/install/)

## Database setup

Download and place the required databases in:
  `sphaehost/workflow/databases`

  - [CheckM2_database](https://github.com/chklovski/CheckM2?tab=readme-ov-file#database)
  - [GTDBTK database](https://ecogenomics.github.io/GTDBTk/installing/index.html)
  - [Capsuledb](https://gitlab.pasteur.fr/gem/capsuledb/-/tree/master/CapsuleFinder_models?ref_type=heads)

### Running the workflow

Run SphaeHost using a single command!

**Before starting the run**
The taxonomic tree is generated using [GTDB-Tk](https://github.com/Ecogenomics/GTDBTk), so update the lines 
  
  ```
  gtdbtk:
    outgroup: "d__Archaea"
    taxa_filter: "d__Bacteria"
  ```

This can be set to more specific genera: 
  
  ```
  gtdbtk:
    outgroup: "g__Escherichia"
    taxa_filter: "g__Achromobacter"
  ```

**For paired end reads**

  `sphaehost run --input sample-data/illumina --cores 32 --use-singularity --sdm apptainer --output test -k --use-conda`

**For long reads**

  `sphaehost run --input sample-data/nanopore --sequencing longread --cores 32 -k --use-singularity --sdm apptainer --output test -k --use-conda`

### Intermediate files 
Stored in:

  `sphae.out/PROCESSING`

### Final Results and Output
Stored in `RESULT-short` for short reads or `RESULTS-long` for long reads

Each folder contains:
  - **{sample} folder**
    - {sample}_amrfinderplus table: identified AMR genes in the genome
    - {sample}_contigs.fa or {sample}_final.fasta : assembled genomes for each genome
    - {sample}.faa : identified proteins
    - {sample}.fna : identified genes
    - {sample}.gbff
    - {sample}.gff3
    - {sample}.png and {sample}.svg : genome visualized
    - {sample}.txt: summary 
    - {sample}_prophage_coordinates.tsv: location of the identified prophages using Phispy
  - **amrfinder_summary.tsv** : a table with all the AMRFinder genes in all the samples
  - **bakta_summary.tsv** : Bakta summary for all the samples saved to one table
  - **checkm2_quality_report.tsv** : Checkm2 completenes results
  - **defensefinder_summary.tsv** : All the defense systems found in all the samples 
  - **gtdbtk.ba120_summary.tsv** : GTDBTK summary with the predicted taxa for each of the samples
  - **gtdbtk.bac120.decorated.tree** , *gtdbtk.bac120.tree.table* : GTDBTK tree and the tree table
    - visualize the tree on iTOL
  - **prophage_regions.tsv** : Location of the prophage regions in al the samples
  - **Panaroo folder**
    - output from running [panaroo](https://github.com/gtonkinhill/panaroo)  
