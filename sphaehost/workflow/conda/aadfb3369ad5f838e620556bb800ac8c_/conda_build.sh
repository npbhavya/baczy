if [ -z ${CONDA_BUILD+x} ]; then
    source /opt/conda/conda-bld/circos_1679355325018/work/build_env_setup.sh
fi
#!/bin/bash

cp -r . $PREFIX
