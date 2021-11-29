% Copyright (c) 2021 Centrum Wiskunde & Informatica (CWI), The Netherlands
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%
% Author:
%   Evangelos Alexiou (evangelos.alexiou@cwi.nl)
%
% Reference:
%   E. Alexiou, I. Viola and P. Cesar, "PointPCA: Point Cloud Objective 
%   Quality Assessment Using PCA-Based Descriptors," submitted to IEEE
%   Transactions on Multimedia
%
%
% This script provides a simple example of a main for the computation of 
%   PointPCA. In particular, a reference and a distorted point cloud are 
%   loaded, and the configurations of the metric are set, which denote
%   the required arguments for the execution of the metric. In the output,
%   quality scores of PointPCA and every statistical feature are returned.


clear all;
close all;
clc;


%% Configuration
% Ratio multiplied by the maximum length of reference bounding box to 
% obtain the radius used in r-search to compute geometric descriptors
cfg.ratio = 0.01;  
% Number of nearest neighbors used in k-nn to compute statistical features
cfg.knn = 25;
% Weights to compute a quality score from individual predictors, with 
% options: {'learned', 'equal'}
cfg.weights = 'learned';


%% Load point clouds
A = pcread('pointcloudA.ply');
B = pcread('pointcloudB.ply');


%% Compute pointpca
[q] = pointpca(A, B, cfg);

