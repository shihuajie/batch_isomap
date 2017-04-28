function imgAnalysis(im, dir, opts)
    [src_rows, src_cols] = size(im(:,:,1));
    startTime = tic;
    %% 1. read/gen feature images
    % old method
%     num_row = floor(src_rows / opts.patchSize) - opts.windowSize + 1;
%     num_col = floor(src_cols / opts.patchSize) - opts.windowSize + 1;
%     im = imresize(im, [num_row num_col]);
%     
    lab_im = rgb2lab(im);

    % new method
    featVec_color = Lab_regularPatch(lab_im, opts);
    
    %% 2. compute distance matrix
    num_row = floor(src_rows / opts.patchSize) - opts.windowSize + 1;
    num_col = floor(src_cols / opts.patchSize) - opts.windowSize + 1;
    featVec_color = reshape(permute(featVec_color,[2 1 3]), num_row*num_col, 3);
    D = pdist2(featVec_color, featVec_color); %full distance matrix

    %% 3. Isomap embedding
    opts = 1:10;
    k = 7;
    outputname = [dir filesep 'newCoord-7'];
    [Y R E] = Isomap(D, 'k', k, opts, outputname);
    
    elapsedTime = toc(startTime);
    disp(['Build neighbor graph cost: ' num2str(elapsedTime/60, '%.2f') ' minutes']);
end