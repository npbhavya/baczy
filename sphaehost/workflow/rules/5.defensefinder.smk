rule defensefinder:
    input:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa")
    output:
        os.path.join(dir_bakta_short, "{sample}_amrfinder", "defense_finder_systems.tsv"),
        os.path.join(dir_bakta_short, "{sample}_amrfinder", "defense_finder_genes.tsv"),
        os.path.join(dir_bakta_short, "{sample}_amrfinder", "defense_finder_hmmer.tsv")
    container:
        "docker://jinlongru/defensefinder:v1.0.9"
    log:
        os.path.join(dir["log"], "defensefinder.{sample}.log")
    shell:
        """
        
        """
