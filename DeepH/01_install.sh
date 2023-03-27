#! /bin/bash

# this script can help you install deepH quickly
#----------------------------------------------
anaconda_path="${HOME}/anaconda3"
py_version="3.9"
root_deepH="${HOME}/app"
deepH_git_address="git@github.com:PhysAIzhijiang/DeepH-dev.git"
deepH_name="deepH"
deepH_branch="main-ZJlab"
##############################################

RED='\033[0;31m'
Green='\033[0;32m'
NC='\033[0m' # No Color

if ! [ -x "$(command -v conda)" ]; then
    echo -e  "${RED}info${NC}: conda not found."
    exit 
fi

echo "========================================"
info="ini enviroment"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
source ${anaconda_path}/etc/profile.d/conda.sh

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi


echo "========================================"
info="create enviroment"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
conda create -n deeph python=$py_version -y

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

echo "========================================"
info="activate enviroment"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
conda activate deeph

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi


# echo "========================================"
# info="install numpy dependency with conda"
# echo -e "${Green}info${NC}: waiting to ${info}..."
# echo "----------------------------------------"
# if (( $(echo "$py_version < 3.9" |bc -l) )); then
#     conda install -y numpy
# else
#     conda install -y numpy
# fi

# if [ $? -eq 0 ]; then
#     echo -e "${Green}info${NC}: ${info} successfully"
# else
#     echo -e  "${RED}info${NC}: ${info} Un-successfully"
#     exit 
# fi

echo "========================================"
info="install torch with conda"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"

# get cuda version
# if ! [ -x "$(command -v nvidia-smi)" ]; then
#     echo -e "${Green}info${NC}: nvidia-smi is not installed. torch with CPU only will be installed."
#     conda install -y pytorch==1.9.1 torchvision==0.10.1 torchaudio==0.9.1 cpuonly -c pytorch
# else 
#     v_cuda=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}')
#     if (( $(echo "$v_cuda > 11" |bc -l) )); then
#         echo -e "${Green}info${NC}: nvidia-smi 11 is installed. torch with CUDA 11 will be installed."

#         conda install -y pytorch==1.9.1 torchvision==0.10.1 torchaudio==0.9.1 cudatoolkit=11.3 -c pytorch -c conda-forge
#     else
#         echo -e "${Green}info${NC}: nvidia-smi 10 is installed. torch with CUDA 10 will be installed."

#         conda install -y pytorch==1.9.1 torchvision==0.10.1 torchaudio==0.9.1 cudatoolkit=10.2 -c pytorch
#     fi
# fi


# get cuda version
if ! [ -x "$(command -v nvidia-smi)" ]; then
    echo -e "${Green}info${NC}: nvidia-smi is not installed. torch with CPU only will be installed."

    pip install torch==1.9.1+cpu # -f https://download.pytorch.org/whl/torch_stable.html
else 
    v_cuda=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}')
    if (( $(echo "$v_cuda > 11" |bc -l) )); then
        echo -e "${Green}info${NC}: nvidia-smi 11 is installed. torch with CUDA 11 will be installed."

        pip install torch==1.9.1+cu111 # -f https://download.pytorch.org/whl/torch_stable.html
    else
        echo -e "${Green}info${NC}: nvidia-smi 10 is installed. torch with CUDA 10 will be installed."

        pip install torch==1.9.1+cu102 # -f https://download.pytorch.org/whl/torch_stable.html
    fi
fi

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"

    info="install torch from sjtu"
    echo -e "${Green}info${NC}: waiting to ${info}..."
    echo "----------------------------------------"
    # get cuda version
    if ! [ -x "$(command -v nvidia-smi)" ]; then
        echo -e "${Green}info${NC}: nvidia-smi is not installed. torch with CPU only will be installed."

        pip install torchvision==0.10.1+cpu torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html

    else 
        v_cuda=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}')
        if (( $(echo "$v_cuda > 11" |bc -l) )); then
            echo -e "${Green}info${NC}: nvidia-smi 11 is installed. torch with CUDA 11 will be installed."

            pip install torch==1.9.1+cu111 -f https://mirror.sjtu.edu.cn/pytorch-wheels/cu111/?mirror_intel_list

        else
            echo -e "${Green}info${NC}: nvidia-smi 10 is installed. torch with CUDA 10 will be installed."

            pip install torch==1.9.1+cu102 -f https://mirror.sjtu.edu.cn/pytorch-wheels/cu102/?mirror_intel_list

        fi
    fi
fi

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

info="install torch-others from pytorch.org"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
# get cuda version
if ! [ -x "$(command -v nvidia-smi)" ]; then
    echo -e "${Green}info${NC}: nvidia-smi is not installed. torch with CPU only will be installed."

    pip install torchvision==0.10.1+cpu torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html

else 
    v_cuda=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}')
    if (( $(echo "$v_cuda > 11" |bc -l) )); then
        echo -e "${Green}info${NC}: nvidia-smi 11 is installed. torch with CUDA 11 will be installed."

        pip install torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
    else
        echo -e "${Green}info${NC}: nvidia-smi 10 is installed. torch with CUDA 10 will be installed."

        pip install torchvision==0.10.1+cu102 torchaudio==0.9.0  -f https://download.pytorch.org/whl/torch_stable.html
    fi
fi

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi



echo "========================================"
info="install torch-geometric with conda"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
# the version of package should be checked from https://data.pyg.org/whl/torch-${TORCH}.html

TORCH=$(python -c "import torch; print(torch.__version__)")

pip install torch_scatter==2.0.9 torch_sparse==0.6.12 torch_cluster==1.5.9 torch_spline_conv==1.2.1 -f https://data.pyg.org/whl/torch-${TORCH}.html
pip install torch-geometric==1.7.2 -f https://data.pyg.org/whl/torch-${TORCH}.html

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

# echo "========================================"
# info="install torch-geometric with pip"
# echo -e "${Green}info${NC}: waiting to ${info}..."
# echo "----------------------------------------"
# if ! [ -x "$(command -v nvidia-smi)" ]; then
#     echo -e "${Green}info${NC}: nvidia-smi is not installed. torch with CPU only will be installed."

#     pip install torch-geometric==1.7.2+cpu -f https://pytorch-geometric.com/whl/torch-1.9.1%2Bcpu.html

# else 
#     v_cuda=$(nvidia-smi | grep "CUDA Version" | awk '{print $9}')
#     if (( $(echo "$v_cuda > 11" |bc -l) )); then
#         echo -e "${Green}info${NC}: nvidia-smi 11 is installed. torch with CUDA 11 will be installed."

#         pip install torch-geometric==1.7.2 -f https://pytorch-geometric.com/whl/torch-1.9.1%2Bcu111.html

#     else
#         echo -e "${Green}info${NC}: nvidia-smi 10 is installed. torch with CUDA 10 will be installed."

#         pip install torch-geometric==1.7.2+cu102 -f https://pytorch-geometric.com/whl/torch-1.9.0%2Bcu111.html
#     fi
# fi


echo "========================================"
info="install pymatgen dependency with conda"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
if (( $(echo "$py_version < 3.9" |bc -l) )); then
    # conda install -y pymatgen==2020.8.3 -c conda-forge
    pip install pymatgen==2020.8.3
else
    # conda install -y pymatgen -c conda-forge
    pip install pymatgen
fi

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi


echo "========================================"
info="install dependency using torch with pip"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
# pip install e3nn==0.3.5 h5py tensorboard pathos psutil
# pip install e3nn h5py tensorboard pathos psutil
# conda install -c conda-forge e3nn h5py tensorboard pathos psutil
# This is not nessasury, pip install deeph will install them

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

echo "========================================"
info="downgrade setuptools to 59.5.0"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
pip install setuptools==59.5.0

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

echo "========================================"
info="git clone deepH"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
pushd $root_deepH
git clone "$deepH_git_address" "$deepH_name"
if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

echo "========================================"
info="checkout deepH branch"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
pushd "$deepH_name"
git checkout "origin/${deepH_branch}"
git checkout -b "${deepH_branch}"
git branch --set-upstream-to=origin/${deepH_branch} ${deepH_branch}

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

echo "========================================"
info="compile deepH"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"
if (( $(echo "$py_version < 3.9" |bc -l) )); then
    sed -i "s/python_requires=\">=3.9\",/python_requires=\">=3.8\",/g" setup.py
fi
pip install . 

if [ $? -eq 0 ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi

echo "========================================"
info="install deepH"
echo -e "${Green}info${NC}: waiting to ${info}..."
echo "----------------------------------------"

if [ -x "$(command -v deeph-preprocess)" ]; then
    echo -e "${Green}info${NC}: ${info} successfully"
else
    echo -e  "${RED}info${NC}: ${info} Un-successfully"
    exit 
fi