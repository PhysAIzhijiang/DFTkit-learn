import os
import subprocess as sp
import time

import numpy as np
from pymatgen.core.structure import Structure


np.random.seed(42)

structure = Structure.from_file('Graphene.cif')
structure_supercell = Structure(structure.lattice.matrix,
                                structure.atomic_numbers,
                                structure.frac_coords,
                                coords_are_cartesian=False,
                                to_unit_cell=True)
structure_supercell.make_supercell([[5, 0, 0], [0, 5, 0], [0, 0, 1]])
N_supercell = len(structure_supercell)

cwd_dir = os.getcwd()
root_dir = 'configuration'
for index_perturb in range(400):
    work_dir = os.path.join(cwd_dir, root_dir, str(index_perturb))
    os.makedirs(work_dir, exist_ok=True)
    os.chdir(work_dir)
    os.system(f"cp {cwd_dir}/C_ONCV_PBE-1.0.upf ./")
    os.system(f"cp {cwd_dir}/C_gga_8au_100Ry_2s2p1d.orb ./")

    cart_coords = structure_supercell.cart_coords

    disorder_x = (np.random.rand(N_supercell, 1) - 0.5) * 0.2 # -0.1 ~ 0.1
    disorder_y = (np.random.rand(N_supercell, 1) - 0.5) * 0.2 # -0.1 ~ 0.1
    disorder_z = (np.random.rand(N_supercell, 1) - 0.5) * 0.4 # -0.2 ~ 0.2

    cart_coords += np.concatenate([disorder_x, disorder_y, disorder_z], axis=-1)

    structure_supercell_perturb = Structure(structure_supercell.lattice.matrix,
                                            structure_supercell.atomic_numbers,
                                            cart_coords,
                                            coords_are_cartesian=True,
                                            to_unit_cell=True)
    
    numbers = structure_supercell_perturb.atomic_numbers
    NUM_ATOM = len(numbers)
    lattice = structure_supercell_perturb.lattice.matrix
    frac_coords = structure_supercell_perturb.frac_coords
    C_frac_coords_str = ''
    for i in range(NUM_ATOM):
        if i < 50:
            assert numbers[i] == 6
            C_frac_coords_str += f'{frac_coords[i, 0]:.16f} {frac_coords[i, 1]:.16f} {frac_coords[i, 2]:.16f} 0 0 0\n'
        else:
            raise "NUM_ATOM sould be 50"

    structure_supercell_perturb.to('poscar', 'POSCAR')

    in_file = fr"""ATOMIC_SPECIES
    C   1.0   C_ONCV_PBE-1.0.upf

    NUMERICAL_ORBITAL
    C_gga_8au_100Ry_2s2p1d.orb

    LATTICE_CONSTANT
    1.88972

    LATTICE_VECTORS
{lattice[0, 0]:.16f} {lattice[0, 1]:.16f} {lattice[0, 2]:.16f}
{lattice[1, 0]:.16f} {lattice[1, 1]:.16f} {lattice[1, 2]:.16f}
{lattice[2, 0]:.16f} {lattice[2, 1]:.16f} {lattice[2, 2]:.16f}

ATOMIC_POSITIONS
Direct

C
0.0
50
{C_frac_coords_str}
"""
    with open('STRU', 'w') as f:
        f.write(in_file)

    in_file = fr"""K_POINTS
0
Gamma
7 7 1 0 0 0
"""
    with open('KPT', 'w') as f:
        f.write(in_file)

    in_file = fr"""INPUT_PARAMETERS
ntype                   1
nbands                  200
nspin                   1
calculation             scf
basis_type              lcao
ecutwfc                 100
scf_thr                 1.0e-8
scf_nmax                100
gamma_only              0

smearing_method         gaussian
smearing_sigma          0.02

mixing_type             pulay
mixing_beta             0.4

out_mat_hs2       1
"""

    with open('INPUT', 'w') as f:
        f.write(in_file)
