keySet = {'0 0 0', '64 0 0', '0 0 128','0 64 0','0 128 0','0 128 128','0 192 0',...
    '0 192 128','64 0 128','64 64 0','64 128 0','64 128 128','128 0 0','128 64 0',...
    '128 64 128','128 128 0','128 128 128','128 192 128','192 0 0',...
    '192 0 128','192 64 0','192 128 0','192 128 128'};
valueSet = {'void', 'mountain','cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
labelMap = containers.Map(keySet,valueSet);

keySet2 = {'void', 'mountain', 'cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
valueSet2 = 0:22;
reverseLabelMap = containers.Map(keySet2,valueSet2);

KeySet3 = {'0 0 0', '64 0 0', '0 0 128','0 64 0','0 128 0','0 128 128','0 192 0',...
    '0 192 128','64 0 128','64 64 0','64 128 0','64 128 128','128 0 0','128 64 0',...
    '128 64 128','128 128 0','128 128 128','128 192 128','192 0 0',...
    '192 0 128','192 64 0','192 128 0','192 128 128'};
valueSet3 = 0:22;
AllLabelMap = containers.Map(KeySet3, valueSet3);

for i = 1:size(train_files,1)
    fprintf('processing image %d of %d',i, size(train_files,1))
    tic
    GT_im = imread(strcat('GroundTruth/', train_files{i}(1:end-4), '_GT.bmp'));
    im = imread(strcat('Images/', train_files{i}));
    
    [IND,map] = rgb2ind(GT_im,23);
    map = map*255;
    for id = 2:size(map,1) % 1 is always void
        label_string = sprintf(('%d %d %d'), map(id,1), map(id,2), map(id,3));
        if strcmp(label_string, '0 0 0')
            disp('ERROR, why 000 here?');
        end
        %    label_string = '0 0 0';
        %end %ignore the \del(mountain) and horse patches
        
        numPatches = per_image_per_label(AllLabelMap(label_string)+1);
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
            context = extract_context(GT_im, I(patchIdx(np)), J(patchIdx(np)), AllLabelMap);
            
            patchName = [patchFolderName, train_files{i}(1:end-4), '_', labelMap(label_string), '_' ,int2str(np), '.jpg'];
            contextName = [contextFolderName, train_files{i}(1:end-4), '_', labelMap(label_string), '_' ,int2str(np), '.mat'];

            imwrite(patchImg, patchName, 'JPG');
            save(contextName, 'context');
        end
    end    
    time = toc;
    fprintf('processing time: %f\n', time);
end

