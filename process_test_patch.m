keySet = {'64 0 0', '0 0 0','0 0 128','0 64 0','0 128 0','0 128 128','0 192 0',...
    '0 192 128','64 0 128','64 64 0','64 128 0','64 128 128','128 0 0','128 64 0',...
    '128 64 128','128 128 0','128 128 128','128 192 128','192 0 0',...
    '192 0 128','192 64 0','192 128 0','192 128 128'};
valueSet = {'mountain', 'void','cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
labelMap = containers.Map(keySet,valueSet);

keySet2 = {'mountain', 'void', 'cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
valueSet2 = 1:23;
reverseLabelMap = containers.Map(keySet2,valueSet2);

parfor i = 1:size(test_files,1)
    fprintf('processing image %d of %d',i, size(test_files,1))
    tic;
    im = imread(strcat('Images/', test_files{i}));
    GT_im = imread(strcat('GroundTruth/',test_files{i}(1:end-4),'_GT.bmp'));
    patchFolderName = ['Test_Patches_JPG/', test_files{i}(1:end-4), '/'];
    if ~exist(patchFolderName, 'dir')
        mkdir(patchFolderName);
    end

    height = size(im, 1);
    width  = size(im, 2);
    count = 0;
    for ii = 1:height,
        for jj = 1:width,
            label_string = sprintf(('%d %d %d'), GT_im(ii,jj,1), GT_im(ii,jj,2), GT_im(ii,jj,3));
            if strcmp(label_string, '128 0 128')
                label_string = '0 0 0'; %skip horse:q
            end

            count = count + 1;
            patchImg = extract_patch(im, ii, jj);
            patchName = [patchFolderName, int2str(count) ,'_', int2str(ii), '_' , int2str(jj),'_',labelMap(label_string),'_', int2str(reverseLabelMap(labelMap(label_string))), '.jpg'];
            imwrite(patchImg, patchName, 'JPG');
        end
    end

    time = toc;
    fprintf('processing time: %f\n', time);
end
