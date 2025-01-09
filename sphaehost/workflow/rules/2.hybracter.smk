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
        o = os.path.join(dir_hybracter, "hybracter.out")
    output:
        tsv = os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"),
    container:
        "docker://quay.io/gbouras13/hybracter:0.10.0"
    log:
        os.path.join(dir["log"], "hybracter-long.log")
    threads: 16
    shell:
        """
        hybracter long -i {input} -o {params.o} --threads {threads} --verbose -k 2>{log} || \
        (echo "ERROR: Snakemake failed" && touch {output.tsv} && touch {log})2>/dev/null
        """

rule hybracter_genome_dir:
    input:
        p = os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"),
    params:
        out= os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT"),
        final=os.path.join(dir_hybracter, "hybracter.out", "final_assemblies"),
        s="{sample}"
    output:
        actual = os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"),
    shell:
        """
        if [ -f {params.out}/incomplete/{params.s}_final.fasta ]; then
            cp {params.out}/incomplete/{params.s}_final.fasta {params.final}/.
        else
            cp {params.out}/complete/{params.s}_final.fasta {params.final}/.
        fi
        """