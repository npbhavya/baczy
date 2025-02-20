
import glob

SAMPLES = [os.path.splitext(os.path.basename(file_path))[0].rsplit('_R1', 1)[0] for file_path in file_paths]

rule gff3_dir:
    input:
        gff = os.path.join(dir_bakta_short, "{sample}_bakta",  "{sample}.gff3")
    params:
        os.path.join(dir_panaroo_short, "gff3")
    output:
        os.path.join(dir_panaroo_short, "gff3", "{sample}.gff3")
    shell:
        """
        cp {input.gff} {output}
        """
    
rule panaroo_paired:
    input:
        gff = (expand(os.path.join(dir_panaroo_short, "gff3",  "{sample}.gff3"), sample=sample_names))
    params:
        out = os.path.join(dir_panaroo_short),
        gff3 = os.path.join(dir_panaroo_short, "gff3")
    output:
        summary = os.path.join(dir_panaroo_short, "summary_statistics.txt"),
        preabs = os.path.join(dir_panaroo_short, "gene_presence_absence.csv")
    container:
        "docker://staphb/panaroo:1.5.1"
    threads: 32
    shell:
        """
        if [ $(echo {input.gff} | wc -w) -eq 1 ]; then
            echo "only one file, did not run panaroo" > {output.summary}
            echo "only one file, did not run panaroo" > {output.preabs}
        else
            panaroo -i {input.gff} -o {params.out} -t {threads} --remove-invalid-genes --clean-mode strict -a core
        fi        
        """


