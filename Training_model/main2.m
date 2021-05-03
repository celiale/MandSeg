clear variables
close all

server_path = '/Volumes/med-kayvan-lab/Projects/TMJ/Data/Processed/Large_FOV_Condyle_Seg/XV/';

%%  Convert PNG slices from deep learning to 3D nifti scans in results_reconstruct
test_path = strcat(server_path,'train/Fold10/');
PngSlicesToNiftiScan (test_path);

%% Compute AUC
pathFold = test_path;
computeAucFolder (pathFold)

