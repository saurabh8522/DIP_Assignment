function [output] = DEF_PSNR(img1,img2)
mse=sqrt(mean(mean((img1-img2).^2)));
output=20*log10(255/mse);
end