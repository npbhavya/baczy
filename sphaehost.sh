#!/bin/bash

#SBATCH --job-name=sphaehost
#SBATCH --output=%x-%j.out.txt
#SBATCH --error=%x-%j.err.txt
#SBATCH --time=1-0
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=200G

##SBATCH --partition=high-capacity
##SBATCH --qos=hc-concurrent-jobs

module load singularity

#test datasets
<<<<<<< HEAD
#sphaehost run --input sample-data/illumina --cores 32 --use-singularity --sdm apptainer --output test 
=======
sphaehost run --input sample-data/illumina --cores 32 --use-singularity --sdm apptainer --output test 
>>>>>>> 4dc006d40bc2610d868781407d1c32f25eee0220
sphaehost run --input sample-data/nanopore --sequencing longread --cores 32 -k --use-singularity --sdm apptainer --output test
