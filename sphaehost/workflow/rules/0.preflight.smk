import glob
from metasnek import fastq_finder
import os 
import yaml

############################################################################
# Checking through the input folder
############################################################################
"""DIRECTORIES/FILES etc.
Declare some directories for pipeline intermediates and outputs.
"""
configfile: os.path.join(workflow.basedir, "..", "config", "config.yaml")

dir ={}
# output dir
try:
    if config['sphaehost']['args']['output'] is None:
        dir_out = os.path.join('sphaehost.out')
    else:
        dir_out = config['sphaehost']['args']['output']
except KeyError:
    dir_out = os.path.join('sphaehost.out')

# Load the YAML file
config_path = os.path.join(config['sphaehost']['args']['output'], 'config.yaml')

with open(config_path, 'r') as yaml_file:
    config_data = yaml.safe_load(yaml_file)

# Access the value of _input from the loaded YAML data
input_dir = config_data.get('sphaehost', {}).get('args', {}).get('_input')

# List of file paths matching the pattern
if config['sphaehost']['args']['sequencing'] == 'paired':
    file_paths = glob.glob(os.path.join(input_dir, '*_R1*.fastq*'))
    sample_names = [os.path.splitext(os.path.basename(file_path))[0].rsplit('_R1', 1)[0] for file_path in file_paths]
    extn = [os.path.splitext(os.path.basename(file_path))[0].rsplit('_R1', 1)[1] + os.path.splitext(os.path.basename(file_path))[1] for file_path in file_paths]
elif config['sphaehost']['args']['sequencing'] == 'longread':
    file_paths = glob.glob(os.path.join(input_dir, '*.fastq*'))
    sample_names, extn = zip(*(
    (
        os.path.basename(file_path).rsplit('.', maxsplit=2)[0],  # Split by the last two dots for extensions like `.fastq.gz`
        '.' + '.'.join(os.path.basename(file_path).rsplit('.', maxsplit=2)[1:])
    )
    if file_path.endswith(('.fastq.gz', '.fq.gz')) else
    (
        os.path.splitext(os.path.basename(file_path))[0],  # Regular split for single-extension files like `.fastq`
        os.path.splitext(os.path.basename(file_path))[1]
    )
    for file_path in file_paths
    ))

    
print(f"Samples are {sample_names}")
print(f"Extensions are {extn}")

try:
    if config['db_dir'] is None:
        databaseDir = os.path.join(workflow.basedir, 'databases')
    else:
        databaseDir = config['db_dir']
except KeyError:
    databaseDir = os.path.join(workflow.basedir, 'databases')


if len(sample_names) == 0:
	sys.stderr.write(f"We did not find any fastq files in {sample_names}. Is this the right read dir?\n")
	sys.exit(0)

unique_strings = set(extn)
if len(unique_strings)>2:
    print ("There are multiple extensions, pick one")
    sys.exit(0)


FQEXTN = extn[0]
PATTERN_R1 = '{sample}_R1' + FQEXTN
PATTERN_R2 = '{sample}_R2' + FQEXTN



# Set default database directory
default_db_dir = os.path.join(workflow.basedir, 'databases')

# Set default temporary directory
default_temp_dir = os.path.join(dir_out, "temp")

dir_env = os.path.join(workflow.basedir, "envs")
dir_script = os.path.join(workflow.basedir, "scripts")

dir_fastp_short = os.path.join(dir_out, 'PROCESSING', 'fastp-short')
dir_megahit = os.path.join(dir_out, 'PROCESSING', 'megahit')
dir_bakta_short = os.path.join(dir_out, 'PROCESSING','bakta-short')
dir_summary_short = os.path.join(dir_out, 'RESULTS-short')
dir_panaroo_short = os.path.join(dir_out, 'RESULTS-short', 'panaroo')

#long reads
dir_hybracter = os.path.join(dir_out, 'PROCESSING', 'hybracter')
dir_bakta_long = os.path.join(dir_out, 'PROCESSING','bakta-long')
dir_summary_long = os.path.join(dir_out, 'RESULTS-long')
dir_panaroo_long = os.path.join(dir_out, 'RESULTS-long', 'panaroo')

"""ONSTART/END/ERROR
Tasks to perform at various stages the start and end of a run.
"""
def copy_log_file():
    files = glob.glob(os.path.join(".snakemake", "log", "*.snakemake.log"))
    if not files:
        return None
    current_log = max(files, key=os.path.getmtime)
    target_log = os.path.join(dir['log'], os.path.basename(current_log))
    shutil.copy(current_log, target_log)

dir = {'log': os.path.join(dir_out, 'logs')}
onstart:
    """Cleanup old log files before starting"""
    if os.path.isdir(dir["log"]):
        oldLogs = filter(re.compile(r'.*.log').match, os.listdir(dir["log"]))
        for logfile in oldLogs:
            os.unlink(os.path.join(dir["log"], logfile))
onsuccess:
    """Print a success message"""
    sys.stderr.write('\n\nSphaehost ran successfully!\n\n')
onerror:
    """Print an error message"""
    sys.stderr.write('\n\nSphaehost run failed\n\n')
