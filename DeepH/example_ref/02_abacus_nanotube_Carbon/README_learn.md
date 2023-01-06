#### 介绍
在该例子里, 我们将使用ABACUS+DeepH完整实现计算C纳米管的计算过程.

碳纳米管一个原胞:
![](./CNT_geometry.png)

#### 下载

该例子DeepH官方提供了程序来生成数据, 我们需要下载官方提供的配套程序代码.

- 下载链接为DeepH仓库地址 >>>[下载链接](https://github.com/deepmodeling/DeepH-pack/files/9526304/demo_abacus.zip)<<<
  ``` bash
  # 找到DeepH路径
  $ cd DFTkit-learn地址/DeepH;
  # 创建文件夹
  $ mkdir -p run_example/02_abacus_nanotube_Carbon;
  $ cd run_example/02_abacus_nanotube_Carbon;
  # 使用wget下载demo_abacus.zip到'DFTkit-learn/DeepH/run_example/02_abacus_nanotube_Carbon', 也可使用其他下载器自行下载
  $ wget -c https://github.com/deepmodeling/DeepH-pack/files/9526304/demo_abacus.zip
  ```

- 解压缩
    ``` bash
    # 解压到当前路径
    $ unzip demo_abacus.zip;
    $ ll
    shengbi@shengbi-Latitude:example$ ll
    总用量 276
    drwxrwxr-x 2   4096 xx:xx ./
    drwxrwxr-x 4   4096 xx:xx ../
    -rw-r--r-- 1     86 xx:xx abacus_CNT.json
    -rwx------ 1   2099 xx:xx calc_OLP_of_CNT.py*
    -rw-r--r-- 1  79510 xx:xx C_gga_8au_100Ry_2s2p1d.orb
    -rw-r--r-- 1   5864 xx:xx CNT.cif
    -rw-r--r-- 1  89982 xx:xx C_ONCV_PBE-1.0.upf
    -rw-rw-r-- 1  58779 xx:xx demo_abacus.zip
    -rwx------ 1   3356 xx:xx get_dataset.py*
    -rwx------ 1   1297 xx:xx Graphene.cif*
    -rw-r--r-- 1    344 xx:xx inference.ini
    -rwxr-xr-x 1    227 xx:xx preprocess.ini*
    -rw-r--r-- 1   2442 xx:xx README.md
    -rwxr-xr-x 1   3390 xx:xx train.ini*
    ```

    在刚刚解压缩的文件里, 可以看到`README.md`文件. 该文件为DeepH官方准备的说明文档, 请先仔细阅读.

#### 准备数据

按照官方文档的介绍, 我们需要如下步骤:
- **Generate the dataset by ABACUS**
- Preprocess the dataset by DeepH-pack
- Train the DeepH model
- Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)

这里我们用`ABACUS`产生数据. 
DeepH已经给我们提供了`get_dataset.py`程序, 该程序读取石墨烯的结构文件`Graphene.cif`.
在石墨烯的基础上进行随机扰动结构, 产生大量超胞结构. 这些结构将用`ABACUS`计算, 计算结果会作为`DeepH`训练集.


- 激活环境
  `get_dataset.py`程序使用了`pymatgen`依赖, 在运行前我们先安装依赖.
  如果您已安装DeepH的运行环境, 则加载环境就可以使用`pymatgen`. 参考[DeepH安装指南](../../01_install.md)

  ``` bash
  # 加载DeepH安装环境
  $ module load deeph
  # 加载DeepH python依赖环境 退出环境 conda deactivate
  $ conda activate deeph
  ```

- 产生ABACUS输入文件
    ``` bash
    $ python get_dataset.py
    ```
    运行结束后, 在当前文件夹下将创建`configuration`文件夹.
    该文件夹包含了400个子文件夹
    ``` bash
    # 查看文件数
    $ ls configuration | wc -l
    400
    ```
    每一个子文件夹都包含了一个随机扰动的超胞结构和对应ABACUS的输入文件
    ``` bash
    # 查看超胞结构
    $ ls configuration/0/
    C_gga_8au_100Ry_2s2p1d.orb  C_ONCV_PBE-1.0.upf  INPUT  KPT  poscar  STRU
    # 查看变化
    $ diff --brief  configuration/0/ configuration/1/
    Files configuration/0/poscar and configuration/1/poscar differ
    Files configuration/0/STRU and configuration/1/STRU differ
    ```
    `poscar`是`VASP`计算需要的结构文件, `get_dataset.py`程序使用的`pymatgen`包可以直接输出该格式的文件. 
    `STRU`是ABACUS计算需要的结构文件, 该文件由`get_dataset.py`程序读取`poscar`转化而来.

    查看`poscar`是一个含有50个C原子的超胞(BS:这么大? C纳米管一个原胞含有100个C原子)
    ``` bash
    # 查看poscar里含有多少个C
    $ cat configuration/0/poscar | grep " C" | wc -l
    50
    ``` 

- 运行ABACUS
  用在上一步得到输入文件开始ABACUS的计算.
  这里, 我们以Slurm集群为例子, 批量提交ABACUS作业进行计算. 更多细节请参看[ABACUS使用指南](../../../ABACUS/02_example.md)

  - 准备脚本
    - 创建
      ``` bash
      # 复制脚本到当前目录 (DFTkit-learn地址/DeepH/run_example/02_abacus_nanotube_Carbon)
      $ cp ../../../src/run_abacus.slurm ./
      $ sed -i 's/#SBATCH -J abacus/#SBATCH -J C50/g' run_abacus.slurm
      ```
    - 修改任务
      ``` bash
      # 任务编号0-399. 如果不想一次提交太多任务, 可以把范围分次修改0-9;10-19;...
      $ sed -i 's/## #SBATCH -a .*/#SBATCH -a 0-399/g' run_abacus.slurm
      $ 文本编辑器 run_abacus.slurm
      ```
    - 修改需要的核数和线程数, 以及作业提交的节点. 请根据自己的使用环境进行更改.
      修改 'cpus-per-task' 'ntasks-per-node' 'SBATCH --time'
      参考: configuration/0文件下的任务用16个核大概要运行7分钟. 同时可以用4个节点的话, 需要大概11小时.
      
    - 将`# srun .....`替换为
      ``` txt
      pushd configuration/
      shopt -s nullglob
      input=(*)
      shopt -u nullglob 
      echo "There are ${SLURM_ARRAY_TASK_COUNT} task(s) in the array."
      echo "  Max index is ${SLURM_ARRAY_TASK_MAX}, and Min index is ${SLURM_ARRAY_TASK_MIN}"
      echo "This is job #${SLURM_ARRAY_JOB_ID}, with parameter ${input[$SLURM_ARRAY_TASK_ID]}"
      pushd ${input[$SLURM_ARRAY_TASK_ID]}
      srun ${ABACUS_PATH} > scf.output
      popd
      popd
      ```

  - 提交任务
    ``` bash
    # !!!确认无误后提交任务!!!
    $ sbatch run_abacus.slurm
    ```
  
  - 检查计算结果
    为保证所有数据都有正确收敛, 我们需要检查所有数据集的计算结果.
    ``` bash
    $ for f in configuration/*; do if ! grep -Fq "charge density convergence is achieved" $f/OUT.ABACUS/running_scf.log ; then echo "NOT CONVERED in $f"; fi; done
    ```
    没有输出说明全部收敛.
  
#### DeepH数据预处理

按照官方文档的介绍, 我们需要如下步骤:
- Generate the dataset by ABACUS
- **Preprocess the dataset by DeepH-pack**
- Train the DeepH model
- Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)

接下来, 我们需要把ABACUS计算的结果转化成DeepH接受的输入格式, 比如局域化的基矢表示. 

- 编辑文件`preprocess.ini`, 修改为
  ``` ini
  [basic]
  raw_dir = ./configuration
  processed_dir = ./processed_dir
  target = hamiltonian
  interface = abacus
  # use 16 cores
  multiprocessing = 16

  [interpreter]
  julia_interpreter = "JULIA_DEPOT_PATH=/sharedata01/shengbi/app/julia/.pkg_1.8.4; /sharedata01/shengbi/app/julia/1.8.4/bin/julia"

  [graph]
  radius = 
  create_from_DFT = True
  ```
- 创建任务脚本. 
  ``` bash
  cp ../../../src/run_deeph.slurm  .
  ```
  将脚本中`# srun .....`替换为`deeph-preprocess --config preprocess.ini`
  **另外请注意:**
  脚本中`#SBATCH --ntasks-per-node=16`要和`preprocess.ini`文件中`multiprocessing = 16`设置的核数一致.

- 运行
  ```bash
  sbatch run_deeph.slurm
  ```
  大概需要20分钟.
  在`slurm`输出的结果里可以看到`Preprocess finished`字样.

  (BS: 在`processed_dir`里少于400个文件夹, 不知道是否争取正确)

#### DeepH数据训练

按照官方文档的介绍, 我们需要如下步骤:
- Generate the dataset by ABACUS
- Preprocess the dataset by DeepH-pack**
- **Train the DeepH model**
- Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)


DeepH model can be trained using the preprocessed dataset. Set up the `graph_dir`, `save_dir` and `raw_dir` for the config file `train.ini`. The `raw_dir` in the `train.ini` should be set to the value of `processed_dir` in the `preprocess.ini`. `graph_dir` and `save_dir` are the directories where you want to store the graph file and output files, respectively. 

- 编辑文件`train.ini`, 修改为
  ``` ini
  [basic]
  graph_dir = ./graph_dir
  save_dir = ./save_dir
  raw_dir = ./processed_dir 
  dataset_name = graphine10

  disable_cuda = true
  device = cpu

  multiprocessing = false
  num_threads = 1

  orbital = [{"6 6": [0, 0]}, {"6 6": [0, 1]}, {"6 6": [0, 2]}, {"6 6": [0, 3]}, {"6 6": [0, 4]}, {"6 6": [0, 5]}, {"6 6": [0, 6]}, {"6 6": [0, 7]}, {"6 6": [0, 8]}, {"6 6": [0, 9]}, {"6 6": [0, 10]}, {"6 6": [0, 11]}, {"6 6": [0, 12]}, {"6 6": [1, 0]}, {"6 6": [1, 1]}, {"6 6": [1, 2]}, {"6 6": [1, 3]}, {"6 6": [1, 4]}, {"6 6": [1, 5]}, {"6 6": [1, 6]}, {"6 6": [1, 7]}, {"6 6": [1, 8]}, {"6 6": [1, 9]}, {"6 6": [1, 10]}, {"6 6": [1, 11]}, {"6 6": [1, 12]}, {"6 6": [2, 0]}, {"6 6": [2, 1]}, {"6 6": [2, 2]}, {"6 6": [2, 3]}, {"6 6": [2, 4]}, {"6 6": [2, 5]}, {"6 6": [2, 6]}, {"6 6": [2, 7]}, {"6 6": [2, 8]}, {"6 6": [2, 9]}, {"6 6": [2, 10]}, {"6 6": [2, 11]}, {"6 6": [2, 12]}, {"6 6": [3, 0]}, {"6 6": [3, 1]}, {"6 6": [3, 2]}, {"6 6": [3, 3]}, {"6 6": [3, 4]}, {"6 6": [3, 5]}, {"6 6": [3, 6]}, {"6 6": [3, 7]}, {"6 6": [3, 8]}, {"6 6": [3, 9]}, {"6 6": [3, 10]}, {"6 6": [3, 11]}, {"6 6": [3, 12]}, {"6 6": [4, 0]}, {"6 6": [4, 1]}, {"6 6": [4, 2]}, {"6 6": [4, 3]}, {"6 6": [4, 4]}, {"6 6": [4, 5]}, {"6 6": [4, 6]}, {"6 6": [4, 7]}, {"6 6": [4, 8]}, {"6 6": [4, 9]}, {"6 6": [4, 10]}, {"6 6": [4, 11]}, {"6 6": [4, 12]}, {"6 6": [5, 0]}, {"6 6": [5, 1]}, {"6 6": [5, 2]}, {"6 6": [5, 3]}, {"6 6": [5, 4]}, {"6 6": [5, 5]}, {"6 6": [5, 6]}, {"6 6": [5, 7]}, {"6 6": [5, 8]}, {"6 6": [5, 9]}, {"6 6": [5, 10]}, {"6 6": [5, 11]}, {"6 6": [5, 12]}, {"6 6": [6, 0]}, {"6 6": [6, 1]}, {"6 6": [6, 2]}, {"6 6": [6, 3]}, {"6 6": [6, 4]}, {"6 6": [6, 5]}, {"6 6": [6, 6]}, {"6 6": [6, 7]}, {"6 6": [6, 8]}, {"6 6": [6, 9]}, {"6 6": [6, 10]}, {"6 6": [6, 11]}, {"6 6": [6, 12]}, {"6 6": [7, 0]}, {"6 6": [7, 1]}, {"6 6": [7, 2]}, {"6 6": [7, 3]}, {"6 6": [7, 4]}, {"6 6": [7, 5]}, {"6 6": [7, 6]}, {"6 6": [7, 7]}, {"6 6": [7, 8]}, {"6 6": [7, 9]}, {"6 6": [7, 10]}, {"6 6": [7, 11]}, {"6 6": [7, 12]}, {"6 6": [8, 0]}, {"6 6": [8, 1]}, {"6 6": [8, 2]}, {"6 6": [8, 3]}, {"6 6": [8, 4]}, {"6 6": [8, 5]}, {"6 6": [8, 6]}, {"6 6": [8, 7]}, {"6 6": [8, 8]}, {"6 6": [8, 9]}, {"6 6": [8, 10]}, {"6 6": [8, 11]}, {"6 6": [8, 12]}, {"6 6": [9, 0]}, {"6 6": [9, 1]}, {"6 6": [9, 2]}, {"6 6": [9, 3]}, {"6 6": [9, 4]}, {"6 6": [9, 5]}, {"6 6": [9, 6]}, {"6 6": [9, 7]}, {"6 6": [9, 8]}, {"6 6": [9, 9]}, {"6 6": [9, 10]}, {"6 6": [9, 11]}, {"6 6": [9, 12]}, {"6 6": [10, 0]}, {"6 6": [10, 1]}, {"6 6": [10, 2]}, {"6 6": [10, 3]}, {"6 6": [10, 4]}, {"6 6": [10, 5]}, {"6 6": [10, 6]}, {"6 6": [10, 7]}, {"6 6": [10, 8]}, {"6 6": [10, 9]}, {"6 6": [10, 10]}, {"6 6": [10, 11]}, {"6 6": [10, 12]}, {"6 6": [11, 0]}, {"6 6": [11, 1]}, {"6 6": [11, 2]}, {"6 6": [11, 3]}, {"6 6": [11, 4]}, {"6 6": [11, 5]}, {"6 6": [11, 6]}, {"6 6": [11, 7]}, {"6 6": [11, 8]}, {"6 6": [11, 9]}, {"6 6": [11, 10]}, {"6 6": [11, 11]}, {"6 6": [11, 12]}, {"6 6": [12, 0]}, {"6 6": [12, 1]}, {"6 6": [12, 2]}, {"6 6": [12, 3]}, {"6 6": [12, 4]}, {"6 6": [12, 5]}, {"6 6": [12, 6]}, {"6 6": [12, 7]}, {"6 6": [12, 8]}, {"6 6": [12, 9]}, {"6 6": [12, 10]}, {"6 6": [12, 11]}, {"6 6": [12, 12]}]

  [train]
  epochs = 5000
  train_ratio = 0.6
  val_ratio = 0.2
  test_ratio = 0.2
  revert_decay_epoch = [600, 2000, 3000, 4000]
  revert_decay_gamma = [0.4, 0.5, 0.5, 0.4]

  [hyperparameter]
  batch_size = 1
  learning_rate = 0.001

  [network]
  atom_fea_len = 64
  edge_fea_len = 128
  gauss_stop = 6.5
  ```

- 创建任务脚本.
  ``` bash
  $ cp run_deeph.slurm run_deeph_2.slurm
  $ sed -i "s/deeph-preprocess.*/deeph-train --config train.ini/g" run_deeph_2.slurm
  ```
  **要注意deepH使用1个进程, 但是占用了32个核. 因为内存消耗量很大.**

- 运行
  ```bash
  sbatch run_deeph.slurm
  ```

  查看运行进度
  ``` bash
  $ tail -f save_dir/xxxx-xx-xx_xx-xx-xx/result.txt
  ```
  大致30s可以处理一个训练集.


The trained model can be found in the `save_dir`. The average loss of all orbital pairs is expected to reach `1e-6`.

#### DeepH预测

按照官方文档的介绍, 我们需要如下步骤:
- Generate the dataset by ABACUS
- Preprocess the dataset by DeepH-pack**
- Train the DeepH model**
- **Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)**

Firstly, you should compute the overlap matrix of the carbon nanotube without scf calculation. Run
```bash
python calc_OLP_of_CNT.py
```
to get ABACUS input files in `olp_CNT` and perform overlap calculation by ABACUS. ABACUS version >= 2.3.2 is required.

``` bash
$ cp ../../../src/run_abacus.slurm / olp_CNT/
$ sed -i 
$ sbatch run
```

Then predict the DFT Hamiltonian and calculation the band structure. Set up the `work_dir`, `OLP_dir` and `trained_model_dir` for the config file `inference.ini`. `work_dir` is the directory where you want to store the prediction results. `OLP_dir` is the directory of your overlap calculation of CNT. `trained_model_dir` needs to be set to the directory where you store the output files of training (`best_model.pt` file).

编辑`inference.ini`

``` ini
[basic]
work_dir = ./prediction
OLP_dir = ./olp_CNT
interface = abacus
trained_model_dir = ./save_dir/xxxx-xx-xx_xx-xx-xx/
task = [1, 2, 3, 4, 5]
sparse_calc_config = ./abacus_CNT.json
dense_calc = True
disable_cuda = True
huge_structure = False

[interpreter]
julia_interpreter = "JULIA_DEPOT_PATH=/sharedata01/shengbi/app/julia/.pkg_1.8.4; /sharedata01/shengbi/app/julia/1.8.4/bin/julia"

[graph]
radius = -1.0
create_from_DFT = True

```

```bash
deeph-inference --config inference.ini
```

#### 结果分析

下面我们来分析一下计算结果.

`deeph/inference/dense_calc.jl`用来计算能带

hamiltonians_pred = _create_dict_h5(joinpath(parsed_args["input_dir"], "hamiltonians_pred.h5"))
overlaps = _create_dict_h5(joinpath(parsed_args["input_dir"], "overlaps.h5"))

then "construct Hamiltonian and overlap matrix in the real space" ....
The Hamiltonian and overlao matrix are stored like "H_R[R], S_R[R]", "R" is Lattice vectors.

下载 wget https://raw.githubusercontent.com/certik/openmx/master/src/bandgnu13.c
安装 gcc -lm bandgnu13.c -o bandgnu13
app/bandgnu/bandgnu13 prediction/openmx.Band -> openmx.GNUBAND