function prog_X = GenProgressionMap(coord_X, src_row, src_col, Opts)
    patchCount_y = floor(src_row / Opts.patchSize);
    patchCount_x = floor(src_col / Opts.patchSize);
    
    prog_X = zeros(patchCount_y, patchCount_x);
    update_X = zeros(patchCount_y, patchCount_x);
    
    blockCount_y = patchCount_y - Opts.windowSize + 1;
    blockCount_x = patchCount_x - Opts.windowSize + 1;
    numSamples = size(coord_X);
    if(numSamples ~= blockCount_y*blockCount_x)
        fprintf('Warning: some samples are missing!');
    end
    
    % normalize coordinates
    maxX = max(coord_X);
    minX = min(coord_X);
    if(maxX > minX)
        normalizeX = (coord_X - repmat(minX, blockCount_y*blockCount_x, 1)) / (maxX - minX);
    else
        normalizeX = ones(blockCount_y*blockCount_x, 1);
    end
    
    % update progression map
    for i = 1:numSamples
        cy_topleft = floor( (i-1) / blockCount_x) + 1;
        cx_topleft = mod( i-1, blockCount_x) + 1;
        
        xValue = normalizeX(i);
        xValue = 1 - xValue;
		colorX = 255.0*xValue;
        
        for dy = 0:Opts.windowSize-1
            for dx = 0:Opts.windowSize-1
   				cy = cy_topleft + dy;
				cx = cx_topleft + dx;	
				updateCount = update_X(cy, cx);
				oldColorX = prog_X(cy, cx);

                newcolorX = floor( (oldColorX*updateCount + colorX) / (updateCount+1.0) + 0.5 );
				prog_X(cy, cx) = newcolorX;

				update_X(cy, cx) = updateCount+1;
            end
        end
    end

end