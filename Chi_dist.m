function D = Chi_dist(x, y)
    subMatrix = x-y;
    subMatrix2 = subMatrix.^2;
    addMatrix = x+y;

    idxZero = find(addMatrix==0);
    addMatrix(idxZero) = 1;
    DistMat = subMatrix2./addMatrix;
    D = sum(DistMat,2);
end