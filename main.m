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
%   PointPCA. The two point clouds under comparison are loaded, and the 
%   configuration of the metric is set, which denote the required arguments
%   for its execution. In the output, a table with 33 quality scores of 
%   PointPCA (1) and every statistical feature (32), are returned.


clear all;
close all;
clc;


%% Configuration
cfg.ratio = 0.01;  
cfg.knn = 25;
cfg.weights = 'learned';


%% Load point clouds
% Original content
A = pcread('pointcloudA.ply');
% Distorted content
B = pcread('pointcloudB.ply');


%% Compute pointpca
[Q] = pointpca(A, B, cfg);

