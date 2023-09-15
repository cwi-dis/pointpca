function [geoP, colP] = duplicate_merging(P)
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
% Points with identical coordinates that belong to the same point cloud are
%   merged. The color of a merged point is obtained by averaging the color 
%   values of corresponding points with same coordinates.
%
% 
%   [geoP, colP] = duplicate_merging(P)
%
% 
%   INPUTS
%       P: Point cloud P as a pointCloud struct, with size Nx3 for the
%          Location and Color fields
%
%   OUTPUTS
%       geoP: Geometry of point cloud P after discarding duplicated 
%             coordinates, with size Mx3 and M <= N
%       colP: Color of point cloud P after averaging across duplicated 
%             coordinates, with size Mx3 and M <= N


% Console output
fprintf('# \tDuplicate merging\n');

% Sort and get unique point coordinates, with corresponding indexes
[geoP, ind_geo] = unique(double(P.Location), 'rows');

if (size(P.Location,1) ~= size(geoP,1)) 
    warning('Duplicated coordinates are found. Color averaging is applied.');
    
    % Sort of coordinates and color values
    [geoP_sorted, ind_geo] = sortrows(double(P.Location));
    colP_sorted = double(P.Color(ind_geo, :));

    % Indexes that correspond to different coordinates
    d = diff(geoP_sorted,1,1);
    sd = sum(abs(d),2) > 0;
    id = [1; find(sd == 1)+1; size(geoP_sorted,1)+1];

    % Averaging color values with identical coordinates
    colP = zeros(size(id,1)-1,3);
    for j = 1:size(id,1)-1
        colP(j,:) = round(mean(colP_sorted(id(j):id(j+1)-1, :), 1));
    end
    id(end) = [];

    % Unique point coordinates
    geoP = geoP_sorted(id,:);
    
else
    % Sort color values
    colP = double(P.Color(ind_geo, :));
end
