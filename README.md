[![Edwards Lab](https://img.shields.io/badge/Bioinformatics-EdwardsLab-03A9F4)](https://edwards.flinders.edu.au)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![GitHub language count](https://img.shields.io/github/languages/count/npbhavya/spaehost)
[![](https://img.shields.io/static/v1?label=CLI&message=Snaketool&color=blueviolet)](https://github.com/beardymcjohnface/Snaketool)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/npbhavya/spaehost/main)

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

### Installing databases
Run command,

```bash
sphaehost install
```

### Running the workflow

The command `sphaehost run` will run QC, assembly and annotation

**Commands to run**

Only one command needs to be submitted to run all the above steps: QC, assembly and assembly stats

```bash
#For illumina reads, place the reads both forward and reverse reads to one directory
sphaehost run --input sample-data/illumina --output example -k 

#For nanopore reads, place the reads, one file per sample in a directory
sphaehost run --input sample-data/nanopore --sequencing longread --output example -k

#To run either of the commands on the cluster, add --profile slurm to the command. For instance here is the command for longreads/nanopore reads 
#Before running this below command, make sure have slurm config files setup, here is a tutorial, https://fame.flinders.edu.au/blog/2021/08/02/snakemake-profiles-updated 
sphaehost run --input sample-data/illumina --preprocess longread --output example --profile slurm -k
```

### Output

Need to generate the results folder
