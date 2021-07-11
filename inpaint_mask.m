function inpainting_mask =inpaint_mask(im)
%% Repair to an image with 50% random artifacts

% Garden at Sainte-Adresse (Monet, 1867)
% imname='monet_adresse.jpg';
%imname='s.jpg';
%imname='Face22.jpeg';
%im = imread(imname);
%figure(1), imshow(im), title('Original image');
% G = double(im);

%gray_im=rgb2gray(im);
% mask_BW = edge(gray_im,'sobel');
% inv_mask_BW = ~mask_BW;


% mask_im = CoyeFilter_adapt(im); % previous wrinkle detect
resizedimage = imresize(im, [500 500]);
mask_im = Morphological_Wrinkle_mask_detect(resizedimage);
mask_BW = ~mask_im;
%inv_mask_BW = mask_im;

%figure(double(gcf)+1), imshow(mask_im), title('mask_im');
%figure(double(gcf)+1), imshow(mask_BW), title('mask_BW');
%figure(double(gcf)+1), imshow(inv_mask_BW), title('inv_mask_BW');

% combine wrinkle mask and skin area mask
[skin_without_eyes_mask]=face_skin_mask_detect(resizedimage);
%figure(double(gcf)+1), imshow(skin_without_eyes_mask), title('skin_without_eyes_mask');
combine_wrinkle_skin_mask = mask_BW .* skin_without_eyes_mask;
%figure(double(gcf)+1), imshow(combine_wrinkle_skin_mask), title('combine_wrinkle_skin_mask');

mask_BW = logical(combine_wrinkle_skin_mask); % set mask to use in inpainting

% figure(1), imshow(mask_im), title('mask_im');
% figure(gcf+1), imshow(mask_BW), title('mask_BW');
% figure(gcf+1), imshow(inv_mask_BW), title('inv_mask_BW');


G=double(resizedimage);
G_R=G(:,:,1);
G_G=G(:,:,2);
G_B=G(:,:,3);
G_R(mask_BW) = NaN;
G_G(mask_BW) = NaN;
G_B(mask_BW) = NaN;
G(:,:,1)=G_R;
G(:,:,2)=G_G;
G(:,:,3)=G_B;

% G(mask_BW) = NaN;

%Gnan = G;

%figure(double(gcf)+1), imshow(inv_mask_BW); , title('mask image');


% G(rand(size(G))<0.50) = NaN;
% Gnan = G;

% inpaint_method = 1;
inpaint_method = 2;
G(:,:,1) = inpaint_nans(G(:,:,1),inpaint_method);
G(:,:,2) = inpaint_nans(G(:,:,2),inpaint_method);
G(:,:,3) = inpaint_nans(G(:,:,3),inpaint_method);

%figure(double(gcf)+1),
%subplot(1,3,1),
%image(im),
%title 'Original image'

%subplot(1,3,2)
%image(uint8(Gnan))
%title 'Image with Mask'

%subplot(1,3,3)
%image(uint8(G))
%title 'Inpainted image'

%figure(double(gcf)+1),
%image(uint8(G))
%title 'Inpainted image'

G1 = uint8(G);
imwrite(G1, 'r.jpg');
inpainting_mask = G1;

