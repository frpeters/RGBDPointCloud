# RGBDPointCloud

To use this repository just download all the source files, run depthToPCD.m in Matlab, change the first line to use the depth image you want:

'depth = imread('00000-depth.png');'

And you will get the output result.pcd which can be viewed with pcl_viewer.

To make a .pcd file out of a set of depth images and a matrix of poses you will use the depthSceneToPCD.m file, you first need to write your matrix of poses into the variable "poses". Then copy all t he depth images into the same folder name them with this convention: "00000-depth.png", "00001-depth.png", "00002-depth.png", etc. And then change the loop in line 892:

'for i=1:100'

To "for i=1:x" where x is the number of poses/depth images you're using. After that the .pcd file will have 2 discrepances, WIDTH and POINTS. Make sure to change both of them to the number of points you generated.
