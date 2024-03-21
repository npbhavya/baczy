rule panaroo_paired:
    input:
        gff = expand(os.path.join(dir_summary_short, "{sample}", "{sample}.gff3"), sample=sample_names)
    params:
        out = os.path.join(dir_panaroo_short)
    output:
        