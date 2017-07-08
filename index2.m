fid = fopen('resultado15.pcd','wt');
fprintf(fid, '# .PCD v.7 - Point Cloud Data file format\nVERSION .7\nFIELDS x y z rgb\nSIZE 4 4 4 4\nTYPE F F F F\nCOUNT 1 1 1 1\nWIDTH 8293403\nHEIGHT 1\nVIEWPOINT 0 0 0 1 0 0 0\nPOINTS 8293403\nDATA ascii\n');
[previous, distance] = depthToCloud(imread(strcat('00000-depth.png')));
previous = reshape(previous, 3, []);
pts = reshape(previous,size(previous,1)*size(previous,2)/3,3);
 for j=1:size(pts, 1)
        fprintf(fid, '%f %f %f 4.2108e+06\n', pts(j, 1), pts(j, 2), pts(j, 3));
 end
 R = [1 0 0; 0 1 0; 0 0 1];
 T = [0 0 0];
 accTM = [R(1, 1), R(1, 2), R(1, 3), T(1); R(2, 1), R(2, 2), R(2, 3), T(2); R(3, 1), R(3, 2), R(3, 3), T(3); 0 0 0 1]
 
 for i=1:100
    if (i<10)
        [pcloud, distance] = depthToCloud(imread(strcat('0000',int2str(i),'-depth.png')));
    elseif (i<100)
        [pcloud, distance] = depthToCloud(imread(strcat('000',int2str(i),'-depth.png')));
    else
        [pcloud, distance] = depthToCloud(imread(strcat('00',int2str(i),'-depth.png')));
    end
    %[R,T] = icp(q,p,10);
    %R * p + T = q.
    pts = reshape(pcloud, 3,[]);
    previous = reshape(previous, 3, []);
    pts(isnan(pts))=0;
    previous(isnan(previous))=0;
    [TR, TT] = icp(previous, pts, 15, 'Matching', 'kDtree', 'Extrapolation', true);
    %[Points_Moved, TM] = ICP_finite(previous, pts, struct('Registration','Size'));
    TM = [TR(1, 1), TR(1, 2), TR(1, 3), TT(1); TR(2, 1), TR(2, 2), TR(2, 3), TT(2); TR(3, 1), TR(3, 2), TR(3, 3), TT(3); 0 0 0 1]
    accTM = accTM*TM
    %quat = rotm2quat([accTM(1,1), accTM(1, 2), accTM(1, 3); accTM(2, 1), accTM(2, 2), accTM(2, 3); accTM(3, 1), accTM(3, 2), accTM(3, 3)])
    pts = reshape(pcloud, 4, []);
    pts = accTM*pts;
    %pts = reshape(pts,size(pts,1)*size(pts,2)/3,3);
    %pts = quatrotate(quat, pts);
    %pts = bsxfun(@plus, [accTM(1, 4), accTM(2, 4), accTM(3, 4)], pts);
    %pts = quatrotate(quat, pts);
    pts = reshape(pts, 3, []);
    %pts = bsxfun(@plus, T, pts);
    previous = pts;
    pts = reshape(pts,size(pts,1)*size(pts,2)/3,3);
    for j=1:size(pts, 1)
        if (isnan(pts(j,1)))
            continue
        else
            fprintf(fid, '%f %f %f 4.2108e+06\n', pts(j, 1), pts(j, 2), pts(j, 3));
        end
    end
    i
 end
 
fclose(fid);



