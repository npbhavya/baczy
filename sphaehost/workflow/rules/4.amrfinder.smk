rule amrfinderplus_paired:
    input:
        faa = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa"),
        gff3 = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gff3"), 
        contigs = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.fna")
    output:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_amrfinderplus")
    container:
        "docker://staphb/ncbi-amrfinderplus:4.0.3-2024-10-22.1"
    params:
        organism = config['sphaehost']['args']['organism'],
    shell:
        """
        if [[ "{params.organism}" != "" ]]; then
            amrfinder -u 
            amrfinder -p {input.faa} -g {input.gff3} -n {input.contigs} -O {params.organism} -a bakta -o {output} --plus
        else
            amrfinder -p {input.faa} -g {input.gff3} -n {input.contigs} -a bakta -o {output} --plus
        fi
        """

rule amrfinderplus_long:
    input:
        faa = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"),
        gff3 = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gff3"),
        contigs = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.fna") 
    output:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_amrfinderplus")
    container:
        "docker://staphb/ncbi-amrfinderplus:4.0.3-2024-10-22.1"
    params:
        organism = config['sphaehost']['args']['organism'],
    shell:
        """
        if [[ "{params.organism}" != "" ]]; then
            amrfinder -u 
            amrfinder -p {input.faa} -g {input.gff3} -n {input.contigs} -O {params.organism} -a bakta -o {output} --plus
        else
            amrfinder -p {input.faa} -g {input.gff3} -n {input.contigs} -a bakta -o {output} --plus
        fi
        """