function ConvertToPngSlices (scans_path,save_path)

    %%Convert every file (nii/gipl) segmentation/label to png slices
    
    % input : Files in format : *.nii.gz / *.gipl.gz

    % output : one folder with all the png slices of the scans 
    %          The files are named 'patientNbr_NumSlice.png'
    
    % slices min and max for cropping : 50-450
    sliceMin = 50;
    sliceMax = 450;

    % Input files
    scans = dir(scans_path);
    scans = scans(~ismember({scans.name},{'.','..','.DS_Store'}));

    for k = 1:length(scans)

    % Read files depending on the format (nii/gipl)   

        path_scans = strcat(scans_path,scans(k).name);
        splitName = split(scans(k).name,'_');
        patientNbr = num2str(cell2mat(splitName(1)));
        
            if contains(scans(k).name, 'gipl')
                info_scans = gipl_read_header(path_scans);
                V_scans = gipl_read_volume(info_scans);
            else 
                V_scans = niftiread(path_scans);
            end

            % Adjusting the contrast
            V_scans(V_scans<0) = 0;
            V_scans = imadjustn(V_scans);

            S = size(V_scans);

            for z = sliceMin:min(S(3),sliceMax)
                slice_scan = imresize(V_scans(:,:,z) ,[512 512]);

                % Save slice
                SliceScan = strcat(save_path,patientNbr,'_',int2str(z),'.png');
                imwrite(im2double(slice_scan),SliceScan);
            end 

     end

end