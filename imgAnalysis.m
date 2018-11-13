function imgAnalysis(im, dir, opts)
    [src_rows src_cols] = size(im(:,:,1));
    
    %% 1. read/gen feature images
    texton = zeros(src_rows, src_cols); 
    colortexton = zeros(src_rows, src_cols); 

    dir_colortexton = [dir filesep 'src_colortexton_regular.png'];
    dir_texton = [dir filesep 'src_texton.png'];

    if(~exist(dir_colortexton, 'file'))
        if(opts.ad_kmeans)
            colortexton = GenColorTexton_kmeans(im, opts.numBins_texton);
        else
            colortexton = GenColorTexton_regular(im, opts.numBins_colortexton);
        end
        imwrite(colortexton, dir_colortexton);
    end

    if(~exist(dir_texton, 'file'))
        texton = genMR8Textons(im, opts.numBins_texton);
        imwrite(texton, dir_texton);
    end

    colortexton = imread(dir_colortexton);  
    texton = imread(dir_texton);


    %% 2. compute 3d color histogram & texton histogram for each patch/cell

    numPatch_row = floor(src_rows/opts.patchSize);
    numPatch_col = floor(src_cols/opts.patchSize);

    hist_color = histfeat_regularPatch(colortexton, opts.patchSize, opts.numBins_colortexton.^3, true);
    hist_texton = histfeat_regularPatch(texton, opts.patchSize, opts.numBins_texton, true);

    hist_color = reshape(hist_color, numPatch_row, numPatch_col, opts.numBins_colortexton.^3);
    hist_texton = reshape(hist_texton, numPatch_row, numPatch_col, opts.numBins_texton);


    %% 3. compute feature vectors for local windows - please compare to previous results here

    numWindow_row = numPatch_row - opts.windowSize + 1;
    numWindow_col = numPatch_col - opts.windowSize + 1;

    featVec_color = featureVec_localWindow(hist_color, opts.windowSize);
    featVec_texton = featureVec_localWindow(hist_texton, opts.windowSize);

    featVec_color = reshape(featVec_color, numWindow_row, numWindow_col, opts.numBins_colortexton.^3);
    featVec_texton = reshape(featVec_texton, numWindow_row, numWindow_col, opts.numBins_texton);

    featVec_color = reshape(permute(featVec_color,[2 1 3]), numWindow_row*numWindow_col, opts.numBins_colortexton.^3);
    featVec_texton = reshape(permute(featVec_texton,[2 1 3]), numWindow_row*numWindow_col, opts.numBins_texton);

    dlmwrite([dir filesep 'featureVec_color.txt'], featVec_color);
    dlmwrite([dir filesep 'featureVec_texton.txt'], featVec_texton);


    %% 4. compute distance matrix
%% compute distance use emd_metric
    numBins = opts.numBins_texton;
    cost = zeros(numBins);
    for i = 1:numBins
        for j = 1:numBins
            cost(i,j) = abs(i-j);
        end
    end

    numsamples = numWindow_row*numWindow_col;
    D = zeros(numsamples);
    for i=1:numsamples-1
        for j=i+1:numsamples
            d_color = emd_hat_gd_metric_mex(featVec_color(i,:)',featVec_color(j,:)', cost);
            d_texton = emd_hat_gd_metric_mex(featVec_texton(i,:)', featVec_texton(j,:)', cost);
            D(i, j) = d_color + d_texton;
            D(j, i) = d_color + d_texton;
        end
    end
%% compute distance use chi_squre
%     numsamples = numWindow_row*numWindow_col;
%     D = zeros(numsamples);
%     for i=1:numsamples-1
%         for j=i+1:numsamples
%             d = Chi_dist(featVec_color(i,:),featVec_color(j,:));
%             D(i, j) = d;
%             D(j, i) = d;
%         end
%     end
    dlmwrite([dir filesep 'distance_EMD1.dat'], D);

    %% 5. Isomap embedding
    opts = 1:10;
    k = 7;
    outputname = [dir filesep 'newCoord-7'];
    [Y R E] = Isomap(D, 'k', k, opts, outputname);
end