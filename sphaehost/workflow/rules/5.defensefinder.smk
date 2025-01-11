rule defensefinder_short:
    input:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa")
    output:
        os.path.join(dir_bakta_short, "{sample}_bakta", "defense_finder_systems.tsv"),
        os.path.join(dir_bakta_short, "{sample}_bakta", "defense_finder_genes.tsv"),
        os.path.join(dir_bakta_short, "{sample}_bakta", "defense_finder_hmmer.tsv")
    container:
        "docker://mesti90/defensefinder:1.0"
    shell:
        """
        defense-finder update
        defense-finder run {input}
        """

rule defensefinder_long:
    input:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"),
    output:
        os.path.join(dir_bakta_long, "{sample}_bakta", "defense_finder_systems.tsv"),
        os.path.join(dir_bakta_long, "{sample}_bakta", "defense_finder_genes.tsv"),
        os.path.join(dir_bakta_long, "{sample}_bakta", "defense_finder_hmmer.tsv")
    container:
        "docker://mesti90/defensefinder:1.0"
    shell:
        """
        defense-finder update
        defense-finder run {input}
        """