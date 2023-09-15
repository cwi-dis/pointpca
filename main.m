% Copyright (c) 2023 Centrum Wiskunde & Informatica (CWI), The Netherlands
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
%   E. Alexiou, X. Zhou, I. Viola and P. Cesar, "PointPCA: Point Cloud 
%   Objective  Quality Assessment Using PCA-Based Descriptors," under 
%   submission 
%
%
% This script provides a simple example of a main for the computation of 
%   PointPCA. The two point clouds under comparison are loaded, and the 
%   metric is executed using the recommended configurations for the 
%   estimation of descriptors and statistical features. In the output, a 
%   table with 46 predictors is returned.


clear all;
close all;
clc;


%% Configuration
cfg.ratio = 0.008;  
cfg.knn = 9;


%% Load point clouds
A = pcread('datasets/Dxx/stimuli/original.ply');
B = pcread('datasets/Dxx/stimuli/distorted_yy.ply');


%% Compute pointpca predictors
[Q] = pointpca(A, B, cfg);


%% Include point cloud name and save table
stimulus = {'distorted_yy.ply'};
Q = [table(stimulus), Q];
writetable(Q, 'datasets/Dxx/objective scores/obj_pointpca_predictors.csv')
