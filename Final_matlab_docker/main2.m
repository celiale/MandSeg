clear variables
close all

% Paths
scans_path = '../Scans/';
scans_renamed_path = '../Renamed/';
slice_path = '../Slices/';
seg_path = '../Slices_segmented/';
reconstruct_path = '../Reconstruct/';
output_path = '../Output/';
filename_path = '../filenames.txt';
extension_path = '../extensions.txt';

%  Convert PNG slices from deep learning to 3D nifti scans
ConvertToNiftiScan (scans_renamed_path,seg_path,reconstruct_path,extension_path);
renameBack(reconstruct_path,output_path,filename_path,extension_path);

