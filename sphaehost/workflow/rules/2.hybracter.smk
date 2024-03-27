rule generate_csv:
    input:
        fastp = os.path.join(input_dir)
    params:
        gensize = 6000000,
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
        db = os.path.join(databaseDir, 'hybracterDB')
    output:
        fasta = os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv")
    conda:
        os.path.join(dir_env, "hybracter.yaml")
    log:
        os.path.join(dir["log"], "hybracter-long.log")
    threads: 16
    shell:
        """
        hybracter long -i {input} -o {params.o} --threads {threads} -d {params.db} --verbose -k 2>{log} || \
        (echo "Error: Command failed" && touch {output.fasta} && touch {log})
        """

rule hybracter_genome_dir:
    input:
        p = os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"),
    params:
        out= os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT"),
        final=os.path.join(dir_hybracter, "hybracter.out", "final_assemblies")
    output:
        actual = os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"),
    shell:
        """
        cp {params.out}/*/*_final.fasta {params.final}
        """
    