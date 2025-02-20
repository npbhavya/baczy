rule defensefinder_short:
    input:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa")
    params:
        out = os.path.join(dir_bakta_short, "{sample}_bakta"),
        db=os.path.join(databaseDir, "macysfinder"),
        sample = "{sample}"
    output:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_defense_finder_systems.tsv"),
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_defense_finder_genes.tsv"),
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_defense_finder_hmmer.tsv")
    conda:
        os.path.join(dir_env, "defensefinder.yaml")
    threads: 8
    shell:
        """
        defense-finder update --models-dir {params.db}
        defense-finder run {input} --models-dir {params.db} -o {params.out} -w {threads}
        """

rule defensefinder_long:
    input:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"),
    params:
        out = os.path.join(dir_bakta_long, "{sample}_bakta"),
        db=os.path.join(databaseDir, "macysfinder"),
        sample = "{sample}"
    output:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_defense_finder_systems.tsv"),
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_defense_finder_genes.tsv"),
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_defense_finder_hmmer.tsv")
    conda:
        os.path.join(dir_env, "defensefinder.yaml")
    threads: 8
    shell:
        """
        defense-finder update --models-dir {params.db}
        defense-finder run {input} --models-dir {params.db} -o {params.out} -w {threads}
        """