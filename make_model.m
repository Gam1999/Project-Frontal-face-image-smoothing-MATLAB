%**************************************************************************
%Following fnction fit the statistics of sample chrominance values into
%2D Gaussian model and returns the parameters of model
function [rmean,bmean,rbcov]=make_model()
%get crominance values of skin sample images
[cr1, cb1] = get_crcb('sampleset/1.jpg');
[cr2, cb2] = get_crcb('sampleset/2.jpg');
[cr3, cb3] = get_crcb('sampleset/3.jpg');
[cr4, cb4] = get_crcb('sampleset/4.jpg');
[cr5, cb5] = get_crcb('sampleset/5.jpg');
[cr6, cb6] = get_crcb('sampleset/6.jpg');
[cr7, cb7] = get_crcb('sampleset/7.jpg');
[cr8, cb8] = get_crcb('sampleset/8.jpg');
[cr9, cb9] = get_crcb('sampleset/9.jpg');
[cr10, cb10] = get_crcb('sampleset/10.jpg');
[cr11, cb11] = get_crcb('sampleset/11.jpg');
[cr12, cb12] = get_crcb('sampleset/12.jpg');
[cr13, cb13] = get_crcb('sampleset/13.jpg');
%concatenate all values
cr = [cr1 cr2 cr3 cr4 cr5 cr6 cr7 cr8 cr9 cr10 cr11 cr12 cr13];
cb = [cb1 cb2 cb3 cb4 cb5 cb6 cb7 cb8 cb9 cb10 cb11 cr12 cb13];
%compute statistics of sample values
rmean = mean(cr);
bmean = mean(cb);
rbcov = cov(cr,cb);
%The concept of linear transformation of random variables is applied 
%In this case, random variables Cr and Cb are jointly Gaussian
%Write joint distribution function
jointchart = zeros(256);
for r = 0:255
   for b = 0:255
		 x = [(r - rmean);(b - bmean)];
      jointchart(r+1,b+1) = [power(2*pi*power(det(rbcov),0.5),-1)]*exp(-0.5* x'*inv(rbcov)* x);
   end
end
% %plot 2D histogram
% subplot(4,3,1);
% plot_hist2d(cr,cb)
% title('2D Chromatic Histogram Model')
% %plot joint distribution function
% subplot(4,3,2);
% surf(jointchart)
% title('Joint Gaussian Distribution Model')
