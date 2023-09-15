function [sNames] = get_predictor_names
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
% Get the names of predictors in a readable form.
%
% 
%   [sNames] = get_predictor_names
%
% 
%   OUTPUTS
%       sNames: Names of predictors in a readable form


dgNames = {'g_eigval1', 'g_eigval2', 'g_eigval3', 'g_sum_eigvals', 'g_linearity', 'g_planarity', 'g_sphericity', 'g_anisotropy', 'g_omnivariance', 'g_eigenentropy',  'g_surface_variation', 'g_roughness', 'g_parallelity_x', 'g_parallelity_y', 'g_parallelity_z'};
dtNames = {'t_R', 't_G', 't_B', 't_eigval1', 't_eigval2', 't_eigval3', 't_sum_eigvals', 't_eigenentropy'};
dNames = [dgNames, dtNames];
sNames = [strcat('mean_', dNames), strcat('std_', dNames)];
