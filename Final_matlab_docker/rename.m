function rename(scans_path,scans_renamed_path,filename_path,extension_path)
    
    scans = dir(scans_path);
    scans = scans(~ismember({scans.name},{'.','..','.DS_Store'}));
    
    segs = dir(fullfile(scans_path,'*_seg*'));
    if ~isempty(segs)
        for i = 1:length(segs)
            scans = scans(~ismember({scans.name},{segs.name}));
        end
    end
    
    filenames = fopen(filename_path,'wt');
    extensions = fopen(extension_path,'wt');
    
    patientNbr = 1;
    
    for k = 1:length(scans)
        
        filename = scans(k).name;
        splitName = split(filename,'.');
        
        ext = splitName(2:end);
        extension = '';
        for i = 1:length(ext)
            extension = strcat(extension,'.',cell2mat(ext(i)));
        end
        
        fprintf(extensions, '%s\n', extension);
        fprintf(filenames, '%s\n', cell2mat(splitName(1)));
        
        oldName = strcat(scans_path,filename);
        newName = strcat(scans_renamed_path,int2str(patientNbr),'_scan',extension);
        copyfile(oldName,newName);
        
        patientNbr = patientNbr + 1;
    end
    
    fclose(filenames);

end