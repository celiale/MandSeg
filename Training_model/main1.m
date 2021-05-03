clear variables
close all

server_path = '/Volumes/med-kayvan-lab/Projects/TMJ/Data/Processed/Large_FOV_Condyle_Seg/XV/';

%% Convert 3D scans to PNG slices
% scans for training unet
path = '../../TMJ_database/';
scans_path = strcat(path,'scans_06/');
segs_path = strcat(path,'segs_06/');
patientNumber = 110;
NiftiGiplScanToPngSlices (patientNumber,scans_path,segs_path,path,'train')

% scans for testing unet
scans_path = strcat(path,'scans_test/');
segs_path = strcat(path,'segs_test/');
patientNumber = 110;
NiftiGiplScanToPngSlices (patientNumber,scans_path,segs_path,save_path,'test')
