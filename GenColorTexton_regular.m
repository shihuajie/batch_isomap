function outimg = GenColorTexton_regular(im, numBinsPerChannel)
    [rows cols] = size(im(:,:,1));
    
    im = im2double(im);
    im = reshape(im, rows*cols, 3);
    
    %% regular Patch 3D color histogram
    binID = floor(im*255.0/256.0*numBinsPerChannel);
    
    d1 = numBinsPerChannel*numBinsPerChannel;
    d2 = numBinsPerChannel;
    d3 = 1;
    
   	binID = binID*[d1, d2, d3]';
    
    outimg = uint8(reshape(round(binID/numBinsPerChannel^3*255.0), rows, cols));
    %imwrite(mat2gray(outimg),'..\src_colortexton_regular.png');

end