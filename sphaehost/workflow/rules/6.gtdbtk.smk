rule gtdbtk_long:
    input:
        fi= os.path.join(dir_hybracter, "checkm2", "quality_report.tsv")
    output:
        os.path.join(dir_hybracter, "classify", "gtdbtk.bac120.summary.tsv"),
    params:
        files = os.path.join(dir_hybracter),
        db= os.path.join(databaseDir, "gtdbtk-2.2.3", "db"),
        container="docker://ecogenomic/gtdbtk:2.1.1", 
    threads: 32
    shell:
        """
        apptainer pull -F {params.container}

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk identify --genome_dir /data/hybracter.out/final_assemblies --cpus {threads} --out_dir /data -x fasta

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk align --identify_dir /data --out_dir /data --cpus {threads} 
        
        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk classify --genome_dir /data/hybracter.out/final_assemblies --out_dir /data --cpus {threads} -x fasta -f --align_dir /data
        """

rule gtdbtk_short:
    input:
        fi= os.path.join(dir_megahit, "checkm2", "quality_report.tsv")
    output:
        os.path.join(dir_megahit, "classify", "gtdbtk.bac120.summary.tsv"),
    params:
        files = os.path.join(dir_megahit),
        db= os.path.join(databaseDir, "gtdbtk-2.2.3", "db"),
        container="docker://ecogenomic/gtdbtk:2.1.1", 
    threads: 32
    shell:
        """
        apptainer pull -F {params.container}

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk identify --genome_dir /data/processed_assemblies --cpus {threads} --out_dir /data -x fasta

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk align --identify_dir /data --out_dir /data --cpus {threads} 
        
        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk classify --genome_dir /data/processed_assemblies --out_dir /data --cpus {threads}  -x fasta  -f --align_dir /data
        """