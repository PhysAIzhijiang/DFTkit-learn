# Demo: Train the DeepH model by random graphene supercells and predict the Hamiltonian of carbon nanotube using the ABACUS interface

## Generate the dataset by ABACUS

In order to construct the dataset of graphene, you can perpare some 5x5x1 graphene supercells with random perturbations to each atomic site. Firstly, run
```bash
python get_dataset.py
```
to get ABACUS input files of 400 random graphene supercells.

Then perform DFT calculations on each of the 400 supercells by ABACUS.

## Preprocess the dataset by DeepH-pack

You can store the DFT data files in DeepH format and perform basis transformation to local coordinates by DeepH-pack. Set up the `raw_dir` and `processed_dir` for the config file `preprocess.ini`. `raw_dir` should be the root directory where different DFT calculation results are stored. `processed_dir` needs to be set to the directory where you want to store the processed data in DeepH format. Run
```bash
deeph-preprocess --config preprocess.ini
```

## Train the DeepH model

DeepH model can be trained using the preprocessed dataset. Set up the `graph_dir`, `save_dir` and `raw_dir` for the config file `train.ini`. The `raw_dir` in the `train.ini` should be set to the value of `processed_dir` in the `preprocess.ini`. `graph_dir` and `save_dir` are the directories where you want to store the graph file and output files, respectively. Run
```bash
deeph-train --config train.ini
```
The trained model can be found in the `save_dir`. The average loss of all orbital pairs is expected to reach `1e-6`.


## Predict the Hamiltonian of (25, 0) carbon nanotube (CNT)

Firstly, you should compute the overlap matrix of the carbon nanotube without scf calculation. Run
```bash
python calc_OLP_of_CNT.py
```
to get ABACUS input files and perform overlap calculation by ABACUS. ABACUS version >= 2.3.2 is required.

Then predict the DFT Hamiltonian and calculation the band structure. Set up the `work_dir`, `OLP_dir` and `trained_model_dir` for the config file `inference.ini`. `work_dir` is the directory where you want to store the prediction results. `OLP_dir` is the directory of your overlap calculation of CNT. `trained_model_dir` needs to be set to the directory where you store the output files of training (`best_model.pt` file). Run
```bash
deeph-inference --config inference.ini
```
After completing the calculation, you can find the predicted band structure in OpenMX Band format of (25, 0) CNT. 
