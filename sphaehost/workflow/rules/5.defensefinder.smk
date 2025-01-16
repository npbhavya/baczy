rule defensefinder_short:
    input:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa")
    params:
        out = os.path.join(dir_bakta_short, "{sample}_bakta"),
        sample = "{sample}"
    output:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_defense_finder_systems.tsv"),
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_defense_finder_genes.tsv"),
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_defense_finder_hmmer.tsv")
    container:
        "docker://mesti90/defensefinder:1.0"
    shell:
        """
        defense-finder update
        defense-finder run {input}
        mv {params.sample}_defense_finder* {params.out}/.
        """

rule defensefinder_long:
    input:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"),
    params:
        out = os.path.join(dir_bakta_long, "{sample}_bakta"),
        sample = "{sample}"
    output:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_defense_finder_systems.tsv"),
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_defense_finder_genes.tsv"),
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_defense_finder_hmmer.tsv")
    container:
        "docker://mesti90/defensefinder:1.0"
    shell:
        """
        defense-finder update
        defense-finder run {input}
        mv {params.sample}_defense_finder* {params.out}/.
        """