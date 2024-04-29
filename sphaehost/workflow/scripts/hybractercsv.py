#!/usr/bin/env python

import os
import sys

# Directory containing the FASTQ files
directory = snakemake.input.fastp
genome_size = snakemake.params.gensize

# Get all files in the directory
files = os.listdir(directory)

# Filter for only FASTQ files
fastq_files = [file for file in files if file.endswith(".fastq") or file.endswith(".fastq.gz")]

# Process each FASTQ file to generate data
data = []
for fastq_file in fastq_files:
    # Extract the sample name (text before ".fastq")
    sample_name = fastq_file.split(".fastq")[0]
    filepath = os.path.join(directory, fastq_file)
    # Append data to the list
    data.append((sample_name, filepath, genome_size))

# Write the data to a file
with open(snakemake.output.csv, "w") as file:

    # Write each line of data
    for entry in data:
        file.write(f"{entry[0]},{entry[1]},{entry[2]}\n")
