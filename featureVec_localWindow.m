function featVec = featureVec_localWindow(feat, windowSz)
    [rows, cols, numBins] = size(feat);
    numWindow_row = rows - windowSz + 1;
    numWindow_col = cols - windowSz + 1;

    featVec = zeros(numWindow_row*numWindow_col, numBins);

    num = 0;
    for j=1:numWindow_col
        for i=1:numWindow_row
            num = num + 1;
            for k=1:windowSz
                for l=1:windowSz
                    featVec(num, :) = featVec(num, :) + reshape(feat(i+k-1, j+l-1, :), 1, []);
                end
            end
            featVec(num, :) = featVec(num, :)/sum(sum(featVec(num, :)));
        end
    end
end