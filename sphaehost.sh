#!/bin/bash

#SBATCH --job-name=sphaehost
#SBATCH --output=%x-%j.out.txt
#SBATCH --error=%x-%j.err.txt
#SBATCH --time=0-8:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --partition=high-capacity
#SBATCH --qos=hc-concurrent-jobs

module load singularity

#test datasets
sphaehost run --input sample-data/illumina --cores 1 --use-singularity --sdm apptainer --output test --use-conda
sphaehost run --input sample-data/nanopore --sequencing longread --cores 32 -k --use-singularity --sdm apptainer --output test --use-conda
