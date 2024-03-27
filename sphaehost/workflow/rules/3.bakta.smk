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
        faa = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"), 
        fna = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.fna"),
        gbff = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff"),
        gff3 = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"),
        txt = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.txt"),
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
        if [ -z "{input}" ]; then
            # Input is empty, touch the output files
            touch {output.faa} {output.fna} {output.gbff} {output.gff3} {output.txt}
        else
            # Input is not empty, run the bakta command
            bakta --db {params.db} --output {params.bakta} --prefix {params.sample} --force --threads {threads} {input}
        fi        
        """
