function [sP] = predictors(rYX, rXY)
% Copyright (c) 2022 Centrum Wiskunde & Informatica (CWI), The Netherlands
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
% Computation of predictors from corresponding statistical features, via 
%   pooling across error samples, using both point clouds as reference, and
%   getting the symmetric error. 
%   
%
%   [sP] = predictors(rYX, rXY)
%
% 
%   INPUTS
%       rYX: Error samples using X as reference, with size Kx42
%       rXY: Error samples using Y as reference, with size Lx42
%
%   OUTPUTS
%       s: Predictors with size 1x42


% Console output
fprintf('######\tPredictors\n');

% Pooling across points
sYX = nanmean(rYX);
sXY = nanmean(rXY);

% Symmetric error
sP = max(sYX, sXY);
