function NiftiGiplScanToPngSlices (patientNbr,scans_path,segs_path,save_path,purpose)

    %%Convert every file (nii/gipl) segmentation/label to png slices
    
    % input : Files in format : *.nii.gz / *.gipl.gz

    % output : one folder containing :
    %          -> one folder with all the png slices of the scans 
    %          -> one folder with all the png slices of the segs 
    %          The files are named 'patient_patientNbr_NumSlice.png'
    
    % slices min and max for cropping : 85-450
    sliceMin = 85;
    sliceMax = 450;

    % Input files 
    scans = dir(fullfile(scans_path, '*.gz'));
    segs = dir(fullfile(segs_path, '*.gz'));

    % Create folders
    save_path = strcat(save_path,'/',purpose,'/');
    mkdir(save_path);
    save_path = strcat(save_path,'/AllFiles/');
    SaveScans = strcat(save_path,'scans/');
    SaveSegs = strcat(save_path,'labels/');
    mkdir(SaveScans);
    mkdir(SaveSegs);
    if strcmp(purpose,'test')
        mkdir(strcat(save_path,'results'));
        mkdir(strcat(save_path,'results_reconstruct'));
        niftiScans = strcat(save_path,'niftiScans');
        niftiSegs = strcat(save_path,'niftiSegs');
        mkdir(niftiScans);
        mkdir(niftiSegs);
        mkdir(strcat(save_path,'auc_values'));
    end

    for k = 1:length(scans)
        
        gunzip(strcat(scans_path,scans(k).name));
        gunzip(strcat(segs_path,segs(k).name));

    % Read files depending on the format (nii/gipl)   

        path_scans = strcat(scans_path,scans(k).name(1:end-3));
        path_segs = strcat(segs_path,segs(k).name(1:end-3));
        
        if contains(scans(k).name, 'gipl')
            info_scans = gipl_read_header(path_scans);
            V_scans = gipl_read_volume(info_scans);
            info_segs = gipl_read_header(path_segs);
            V_segs = gipl_read_volume(info_segs);
        else 
            V_scans = niftiread(path_scans);
            V_segs = niftiread(path_segs);
        end
        
        % Pre process for training 
        % Adjusting the contrast for the model training
        V_scans(V_scans<0) = 0;
        V_scans = imadjustn(V_scans);
        
        V_segs = imbinarize(V_segs);
        V_segs(V_segs<0) = 0;
        V_segs = imadjustn(double(V_segs));
        
        S = size(V_scans);

        for z = sliceMin:min(S(3),sliceMax)
            slice_seg = imresize(V_segs(:,:,z) ,[512 512]);
            slice_scan = imresize(V_scans(:,:,z) ,[512 512]);
            
            % Save slice
            SliceScan = sprintf('%s%s%d%s%d%s',SaveScans,'slice_',patientNbr,'_',z,'.png');
            SliceSeg = sprintf('%s%s%d%s%d%s',SaveSegs,'slice_',patientNbr,'_',z,'.png');
            imwrite(im2double(slice_scan),SliceScan);
            imwrite(slice_seg,SliceSeg);
        end 
        
        if strcmp(purpose,'test')
            ScanName = sprintf('%s%s%d%s',niftiScans,'/',patientNbr,'_scan.nii');
            niftiwrite(V_scans,ScanName(1:end-4));
%             gzip(ScanName);
%             delete(ScanName);
            SegName = sprintf('%s%s%d%s',niftiSegs,'/',patientNbr,'_seg.nii');
            niftiwrite(V_segs,SegName(1:end-4));
%             gzip(SegName);
%             delete(SegName);
        end
        
        delete(strcat(scans_path,scans(k).name(1:end-3)));
        delete(strcat(segs_path,segs(k).name(1:end-3)));
        
        patientNbr = patientNbr + 1;

     end

end