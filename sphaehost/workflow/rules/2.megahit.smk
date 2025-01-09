#assembly rules here 
rule megahit:
    """Assemble short reads with MEGAHIT"""
    input:
        r1 = os.path.join(dir_fastp_short,"{sample}_R1.fastq.gz"),
        r2 = os.path.join(dir_fastp_short,"{sample}_R2.fastq.gz")
    output:
        contigs = os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa"),
        log = os.path.join(dir_megahit, "{sample}-pr", "log")
    params:
        os.path.join(dir_megahit, "{sample}-pr")
    container:
        "docker://biocontainers/megahit:1.2.9_cv1"
    log:
        os.path.join(dir["log"], "megahit.{sample}.log")
    threads: 32
    resources:
        mem_mb=64000,
        time= 480
    shell:
        """
        if megahit \
            -1 {input.r1} \
            -2 {input.r2} \
            -o {params} \
            -t {threads} -f \
            2> {log}; then
                touch {output.contigs}
                touch {output.log}
            else
                touch {output.contigs}
                touch {output.log}
        fi
        """


rule fastg:
    """Save the MEGAHIT graph"""
    input:
        os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa")
    output:
        fastg=os.path.join(dir_megahit, "{sample}-pr", "final.fastg"),
        graph=os.path.join(dir_megahit, "{sample}-pr", "final.gfa")
    container:
        "docker://biocontainers/megahit:1.2.9_cv1"
    log:
        os.path.join(dir["log"], "fastg.{sample}.log")
    shell:
        """
        if [[ -s {input.fastg} ]] ; then
            kmer=$(head -1 {input.fastg} | sed 's/>//' | sed 's/_.*//')
            megahit_toolkit contig2fastg $kmer {input.fastg} > {output.fastg} 2>{log}
            Bandage reduce {output.fastg} {output.graph} 2>>{log}
            touch {output.fastg}
            touch {output.graph}
        else
            touch {output.fastg}
            touch {output.graph}
        fi
        """