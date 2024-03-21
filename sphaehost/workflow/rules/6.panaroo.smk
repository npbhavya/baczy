rule panaroo_paired:
    input:
        gff = (expand(os.path.join(dir_summary_short, "{sample}", "{sample}.gff3"), sample=sample_names))
    params:
        out = os.path.join(dir_panaroo_short)
    output:
        summary = os.path.join(dir_panaroo_short, "summary_statistics.txt"),
        preabs = os.path.join(dir_panaroo_short, "gene_presence_absence.csv")
    conda:
        os.path.join(dir_env, "panaroo.yaml")
    log:
        os.path.join(dir["log"],"panaroo-short.log")
    threads: 32
    shell:
        """
        panaroo -i {input.gff} -o {params.out} -t {threads} --remove-invalid-genes --clean-mode strict -a core
        """

rule panaroo_long:
    input:
        gff = (expand(os.path.join(dir_summary_long, "{sample}", "{sample}.gff3"), sample=sample_names))
    params:
        out = os.path.join(dir_panaroo_long)
    output:
        summary = os.path.join(dir_panaroo_long, "summary_statistics.txt"),
        preabs = os.path.join(dir_panaroo_long, "gene_presence_absence.csv")
    conda:
        os.path.join(dir_env, "panaroo.yaml")
    log:
        os.path.join(dir["log"],"panaroo-long.log")
    threads: 32
    shell:
        """
        panaroo -i {input.gff} -o {params.out} -t {threads} --remove-invalid-genes --clean-mode strict -a core
        """