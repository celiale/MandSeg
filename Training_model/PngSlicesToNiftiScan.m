function PngSlicesToNiftiScan (path)

%     path = '../../TMJ_database/xvalidation/test/';

    % Reconstruction of the scan after xvalidation
    % reconstructed scans still have value in [0,1] (prediction from the model)

    % input : path of the test folder containing the data and the results
    % of the deep learning test
    %         (to do : one folder per model)
    % output : each scan reconstructed and saved as "filename"_reconstruct.nii
    
    %% Create folders with all the scans and segs
    
    folder = 'test';
    switch folder
        case 'validation'
            test_path = path;
            xvalidationResults = strcat(test_path,'results/');
        case 'test'
            test_path = strcat(path,'../../test/');
%             modelNum = path(end-1);
            modelNum = '10';
            xvalidationResults = strcat(test_path,'results_model',modelNum,'/');
    end
    
    results = dir(fullfile(xvalidationResults, 'slice*'));
    results = results(~ismember({results.name},{'.','..','.DS_Store'}));
    Patients = [];
    
    AllScans = strcat(path,'../../../AllScansRenamed/Scans/');
    AllSegs = strcat(path,'../../../AllScansRenamed/Segs/');
    scans_path = strcat(test_path,'niftiScans/');
    segs_path = strcat(test_path,'niftiSegs/');
    save_path = strrep(xvalidationResults,'results','results_final');

    if ~isfile(scans_path)
        mkdir(scans_path);
    end
    if ~isfile(segs_path)
        mkdir(segs_path);
    end
    if ~isfile(save_path)
        mkdir(save_path);
    end
        
    for k = 1:length(results)
        name = results(k).name;
        namesplit = split(name,'_');
        patientNumber = str2double(cell2mat(namesplit(2)));
        if isempty(Patients)
            Patients = [patientNumber];
        end
        if ~ismember(Patients, patientNumber)
            Patients = [Patients,patientNumber];
        end
    end
    
    
    for k = 1:length(Patients)
        patientNumber = int2str(Patients(k));
        if ~isfile(strcat(scans_path,patientNumber,'_scan.nii.gz'))
            copyfile(strcat(AllScans,patientNumber,'_scan.nii.gz'),scans_path);
        end
        if ~isfile(strcat(segs_path,patientNumber,'_seg.nii.gz'))
            copyfile(strcat(AllSegs,patientNumber,'_seg.nii.gz'),segs_path);
        end
    end
    
    'Folders created'
    
    
    
    %% Get size of every scan

    % output : sizes - object with each scan ordered by patient number

    % Folder with every scan in format *.nii
%     pathScan = strcat(path,'niftiScans/');
    scans = dir(fullfile(scans_path, '*.gz'));
%     scans = dir(pathScan);
%     scans = scans(~ismember({scans.name},{'.','..','.DS_Store'}));

    sizes = {};

    for k = 1:length(scans)
        name = scans(k).name;
        namesplit = split(name,'_');
        patientNumber = str2double(cell2mat(namesplit(1)))
%         gunzip(fullfile(scans(k).folder, name));

%         if contains(name, 'gipl')
%             info_scan = gipl_read_header(fullfile(scans(k).folder, name));
%             V_scan = gipl_read_volume(info_scan);
%         else
            V_scan = niftiread(fullfile(scans(k).folder, name));
%         end
        S = size(V_scan);
        sizes(patientNumber).size = S;

%         delete(fullfile(scans(k).folder, name(1:end-3)));
    end
    
    
    %% Get number of png slices for each scan 
    
    % output : nbr_slices - object with number of slice for each patient
    
    % Folder with each fold for xvalidation
    pathSlices = strcat(test_path,'scans/');

%     folds = dir(pathSlices);
%     folds = folds(~ismember({folds.name},{'.','..','.DS_Store'}));
    
    nbr_slices = {};
    patientNumber = -1;
    l = 0;
    sliceMin = 450;
    sliceMax = 85;
%     for k = 1:length(folds) 
%         files = dir(strcat(folds(k).folder,'/',folds(k).name));
        files = dir(pathSlices);
        files = files(~ismember({files.name},{'.','..','.DS_Store'}));
        
        for i = 1:length(files)
            splitName = split(files(i).name,'.');
            splitName = split(splitName(1),'_');
            if patientNumber ~= str2double(cell2mat(splitName(2)))
                patientNumber = str2double(cell2mat(splitName(2)));
                sliceMin = 450;
                sliceMax = 85;
            else
                if str2double(cell2mat(splitName(3))) > sliceMax
                    sliceMax = str2double(cell2mat(splitName(3)));
                elseif str2double(cell2mat(splitName(3))) < sliceMin
                    sliceMin = str2double(cell2mat(splitName(3)));
                end
            end
            
            l = sliceMax - sliceMin;
            nbr_slices(patientNumber).nbrSlices = l + 1;
        end
%     end

    %% Reconstruction of the 3D scan
    
    sliceCount = 0;

    for k = 1:length(results)
        
        name = results(k).name;
        nameSplit = split(name,'_');
        patientNumber = str2double(cell2mat(nameSplit(2)));
        slice_nbr = str2double(cell2mat(nameSplit(3)));
        
%         if patientNumber ~= [4,5,6,7,8,9,80,81,82,83]

            sliceCount = sliceCount + 1;

            if sliceCount == 1
                S = sizes(patientNumber).size;
                scan = uint8(zeros(S));
                label = uint8(zeros(S));

            end

            nameLabel = erase(name, "_predict");

            slice_scan = imread(fullfile(results(k).folder, name));
            % should be im2double but not enough space
    %         slice_scan = uint8(slice_scan);
            slice_scan = im2double(slice_scan);
    %         imshow(slice_scan)
    %         slice_scan = imcomplement(slice_scan);
            slice_scan = imresize(slice_scan, [S(1),S(2)]);
    %         thresh = 0.5;
    %         slice_scan(slice_scan>thresh) = 1;
    %         slice_scan(slice_scan<thresh) = 0;
            thresh = graythresh(slice_scan);
            slice_scan = imbinarize(slice_scan,thresh/2);
            scan(:,:,slice_nbr) = slice_scan;

            if sliceCount == nbr_slices(patientNumber).nbrSlices

                % save current scan
    %             savePath = strcat(results(k).folder,"/",num2str(patientNumber)+"_reconstruct");
    %             savePath = strrep(savePath,'results','results_reconstruct');
    %             niftiwrite(scan, savePath);
                sliceCount = 0;

                % Post-processing
                [label, ~] = bwlabeln(scan);
                volume = regionprops3(label, 'Volume');

                for vol = 1:length(volume.Volume) % Remove small components
                    if volume.Volume(vol) < S(1)*S(2)/8
                        label(label == vol) = 0;
                    end
                end

    %             mask = niftiread(strcat(pathScan,"/",num2str(patientNumber),'_scan.nii'));
    %             mask = mask>0.7;
    %             label = activecontour(label,mask,350,'Chan-Vese','ContractionBias',-0.3);

    %             figure;
    %             p = patch(isosurface(double(bw)));
    %             p.FaceColor = 'red';
    %             p.EdgeColor = 'none';
    %             daspect([1 1 27/128]);
    %             camlight; 
    %             lighting phong

                label(label~=0)= 1;

                newSavePath = strcat(save_path,num2str(patientNumber)+"_final");
                niftiwrite(double(label),newSavePath);
                gzip(strcat(newSavePath,'.nii'));
                delete(strcat(newSavePath,'.nii'));

    %             'end'

            end
%         end

    end
    
end

