function mask_im = Morphological_Wrinkle_mask_detect(I)
% from CoyeFilter_adapt(I)
% clear all;
% close all;

% imname='face_test.jpg';
% I = imread(imname);

% Resize image for easier computation
% B = imresize(I, [584 565]);
% Read image
% im = im2double(B);

% % Convert RGB to Gray via PCA
% lab = rgb2lab(im);
% f = 0;
% wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3);
% [C,S] = pca(wlab);
% S = reshape(S,size(lab));
% S = S(:,:,1);
% gray = (S-min(S(:)))./(max(S(:))-min(S(:)));
resizedimage = imresize(I, [500 500]);
if size(resizedimage,2) > 1
    gray=rgb2gray(resizedimage);
else
    gray=resizedimage;
end
B=resizedimage;

%% Contrast Enhancment of gray image using CLAHE
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);
%% Background Exclusion
% Apply Average Filter
h = fspecial('average', [9 9]);
JF = imfilter(J, h);
% figure(1), imshow(JF), title('Average filter');

% Take the difference between the gray image and Average Filter
Z = imsubtract(JF, J);
% figure(gcf+1), imshow(Z), title('Difference between the gray image and Average Filter');

%% Threshold using the IsoData Method
level=isodata(Z); % this is our threshold level
%level = graythresh(Z)
%% Convert to Binary
BW = im2bw(Z, level-.008);
%% Remove small pixels
BW2 = bwareaopen(BW, 100);
%% Overlay
BW2 = imcomplement(BW2);
out = imoverlay(B, BW2, [0 0 0]);
% figure(gcf+1), imshow(BW2), title('Face Wrinkle mask from Removal small conponents') ;

% Morphological to enhance wrinkle mask
originalI=~BW2;
filter_size = 1;                % parameter to enhance mask
se = strel('disk', filter_size);
% se = strel('line',10,10);

dilatedI = imdilate(originalI,se);
newImg = cat(2,~originalI,~dilatedI);
%figure(double(gcf)+1),imshow(newImg),title('Dilated image');
mask_im=~dilatedI;
% figure(gcf+1),imshow(mask_im),title('Morphological wrinkle mask');
%figure(double(gcf)+1), imshow(mask_im), title('mask_im return by CoyeFilter_adap.m');

% closedI = imclose(originalI,se);
% erodedI = imerode(originalI,se);
% openedI = imopen(originalI,se);


% newImg = cat(2,~originalI,~closedI);
% figure(gcf+1),imshow(newImg),title('Closed image');
% 
% newImg = cat(2,~originalI,~erodedI);
% figure(gcf+1),imshow(newImg),title('Eroded image');
% 
% newImg = cat(2,~originalI,~openedI);
% figure(gcf+1),imshow(newImg),title('Opened image');



