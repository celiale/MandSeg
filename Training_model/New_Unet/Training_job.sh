#!/bin/bash
####  SBATCH preamble

#SBATCH --job-name=Training
#SBATCH --mail-type=BEGIN,END
#SBATCH --account=luciacev1
#SBATCH --output=out.log

#SBATCH --time=95:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=180GB
#SBATCH --partition=gpu
#SBATCH --gpus=1


module load tensorflow/2.1.0
python3 training.py

