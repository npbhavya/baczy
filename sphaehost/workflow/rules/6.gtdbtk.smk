rule gtdbtk_long:
    input:
        fi= os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta")
    output:
        identify = os.path.join(dir_hybracter, "gtdbtk", "gtdbtk_indentify"),
        align = os.path.join(dir_hybracter, "gtdbtk", "gtdbtk_align"),
        classify = os.path.join(dir_hybracter, "gtdbtk", "gtdbtk_classify")
    params:
        files=os.path.join(dir_hybracter, "hybracter.out", "final_assemblies"),
        db= os.path.join(databaseDir, "gtdbtk", "release220"),
        container="docker://ecogenomic/gtdbtk:2.4.0"
    threads: 32
    shell:
        """
        apptainer pull -F {params.container}
        apptainer exec -B {params.files}:/data,{output.identify}:/indentify gtdbtk_2.4.0.sif \
            gtdbtk identify --genome_dir /data --cpus {threads} --out_dir /classify -x fasta
        
        apptainer exec -B {output.identify}:/identify, {output.align}:/align gtdbtk_2.4.0.sif \
            gtdbtk align --identify_dir /identify --out_dir /align --cpus {threads}

        apptainer exec -B {output.classify}:/classify,{params.files}:/data,{params.align}:/align \
            gtdbtk_2.4.0.sif \
            gtdbtk classify --genome_dir /data --out_dir /classify --cpus {threads}  -x fasta \
            -f --align_dir /align
        """
