# Target rules

targets = {'asan': [], 'pan': []}

if config['sphaehost']['args']['sequencing'] == 'paired':
    print ("Entering paired targets")
    targets['asan'].append(expand(os.path.join(dir_fastp_short,"{sample}_R1.fastq.gz"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_fastp_short,"{sample}_R2.fastq.gz"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gbff"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.fna"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gff3"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.txt"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_amrfinderplus"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_{sample}.gbff"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_phispy.log"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_summary_short, "{sample}", "{sample}_logs"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_summary_short, "{sample}", "{sample}.gff3"), sample=sample_names))
elif config['sphaehost']['args']['sequencing'] == 'longread':
    print ("entering nanopore targets")
    targets['asan'].append(os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"))
    targets['asan'].append(expand(os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.fna"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.txt"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_amrfinderplus"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_{sample}.gbff"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_phispy.log"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_summary_long, "{sample}", "{sample}_log"), sample=sample_names))
    targets['asan'].append(expand(os.path.join(dir_summary_long, "{sample}", "{sample}.gff3"), sample=sample_names))

if config['sphaehost']['args']['sequencing'] == 'paired':
    targets['pan'].append(os.path.join(dir_panaroo_short, "summary_statistics.txt"))
    targets['pan'].append(os.path.join(dir_panaroo_short, "gene_presence_absence.csv"))
elif config['sphaehost']['args']['sequencing'] == 'longread':
    targets['pan'].append(os.path.join(dir_panaroo_long, "summary_statistics.txt"))
    targets['pan'].append(os.path.join(dir_panaroo_long, "gene_presence_absence.csv"))