function batch_isomap
    d = str2num(input('please input id range :', 's'));
    s = d(1);
    e = d(2);
    if ~exist('result', 'dir')
        mkdir('result');
    end
    if ~exist('data', 'dir')
        mkdir('data');
    end
    
    for i= s:e
        dir = ['exemplars' filesep num2str(i)];
        if ~exist([dir '.jpg'], 'file')
            continue;
        end
        if ~exist(['data' filesep num2str(i)], 'dir')
            mkdir(['data' filesep num2str(i)]);
        end
        [c1 c2 c3] = textread('isomap_config.txt', '%s %d %d', 'emptyvalue', NaN);
        opts.ad_kmeans = c2(4);
        opts.numBins_colortexton = round((c3(3))^(1/3));
        opts.numBins_texton = c3(5);
        opts.patchSize = c2(1);
        opts.windowSize = c2(9);
        src_img = imread([dir '.jpg']);
        [row col] = size(src_img(:,:,1));
        imwrite(src_img, ['data' filesep num2str(i) filesep 'src.jpg']);
        imgAnalysis(src_img, ['data' filesep num2str(i)], opts);
        
        coord = load(fullfile('data', num2str(i), 'newCoord-7.txt'));
        coord_range = max(coord) - min(coord);
        dlmwrite(fullfile('data', num2str(i), 'coord_range.txt'), coord_range, ' ');
        prog_x = GenProgressionMap(coord(:,1), row, col, opts);
        prog_y = GenProgressionMap(coord(:,2), row, col, opts);
    
        imwrite(uint8(prog_x), fullfile('data', num2str(i), 'alongX-s.png'));
        imwrite(uint8(prog_y), fullfile('data', num2str(i), 'alongY-s.png'));
        
        %isomap_vis = imread(['data' filesep num2str(i) filesep 'isomap-vis.png']);
        gc_im_x = imread(['data' filesep num2str(i) filesep 'alongX-s.png']);
        gc_im_y = imread(['data' filesep num2str(i) filesep 'alongY-s.png']);
        range = textread(['data' filesep num2str(i) filesep 'coord_range.txt'], '%f', 2);
        [val_1, gc_x]= calGradMag(range(1), gc_im_x, src_img, opts.patchSize, opts.numBins_colortexton); 
        [val_2, gc_y]= calGradMag(range(2), gc_im_y, src_img, opts.patchSize, opts.numBins_colortexton); 
 
        dlmwrite(fullfile('data', num2str(i), 'progressiveness.txt'), [val_1 val_2], ' ');

        imwrite(src_img, ['result' filesep num2str(i) '.png']);
        %imwrite(isomap_vis, ['result' filesep num2str(i) '_vis.png']);
        imwrite(gc_x, ['result' filesep num2str(i) '_src_gcX.png']);
        imwrite(gc_y, ['result' filesep num2str(i) '_src_gcY.png']);
        
%         imwrite(src_img, ['result' filesep num2str(val,'%0.2f') '_' num2str(i) '.png']);
%         imwrite(im, ['result' filesep num2str(val,'%0.2f') '_' num2str(i) '_src_gc.png']);
        
    end
end