rule bakta_short:
    input:
        os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa")
    output:
        faa = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa"), 
        fna = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.fna"),
        gbff = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gbff"),
        gff3 = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gff3"),
        txt = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.txt")
    params:
        bakta = os.path.join(dir_bakta_short, "{sample}_bakta"),
        smp = "{sample}"
    container:
        "docker://staphb/bakta:1.10.3-5.1-light"
    log:
        os.path.join(dir["log"], "bakta.{sample}.log")
    threads: 32
    shell:
        """
        bakta --output {params.bakta} --prefix {params.smp} --threads {threads} {input} --force
        """

rule bakta_long:
    input:
        os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta")
    output:
        faa = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"), 
        fna = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.fna"),
        gbff = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff"),
        gff3 = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"),
        txt = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.txt"),
    params:
        bakta = os.path.join(dir_bakta_long, "{sample}_bakta"),
        smp = "{sample}"
    container:
        "docker://staphb/bakta:1.10.3-5.1-light"
    log:
        os.path.join(dir["log"], "bakta-long.{sample}.log")
    threads: 32
    shell:
        """
        bakta --output {params.bakta} --prefix {params.smp} --threads {threads} {input} --force
        """