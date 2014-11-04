function patch_img = extract_context(test_img, y, x, labelMap, reverseLabelMap)
    
    image_size = size(test_img);
    img_s1 = image_size(1);
    img_s2 = image_size(2);
    
    list_x = [x-48:2:x-18, x-16:x-1, x, x+1:x+16, x+18: 2: x+48];
    list_y = [y-48:2:y-18, y-16:y-1, y, y+1:y+16, y+18: 2: y+48];
    % x,y +-16 dense 1 pixel, then every two pixel take 16 pixels

    %three fold features
    %list_x = [x-64: 4: x-36, x-32:2:x-18, x-16:x-1, x, x+1:x+16, x+18: 2: x+32, x+36: 4: x+64];
    %list_y = [y-64: 4: y-36, y-32:2:y-18, y-16:y-1, y, y+1:y+16, y+18: 2: y+32, y+36: 4: y+64];

    [X,Y] = meshgrid(list_x, list_y);

    patch_img = uint8(zeros(65,65));

    parfor i = 1:65,
        for j = 1:65,
            yy = Y(i,j);
            xx = X(i,j);
            if yy >= 1 && xx >= 1 && yy <= img_s1 && xx <= img_s2
                label_string = sprintf(('%d %d %d'), test_img(yy, xx, 1), test_img(yy, xx, 2), test_img(yy, xx, 3));
                if ~strcmp(label_string, '0 0 0') && ~strcmp(label_string, '64 0 0') && ~strcmp(label_string, '128 0 128'),    
                    patch_img(i,j) = reverseLabelMap(labelMap(label_string));
                end
            end
        end
    end

