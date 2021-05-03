function ConvertToNiftiScan (scans_renamed_path,seg_path,reconstruct_path,extension_path)


    % Reconstruction of the scan after xvalidation
    % reconstructed scans still have value in [0,1] (prediction from the model)

    % input : path of the test folder containing the data and the results
    % of the deep learning test
    %         (to do : one folder per model)
    % output : each scan reconstructed and saved as
    % "filename"_reconstruct.nii.gz

    %% Reconstruction of the 3D scan
    
    results = dir(seg_path);
    results = results(~ismember({results.name},{'.','..','.DS_Store'}));
    
    patientNbr = 0;
    cpt = 0;
    extensions = fopen(extension_path);

    for k = 1:length(results)
        
        name = results(k).name;
        nameSplit = split(name,'_');
        newPatientNbr = str2double(cell2mat(nameSplit(1)));
        slice_nbr = str2double(cell2mat(nameSplit(2)));

        if newPatientNbr ~= patientNbr
            
            if cpt ~= 0
                
                [label, ~] = bwlabeln(scan);
                volume = regionprops3(label, 'Volume');
                for vol = 1:length(volume.Volume) % Remove small components
                    if volume.Volume(vol) < S(1)*S(2)/8
                        label(label == vol) = 0;
                    end
                end
                label(label~=0)= 1;

                % Save scan
                save_path = strcat(reconstruct_path,num2str(patientNbr),'_segmented');
                niftiwrite(double(label),save_path);
                gzip(strcat(save_path,'.nii'));
                delete(strcat(save_path,'.nii'));
            
            end
            
            % New scan
            patientNbr = newPatientNbr;
            scan_name = strcat(num2str(patientNbr),'_scan',fgetl(extensions));
            if contains(scan_name, 'gipl')
                info_scan = gipl_read_header(fullfile(scans_renamed_path, scan_name));
                V_scan = gipl_read_volume(info_scan);
            else
                V_scan = niftiread(fullfile(scans_renamed_path, scan_name));
            end
            S = size(V_scan);
            scan = uint8(zeros(S));
            cpt = 1;
            
        end

        slice_scan = imread(fullfile(results(k).folder, name));
        slice_scan = im2double(slice_scan);
        slice_scan = imresize(slice_scan, [S(1),S(2)]);
        thresh = graythresh(slice_scan);
        slice_scan = imbinarize(slice_scan,thresh/2);
        scan(:,:,slice_nbr) = slice_scan;
        
        if k == length(results)
        
            [label, ~] = bwlabeln(scan);
            volume = regionprops3(label, 'Volume');
            for vol = 1:length(volume.Volume) % Remove small components
                if volume.Volume(vol) < S(1)*S(2)/8
                    label(label == vol) = 0;
                end
            end
            label(label~=0)= 1;
        
            % Save scan
            save_path = strcat(reconstruct_path,num2str(patientNbr),'_segmented');
            niftiwrite(double(label),save_path);
            gzip(strcat(save_path,'.nii'));
            delete(strcat(save_path,'.nii'));
            
        end

    end
    
    
    
end

