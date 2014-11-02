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

for i = 1:size(test_files,1)
    fprintf('processing image %d of %d',i, size(test_files,1))
    tic
    GT_im = imread(strcat('GroundTruth/', test_files{i}(1:end-4), '_GT.bmp'));
    im_size1 = size(GT_im, 1);
    im_size2 = size(GT_im, 2);
    
    label_map = uint8(zeros(im_size1, im_size2));
    
    for ii = 1:im_size1,
        for jj = 1:im_size2,
            label_string = sprintf(('%d %d %d'), GT_im(ii,jj,1), GT_im(ii,jj,2), GT_im(ii,jj,3));
            if strcmp(label_string, '0 0 0') || strcmp(label_string, '64 0 0') || strcmp(label_string, '128 0 128')
                continue;
            end
            label_map = reverseLabelMap(labelMap(label_string));
        end
    end
    
    testLabelFolderName = ['TestLabelMaps/'];
        if ~exist(testLabelFolderName, 'dir')
            mkdir(testLabelFolderName);
        end
            
    save([testLabelFolderName, test_files{i}(1:end-4), '.mat'], 'label_map');    
    
    time = toc;
    fprintf('processing time: %f\n', time);    
end

