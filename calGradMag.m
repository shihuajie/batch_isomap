function [G_mag, out_im]= calGradMag(range, im, src_img, patchSize, numBins)
    im = imresize(im, floor(size(src_img(:,:,1))/patchSize)*patchSize);
    gray_img = rgb2gray(src_img(1:size(im,1), 1:size(im,2), :));
    diff_im = abs(mat2gray(im) - mat2gray(gray_img));
    diff_inv_im = abs(mat2gray(255-im) - mat2gray(gray_img));
    if(sum(diff_im(:)) < sum(diff_inv_im(:)))
        out_im = im;
    else
%         out_im = mat2gray(255-im);
        out_im = 255-im;
    end
    sz = floor(size(src_img(:,:,1))/patchSize)*patchSize;
    scaleRatio = (prod(sz)/400)^(1/2);
%     scaleRatio = max(sz)/20;
    im = imresize(im, sz/scaleRatio);

    med_im = medfilt2(im,[5,5],'symmetric');
    [GX,GY]=gradient(double(med_im));
    G_mag = sqrt(GX.*GX+GY.*GY);
    G_mag = sum(G_mag(:))/prod(size(med_im));
    G_mag = range*G_mag/(2*numBins);
end