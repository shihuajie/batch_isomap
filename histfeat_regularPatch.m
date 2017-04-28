function featVec = histfeat_regularPatch( src, patchSz, numBins, nonoverlapping)
    src = uint8(mat2gray(src)*255); %normalization
    [rows cols channels] = size(src);
    imgW = cols - patchSz + 1;
    imgH = rows - patchSz + 1;
    if(nonoverlapping)
        imgW = floor(cols/patchSz);
        imgH = floor(rows/patchSz);
    end
    
    featVec = zeros(imgW*imgH, numBins);
    num = 0;
    for j = 1:imgW
        for i = 1:imgH
            start_i = i;
            end_i = i + patchSz - 1;
            start_j = j;
            end_j = j + patchSz - 1;
            if(nonoverlapping)
                start_i = (i-1)*patchSz + 1;
                end_i = i*patchSz;
                start_j = (j-1)*patchSz + 1;
                end_j = j*patchSz;
            end
            
            pIm = src(start_i:end_i,start_j:end_j);
                      
            H = imhist(pIm, numBins);
            H = H/(patchSz*patchSz);
            num = num + 1;
            featVec(num, :) = H';
        end
    end
end