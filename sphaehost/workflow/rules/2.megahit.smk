#assembly rules here 
import glob

SAMPLES = [os.path.splitext(os.path.basename(file_path))[0].rsplit('_R1', 1)[0] for file_path in file_paths]


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

rule preprocess_assembly:
    """Preprocess and copy contig files to a new directory for CheckM2 input."""
    input:
        contigs=os.path.join(dir_megahit, "{sample}-pr", "final.contigs.fa")  # Contig files for each sample
    params:
        dirs=os.path.join(dir_megahit, "processed_assemblies")  # New directory for preprocessed files
    output:
        contig_copy=os.path.join(dir_megahit, "processed_assemblies", "{sample}_contigs.fa")  # New directory for preprocessed files
    shell:
        """
        if [[ -d {params.dirs} ]]; then
            mkdir -p {params.dirs}
            cp {input.contigs} {output.contig_copy}
        else
            cp {input.contigs} {output.contig_copy}
        fi
        """

rule checkm2_short:
    """Run CheckM2 to assess the quality of the assemblies."""
    input:
        fasta = expand(os.path.join(dir_megahit, "processed_assemblies", "{sample}_contigs.fa"), sample=SAMPLES)  # Use the preprocessed contig files
    output:
        report = os.path.join(dir_megahit, "checkm2", "quality_report.tsv")  # CheckM2 quality report
    params:
        out=os.path.join(dir_megahit, "checkm2"),  # Output directory for CheckM2 results
        db=os.path.join(databaseDir),
        container=os.path.join(databaseDir, "..", "envs", "checkm2_1.0.2.sif"),
        fin=os.path.join(dir_megahit, "processed_assemblies")
    threads: 32
    shell:
        """
        apptainer exec -B {params.fin}:/data,{params.out}:/out,{params.db}:/database {params.container} \
            checkm2 predict -t {threads} -x fa -i /data -o /out --database_path /database/CheckM2_database/uniref100.KO.1.dmnd --force
        """
