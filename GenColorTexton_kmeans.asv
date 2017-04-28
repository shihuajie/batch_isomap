function outimg = GenColorTexton_kmeans(im, numBins_texton)
    [rows cols] = size(im(:,:,1));
    
    im = im2double(im);
    im = reshape(im, rows*cols, 3);
    
    %% kmeans result
    opts = statset('Display', 'final');
    [idx,ctrs] = kmeans(im, numBins_texton, 'Options',opts);
    outimg = mat2gray(reshape(idx,rows,cols));
end