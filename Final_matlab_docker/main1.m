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

% Create folders
mkdir(slice_path);
mkdir(seg_path);
mkdir(reconstruct_path);
mkdir(scans_renamed_path);
% mkdir(output_path);

% Convert 3D scans to PNG slices
rename(scans_path,scans_renamed_path,filename_path,extension_path);
ConvertToPngSlices(scans_renamed_path,slice_path);
