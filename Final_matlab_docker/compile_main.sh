#!/bin/bash
####  SBATCH preamble

#SBATCH --job-name=compile
#SBATCH --mail-type=BEGIN,END
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=15GB
#SBATCH --time=00:10:00
#SBATCH --account=luciacev1
#SBATCH --gpus=1
#SBATCH --partition=gpu
#SBATCH --output=output.log

module load matlab/R2020a

# For running matlab script
#matlab -nosplash -noFigureWindows -r "try; run('main.m'); catch; end; quit"

# For running matlab function
#matlab -nosplash -noFigureWindows -r "try; cd('C:\Path\To\'); YourFunctionName(); catch; end; quit"

# For compiling matlab code
mcc -m -R -nodisplay main1.m
mcc -m -R -nodisplay main2.m

