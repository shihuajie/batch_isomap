function outimg = genMR8Textons(src, numLabel)
    [rows cols channels] = size(src);
    
    src = rgb2gray(im2double(src));
    textons = MR8fast(src);
    opts = statset('Display', 'final');
    [idx,ctrs] = kmeans(textons,numLabel,'Options',opts);

    outimg = mat2gray(reshape(idx,rows,cols));
    %imwrite(mat2gray(outimg),'..\src_texton.png');
    
%     src = im2double(src);
%     [rows cols channels] = size(src);
%     textons = [];%zeros(rows*cols, 8*channels);
%     for ch =1:channels
%         tmp = MR8fast(src(:,:,ch));
%         textons = cat(2, textons, tmp);
%     end
end