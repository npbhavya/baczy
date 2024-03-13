#quality control rules here
rule fastp_short:
    input:
        r1 = os.path.join(input_dir, "{sample}_1.fastq"),
        r2 = os.path.join(input_dir, "{sample}_2.fastq")
    output:
        r1 = os.path.join(dir_fastp_short,"{sample}_R1.fastq.gz"),
        r2 = os.path.join(dir_fastp_short,"{sample}_R2.fastq.gz"),
        stats = os.path.join(dir_fastp_short,"{sample}.stats.json"),
        html = os.path.join(dir_fastp_short,"{sample}.stats.html")
    conda:
        os.path.join(dir_env, "fastp.yaml")
    log:
        os.path.join(dir["log"],"fastp.{sample}.log")
    threads: 16
    shell:
        """
        fastp -i {input.r1} -I {input.r2} -o {output.r1} -O {output.r2} -j {output.stats} -h {output.html} 2>{log}
        """