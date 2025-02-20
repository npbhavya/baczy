#grabbing all the sample names for the second rule
import glob
SAMPLES, EXTN = zip(*(os.path.splitext(os.path.basename(file_path)) if '.' in os.path.basename(file_path) else (os.path.basename(file_path), '') for file_path in file_paths))

rule gff3_dir_long:
    input:
        gff = os.path.join(dir_bakta_long, "{sample}_bakta",  "{sample}.gff3")
    params:
        os.path.join(dir_panaroo_long, "gff3")
    output:
        os.path.join(dir_panaroo_long, "gff3", "{sample}.gff3")
    shell:
        """
        cp {input.gff} {output}
        """

rule panaroo_long:
    input:
        gff = (expand(os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"), sample=sample_names))
    params:
        out = os.path.join(dir_panaroo_long)
    output:
        summary = os.path.join(dir_panaroo_long, "summary_statistics.txt"),
        preabs = os.path.join(dir_panaroo_long, "gene_presence_absence.csv")
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