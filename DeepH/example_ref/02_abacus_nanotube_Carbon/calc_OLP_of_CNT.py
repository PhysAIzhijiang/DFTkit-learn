import os
import subprocess as sp
import time

import numpy as np
from pymatgen.core.structure import Structure


os.makedirs('olp_CNT', exist_ok=True)
os.system(f"cp C_ONCV_PBE-1.0.upf ./olp_CNT/")
os.system(f"cp C_gga_8au_100Ry_2s2p1d.orb ./olp_CNT/")

structure = Structure.from_file('CNT.cif')
structure = Structure(structure.lattice.matrix,
                      structure.atomic_numbers,
                      structure.frac_coords,
                      coords_are_cartesian=False,
                      to_unit_cell=True)


numbers = structure.atomic_numbers
NUM_ATOM = len(numbers)
lattice = structure.lattice.matrix
frac_coords = structure.frac_coords
C_frac_coords_str = ''
for i in range(NUM_ATOM):
    if i < 100:
        assert numbers[i] == 6
        C_frac_coords_str += f'{frac_coords[i, 0]:.16f} {frac_coords[i, 1]:.16f} {frac_coords[i, 2]:.16f} 0 0 0\n'
    else:
        raise "NUM_ATOM sould be 100"

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
{NUM_ATOM}
{C_frac_coords_str}
"""
with open('./olp_CNT/STRU', 'w') as f:
    f.write(in_file)

in_file = fr"""K_POINTS
0
Gamma
1 1 1 0 0 0
"""
with open('./olp_CNT/KPT', 'w') as f:
    f.write(in_file)

in_file = fr"""INPUT_PARAMETERS
ntype                   1
nbands                  500
nspin                   1
calculation             get_S
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

with open('./olp_CNT/INPUT', 'w') as f:
    f.write(in_file)
