clear variables
close all

OriginalPath = '../../TMJ_database/AllFiles/';
EndPath = '../../TMJ_database/xvalidation/XV/';

FilesTest = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 80 81 82 83 110];
FilesFolds = [
                [15 16 17 18 19 20 84 85 111];
                [21 22 23 24 25 26 86 87 112];
                [27 28 29 30 31 32 88 89 113];
                [33 34 35 36 37 38 90 91 114];
                [39 40 41 42 43 44 92 93 115];
                [45 46 47 48 49 50 94 95 116];
                [51 52 53 54 55 56 96 97 117];
                [57 58 59 60 61 62 98 99 118];
                [63 64 65 66 67 68 69 100 101];
                [70 71 72 73 74 75 76 102 119]
             ];
      
NbrFolds = length(FilesFolds);

AllScans = dir(strcat(OriginalPath,'scans/'));
AllSegs = dir(strcat(OriginalPath,'labels/'));
AllScans = AllScans(~ismember({AllScans.name},{'.','..','.DS_Store'}));
AllSegs = AllSegs(~ismember({AllSegs.name},{'.','..','.DS_Store'}));

% Create folders
TestPath = strcat(EndPath,'/test/');
ScansTestPath = strcat(TestPath,'scans/');
SegsTestPath = strcat(TestPath,'segs/');
mkdir(TestPath);
mkdir(ScansTestPath);
mkdir(SegsTestPath);

for fold = 1:NbrFolds
    SavePath = sprintf('%s%s%d',EndPath,'Fold',fold);
    mkdir(SavePath);
    ScansTrainPath = strcat(SavePath,'/scans/');
    SegsTrainPath = strcat(SavePath,'/segs/');
    mkdir(ScansTrainPath);
    mkdir(SegsTrainPath);
end

for file = 1:length(AllScans)
    
    % Get patient number
    nameScan = AllScans(file).name;
    nameSeg = AllSegs(file).name;
    scan = imread(fullfile(AllScans(file).folder,nameScan));
    seg = imread(fullfile(AllSegs(file).folder,nameSeg));
    nameSplit = split(nameScan,'_');
    PatientNbr = str2double(cell2mat(nameSplit(2)));

    if ismember(PatientNbr,FilesTest)
        imwrite(scan,strcat(ScansTestPath,nameScan));
        imwrite(seg,strcat(SegsTestPath,nameSeg));
    else
        for fold = 1:NbrFolds
            NbrFilesFold = FilesFolds(fold,:);
            if ismember(PatientNbr,NbrFilesFold)
                imwrite(scan,sprintf('%s%s%d%s%s',EndPath,'Fold',fold,'/scans/',nameScan));
                imwrite(seg,sprintf('%s%s%d%s%s',EndPath,'Fold',fold,'/segs/',nameSeg));
            end
        end
    end

end


% for fold = 1:NbrFolds
%     NbrFilesTest = FilesFolds(fold,:);
%     
%     % Create folders
%     SavePath = sprintf('%s%s%d',TrainPath,'Fold',fold);
%     mkdir(SavePath);
%     ScansTrainPath = strcat(TrainPath,'scans/');
%     SegsTrainPath = strcat(TrainPath,'segs/');
%     mkdir(ScansTrainPath);
%     mkdir(SegsTrainPath);
%     
%     % Add files to the folders
%     for file = 1:length(AllScans)
%         
%         nameScan = AllScans(file).name;
%         nameSeg = AllSegs(file).name;
%         scan = imread(fullfile(AllScans(file).folder,nameScan));
%         seg = imread(fullfile(AllSegs(file).folder,nameSeg));
%         nameSplit = split(nameScan,'_');
%         PatientNbr = str2double(cell2mat(nameSplit(2)));
%         
%         if ismember(PatientNbr,NbrFilesTest)
%             imwrite(scan,strcat(ScansTestPath,nameScan));
%             imwrite(seg,strcat(SegsTestPath,nameSeg));
%         else
%             imwrite(scan,strcat(ScansTrainPath,nameScan));
%             imwrite(seg,strcat(SegsTrainPath,nameSeg));
%         end
%         
%     end
% end


