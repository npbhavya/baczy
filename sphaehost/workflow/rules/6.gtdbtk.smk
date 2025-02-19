rule gtdbtk_long:
    input:
        fi= os.path.join(dir_hybracter, "checkm2", "quality_report.tsv")
    output:
        summary=os.path.join(dir_hybracter, "classify", "gtdbtk.bac120.summary.tsv"),
    params:
        files = os.path.join(dir_hybracter),
        db= os.path.join(databaseDir, "gtdbtk-2.2.3", "db"),
        container="docker://ecogenomic/gtdbtk:2.1.1", 
    threads: 32
    shell:
        """
        apptainer pull -F {params.container}

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk identify --genome_dir /data/hybracter.out/final_assemblies --cpus {threads} --out_dir /data -x fasta

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk align --identify_dir /data --out_dir /data --cpus {threads} 
        
        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk classify --genome_dir /data/hybracter.out/final_assemblies --out_dir /data --cpus {threads} -x fasta -f --align_dir /data
        """

rule gtdbtk_tree_long:
    input:
        summary=os.path.join(dir_hybracter, "classify", "gtdbtk.bac120.summary.tsv")
    output:
        tree=os.path.join(dir_hybracter, "de_novo_output", "gtdbtk.bac120.decorated.tree"),
        tree_table=os.path.join(dir_hybracter, "de_novo_output", "gtdbtk.bac120.tree.table"),
    params:
        files = os.path.join(dir_hybracter),
        outgroup = config["gtdbtk"]["outgroup"],
        db= os.path.join(databaseDir, "gtdbtk-2.2.3", "db"),
        taxa_filter = config["gtdbtk"]["taxa_filter"],
        container="docker://ecogenomic/gtdbtk:2.1.1", 
    threads: 32
    shell:
        """
        if [[ -s {params.files}/align/gtdbtk.bac120.msa.fasta.gz ]] ; then
            apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
                gtdbtk de_novo_wf --genome_dir /data/processed_assemblies --outgroup_taxon {params.outgroup} \
                --bacteria --taxa_filter {params.taxa_filter} --out_dir /data -x fa --cpus {threads}
        else
            touch {output.tree}
            touch {output.tree_table}
        fi
        """

rule gtdbtk_short:
    input:
        fi= os.path.join(dir_megahit, "checkm2", "quality_report.tsv")
    output:
        summary=os.path.join(dir_megahit, "classify", "gtdbtk.bac120.summary.tsv")
    params:
        files = os.path.join(dir_megahit),
        db= os.path.join(databaseDir, "gtdbtk-2.2.3", "db"),
        outgroup = config["gtdbtk"]["outgroup"],
        taxa_filter = config["gtdbtk"]["taxa_filter"],
        container="docker://ecogenomic/gtdbtk:2.1.1", 
    threads: 32
    shell:
        """
        apptainer pull -F {params.container}

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk identify --genome_dir /data/processed_assemblies --cpus {threads} --out_dir /data -x fa

        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk align --identify_dir /data --out_dir /data --cpus {threads} 
        
        apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
            gtdbtk classify --genome_dir /data/processed_assemblies --out_dir /data --cpus {threads}  -x fa  -f --align_dir /data
        """

rule gtdbtk_tree_short:
    input:
        summary=os.path.join(dir_megahit, "classify", "gtdbtk.bac120.summary.tsv")
    output:
        tree=os.path.join(dir_megahit, "de_novo_output", "gtdbtk.bac120.decorated.tree"),
        tree_table=os.path.join(dir_megahit, "de_novo_output", "gtdbtk.bac120.tree.table"),
    params:
        files = os.path.join(dir_megahit),
        db= os.path.join(databaseDir, "gtdbtk-2.2.3", "db"),
        outgroup = config["gtdbtk"]["outgroup"],
        taxa_filter = config["gtdbtk"]["taxa_filter"],
        container="docker://ecogenomic/gtdbtk:2.1.1", 
    threads: 32
    shell:
        """
        if [[ -s {params.files}/align/gtdbtk.bac120.msa.fasta.gz ]] ; then
            apptainer exec -B {params.files}:/data,{params.db}:/refdata gtdbtk_2.1.1.sif \
                gtdbtk de_novo_wf --genome_dir /data/processed_assemblies --outgroup_taxon {params.outgroup} \
                --bacteria --taxa_filter {params.taxa_filter} --out_dir /data -x fa --cpus {threads}
        else
            touch {output.tree}
            touch {output.tree_table}
        fi
        """