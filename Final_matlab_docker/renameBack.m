function renameBack(reconstruct_path,output_path,filename_path,extension_path)
    
    scans = dir(reconstruct_path);
    scans = scans(~ismember({scans.name},{'.','..','.DS_Store'}));
    
    filenames = fopen(filename_path);
    extensions = fopen(extension_path);
    patientNbr = 1;
    
    for k = 1:length(scans)
        
        ext = fgetl(extensions);
        oldName = strcat(reconstruct_path,num2str(patientNbr),'_segmented',ext);
        disp(oldName)
        newName = strcat(output_path,fgetl(filenames),'_seg',ext);
        disp(newName)
        
        if isfile(newName)
            delete(newName);
        end
        
        copyfile(oldName,newName);
        patientNbr = patientNbr + 1;
        
    end

end
