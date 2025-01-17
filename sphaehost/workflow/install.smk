import yaml
import os
import glob

"""
Parse config
"""
configfile: os.path.join(workflow.basedir, "..", "config", "config.yaml")

"""
DIRECTORIES
"""
dir = {}
dir_env = os.path.join(workflow.basedir, "envs")

try:
    if config['db_dir'] is None:
        databaseDir = os.path.join(workflow.basedir, 'databases')
    else:
        databaseDir = config['db_dir']
except KeyError:
    databaseDir = os.path.join(workflow.basedir, 'databases')

"""Targets"""
targets = type('', (), {})()
targets.db = []

targets.db.append(os.path.join(databaseDir, "gtdbtk", "release220", "metadata", "metadata.txt"))
targets.db.append(os.path.join(databaseDir, "CheckM2_database", "uniref100.KO.1.dmnd"))

"""RUN SNAKEMAKE"""
rule all:
    input:
        targets.db

rule gtdbtk_db:
    params:
        link="https://data.ace.uq.edu.au/public/gtdb/data/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz",
        file2=os.path.join(databaseDir, "gtdbtk", "gtdbtk_data.tar.gz")
    output:
        os.path.join(databaseDir, "gtdbtk", "release220", "metadata", "metadata.txt")
    shell:
        """
        curl -Lo {params.file2} {params.link}
        tar -xvzf {params.file2}
        """

rule checkm_db:
    params:
        db=os.path.join(databaseDir),
    output:
        os.path.join(databaseDir, "CheckM2_database", "uniref100.KO.1.dmnd")
    conda:
       os.path.join(dir_env, "checkm2.yaml")
    shell:
        """
        checkm2 database --download --path {params.db}
        """