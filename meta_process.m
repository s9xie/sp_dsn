keySet = {'64 0 0', '128 0 128', '0 0 0','0 0 128','0 64 0','0 128 0','0 128 128','0 192 0',...
    '0 192 128','64 0 128','64 64 0','64 128 0','64 128 128','128 0 0','128 64 0',...
    '128 64 128','128 128 0','128 128 128','128 192 128','192 0 0',...
    '192 0 128','192 64 0','192 128 0','192 128 128'};
valueSet = {'mountain','horse', 'blank','cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
labelMap = containers.Map(keySet,valueSet);

keySet2 = {'total','mountain','horse', 'blank','cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
valueSet2 = zeros(1,25);
labelCountMap = containers.Map(keySet2,valueSet2);

keySet3 = {'mountain','horse', 'blank','cow','bird','grass','sheep','chair','cat','car','body','water',...
    'flower','bldg','book','road','tree','sky','dog','airplane','bicycle','boat','face','sign'};
valueSet3 = zeros(1,24);
labelCountImageMap = containers.Map(keySet3,valueSet3);

load('file_list.mat')

for i = 1:size(train_files,1)
    %fprintf('\n');
    %fprintf('Image: %s\n', train_files{i});
    im = imread(strcat('GroundTruth/', train_files{i}(1:end-4), '_GT.bmp'));
    %fprintf('Imagesize: %d \n', size(im,1)*size(im,2));
    labelCountMap('total') = labelCountMap('total') + size(im,1)*size(im,2);
    [IND,map] = rgb2ind(im,23);
    map = map*255;
    for id = 1:size(map,1)
        label_string = sprintf(('%d %d %d'), map(id,1), map(id,2), map(id,3));
        %if (~strcmp(label_string, '64 0 0') && ~strcmp(label_string, '128 0 128'))
            %fprintf('%s: %d \n', labelMap(label_string), sum(sum(IND==(id-1))));
            labelCountMap(labelMap(label_string)) = labelCountMap(labelMap(label_string)) + sum(sum(IND==(id-1)));
        %end
        labelCountImageMap(labelMap(label_string)) = labelCountImageMap(labelMap(label_string)) + 1;
    end
end


image_count = zeros(1,21);
label_count = zeros(1,21);
for i = 5:25,
    label_count(i-4) = 1000000*labelCountMap(keySet2{i})/labelCountMap('total');
    fprintf('%s: %f\n', keySet2{i}, 1000000*labelCountMap(keySet2{i})/labelCountMap('total'));
end

for i = 4:24,
    image_count(i-3) = labelCountImageMap(keySet3{i});
    fprintf('%s: %d\n', keySet3{i}, labelCountImageMap(keySet3{i}));
end

per_image_per_label = ceil(label_count ./ image_count);