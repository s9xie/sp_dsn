keySet = {'64 0 0', '128 0 128', '0 0 0','0 0 128','0 64 0','0 128 0','0 128 128','0 192 0',...
    '0 192 128','64 0 128','64 64 0','64 128 0','64 128 128','128 0 0','128 64 0',...
    '128 64 128','128 128 0','128 128 128','128 192 128','192 0 0',...
    '192 0 128','192 64 0','192 128 0','192 128 128'};
valueSet = {'mountain','horse', 'blank','cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
labelMap = containers.Map(keySet,valueSet);

keySet2 = {'cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
valueSet2 = [1:21];
reverseLabelMap = containers.Map(keySet2,valueSet2);

parfor i = 1:size(test_files,1)
    fprintf('processing image %d of %d',i, size(test_files,1))
    tic
    GT_im = imread(strcat('GroundTruth/', test_files{i}(1:end-4), '_GT.bmp'));
     
    %Write a image size label map
    use the patch file name as index to query the exact label during training
	    

    [IND,map] = rgb2ind(GT_im,23);
    map = map*255;
    for id = 2:size(map,1) % 1 is always blank
        label_string = sprintf(('%d %d %d'), map(id,1), map(id,2), map(id,3));
        if strcmp(label_string, '0 0 0') || strcmp(label_string, '64 0 0') || strcmp(label_string, '128 0 128')
            continue;
        end %ignore the mountain and horse patches
        numPatches = per_image_per_label(reverseLabelMap(labelMap(label_string)));
        [I,J] = ind2sub(size(IND),find(IND == (id-1)));
        patchIdx = randperm(size(I,1));
        
        if(size(I,1) < numPatches)
           numPatches = size(I,1);
        end
        
        patchIdx = patchIdx(1:numPatches);
        
        patchFolderName = ['Patches/', labelMap(label_string), '/'];
            if ~exist(patchFolderName, 'dir')
                mkdir(patchFolderName);
            end
            
        contextFolderName = ['Context/', labelMap(label_string), '/'];
            if ~exist(contextFolderName, 'dir')
                mkdir(contextFolderName);
            end
        
        for np = 1: numPatches,
            patchImg = extract_patch(im, I(patchIdx(np)), J(patchIdx(np)));
            contextImg = extract_context(GT_im, I(patchIdx(np)), J(patchIdx(np)), labelMap, reverseLabelMap);
            
            patchName = [patchFolderName, test_files{i}(1:end-4), '_', labelMap(label_string), '_' ,int2str(np), '.bmp'];
            contextName = [contextFolderName, test_files{i}(1:end-4), '_', labelMap(label_string), '_' ,int2str(np), '.bmp'];

            imwrite(patchImg, patchName, 'BMP');
            imwrite(contextImg, contextName, 'BMP');
        end
        time = toc;
        fprintf('processing time: %f\n', time);
    end    
end

