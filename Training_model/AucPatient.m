function [auc,f1,sensitivity,specificity,accuracy] = AucPatient(patientNumber,pathResults)
    
    % path to the folder with the ground truth segmentation 3D scans
%     pathGroundTruth = strcat(test_path,'niftiSegs/');
    pathGroundTruth = strcat(pathResults,'../niftiSegs/');

%     class(patientNumber)
    
    labelName = strcat(pathGroundTruth, num2str(patientNumber), '_seg.nii.gz');
    scanName = strcat(pathResults, num2str(patientNumber), '_final.nii.gz');
    
%     gunzip(labelName);
%     gunzip(scanName);
    label = niftiread(labelName);
    S = size(label);
    label = imresize3(label, [512, 512, S(3)], 'linear');
    label = label(:);

    prediction = im2double(niftiread(scanName));
    Sp = size(prediction);
    prediction = imresize3(prediction, [512, 512, Sp(3)], 'linear');
    prediction = prediction(:); 
    
%     max(prediction)
    
    [auc,f1,sensitivity,specificity,accuracy] = AUC(double(imbinarize(label)),double(imbinarize(prediction)));
    
%     values = [auc,f1,sensitivity,specificity,accuracy];
%     
%     saveName = sprintf('%s/auc_values/value_%d.mat',test_path, patientNumber);
%     save(saveName,'values')
%     delete(labelName(1:end-3));
%     delete(scanName(1:end-3));

end