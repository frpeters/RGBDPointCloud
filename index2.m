fid = fopen('resultado3.pcd','wt');
fprintf(fid, '# .PCD v.7 - Point Cloud Data file format\nVERSION .7\nFIELDS x y z rgb\nSIZE 4 4 4 4\nTYPE F F F F\nCOUNT 1 1 1 1\nWIDTH 38140\nHEIGHT 1\nVIEWPOINT 0 0 0 1 0 0 0\nPOINTS 38140\nDATA ascii\n');
[previous, distance] = depthToCloud(imread(strcat('00000-depth.png')));
previous = reshape(previous, 3, []);
pts = reshape(previous,size(previous,1)*size(previous,2)/3,3);
 for j=1:size(pts, 1)
        fprintf(fid, '%f %f %f 4.2108e+06\n', pts(j, 1), pts(j, 2), pts(j, 3));
 end
 for i=1:25:887
    if (i<10)
        [pcloud, distance] = depthToCloud(imread(strcat('0000',int2str(i),'-depth.png')));
    elseif (i<100)
        [pcloud, distance] = depthToCloud(imread(strcat('000',int2str(i),'-depth.png')));
    else
        [pcloud, distance] = depthToCloud(imread(strcat('00',int2str(i),'-depth.png')));
    end
    %{
    pts = reshape(pcloud,size(pcloud,1)*size(pcloud,2),3);
    pts = bsxfun(@plus,poses(i,5:7),quatrotate([poses(i,1) -poses(i,2:4)],pts));
    for j=1:size(pts, 1)
        fprintf(fid, '%f %f %f 4.2108e+06\n', pts(j, 1), pts(j, 2), pts(j, 3));
    end
    %}
    %TR * p + TT = q.
    
    pts = reshape(pcloud,size(pcloud,1)*size(pcloud,2),3);
    pts = reshape(pts, 3, []);
    [TR, TT] = icp(pts, previous, 10, 'EdgeRejection', true, 'Boundary', bound, 'Matching', 'kDtree');
    pts = TR*pts;
    i
    pts = bsxfun(@plus, TT, pts);
    pts = reshape(pts,size(pts,1)*size(pts,2)/3,3);
    for j=1:size(pts, 1)
        fprintf(fid, '%f %f %f 4.2108e+06\n', pts(j, 1), pts(j, 2), pts(j, 3));
    end
    previus = pts;
end
fclose(fid);



