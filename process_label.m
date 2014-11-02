map_all = [];
for i = 1:size(train_files,1),
    im = imread(strcat('GroundTruth/', train_files{i}(1:end-4), '_GT.bmp'));
    [x,map] = rgb2ind(im,65536);
    map_all = [map_all; map*255];
end
for i = 1:size(test_files,1),
    im = imread(strcat('GroundTruth/', test_files{i}(1:end-4), '_GT.bmp'));
    [x,map] = rgb2ind(im,65536);
    map_all = [map_all; map*255];
end