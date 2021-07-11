%**************************************************************************
%Following function convert original image into normalized skin likelyhood image
function[likely_skin]=get_likelyhood(filename,rmean,bmean,rbcov)
%read input file 
if ischar(filename)
    img = imread(filename);
else
    img = filename;
end
% convert RGB to YCrCb color space
imycbcr = rgb2ycbcr(img);
[m,n,l] = size(img);
%create a 2D matrix with same dimension of image
likely_skin = zeros(m,n);
for i = 1:m
   for j = 1:n
      %get crominance values for each pixel
      cr = double(imycbcr(i,j,3));
      cb = double(imycbcr(i,j,2));
      %compute the likelyhood of each pixel
      x = [(cr-rmean);(cb-bmean)];
      likely_skin(i,j) = [power(2*pi*power(det(rbcov),0.5),-1)]*exp(-0.5* x'*inv(rbcov)* x);
   end
end
%pass thru low pass filter
lpf= 1/9*ones(3);
likely_skin = filter2(lpf,likely_skin);
%normalize the likelyhood values with maximum value
likely_skin = likely_skin./max(max(likely_skin));

% %show skin likelyhood grayscale image
% subplot(4,3,3);
% imshow(img, [0 1])
% title('Original RGB Image')
% subplot(4,3,4);
% imshow(likely_skin, [0 1])
% title('Skin Likelyhood Image')

%**************************************************************************
%Following function take likelyhood image as input and segment it into binary image by
%setting the threshold adaptively
function [binary_skin,opt_th] = segment_adaptive(likely_skin)
%intialize
[m,n] = size(likely_skin);
temp = zeros(m,n);
diff_list = [];
%set threshold range and stepsize by experiment
high=0.55;
low=0.01;
step_size=-0.1;
bias_factor=1;
indx_count=[(high-low)/abs(step_size)]+2;
%finding optimal threshold
for threshold = high:step_size:low
   binary_skin = zeros(m,n);
   binary_skin(find(likely_skin>threshold)) = 1;
   diff = sum(sum(binary_skin - temp));
   diff_list = [diff_list diff];
   temp = binary_skin;
end
%optimal threshold is the threshold where minimum diff occur
[C, indx] = min(diff_list);
opt_th = (indx_count-indx)*abs(step_size)*bias_factor;
% reset the binary_skin image matrix
binary_skin = zeros(m,n);
binary_skin(find(likely_skin>opt_th)) = 1;
% %show skin segmented binary image
% subplot(4,3,5);
% imshow(binary_skin, [0 1])
% title('Skin Segmented Image')
