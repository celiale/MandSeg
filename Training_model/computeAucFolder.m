function computeAucFolder (pathFold)
    
%     pathFold = '../../TMJ_database/xvalidation/test/';

    folder = 'test';
    switch folder
        case 'validation'
            pathResults = strcat(pathFold, 'results_final/');
            saveName = strcat(pathFold, 'auc_values.xlsx');
        case 'test'
%             modelNum = pathFold(end-1);
            modelNum = '10';
            pathFold = strcat(pathFold,'../../test/');
            pathResults = strcat(pathFold,'results_final_model',modelNum,'/');
            saveName = strcat(pathFold, 'auc_values_model',modelNum,'.xlsx');
    end
%     pathAUC = strcat(pathFold, 'auc_values/');
    
    results = dir(pathResults);
    results = results(~ismember({results.name},{'.','..','.DS_Store'}));
    
    File = {};
    AUC = [];
    F1 = [];
    Sensitivity = [];
    Specificity = [];
    Accuracy = [];
    
    NbrFiles = length(results);
    list = [];
    for k = 1:NbrFiles
        name = results(k).name;
        splitName = split(name, '_');
        patientNum = splitName(1);
        list(k) = str2double(cell2mat(patientNum));
    end
    
    for k = list
        
        [auc,f1,sensitivity,specificity,accuracy] = AucPatient(k,pathResults);
        File{end+1} = round(k,4);
        AUC(end+1) = round(auc,4);
        F1(end+1) = round(f1,4);
        Sensitivity(end+1) = round(sensitivity,4);
        Specificity(end+1) = round(specificity,4);
        Accuracy(end+1) = round(accuracy,4);

    end
    
    model_mean = [];
    model_mean(1) = sum(AUC(:))/NbrFiles;
    model_mean(2) = sum(F1(:))/NbrFiles;
    model_mean(3) = sum(Sensitivity(:))/NbrFiles;
    model_mean(4) = sum(Specificity(:))/NbrFiles;
    model_mean(5) = sum(Accuracy(:))/NbrFiles;
    
    File{end+1} = 'model';
    AUC(end+1) = round(model_mean(1),4);
    F1(end+1) = round(model_mean(2),4);
    Sensitivity(end+1) = round(model_mean(3),4);
    Specificity(end+1) = round(model_mean(4),4);
    Accuracy(end+1) = round(model_mean(5),4);
    
    varNames = {'File','AUC','F1','Sensitivity','Specificity','Accuracy'};
    T = table(File',AUC',F1',Sensitivity',Specificity',Accuracy','VariableNames',varNames');

%     save(saveName,'model_mean');
    writetable(T,saveName);
    
end