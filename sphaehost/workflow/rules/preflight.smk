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
dir ={}
# output dir
if 'sphaehost' in config and 'args' in config['sphaehost']:
    # Check if 'output' is None
    if config['sphaehost']['args']['output'] is None:
        dir_out = os.path.join('sphaehost.out')
    else:
        dir_out = config['sphaehost']['args']['output']
else:
    dir_out = os.path.join('sphaehost.out')

# Load the YAML file
config_path = os.path.join(dir_out, 'config.yaml')
with open(config_path, 'r') as yaml_file:
    config_data = yaml.safe_load(yaml_file)

# Access the value of _input from the loaded YAML data
input_dir = config_data.get('sphaehost', {}).get('args', {}).get('_input')
# List of file paths matching the pattern
file_paths = glob.glob(os.path.join(input_dir, '*1.fastq'))
sample_names = [file_path.split('/')[-1].rsplit('_1', 1)[0] for file_path in file_paths]

if len(sample_names) == 0:
	sys.stderr.write(f"We did not find any fastq files in {sample_names}. Is this the right read dir?\n")
	sys.exit(0)

print(f"Samples are {sample_names}")

# Set default database directory
default_db_dir = os.path.join(workflow.basedir, 'databases')

# Check if 'args' and 'db_dir' exist in config
if 'args' in config and 'db_dir' in config['args']:
    # Check if 'db_dir' is None
    if config['args']['db_dir'] is None:
        dir_db = default_db_dir
    else:
        dir_db = config['args']['db_dir']
else:
    dir_db = default_db_dir

# Set default temporary directory
default_temp_dir = os.path.join(dir_out, "temp")

# Check if 'args' and 'temp_dir' exist in config
if 'args' in config and 'temp_dir' in config['args']:
    # Check if 'temp_dir' is None
    if config['args']['temp_dir'] is None:
        dir_temp = default_temp_dir
    else:
        dir_temp = config['args']['temp_dir']
else:
    dir_temp = default_temp_dir

dir_env = os.path.join(workflow.basedir, "envs")

dir_fastp = os.path.join(dir_out, 'PROCESSING', 'fastp')
dir_megahit = os.path.join(dir_out, 'PROCESSING', 'megahit')

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
    sys.stderr.write('\n\nPhanSphaehost run failed\n\n')
