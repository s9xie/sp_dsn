function patch_img = extract_context(test_img, y, x, AllLabelMap)
    
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

    for i = 1:65,
        for j = 1:65,
            if Y(i,j) >= 1 && X(i,j) >= 1 && Y(i,j) <= img_s1 && X(i,j) <= img_s2
                patch_img(i,j) = AllLabelMap(sprintf(('%d %d %d'), test_img(Y(i,j), X(i,j), 1), ...
                    test_img(Y(i,j), X(i,j), 2), test_img(Y(i,j), X(i,j), 3)));
            end
        end
    end

