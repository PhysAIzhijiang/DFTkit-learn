# DeepH使用指南

**作者: BS**

---

虽然DeepH可以支持多款DFT计算软件, 但是demo里提供的数据和流程并不是对所有支持的DFT软件通用.
本指南将选取计算碳二维晶体的递进流程(石墨烯$\to$转角石墨烯$\to$任意石墨超胞)来讲解DeepH如何使用方法.

## 二维晶体碳的计算

### 石墨管道

*该例子需要结合ABACUS计算, 如果没有安装ABACUS请参考[ABACUS说明](../ABACUS/README.md)*

#### 介绍

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


- 安装依赖
  `get_dataset.py`程序使用了`pymatgen`依赖, 在运行前我们先安装依赖.
  ``` bash
    # 未完待续
    python3 -v venv ....
    pip install
  ```
- 产生ABACUS输入文件
    ``` bash
    $ ...
    ```
    结果: ....

- 运行ABACUS
  ...
  
#### DeepH数据预处理

按照官方文档的介绍, 我们需要如下步骤:
- Generate the dataset by ABACUS
- **Preprocess the dataset by DeepH-pack**
- Train the DeepH model
- Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)

#### DeepH数据训练

按照官方文档的介绍, 我们需要如下步骤:
- Generate the dataset by ABACUS
- Preprocess the dataset by DeepH-pack**
- **Train the DeepH model**
- Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)

#### DeepH预测

按照官方文档的介绍, 我们需要如下步骤:
- Generate the dataset by ABACUS
- Preprocess the dataset by DeepH-pack**
- Train the DeepH model**
- **Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)**

#### 结果分析

下面我们来分析一下计算结果.



### 石墨烯
该部分教程[参考DeepH官方指南:demo](https://deeph-pack.readthedocs.io/en/latest/demo/demo2.html)

#### 介绍 :
([维基百科](https://zh.wikipedia.org/wiki/%E7%9F%B3%E5%A2%A8%E7%83%AF))

> 石墨烯（Graphene）是一种由碳原子以sp2杂化轨道组成六角型呈蜂巢晶格的平面薄膜，只有一个碳原子厚度的二维材料。石墨烯从前被认为是假设性的结构，无法单独稳定存在，直至2004年，英国曼彻斯特大学物理学家安德烈·海姆和康斯坦丁·诺沃肖洛夫，成功在实验中从石墨中分离出石墨烯，而证实它可以单独存在，两人也因“在二维石墨烯材料的开创性实验”，共同获得2010年诺贝尔物理学奖。
>
> 石墨烯目前是世上最薄却也是最坚硬的纳米材料，它几乎是完全透明的，只吸收2.3%的光；导热系数高达5,300 W/(m·K)，高于纳米碳管和金刚石，常温下其电子迁移率超过15,000 cm2/(V·s)，又比纳米碳管或硅晶体（monocrystalline silicon）高，而电阻率只约10-6 Ω·cm，比铜或银更低，为目前世上电阻率最小的材料。由于它的电阻率极低，电子的移动速度极快，因此被期待可用来发展出更薄、导电速度更快的新一代电子器件或晶体管。石墨烯实质上是一种透明、良好的导体，也适合用来制造透明触控萤幕、光板，甚至是太阳能电池。
>
> 石墨烯另一个特性，是能够在常温下观察到量子霍尔效应。




#### 数据准备:
该例子deepH文章有进行计算, 同时deepH官网有提供了计算石墨烯的原始数据. 
不过可惜只给了`raw_data`的数据, 后续数据训练数据未知, 对于新手来说不够友好.

- 访问[数据地址](https://zenodo.org/record/6555484), 下载数据包`graphene_dataset.zip`.

- 解压ZIP压缩包到xxx

- 编辑DeepH的配置文件`DeepH-pack/ini/`. 
  - 其中`raw_dir` set to the path of the downloaded dataset
  - `graph_dir` save your graph file during the training
  - `save_dir` results file during the training
  - a single MPNN model is used



#### 数据训练:

`deeph-train --config ${config_path}`


#### 模型预测:

`deeph-inference --config ${inference_config_path}`

(未完, 详细讲解模型准备工作)

#### 预测分析:

(未完, 描述怎么看结果, 以及后续计算)

### 转角石墨烯
该部分教程[参考DeepH官方指南:demo](https://deeph-pack.readthedocs.io/en/latest/demo/demo2.html)

#### 介绍
(来源[新华社](http://www.xinhuanet.com/world/2018-12/28/c_1123920894.htm))
> 麻省理工学院等机构研究人员通过不断调试两层石墨烯的旋转角发现，在特定角度（约1.1度），这一体系会表现出“莫特绝缘体”特性，而如果利用电场在石墨烯上吸附电子，这一体系则能表现出超导特性。公报认为，这种“魔角”石墨烯体系的发现，开创了“转角电子学”这一全新领域。

(未完)

#### 数据准备:
该例子deepH文章有进行计算, 同时deepH官网有提供了计算石墨烯的原始数据. 

- 访问[数据地址](https://zenodo.org/record/6555484), 下载数据包`TBG_dataset.zip`.