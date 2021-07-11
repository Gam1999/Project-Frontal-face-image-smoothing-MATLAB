% Following function returns cromatic values of an input image file
function [cr, cb] = get_crcb(filename)
im= imread(filename);
% convert RGB to YCbCr
imycc = rgb2ycbcr(im);
% low pass filter matrix
lpf = 1/9 * ones(3);
% take Cr and Cb channels
cr = imycc(:,:,3);
cb = imycc(:,:,2);
% pass thru low pass filter
cr = filter2(lpf, cr);
cb = filter2(lpf, cb);
%concatenate all rows
cr = reshape(cr, 1, prod(size(cr)));
cb = reshape(cb, 1, prod(size(cb)));
