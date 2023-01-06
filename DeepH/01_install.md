# DeepH编译使用指南

deepH : https://deeph-pack.readthedocs.io/

---

## 系统环境
本指南以qlab服务器环境进行编译为例子.

### 服务器加载环境
使用`module load`指令.

#### install
    ​``` bash
    $ module load conda/miniconda
    ​``` 


### 具体版本
- CPU: Intel Xeon Processor (Skylake, IBRS)

    ``` bash
    cat /proc/cpuinfo | grep 'model name' |uniq;
    model name	: Intel Xeon Processor (Skylake, IBRS)
    ```

- 系统版本: CentOS 7

    ``` bash
    $ cat /etc/os-release
    ```

    ``` bash
    NAME="CentOS Linux"
    VERSION="7 (Core)"
    ID="centos"
    ID_LIKE="rhel fedora"
    VERSION_ID="7"
    PRETTY_NAME="CentOS Linux 7 (Core)"
    ANSI_COLOR="0;31"
    CPE_NAME="cpe:/o:centos:centos:7"
    HOME_URL="https://www.centos.org/"
    BUG_REPORT_URL="https://bugs.centos.org/"

    CENTOS_MANTISBT_PROJECT="CentOS-7"
    CENTOS_MANTISBT_PROJECT_VERSION="7"
    REDHAT_SUPPORT_PRODUCT="centos"
    REDHAT_SUPPORT_PRODUCT_VERSION="7"
    ```

- conda版本: 

    ``` bash
    $ conda -V
    conda 4.12.0
    ```

    建议使用清华源: https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/

## 依赖关系
Prepare the Python 3.9 interpreter. Install the following Python packages required:
- NumPy
- SciPy
- PyTorch = 1.9.1
- PyTorch Geometric = 1.7.2
- e3nn = 0.3.5
- pymatgen
- h5py
- TensorBoard
- pathos
- psutil



## 编译
这里我们选取用conda安装的方式, 其他安装方式请参考官方网站.

- 创建conda环境

    ``` bash
    conda create -n deeph python=3.9
    ```
- 激活环境

    ```
    conda activate deeph
    ```


- 安装deeph依赖包
    - 安装数学相关
    ```
    (deeph) $ conda install numpy scipy 
    ```
    - 安装pytorch相关
        ```
        (deeph) $ conda install -y numpy scipy 
        (deeph) $ conda install -y pytorch==1.9.1 torchvision==0.10.1 torchaudio==0.9.1 cpuonly -c pytorch
        (deeph) $ conda install -y pytorch-geometric=1.7.2 -c rusty1s -c conda-forge
        (deeph) $ conda install -y pymatgen -c conda-forge
        ```

        这里要注意, 安装`pytorch`过程可能会报错.
        ``` bash
        Collecting package metadata (current_repodata.json): done
        Solving environment: failed with initial frozen solve. Retrying with flexible solve.
        Collecting package metadata (repodata.json):
        ```
        继续等`Collecting package metadata (repodata.json)`检索完, 会解决环境问题, 完成安装.

        目前是什么原因未知.
    
    - 错误
      - `module 'distutils' has no attribute 'version'`
        ``` bash
            $ pip install setuptools==59.5.0
        ```


- 安装deepH
    - 下载源码:
        ``` bash
        $ cd xxx/apps;
        $ mkdir deeph;
        $ cd deeph
        $ git clone https://github.com/mzjb/DeepH-pack.git
        $ version=$(cd DeepH-pack; git log -n1 --format="%h")
        $ echo "The last commit is $version"
        $ mv DeepH-pack $version;
        ```

        目前(2022.11)最新版本是`dd44e70`.

    - 安装

        ``` bash
        # 进入到之前安装好的环境, 里面包含了pytorch
        $ conda activate deeph
        # 安装pip
        $ conda list pip
        # 获取env目录
        $ envPath=$(conda info --env | grep ^deeph | awk '{print $3}')
        $ pipPath=$envPath/bin/pip
        # 安装deeph
        $ $pipPath install . 
        # 检查安装
        $ whereis deeph-preprocess
        deeph-preprocess: xxx/conda/envs/deeph/bin/deeph-preprocess
        # 找到了deeph-preprocess执行文件说明安装成功了.
        ```

    ​
- 安装Julia 
    参考[runoob教程](https://www.runoob.com/julia/julia-environment.html)
    我们只需要下载后解压缩在本地就可以

## 环境版本
最后把我安装好后的各个包的版本列出来供参考.
``` bash
(deeph) $ conda list
# packages in environment at xxx/envs/deeph:
#
# Name                    Version                   Build  Channel
_libgcc_mutex             0.1                 conda_forge    conda-forge
_openmp_mutex             4.5                  2_kmp_llvm    conda-forge
absl-py                   1.3.0                    pypi_0    pypi
blas                      1.0                         mkl    defaults
bottleneck                1.3.5            py39h7deecbd_0    defaults
brotli                    1.0.9                h166bdaf_8    conda-forge
brotli-bin                1.0.9                h166bdaf_8    conda-forge
brotlipy                  0.7.0           py39hb9d737c_1004    conda-forge
bzip2                     1.0.8                h7b6447c_0    https://repo.anaconda.com/pkgs/main
ca-certificates           2022.9.24            ha878542_0    conda-forge
cachetools                5.2.0                    pypi_0    pypi
certifi                   2022.9.24          pyhd8ed1ab_0    conda-forge
cffi                      1.15.1           py39h74dc2b5_0    defaults
charset-normalizer        2.1.1              pyhd8ed1ab_0    conda-forge
colorama                  0.4.6              pyhd8ed1ab_0    conda-forge
contourpy                 1.0.6            py39hf939315_0    conda-forge
cpuonly                   2.0                           0    pytorch
cryptography              3.4.8            py39h95dcef6_1    conda-forge
cycler                    0.11.0             pyhd8ed1ab_0    conda-forge
deeph                     0.1.0                    pypi_0    pypi
dill                      0.3.6                    pypi_0    pypi
e3nn                      0.4.4                    pypi_0    pypi
emmet-core                0.38.4             pyhd8ed1ab_0    conda-forge
ffmpeg                    4.3                  hf484d3e_0    pytorch
fftw                      3.3.9                h27cfd23_1    defaults
fonttools                 4.38.0           py39hb9d737c_1    conda-forge
freetype                  2.12.1               h4a9f257_0    defaults
future                    0.18.2             pyhd8ed1ab_6    conda-forge
giflib                    5.2.1                h7b6447c_0    defaults
gmp                       6.2.1                h295c915_3    defaults
gmpy2                     2.1.2            py39h376b7d2_1    conda-forge
gnutls                    3.6.15               he1e5248_0    defaults
google-auth               2.14.1                   pypi_0    pypi
google-auth-oauthlib      0.4.6                    pypi_0    pypi
googledrivedownloader     0.4                pyhd3deb0d_1    conda-forge
grpcio                    1.50.0                   pypi_0    pypi
h5py                      3.7.0                    pypi_0    pypi
idna                      3.4                pyhd8ed1ab_0    conda-forge
importlib-metadata        5.0.0                    pypi_0    pypi
intel-openmp              2021.4.0          h06a4308_3561    defaults
isodate                   0.6.1                    pypi_0    pypi
jinja2                    3.1.2              pyhd8ed1ab_1    conda-forge
joblib                    1.2.0              pyhd8ed1ab_0    conda-forge
jpeg                      9b                   h024ee3a_2    defaults
kiwisolver                1.4.4            py39hf939315_1    conda-forge
lame                      3.100                h7b6447c_0    defaults
latexcodec                2.0.1              pyh9f0ad1d_0    conda-forge
lcms2                     2.12                 h3be6417_0    defaults
ld_impl_linux-64          2.38                 h1181459_1    https://repo.anaconda.com/pkgs/main
libblas                   3.9.0            12_linux64_mkl    conda-forge
libbrotlicommon           1.0.9                h166bdaf_8    conda-forge
libbrotlidec              1.0.9                h166bdaf_8    conda-forge
libbrotlienc              1.0.9                h166bdaf_8    conda-forge
libcblas                  3.9.0            12_linux64_mkl    conda-forge
libffi                    3.3                  he6710b0_2    https://repo.anaconda.com/pkgs/main
libgcc-ng                 12.2.0              h65d4601_19    conda-forge
libgfortran-ng            11.2.0               h00389a5_1    defaults
libgfortran5              11.2.0               h1234567_1    defaults
libiconv                  1.16                 h7f8727e_2    defaults
libidn2                   2.3.2                h7f8727e_0    defaults
liblapack                 3.9.0            12_linux64_mkl    conda-forge
libpng                    1.6.37               hbc83047_0    defaults
libstdcxx-ng              12.2.0              h46fd767_19    conda-forge
libtasn1                  4.16.0               h27cfd23_0    defaults
libtiff                   4.1.0                h2733197_1    defaults
libunistring              0.9.10               h27cfd23_0    defaults
libuuid                   1.41.5               h5eee18b_0    https://repo.anaconda.com/pkgs/main
libuv                     1.40.0               h7b6447c_0    defaults
libwebp                   1.2.0                h89dd481_0    defaults
llvm-openmp               14.0.6               h9e868ea_0    defaults
lz4-c                     1.9.3                h295c915_1    defaults
markdown                  3.4.1                    pypi_0    pypi
markupsafe                2.1.1            py39hb9d737c_1    conda-forge
matplotlib-base           3.6.2            py39hf9fd14e_0    conda-forge
mkl                       2021.4.0           h06a4308_640    defaults
mkl-service               2.4.0            py39h7f8727e_0    defaults
mkl_fft                   1.3.1            py39hd3c417c_0    defaults
mkl_random                1.2.2            py39h51133e4_0    defaults
monty                     2022.9.9           pyhd8ed1ab_0    conda-forge
mp-api                    0.29.5             pyhd8ed1ab_0    conda-forge
mpc                       1.2.1                h9f54685_0    conda-forge
mpfr                      4.1.0                h9202a9a_1    conda-forge
mpmath                    1.2.1              pyhd8ed1ab_0    conda-forge
msgpack-python            1.0.4            py39hf939315_1    conda-forge
multiprocess              0.70.14                  pypi_0    pypi
munkres                   1.1.4              pyh9f0ad1d_0    conda-forge
ncurses                   6.3                  h5eee18b_3    https://repo.anaconda.com/pkgs/main
nettle                    3.7.3                hbbd107a_1    defaults
networkx                  2.8.8              pyhd8ed1ab_0    conda-forge
ninja                     1.10.2               h06a4308_5    defaults
ninja-base                1.10.2               hd09550d_5    defaults
numexpr                   2.8.3            py39h807cd23_0    defaults
numpy                     1.23.4           py39h3d75532_1    conda-forge
oauthlib                  3.2.2                    pypi_0    pypi
openh264                  2.1.1                h4ff587b_0    defaults
openssl                   1.1.1s               h166bdaf_0    conda-forge
opt-einsum                3.3.0                    pypi_0    pypi
opt-einsum-fx             0.1.4                    pypi_0    pypi
packaging                 21.3               pyhd8ed1ab_0    conda-forge
palettable                3.3.0                      py_0    conda-forge
pandas                    1.4.4            py39h6a678d5_0    defaults
pathos                    0.3.0                    pypi_0    pypi
pillow                    9.2.0            py39hace64e9_1    defaults
pip                       22.2.2           py39h06a4308_0    defaults
plotly                    5.11.0             pyhd8ed1ab_0    conda-forge
pox                       0.3.2                    pypi_0    pypi
ppft                      1.7.6.6                  pypi_0    pypi
protobuf                  3.20.3                   pypi_0    pypi
psutil                    5.9.4                    pypi_0    pypi
pyasn1                    0.4.8                    pypi_0    pypi
pyasn1-modules            0.2.8                    pypi_0    pypi
pybtex                    0.24.0             pyhd8ed1ab_2    conda-forge
pycparser                 2.21               pyhd8ed1ab_0    conda-forge
pydantic                  1.10.2           py39hb9d737c_1    conda-forge
pymatgen                  2022.11.7        py39hf939315_0    conda-forge
pyopenssl                 20.0.1             pyhd8ed1ab_0    conda-forge
pyparsing                 3.0.9              pyhd8ed1ab_0    conda-forge
pysocks                   1.7.1              pyha2e5f31_6    conda-forge
python                    3.9.15               haa1d7c7_0    defaults
python-dateutil           2.8.2              pyhd8ed1ab_0    conda-forge
python-louvain            0.15               pyhd8ed1ab_1    conda-forge
python_abi                3.9                      2_cp39    conda-forge
pytorch                   1.9.1               py3.9_cpu_0  [cpuonly]  pytorch
pytorch-cluster           1.5.9           py39_torch_1.9.0_cpu    rusty1s
pytorch-geometric         1.7.2           py39_torch_1.9.0_cpu    rusty1s
pytorch-mutex             1.0                         cpu    pytorch
pytorch-scatter           2.0.9           py39_torch_1.9.0_cpu    rusty1s
pytorch-sparse            0.6.12          py39_torch_1.9.0_cpu    rusty1s
pytorch-spline-conv       1.2.1           py39_torch_1.9.0_cpu    rusty1s
pytz                      2022.6             pyhd8ed1ab_0    conda-forge
pyyaml                    6.0              py39hb9d737c_5    conda-forge
rdflib                    6.2.0                    pypi_0    pypi
readline                  8.2                  h5eee18b_0    https://repo.anaconda.com/pkgs/main
requests                  2.28.1             pyhd8ed1ab_1    conda-forge
requests-oauthlib         1.3.1                    pypi_0    pypi
rsa                       4.9                      pypi_0    pypi
ruamel.yaml               0.17.21          py39hb9d737c_2    conda-forge
ruamel.yaml.clib          0.2.7            py39hb9d737c_0    conda-forge
scikit-learn              1.1.3            py39h6a678d5_0    defaults
scipy                     1.9.3            py39h14f4228_0    defaults
setuptools                65.5.0           py39h06a4308_0    defaults
six                       1.16.0             pyhd3eb1b0_1    defaults
spglib                    2.0.2            py39h2ae25f5_0    conda-forge
sqlite                    3.39.3               h5082296_0    https://repo.anaconda.com/pkgs/main
sympy                     1.11.1           py39hf3d152e_2    conda-forge
tabulate                  0.9.0              pyhd8ed1ab_1    conda-forge
tenacity                  8.1.0              pyhd8ed1ab_0    conda-forge
tensorboard               2.11.0                   pypi_0    pypi
tensorboard-data-server   0.6.1                    pypi_0    pypi
tensorboard-plugin-wit    1.8.1                    pypi_0    pypi
threadpoolctl             3.1.0              pyh8a188c0_0    conda-forge
tk                        8.6.12               h1ccaba5_0    https://repo.anaconda.com/pkgs/main
torchaudio                0.9.1                      py39    pytorch
torchvision               0.10.1                 py39_cpu  [cpuonly]  pytorch
tqdm                      4.64.1             pyhd8ed1ab_0    conda-forge
typing-extensions         4.3.0            py39h06a4308_0    defaults
typing_extensions         4.3.0            py39h06a4308_0    defaults
tzdata                    2022f                h04d1e81_0    https://repo.anaconda.com/pkgs/main
uncertainties             3.1.7              pyhd8ed1ab_0    conda-forge
unicodedata2              15.0.0           py39hb9d737c_0    conda-forge
urllib3                   1.26.11            pyhd8ed1ab_0    conda-forge
werkzeug                  2.2.2                    pypi_0    pypi
wheel                     0.37.1             pyhd3eb1b0_0    https://repo.anaconda.com/pkgs/main
xz                        5.2.6                h5eee18b_0    https://repo.anaconda.com/pkgs/main
yaml                      0.2.5                h7f98852_2    conda-forge
zipp                      3.10.0                   pypi_0    pypi
zlib                      1.2.13               h5eee18b_0    https://repo.anaconda.com/pkgs/main
zstd                      1.4.9                haebb681_0    defaults

```
