function [phiNames] = get_statistical_feature_names
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
% Get the names of statistical features in a readable form.
%
% 
%   [phiNames] = get_statistical_feature_names
%
% 
%   OUTPUTS
%       phiNames: Names of statistical features in a readable form


dgNames = {'eigval1', 'eigval2', 'eigval3', 'sum_eigvals', 'linearity', 'planarity', 'sphericity', 'anisotropy', 'omnivariance', 'eigenentropy',  'surface_variation', 'roughness', 'parallelity_x', 'parallelity_y', 'parallelity_z'};
dtNames = {'luminance'};
dNames = [dgNames, dtNames];
phiNames = [strcat('mean_', dNames), strcat('std-', dNames)];