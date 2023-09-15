function [cYX] = correspondence(geoX, geoY)
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
% Computation of correspondence function between two point clouds, using 
%   geometry-only information and based on nearest neighbors.
%
% 
%   [cYX] = correspondence(geoX, geoY)
%
% 
%   INPUTS
%       geoX: Geometry of point cloud X, with size Kx3
%       geoY: Geometry of point cloud Y, with size Lx3
%
%   OUTPUTS
%       cYX: Correspondences between point clouds X and Y after setting X 
%            as the reference, with size Lx1


% Console output
fprintf('## \tCorrespondence\n');

% Loop over Y and find nearest neighbor in X (set X as the reference)
[cYX, ~] = knnsearch(geoX, geoY);
