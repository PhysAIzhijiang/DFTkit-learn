# ABACUS编译指南

**作者: BS**

---



## 系统环境
本指南以qlab服务器环境进行编译为例子.

### 服务器加载环境
使用`module load`指令.

#### install
    ​``` bash
    $ module load intel/2022 mpi/latest mkl/2022.1.0 compiler/latest devtoolset/gcc-11
    ​``` 
    
    可选:
    ​``` bash
    $ module load libxc/5.2.3
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

- gcc版本: 

    ``` bash
    $ gcc --version
    gcc (GCC) 11.2.1 20220127 (Red Hat 11.2.1-9)
    ```

    check `/usr/include/c++/`
    5.4.0 is fine. 4.8.5 not works.


- intel编译器: 
  
    ``` bash
    $ ifort --version
    ifort (IFORT) 2021.6.0 20220226
    ```

- MKL版本:

    ``` bash
    $ echo $MKLROOT
    /opt/intel/oneapi/mkl/2022.1.0
    ```

- make版本:

    ``` bash
    $ make --version
    GNU Make 4.3
    Built for x86_64-redhat-linux-gnu
    ```

- libxc版本:
  
    ``` bash
    $ xc-info --version
    libxc version 5.2.3
    ```

    ​

## 依赖关系
在正式开始编译前, 我们要知道ABACUS和DeepH除了常规的编译环境外, 还需要一些其他的库依赖. 这里将会简单介绍依赖库关系.

- ​cereal $\leftarrow$ ABACUS.  
  
    A C++11 library for serialization. 

- ELPA $\leftarrow$ ABACUS. 

    EIGENVALUE SOLVERS FOR PETAFLOP APPLICATIONS(ELPA) 
    高效并行求解本征值问题

- libxc $\leftarrow$ ABACUS. (可选) 



## 编译

### cereal

#### 下载
在官方网站`https://uscilab.github.io/cereal/`下载最新版本`https://codeload.github.com/USCiLab/cereal/zip/refs/tags/v1.3.2`. 

#### 解压到安装目录
    ​```shell
    $ cd xx/apps/cereal/;
    $ unzip 下载目录/cereal-1.3.2.zip;
    $ mv cereal-1.3.2 1.3.2;
    ​```

#### 加载到环境
    加载有两种方式, 选择其一就好

    - 直接加载:
    ​```bash
        CEREALROOT="xxx/apps/cereal/1.3.2"
        CEREALCPATH="$CEREALOOT/include"
        CPATH="$CPATH:$CEREALOOT/include"
    ​```
    - 加载到module环境中
    
    创建`cereal/1.3.2.lua`文件. 将所在路径添加到`$$MODULEPATH`中
    
    ​``` lua
    help([[
    cereal v1.3.2 library.
    ]])
    
    conflict("cereal")
    whatis("Name: cereal")
    whatis("Version: v1.3.2")
    whatis("Description: cereal v1.3.2 - A C++11 library for serialization")
    
    local prefix="xxx/apps/cereal/1.3.2"
    setenv("CEREALROOT", prefix)
    setenv("CEREALCPATH", prefix .. "/include")
    prepend_path("CPATH", prefix .. "/include")
    ​```
    
    执行`module load cereal/1.3.2`

### ELPA

#### 下载
在官方网站`https://gitlab.mpcdf.mpg.de/elpa/elpa/-/releases`下载`2021.05.002`版本. 以ABACUS-3.0.1为例子, 最好用这个版本的ELPA.

#### 解压到安装目录apps
    ​```bash
    $ cd xx/apps/elpa/2021_05_002;
    $ unzip 下载目录/elpa-new_release_2021_05_002.zip;
    $ cd elpa-new_release_2021_05_002;
    ​```
    *注意*:不要改变文件夹名称"elpa-new_release_2021_05_002", elpa有奇怪的文件链接.

#### 生成config文件.

    ​``` bash
    $ ./autogen.sh
    ​```
    这里输出应该没有warning和error.

#### 准备编译.

    ​``` bash
    # 获取安装目录
    $ dir_elpa_install=$(dirname $(pwd));
    # 删除build文件夹, 从头编译
    $ rm -rf build ;
    $ mkdir build;
    $ cd build;
    # 检查安装环境并准备Makefile
    $ ../configure --prefix=$dir_elpa_install  CC=mpiicc CXX=mpiicpc FC=mpiifort   FCFLAGS="-qmkl=cluster" 
    ​```
    等待一会, 应该没有错误输出.

#### 编译

    ​``` bash
    $ make -j 4
    ​```
    
    `4`代表用4个核, 请根据自己实际情况调整.
    
    这个过程会提示一些warning, 不用担心.
    
    最后看到`Libraries have been installed in xxx`说明编译成功了.


#### 加载到环境
    加载有两种方式, 选择其一就好
    - 直接加载:
        ``` bash
        ELPAROOT="xxx/apps/elpa/2021.05.002"
        LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ELPAROOT/lib"
        LIBRARY_PATH="$LIBRARY_PATH:$ELPAROOT/lib"
        CPATH="$CPATH:$ELPAROOT/include"
        PATH="$PATH:$ELPAROOT/bin"
        MANPATH="$MANPATH:$ELPAROOT/share/man"
        ```
    - 加载到module环境中
      
        创建`elpa/2021.05.002.lua`文件. 将所在路径添加到`$MODULEPATH`中
    
        ``` lua
        help([[
        ELPA 2021.05.002 compiled with Intel MPI compilers.
        ]])
    
        conflict("elpa")
        whatis("Name: elpa")
        whatis("Version: 2021.05.002")
        whatis("Description: ELPA 2021.05.002 compiled with Intel MPI compilers.")
    
        load("compiler/latest")
        load("mpi/latest")
        load("mkl/latest")
    
        local prefix="xxx/apps/elpa/2021.05.002"
        setenv("ELPAROOT", prefix)
        prepend_path("LD_LIBRARY_PATH", prefix .. "/lib")
        prepend_path("LIBRARY_PATH", prefix .. "/lib")
        prepend_path("CPATH", prefix .. "/include")
        prepend_path("PATH", prefix .. "/bin")
        prepend_path("MANPATH", prefix .. "/share/man")
        ```
        
        执行`module load elpa/2021.05.002`


### ABACUS

#### 下载
在官方仓库`https://gitee.com/deepmodeling/abacus-develop/releases`下载最新版本. 本文以`3.0.1`作为例子.

#### 解压到安装目录apps

  ``` bash
  $ cd xxx/apps; unzip 下载目录/abacus-develop-3.0.1.zip
  ```

  ``` bash
  $ mv abacus-develop-3.0.1 3.0.1;
  ```

#### 准备编译

    **虽然ABACUS准备了cmake编译, 但是目前测试并不稳定. 当前版本还是推荐用make进行编译**

    - 添加ELPA路径

        ``` bash
        $ cd 3.0.1;
        $ vi modules/FindELPA.cmake
        ```
        编辑`FindELPA.cmake`文件, 修改`find_path`函数, 在`PATH_SUFFIXES`后添加我们实际安装elpa目录.
    
        ```
            find_path(ELPA_INCLUDE_DIR
                elpa/elpa.h
                HINTS ${ELPA_DIR}
                PATH_SUFFIXES "include" "include/elpa" "include/elpa-2021.05.002"
                )
        ```
    
    - 修改编译变量. 
      
        打开`source/Makefile.vars`文件.
        - 编辑ELPA路径
        
            ``` bash
            CEREAL_DIR    =	${CEREALCPATH}
            # directory of cereal, which contains a include directory in it.
            ```
    
        - 编辑CEREAL路径
        
            ``` bash
            CEREAL_DIR    =	${CEREALCPATH}
            # directory of cereal, which contains a include directory in it.
            ```
    
        - 编辑LIBX路径 (可选)
        
            ``` bash
            LIBXC_DIR               = ${LIBXCROOT}
            # directory of libxc(5.1.7), which contains include and lib/libxc.a
            # add LIBXC_DIR to use libxc to compile ABACUS
            ```
#### 编译

    ​``` bash
    $ cd source; make -j 4
    ​```
    
    `4`代表用4个核, 请根据自己实际情况调整.
    
    在屏幕输出最后看到`-lxc -o  ../bin/ABACUS.mpi`说明编译成功了.
    
    可以看到目录`3.0.1/bin`下出现`ABACUS.mpi`文件.

#### 加载到环境
    加载有两种方式, 选择其一就好
    - 直接加载:
        ``` bash
        ABACUSROOT="xxx/apps/abacus/3.0.1"
        ulimit -s unlimited
        PATH="$PATH:$ELPAROOT/bin"
        ```
    - 加载到module环境中
      
        创建`abacus/intel-3.0.1.lua`文件. 将所在路径添加到`$MODULEPATH`中
    
        ``` lua
        help([[
        ABACUS 3.0.1 compiled with Intel MPI compilers.
        ]])
    
        conflict("abacus")
        whatis("Name: abacus")
        whatis("Version: 3.0.1")
        whatis("Description: ABACUS 3.0.1 compiled with Intel MPI compilers.")
    
        load("devtoolset/gcc-11")
        load("compiler/latest")
        load("mpi/latest")
        load("mkl/latest")
        load("elpa/2021.05.002")
    
        local prefix="xxx/apps/abacus/3.0.1"
        setenv("ABACUSROOT", prefix)
        execute{cmd="ulimit -s unlimited", modeA={"load"}}
        prepend_path("PATH", prefix .. "/bin")
        ```
        
        执行`module load abacus/intel-3.0.1`

#### 测试

##### 可执行测试

先来个最简单的, 直接运行`ABACUS.mpi`
输出

``` txt
 *********************************************************
 *                                                       *
 *                  WELCOME TO ABACUS v3.0               *
 *                                                       *
 *            'Atomic-orbital Based Ab-initio            *
 *                  Computation at UStc'                 *
 *                                                       *
 *          Website: http://abacus.ustc.edu.cn/          *
 *                                                       *
 *********************************************************
 Wed Nov 16 11:10:33 2022
 Can't find the INPUT file.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         NOTICE                           
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Error during readin parameters.
 CHECK IN FILE : warning.log
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                         NOTICE                           
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  |CLASS_NAME---------|NAME---------------|TIME(Sec)-----|CALLS----|AVG------|PER%-------
 ----------------------------------------------------------------------------------------
 See output information in :
```

  空输出版本, 没有任何计算.

##### 简单计算

ABACUS提供了丰富的例子, 我们将使用提供的`Si`的例子来验证程序.

- 准备文件

```bash
# 创建测试目录
$ cd 自己本地目录;
$ mkdir test_abacus;
$ cd test_abacus;
# 复制输入
$ cp -r $ABACUSROOT/examples/band/lcao_Si2 ./lcao_Si2_1
$ cd lcao_Si2_1
$ ls -al
total 32
drwxrwxr-x 2 xxxx xxxx 4096 Nov 16 11:26 .
drwxrwxr-x 4 xxxx xxxx 4096 Nov 16 11:26 ..
-rw-rw-r-- 1 xxxx xxxx  546 Nov 16 11:26 INPUT1
-rw-rw-r-- 1 xxxx xxxx  444 Nov 16 11:26 INPUT2
-rw-rw-r-- 1 xxxx xxxx  112 Nov 16 11:26 KLINES
-rw-rw-r-- 1 xxxx xxxx   29 Nov 16 11:26 KPT
-rw-rw-r-- 1 xxxx xxxx  462 Nov 16 11:26 run.sh
-rw-rw-r-- 1 xxxx xxxx  348 Nov 16 11:26 STRU

```

- 查看官方提供的测试方法, 打开文件`run.sh`

    ``` bash
    #!/bin/bash

    ABACUS_PATH=$(awk -F "=" '$1=="ABACUS_PATH"{print $2}' ../../SETENV)
    ABACUS_NPROCS=$(awk -F "=" '$1=="ABACUS_NPROCS"{print $2}' ../../SETENV)
    ABACUS_THREADS=$(awk -F "=" '$1=="ABACUS_THREADS"{print $2}' ../../SETENV)

    cp INPUT1 INPUT
    OMP_NUM_THREADS=${ABACUS_THREADS} mpirun -np ${ABACUS_NPROCS} ${ABACUS_PATH} | tee scf.output
    cp INPUT2 INPUT
    OMP_NUM_THREADS=${ABACUS_THREADS} mpirun -np ${ABACUS_NPROCS} ${ABACUS_PATH} | tee nscf.output

    rm INPUT
    ```
`ABACUS_PATH`是ABACUS执行文件路径; 
`ABACUS_NPROCS`是MPI用的核数, 例子使用的是2;
`ABACUS_THREADS`是OpenMP每个核使用的线程数, 例子使用的是1 

ABACUS本身支持OpenMP和MPI混合并行, 我们将现在下一个测试例子看到.

修改`run.sh`为本机环境:

    ​``` bash
    #!/bin/bash
    
    # 设置执行文件
    ABACUS_PATH=$ABACUSROOT/bin/ABACUS.mpi
    # 设置MPI使用核数
    ABACUS_NPROCS=2
    # 设置OpenMP使用线程数
    ABACUS_THREADS=1
    
    # 先进行scf计算, 准备输入文件
    cp INPUT1 INPUT
    # 计算, 并将输出到 scf.output
    OMP_NUM_THREADS=${ABACUS_THREADS} mpirun -np ${ABACUS_NPROCS} ${ABACUS_PATH} | tee scf.output
    
    # 计算能带, 准备输入文件
    cp INPUT2 INPUT
    # 计算, 并将输出到 nscf.output
    OMP_NUM_THREADS=${ABACUS_THREADS} mpirun -np ${ABACUS_NPROCS} ${ABACUS_PATH} | tee nscf.output
    
    # 删除临时输入文件
    rm INPUT
    ​```

- 修改`INPUT`
  虽然现在执行脚本已经修改好, 但是还不能运行计算. 
  因为`INPUT`文件中还是使用了相对路径作为输入, 我们需要改成我们本机环境.

  - 编辑`INPUT1`和`INPUT2`
    修改`pseudo_dir`和`orbital_dir`对应的值.
    *注意*:这里要使用abacus的直接路径, 不能使用$ABACUSROOT环境变量.

    ``` 
    ...
    pseudo_dir                      xxx/apps/abacus/3.0.1/tests/PP_ORB
    orbital_dir                     xxx/apps/abacus/3.0.1/tests/PP_ORB
    ...
    ```

- 运行
  - 直接运行

    ``` bash
    ./run.sh
    ```

  - 通过集群队列管理系统运行. 本文以`slurm`队列管理系统为例子.
    
    创建`run.slurm`文件, 并编辑. 该文件和`run.sh`功能一致.

    ``` bash
    #!/bin/bash -l

    #|=======================================
    #| set output and error file name
    #| if not set, slurm will generate files 
    #| with name stdout and stderr.
    #|---------------------------------------
    ## #SBATCH -o Slurm-o.%j
    ## #SBATCH -e Slurm-e.%j

    #|=======================================
    #| name of the job
    #|---------------------------------------
    #SBATCH -J abacus

    #|=======================================
    #| execute job from the current working directory
    #| this is default slurm behavior
    #|---------------------------------------
    #SBATCH -D ./

    #|=======================================
    #| send mail
    #| send when job done
    #|---------------------------------------
    #+ #SBATCH --mail-type=end
    #+ #SBATCH --mail-user=YOUR_NAME@YOUR_MAIL_SERVER

    #|=======================================
    #| specify your job requires
    #|---------------------------------------
    #|- set nodes, task, cpus for a hybrid MPI/OpenMP job
    #|-
    #|- nodes you required
    #SBATCH --nodes=1
    #|- tasks on each node, it depends on the cluster
    #|- use 'sinfo --Node --long' to know how many cores per node
    #SBATCH --ntasks-per-node=2
    #|- Number of cores per task (for openmp)
    #SBATCH --cpus-per-task=1
    #|---------------------------------------
    #|- set memory limit 4000Mb
    #|- #SBATCH --mem 4000
    #|---------------------------------------
    #|- PARTITION & time limit
    #|- use `sinfo` to list PARTITION & TIMELIMIT
    #SBATCH -p debug
    #|- Quality
    #SBATCH -q short
    ## time format day-hour:minute:second
    #SBATCH --time=00-00:30:00

    #|=======================================
    #| start to set your environment for your job
    #|---------------------------------------

    #|-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    #- load intel abacus
    #|---------------------------------------
    module load abacus/intel-3.0.1

    export MKLPATH=$MKL_HOME/lib/intel64/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MKLPATH
    export INTELPATH=$INTEL_HOME/lib/intel64/
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INTELPATH
    #+

    #|-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    #- set parallel environment
    #|---------------------------------------
    #- use mpi/openmp
    if [ -n "$SLURM_CPUS_PER_TASK" ]; then
        omp_threads=$SLURM_CPUS_PER_TASK
    else
        omp_threads=1
    fi
    export OMP_NUM_THREADS=$omp_threads
    export MKL_NUM_THREADS=$omp_threads

    #- If you prefer using mpiexec/mpirun with SLURM, please add the following code to the batch script before running any MPI executable
    # unset I_MPI_PMI_LIBRARY 
    # export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0   # the option -ppn only works if you set this before

    #|-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
    #| load your own lib path(if needed)
    #|---------------------------------------
    #+ export PATH=$PATH:your path

    #|=======================================
    #| start to run your job
    #|---------------------------------------
    rm Slurm-*

    ABACUS_PATH=$ABACUSROOT/bin/ABACUS.mpi

    cp INPUT1 INPUT
    srun ${ABACUS_PATH} > scf.output
    cp INPUT2 INPUT
    srun ${ABACUS_PATH} > nscf.output

    rm INPUT

    #|=======================================
    #| done
    #|---------------------------------------
    # exit 0
    ```

    运行: 
    ``` bash
    sbatch run.slurm
    ```

- 查看结果
    文件结构
    ``` bash
    .
    ├── INPUT1
    ├── INPUT2
    ├── KLINES
    ├── KPT
    ├── nscf.output
    ├── OUT.ABACUS
    │   ├── BANDS_1.dat
    │   ├── INPUT
    │   ├── istate.info
    │   ├── running_nscf.log
    │   ├── running_scf.log
    │   ├── SPIN1_CHG
    │   ├── SPIN1_CHG.cube
    │   ├── STRU_READIN_ADJUST.cif
    │   ├── tmp_SPIN1_CHG
    │   ├── tmp_SPIN1_CHG.cube
    │   └── warning.log
    ├── run.sh
    ├── run.slurm
    ├── scf.output
    └── STRU
    ```

    - `OUT.ABACUS/running_scf.log`有存放`dft scf`运算的结果.

        ``` bash
        grep "charge density convergence is achieved" OUT.ABACUS/running_scf.log -B 15 -A 2
        Density error is 7.85086361775e-10
        
              Energy                       Rydberg                            eV
          E_KohnSham                -15.7225397446                -213.916127558
            E_Harris                -15.7225397446                -213.916127558
              E_band               +0.835412600093                +11.3663715423
          E_one_elec                +4.87091916092                +66.2722550859
           E_Hartree                 +1.1219426667                +15.2648130964
                E_xc                -4.81564296372                -65.5201838402
             E_Ewald                -16.8997586085                  -229.9330119
             E_demet                            +0                            +0
             E_descf                            +0                            +0
               E_exx                            +0                            +0
             E_Fermi               +0.484036464133                +6.58565395198
        
        charge density convergence is achieved
        final etot is -213.916127558 eV
        ```
    - `OUT.ABACUS/BANDS_1.dat`就是我们想要的能带数据.
    
        ``` bash
        $ head OUT.ABACUS/BANDS_1.dat 
        1 0  -1.2520195 -1.2520195 3.4817032 3.4817032 7.4110633 7.4110633 16.978636 16.978636
        2 0.05  -1.6344671 -0.85649321 3.4921902 3.4921902 7.2924856 7.5674533 16.860557 16.860557
        3 0.1  -2.0026077 -0.44919703 3.5236526 3.5236526 7.2109884 7.7622965 16.553316 16.553316
        4 0.15  -2.3553203 -0.031490856 3.5760885 3.5760885 7.1656013 7.9962162 16.138272 16.138272
        5 0.2  -2.6916076 0.39524246 3.6494752 3.6494752 7.155004 8.2696908 15.671076 15.671076
        6 0.25  -3.0105991 0.82962023 3.7437428 3.7437428 7.1775097 8.5826333 15.180921 15.180921
        7 0.3  -3.3115429 1.2702761 3.8587406 3.8587406 7.2311266 8.9336376 14.68249 14.68249
        8 0.35  -3.5937899 1.7158656 3.9941998 3.9941998 7.3136413 9.3189221 14.183388 14.183388
        9 0.4  -3.8567778 2.1650553 4.1496933 4.1496933 7.422673 9.7310944 13.68778 13.68778
        10 0.45  -4.1000167 2.6164921 4.3245906 4.3245906 7.55567 10.157822 13.198172 13.198172        
        ```


---

## 参考

https://cndaqiang.github.io/2021/04/20/abacus/
https://zhuanlan.zhihu.com/p/574031713
