#!/bin/bash
####  SBATCH preamble

#SBATCH --job-name=Create_Npy_Files
#SBATCH --mail-type=BEGIN,END
#SBATCH --account=luciacev1
#SBATCH --output=out.log

#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=32GB
#SBATCH --partition=gpu
#SBATCH --gpus=1


module load tensorflow/2.1.0
python3 create_npy_images.py
