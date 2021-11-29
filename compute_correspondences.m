function [cYX, cXY] = compute_correspondences(geoX, geoY)
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
% Compute correspondences between two point clouds. The correspondences
%   rely only on geometry, and both sets are obtained by setting both point
%   clouds as reference.
%
% 
%   [cYX, cXY] = compute_correspondences(geoX, geoY)
%
% 
%   INPUTS
%       geoX: Geometry of point cloud X
%       geoY: Geometry of point cloud Y
%
%   OUTPUTS
%       cYX: Correspondences by setting X as the reference
%       cXY: Correspondences by setting Y as the reference


% Loop over Y and find nearest neighbor in X (set X as the reference)
[cYX, ~] = knnsearch(geoX, geoY);

% Loop over X and find nearest neighbor in Y (set Y as the reference)
[cXY, ~] = knnsearch(geoY, geoX);
