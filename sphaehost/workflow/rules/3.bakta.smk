rule bakta_short:
    input:
        os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa")
    output:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gbff")
    params:
        bakta = os.path.join(dir_bakta_short, "{sample}_bakta"),
        db = os.path.join(databaseDir, "db-light"),
        smp = "{sample}"
    conda:
        os.path.join(dir_env, "bakta.yaml")
    log:
        os.path.join(dir["log"], "bakta.{sample}.log")
    threads: 32
    shell:
        """
        bakta --db {params.db} --output {params.bakta} --prefix {params.smp} --force --threads {threads} {input}
        """

rule bakta_long:
    input:
        os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta")
    output:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff")
    params:
        bakta = os.path.join(dir_bakta_long, "{sample}_bakta"),
        db = os.path.join(databaseDir, "db-light"),
        sample = "{sample}"
    conda:
        os.path.join(dir_env, "bakta.yaml")
    log:
        os.path.join(dir["log"], "bakta-long.{sample}.log")
    threads: 32
    shell:
        """
        bakta --db {params.db} --output {params.bakta} --prefix {params.sample} --force --threads {threads} {input}
        """
