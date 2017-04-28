function featVec_color = Lab_regularPatch(src, opts)
    [rows, cols, numBins] = size(src);
    imgW = floor(cols/opts.patchSize);
    imgH = floor(rows/opts.patchSize);
    
    vec_color = zeros(imgW*imgH, numBins);
    num = 0;
    for j = 1:imgW
        for i = 1:imgH
            start_i = (i-1)*opts.patchSize + 1;
            end_i = i*opts.patchSize;
            start_j = (j-1)*opts.patchSize + 1;
            end_j = j*opts.patchSize;
            
            pIm = src(start_i:end_i,start_j:end_j, :);
            pIm = reshape(pIm, opts.patchSize*opts.patchSize, numBins);
            H = sum(pIm, 1)/(opts.patchSize*opts.patchSize);
            num = num + 1;
            vec_color(num, :) = H';
        end
    end
    vec_color = reshape(vec_color, imgH, imgW, 3);
    
    numWindow_row = imgH - opts.windowSize + 1;
    numWindow_col = imgW - opts.windowSize + 1;

    featVec = zeros(numWindow_row*numWindow_col, numBins);

    num = 0;
    for j=1:numWindow_col
        for i=1:numWindow_row
            num = num + 1;
            for k=1:opts.windowSize
                for l=1:opts.windowSize
                    featVec(num, :) = featVec(num, :) + reshape(vec_color(i+k-1, j+l-1, :), 1, []);
                end
            end
            featVec(num, :) = featVec(num, :)/sum(sum(featVec(num, :)));
        end
    end
    featVec_color = reshape(featVec, numWindow_row, numWindow_col, numBins);
    
end