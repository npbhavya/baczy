rule phispy_short:
    input:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gbff")
    output:
        os.path.join(dir_bakta_short, "{sample}_prophages", "phispy.log")
    params:
        os.path.join(dir_bakta_short, "{sample}_prophages")
    conda:
        os.path.join(dir_env, "phispy.yaml")
    log:
        os.path.join(dir["log"], "phispy.{sample}.log")
    shell:
        """
        PhiSpy.py -o {params} "{input}"
        """
    
rule long_phispy:
    input:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff")
    output:
        os.path.join(dir_bakta_long, "{sample}_prophages", "phispy.log")
    params:
        os.path.join(dir_bakta_long, "{sample}_prophages")
    conda:
        os.path.join(dir_env, "phispy.yaml")
    log:
        os.path.join(dir["log"], "phispy-long.{sample}.log")
    shell:
        """
        PhiSpy.py -o {params} {input}
        """