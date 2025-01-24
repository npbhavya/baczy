
SAMPLES, EXTN = zip(*(os.path.splitext(os.path.basename(file_path)) if '.' in os.path.basename(file_path) else (os.path.basename(file_path), '') for file_path in file_paths))
    
rule generate_csv:
    input:
        fastp = os.path.join(input_dir)
    params:
        gensize = config['sphaehost']['args']['gen_size']
    output:
        csv = os.path.join(input_dir, "hybracter.csv")
    localrule: True
    script:
        os.path.join(dir_script, "hybractercsv.py")
    
rule hybracter:
    input: 
        os.path.join(input_dir, "hybracter.csv")
    params:
        o = os.path.join(dir_hybracter, "hybracter.out"),
        log = os.path.join(dir_hybracter, "hybracter.out", "hybracter.log")
    output:
        tsv = os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"),
    container:
        "docker://quay.io/gbouras13/hybracter:0.10.0"
    threads: 16
    shell:
        """
        hybracter long -i {input} -o {params.o} --threads {threads} --verbose -k 2>>{params.log} || \
        (echo "ERROR: Snakemake failed" && touch {output.tsv} && touch {params.log})2>>/dev/null
        """


rule hybracter_genome_dir:
    input:
        p = os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"),
    params:
        out= os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT"),
        final=os.path.join(dir_hybracter, "hybracter.out", "final_assemblies"),
        chrom=os.path.join(dir_hybracter, "hybracter.out", "final_chromosomes"),
        s="{sample}",
        fi= os.path.join(dir_hybracter, "hybracter.out", "DONE"),
    output:
        actual = os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"),
        actual2 = os.path.join(dir_hybracter, "hybracter.out", "final_chromosomes", "{sample}_chromosome.fasta"),

    shell:
        """
        echo "{params.s}"
        cp {params.out}/incomplete/{params.s}.fastq_final.fasta {output.actual} 2>/dev/null || \
        cp {params.out}/complete/{params.s}.fastq_final.fasta {output.actual}

        cp {params.out}/incomplete/{params.s}.fastq_final.fasta {output.actual2} 2>/dev/null || \
        cp {params.out}/complete/{params.s}.fastq_chromosome.fasta {output.actual2}
        echo "{params.s}" >> {params.fi}
        """

rule checkm2_hybracter:
    input:
        fi= expand(os.path.join(dir_hybracter, "hybracter.out", "final_chromosomes", "{sample}_chromosome.fasta"), sample=SAMPLES),
    output:
        report = os.path.join(dir_hybracter, "checkm2", "quality_report.tsv")
    params:
        final = os.path.join(dir_hybracter, "hybracter.out", "final_chromosomes"),
        out = os.path.join(dir_hybracter, "checkm2"),
        db= os.path.join(databaseDir),
        container="docker://staphb/checkm2:1.0.2"
    threads: 32
    shell:
        """
        apptainer pull -F {params.container}

        apptainer exec -B {params.final}:/data,{params.out}:/out,{params.db}:/database checkm2_1.0.2.sif \
            checkm2 predict -t {threads} -x fasta -i /data -o /out --database_path /database/CheckM2_database/uniref100.KO.1.dmnd --force
        """
