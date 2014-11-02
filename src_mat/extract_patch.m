function patch_img = extract_patch(test_img, y, x)


%test_img = test_img(:,:,1);
%imshow(test_img);
image_size = size(test_img);

list_x = [x-32:x-1, x, x+1:x+32];
list_y = [y-32:y-1, y, y+1:y+32];

%%%%%%%%%%%%%Label creation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%list_x = [x-48:2:x-18, x-16:x-1, x, x+1:x+16, x+18: 2: x+48];
%list_y = [y-48:2:y-18, y-16:y-1, y, y+1:y+16, y+18: 2: y+48];
% x,y +-16 dense 1 pixel, then every two pixel take 16 pixels

%three fold features
%list_x = [x-64: 4: x-36, x-32:2:x-18, x-16:x-1, x, x+1:x+16, x+18: 2: x+32, x+36: 4: x+64];
%list_y = [y-64: 4: y-36, y-32:2:y-18, y-16:y-1, y, y+1:y+16, y+18: 2: y+32, y+36: 4: y+64];

[X,Y] = meshgrid(list_x, list_y);
% count = 1;
% for i=1:size(list_x,2),
%     for j = 1:size(list_y,2),
%         total{count} = [Y(i,j), X(i,j)];
%         count = count + 1;
%     end
% end

patch_img = uint8(zeros(65,65,3));

for i = 1:65,
    for j = 1:65,
        yy = Y(i,j);
        xx = X(i,j);
        if yy >= 1 && xx >= 1 && yy <= image_size(1) && xx <= image_size(2)
            patch_img(i,j,1) = test_img(yy, xx, 1);
            patch_img(i,j,2) = test_img(yy, xx, 2);
            patch_img(i,j,3) = test_img(yy, xx, 3);
        end
    end
end


%imshow(patch_img,[0,255]);


