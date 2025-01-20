rule capsule_long:
    input:
        fasta=os.path.join(dir_hybracter, "hybracter.out", "final_assemblies", "{sample}_final.fasta"),
        faa = os.path.join(dir_bakta_long, "{sample}_bakta", "{sample}.faa"),
    output:
        os.path.join(dir_bakta_long, "{sample}_capsule", "macsyfinder.log"),
    params:
        indir= os.path.join(dir_hybracter, "hybracter.out", "final_assemblies"),
        capsule = os.path.join(dir_bakta_short, "{sample}_capsule"),
        db= os.path.join(databaseDir, "capsuledb"),
        smp = "{sample}",
        container ="docker://biocontainers/macsyfinder:v1.0.5-2-deb_cv1",
    shell:
        """
        apptainer pull -F {params.container}
        rm -rf {params.capsule}
        mkdir -p {params.capsule}
        apptainer exec -B {params.capsule}:/output,{params.db}:/capsuledb,{params.indir}:/input macsyfinder_v1.0.5-2-deb_cv1.sif macsyfinder \
            --sequence-db /input/{params.smp}_final.fasta --db-type ordered_replicon -p /capsuledb/CapsuleFinder_profiles \
            -d /capsuledb/CapsuleFinder_models/Diderm_bacteria  \
            -o /output all
    
        touch {output}
        rm -rf {input.fasta}.idx
        rm -rf {input.fasta}.phr
        rm -rf {input.fasta}.pin
        rm -rf {input.fasta}.pog
        rm -rf {input.fasta}.psd
        rm -rf {input.fasta}.psi
        rm -rf {input.fasta}.psq
        """
    
rule capsule_short:
    input:
        fasta=os.path.join(dir_megahit, "processed_assemblies", "{sample}_contigs.fa"),
        faa = os.path.join(dir_bakta_short, "{sample}_bakta", "{sample}.faa"),
    output:
        os.path.join(dir_bakta_short, "{sample}_capsule", "macsyfinder.log"),
    params:
        indir= os.path.join(dir_megahit, "processed_assemblies"),
        capsule = os.path.join(dir_bakta_short, "{sample}_capsule"),
        db= os.path.join(databaseDir, "capsuledb"),
        smp = "{sample}",
        container ="docker://biocontainers/macsyfinder:v1.0.5-2-deb_cv1",
    shell:
        """
        apptainer pull -F {params.container}
        rm -rf {params.capsule}
        mkdir -p {params.capsule}
        apptainer exec -B {params.capsule}:/output,{params.db}:/capsuledb,{params.indir}:/input macsyfinder_v1.0.5-2-deb_cv1.sif macsyfinder \
            --sequence-db /input/{params.smp}_contigs.fa --db-type ordered_replicon -p /capsuledb/CapsuleFinder_profiles \
            -d /capsuledb/CapsuleFinder_models/Diderm_bacteria  \
            -o /output all
    
        touch {output}
        rm -rf {input.fasta}.idx
        rm -rf {input.fasta}.phr
        rm -rf {input.fasta}.pin
        rm -rf {input.fasta}.pog
        rm -rf {input.fasta}.psd
        rm -rf {input.fasta}.psi
        rm -rf {input.fasta}.psq
        """
    
