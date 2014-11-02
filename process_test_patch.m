parfor i = 1:size(test_files,1)
    fprintf('processing image %d of %d',i, size(test_files,1))
    tic;
    im = imread(strcat('Images/', test_files{i}));
    
    patchFolderName = ['Test_Patches/', test_files{i}(1:end-4), '/'];
    if ~exist(patchFolderName, 'dir')
        mkdir(patchFolderName);
    end
    
    height = size(im, 1);
    width  = size(im, 2);
    count = 0;
    for ii = 1:height,
        for jj = 1:width,
            count = count + 1;
            patchImg = extract_patch(im, ii, jj);
            patchName = [patchFolderName, int2str(count) ,'_', int2str(ii), '_' , int2str(jj), '.bmp'];
            imwrite(patchImg, patchName, 'BMP');
        end
    end
    
    time = toc;
    fprintf('processing time: %f\n', time);   
end

