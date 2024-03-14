rule amrfinderplus_paired:
    input:
        faa = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa"), 
    output:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}_amrfinderplus")
    conda:
        os.path.join(dir_env, "amrfinderplus.yaml")
    shell:
        """
            amrfinder -u 
            amrfinder -p {input} -o {output} --plus
        """

rule amrfinderplus_long:
    input:
        faa = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"), 
    output:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}_amrfinderplus")
    conda:
        os.path.join(dir_env, "amrfinderplus.yaml")
    shell:
        """
            amrfinder -u
            amrfinder -p {input} -o {output} --plus
        """

