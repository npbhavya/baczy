#grabbing all the sample names for the second rule
import glob
SAMPLES, EXTN = zip(*(os.path.splitext(os.path.basename(file_path)) if '.' in os.path.basename(file_path) else (os.path.basename(file_path), '') for file_path in file_paths))

rule longreads:
    input:
        assembly = os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"),
        chromosome = os.path.join(dir_hybracter, "hybracter.out", "final_chromosomes", "{sample}_chromosome.fasta"),
        faa = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"), 
        fna = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.fna"),
        gbff = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff"),
        gff3 = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"),
        txt = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.txt"),
        amr = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_amrfinderplus"),
        pp_coord = os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"),
        pp_gbff = os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_{sample}.gbff"),
    output:
        l = os.path.join(dir_summary_long, "{sample}", "DONE"),
    params:
        summary_dir = os.path.join(dir_summary_long, "{sample}"),
        bakta_dir = os.path.join(dir_bakta_long, "{sample}_bakta"),
        png = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.png"),
        svg = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.svg"),
    shell:
        """
        cp {input.assembly} {params.summary_dir}/.
        cp -r {input.faa} {params.summary_dir}/.
        cp {input.fna} {params.summary_dir}/.
        cp {input.gbff} {params.summary_dir}/.
        cp {input.gff3} {params.summary_dir}/.
        cp {input.txt} {params.summary_dir}/.
        cp {params.png} {params.summary_dir}/.
        cp {params.svg} {params.summary_dir}/.
        cp {input.pp_coord} {params.summary_dir}/.
        cp {input.pp_gbff} {params.summary_dir}/.
        cp -r {input.amr} {params.summary_dir}/.
        touch {output.l}
        """

rule merged_long_defensefinder:
    input:
        defensefinder = expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_defense_finder_systems.tsv"), sample=sample_names)
    output:
        os.path.join(dir_summary_long, "defensefinder_summary.tsv"),
    shell:
        """
        head -n 1 {input.defensefinder[0]} > {output} && \
        for file in {input.defensefinder}; do
            tail -n +2 "$file" >> {output}
        done
        """

rule merged_long_prophage_regions:
    input:
        prophage_regions = expand(os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"), sample=sample_names)
    output:
        os.path.join(dir_summary_long, "prophage_regions.tsv"),
    shell:
        """
        for file in {input.prophage_regions}; do
            sample=$(basename "$file")
            sample="${{sample%%_prophage*}}"
            awk -v s="$sample" '{{print s "\t" $0}}' "$file"
        done > {output}
        """

rule checkm2_long_report:
    input:
        checkm2 = os.path.join(dir_hybracter, "checkm2", "quality_report.tsv"),
    output:
        os.path.join(dir_summary_long, "checkm2_quality_report.tsv"),
    shell:
        """
        cp {input.checkm2} {output}
        """

rule gtdbtk_long_summary:
    input:
        gtdbtk = os.path.join(dir_hybracter, "classify", "gtdbtk.bac120.summary.tsv"),
        tree = os.path.join(dir_hybracter, "de_novo_output", "gtdbtk.bac120.decorated.tree"),
        tree_table = os.path.join(dir_hybracter, "de_novo_output", "gtdbtk.bac120.tree.table"),
    output:
        gtdb=os.path.join(dir_summary_long, "gtdbtk.bac120.summary.tsv"),
        treeo =os.path.join(dir_summary_long, "gtdbtk.bac120.decorated.tree"),
        tree_tableo =os.path.join(dir_summary_long, "gtdbtk.bac120.tree.table"),
    shell:
        """
        cp {input.gtdbtk} {output.gtdb}
        cp {input.tree} {output.treeo}
        cp {input.tree_table} {output.tree_tableo}
        """

rule bakta_long_summary:
    input:
        txt = expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.txt"), sample=sample_names)
    output:
        os.path.join(dir_summary_long, "bakta_summary.tsv"),
    params:
        script=os.path.join(workflow.basedir, "scripts", "merge_bakta.py"),
    shell:
        """
        python {params.script} -i {input.txt} -o {output}
        """

rule summary_long_amrfinder:
    input:
        amr = expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_amrfinderplus"), sample=sample_names)
    output:
        os.path.join(dir_summary_long, "amrfinder_summary.tsv"),
    shell:
        """
        echo -e "sample\t$(head -n 1 {input.amr[0]})" > {output} && \
        for file in {input.amr}; do
            sample=$(basename "$file")
            sample="${{sample%%_amrfinderplus}}"
            tail -n +2 "$file" | awk -v s="$sample" '{{print s "\t" $0}}'
        done >> {output}
        """