# Target rules

targets = {'all': []}

if config['sphaehost']['args']['sequencing'] == 'paired':
    print ("Entering paired targets")
    targets['all'].append(expand(os.path.join(dir_fastp_short,"{sample}_R1.fastq.gz"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_fastp_short,"{sample}_R2.fastq.gz"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gbff"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.fna"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gff3"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.txt"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_amrfinderplus"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_{sample}.gbff"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_phispy.log"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_summary_short, "{sample}", "logs"), sample=sample_names))
elif config['sphaehost']['args']['sequencing'] == 'longread':
    print ("entering nanopore targets")
    targets['all'].append(os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"))
    targets['all'].append(expand(os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.fna"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.txt"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_amrfinderplus"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_{sample}.gbff"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_phispy.log"), sample=sample_names))
    targets['all'].append(expand(os.path.join(dir_summary_long, "{sample}", "log"), sample=sample_names))