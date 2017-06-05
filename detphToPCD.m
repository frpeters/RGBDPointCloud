depth = imread('00000-depth.png');
[pcloud, distance] = depthToCloud(depth);
fid = fopen('result.pcd','wt');
fprintf(fid, '# .PCD v.7 - Point Cloud Data file format\nVERSION .7\nFIELDS x y z rgb\nSIZE 4 4 4 4\nTYPE F F F F\nCOUNT 1 1 1 1\nWIDTH 640\nHEIGHT 480\nVIEWPOINT 0 0 0 1 0 0 0\nPOINTS 307200\nDATA ascii\n');
for i=1:640
    for j=1:480
        if isnan(pcloud(j,i,1))
            fprintf(fid, 'nan nan nan 4.2108e+06\n');
        else
        fprintf(fid, '%f %f %f 4.2108e+06\n', pcloud(j, i,1), pcloud(j, i,2), pcloud(j, i,3));
        end
    end
end
fclose(fid);