# ABACUS 

组织链接: http://abacus.ustc.edu.cn/main.htm

项目链接: http://abacus.deepmodeling.com/en/latest/index.html

代码链接: https://github.com/deepmodeling/abacus-develop

Docker链接: https://github.com/deepmodeling/abacus-develop/pkgs/container/abacus

## 介绍
ABACUS (Atomic-orbital Based Ab-initio Computation at UStc) is an open-source computer code package based on density functional theory (DFT). The package utilizes both plane wave and numerical atomic basis sets with the usage of norm-conserving pseudopotentials to describe the interactions between nuclear ions and valence electrons. 

## 官方资源
- 手册: http://abacus.ustc.edu.cn/manual/list.htm
  - 不够详细
- 教程: 缺失
- psudo-potential和轨道文件: http://abacus.ustc.edu.cn/pseudo/list.htm
- 例子: 在源代码下面`example`下可以获取
- 开发者教程: 没有
- 工具包: 
  - 图形界面: 有, 需要账户?

## 本仓库资源

- [安装说明](./01_install.md)
- [运行指南与例子](./02_example.md)
  - Band 
    - 使用`lcao`轨道计算Si2能带. [>>点击查看<<](./example_ref/band/lcao_Si2/README.md)
  - Berry Phase 
    - 使用`lcao`轨道计算PbTiO3极化. [>>点击查看<<](./example_ref/berryphase/lcao_PbTiO3/README.md)