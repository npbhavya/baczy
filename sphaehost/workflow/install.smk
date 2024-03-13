"""Parse config"""
configfile: os.path.join(workflow.basedir, "..", "config", "config.yaml")

dir ={}
# output dir
try:
    if config['output'] is None:
        dir_out = os.path.join('sphaehost.out')
    else:
        dir_out = config['sphaehost']['args']['output']
except KeyError:
    dir_out = os.path.join('sphaehost.out')

"""Check if database path exists"""
try:
    if config['db_dir'] is None:
        databaseDir = os.path.join('databases')
    else:
        databaseDir = config['db_dir']
except KeyError:
    databaseDir = os.path.join(dir_out, 'databases')

default_temp_dir = os.path.join(dir_out, "temp")
dir_env = os.path.join(workflow.basedir, "envs")


"""Targets"""
#intiating targets, since they havent been defined yet"
targets = type('', (), {})()

targets.db = []
targets.db.append(os.path.join(databaseDir, 'db-light', 'version.json'))
targets.db.append(os.path.join(databaseDir, 'hybracterDB', 'plsdb_2023_11_03_v2.msh'))


"""RUN SNAKEMAKE"""
rule all:
    input:
        targets.db

"""RULES"""
rule bakta_download:
    params:
        os.path.join(databaseDir)
    output:
        os.path.join(databaseDir, 'db-light', 'version.json')
    conda:
        os.path.join(dir_env, "bakta.yaml")
    shell:
        """
            bakta_db download --type light --output {params} 
        """

rule hybracter_download:
    params:
        db = os.path.join("hybracterDB"),
        tmp = os.path.join(default_temp_dir),
        mvd = os.path.join(databaseDir, "hybracterDB")
    output:
        os.path.join(databaseDir,'hybracterDB', 'plsdb_2023_11_03_v2.msh')
    conda:
        os.path.join(dir_env, "hybracter.yaml")
    shell:
        """
            hybracter install -o {params.tmp} -d {params.db}
            mv {params.db} {params.mvd}
        """