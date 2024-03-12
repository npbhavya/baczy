"""Parse config"""
configfile: os.path.join(workflow.basedir, "..", "config", "config.yaml")

"""Check if database path exists"""
try:
    if config['db_dir'] is None:
        databaseDir = os.path.join('databases')
    else:
        databaseDir = config['db_dir']
except KeyError:
    databaseDir = os.path.join('databases')


"""Targets"""
#intiating targets, since they havent been defined yet"
targets = type('', (), {})()

targets.db = []
targets.db.append(os.path.join(databaseDir, 'db-light', 'version.json'))

"""RUN SNAKEMAKE"""
rule all:
    input:
        targets.db

"""RULES"""
rule bakta_download:
    params:
        os.path.join(os.path.join(databaseDir))
    output:
        os.path.join(databaseDir, 'db-light', 'version.json')
    conda:
        os.path.join('envs', "bakta.yaml")
    shell:
        """
            bakta_db download --type light --output {params} 
        """