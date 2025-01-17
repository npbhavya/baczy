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

## Bacterial asembly and annotation

This is an extension of sphae (https://github.com/linsalrob/sphae). Sphae assembled and annotates phage genomes, here I am assembling and annotating the bacterial hosts. 

### Install 

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
- Install singularity
  On deepthought run `module load apptainer`

### Install databases 

Download the following databases to `sphaehost/workflow/databases`
  - CheckM2_database
  - GTDBTK database

### Running the workflow

The command `sphaehost run` will run QC, assembly and annotation

**Commands to run**

Only one command needs to be submitted to run all the above steps: QC, assembly and assembly stats

```bash
#For illumina reads, place the reads both forward and reverse reads to one directory
sphaehost run --input sample-data/illumina --cores 32 --use-singularity --sdm apptainer --output test -k --use-conda

#For nanopore reads, place the reads, one file per sample in a directory
sphaehost run --input sample-data/nanopore --sequencing longread --cores 32 -k --use-singularity --sdm apptainer --output test -k --use-conda
```

### Intermediate files 
Saved to `sphae.out/PROCESSING`

### Output
Saved to `sphae.out/RESULTS` 

A folder should be generated for each sample. This samples should have
  - Final assembly saved in file ending with {sample}*_final.fasta
  - bakta annotations 
  - defensefinder annotations
