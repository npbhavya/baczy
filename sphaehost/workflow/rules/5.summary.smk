#rule to grab all the results to a results folder
rule paired:
    input:
        assembly = os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa"),
        faa = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa"), 
        fna = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.fna"),
        gbff = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gbff"),
        gff3 = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gff3"),
        txt = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.txt"),
        amr = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_amrfinderplus"),
        pp_coord = os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"),
        pp_gbff = os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_{sample}.gbff"),
    output:
        l= os.path.join(dir_summary_short, "{sample}", "{sample}_logs"),
        gff = os.path.join(dir_summary_short, "{sample}", "{sample}.gff3")
    params:
        png = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.png"),
        svg = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.svg"),
        summary_dir = os.path.join(dir_summary_short, "{sample}")
    shell:
        """
        cp {input.assembly} {params.summary_dir}
        cp {input.faa} {params.summary_dir}
        cp {input.fna} {params.summary_dir}
        cp {input.gbff} {params.summary_dir}
        cp {input.gff3} {params.summary_dir}
        cp {input.txt} {params.summary_dir}
        cp {input.amr} {params.summary_dir}
        cp {input.pp_coord} {params.summary_dir}
        cp {input.pp_gbff} {params.summary_dir}
        cp {params.png} {params.summary_dir}
        cp {params.svg} {params.summary_dir}
        echo "DONE-GREAT-WORK" >{output.l}
        """

rule longreads:
    input:
        p = os.path.join(dir_hybracter, "hybracter.out", "FINAL_OUTPUT", "hybracter_summary.tsv"),
        assembly = os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"),
        faa = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"), 
        fna = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.fna"),
        gbff = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff"),
        gff3 = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"),
        txt = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.txt"),
        amr = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_amrfinderplus"),
        pp_coord = os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"),
        pp_gbff = os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_{sample}.gbff"),
    output:
        l = os.path.join(dir_summary_long, "{sample}", "{sample}_log"),
        gff = os.path.join(dir_summary_long, "{sample}", "{sample}.gff3")
    params:
        summary_dir = os.path.join(dir_summary_long, "{sample}"),
        png = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.png"),
        svg = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.svg")
    shell:
        """
        cp {input.p} {params.summary_dir}
        cp {input.assembly} {params.summary_dir}
        cp {input.faa} {params.summary_dir}
        cp {input.fna} {params.summary_dir}
        cp {input.gbff} {params.summary_dir}
        cp {input.gff3} {params.summary_dir}
        cp {input.txt} {params.summary_dir}
        cp {input.amr} {params.summary_dir}
        cp {input.pp_coord} {params.summary_dir}
        cp {input.pp_gbff} {params.summary_dir}
        cp {params.png} {params.summary_dir}
        cp {params.svg} {params.summary_dir}
        echo "DONE-GREAT-WORK" >{output.l}
        """