# Work on the Large FOV TMJ scans
This directory contains all the code to work on the TMJ scans with large field of view.

## Prerequisites
* Matlab 2020a is necessary in order to run the code
* python with TensorFlow 2 to run the Unet model


## 1. main1.m
Runs the functions : 
1. NiftiGiplScanToPngSlices.m : to create the 2D png slices from the original 3D CBCT scans for the train folder
2. NiftiGiplScanToPngSlices.m : to create the 2D png slices from the original 3D CBCT scans for the test folder
These png slices are used for the cross-validation and the training of the Unet model.

## 2. Create_npy_Files
Contains the code to create npy files containing all of the png slices to give to the Unet.
1. Create_Npy_Files_job.sh : to submit the job on Great Lakes
2. create_npy_images.py : function to create the npy files
3. create_npy_images_XV.py : function to create the npy files for the cross validation

## 3. Unet 
This contains the code to train the model, run the prediction, compute the cross-validation; with the code to compute that on the great lakes computing grid.

1. main_job.sh : script to submit the job on GreatLakes and to manage the files for cross-validation,
2. main.py : main code to call the function for training and prediction of the model,
3. model.py : architecture of the Unet model,
4. data.py : all the functions to read, prepare and save the data for the cross-validation.

from : https://github.com/zhixuhao/unet

## 4. main2.m 
Runs the functions :
1. PngSlicesToNiftiScan.m : to reconstruct the 3D scan from the results of the unet + post-processing
2. computeAucFolder.m : to calculate the AUC, F1 score, sensitivity, specificity, accuracy

## Libraries

* AUC : code to compute the auc and other measurements on the output of the model
* GIPL toolbox : code to read and write gipl files,
from : https://www.mathworks.com/matlabcentral/fileexchange/16407-gipl-toolbox




