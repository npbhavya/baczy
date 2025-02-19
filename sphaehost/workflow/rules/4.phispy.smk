rule phispy_short:
    input:
        os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.gbff")
    output:
        log = os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_phispy.log"),
        pp_coord = os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"),
        pp_gbff = os.path.join(dir_bakta_short, "{sample}_prophages", "{sample}_prophage_{sample}.gbff")
    params:
        out = os.path.join(dir_bakta_short, "{sample}_prophages"),
        s = "{sample}_prophage"
    conda:
        os.path.join(dir_env, "phispy.yaml")
    log:
        os.path.join(dir["log"], "phispy.{sample}.log")
    shell:
        """
        if PhiSpy.py -o {params.out} -p {params.s} {input} 2>{log} ; then
            touch {output.log}
            touch {output.pp_coord}
            touch {output.pp_gbff}
        else
            touch {output.log}
            touch {output.pp_coord}
            touch {output.pp_gbff}
        fi
        """
    
rule long_phispy:
    input:
        os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.gbff")
    output:
        log = os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_phispy.log"),
        pp_coord = os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_prophage_coordinates.tsv"),
        pp_gbff = os.path.join(dir_bakta_long, "{sample}_prophages", "{sample}_prophage_{sample}.gbff")
    params:
        out = os.path.join(dir_bakta_long, "{sample}_prophages"),
        s = "{sample}_prophage"
    conda:
        os.path.join(dir_env, "phispy.yaml")
    log:
        os.path.join(dir["log"], "phispy-long.{sample}.log")
    shell:
        """
        if PhiSpy.py -o {params.out} -p {params.s} {input} 2>{log} ; then
            touch {output}
        else
            touch {output}
        fi
        """