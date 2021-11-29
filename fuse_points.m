function [geo, col] = fuse_points(P)
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
% Fuse points with identical location. Duplicated coordinates are discarded
%   and corresponding color values are averaged.
%
% 
%   [geo, col] = fuse_points(P)
%
% 
%   INPUTS
%       P: Point cloud
%
%   OUTPUTS
%       geo: Geometry of point cloud with unique coordinates
%       col: Corresponding color of point cloud


% Unique point coordinates and corresponding indexes
[geo, ind_geo] = unique(double(P.Location), 'rows');

if (size(P.Location,1) ~= size(geo,1)) 
    warning('Duplicated coordinates are found.');
    if ~isempty(P.Color)
        warning('Color averaging is applied.');
        % Sorting of coordinates and corresponding color values
        [geo_sorted, ind_geo] = sortrows(double(P.Location));
        col_sorted = double(P.Color(ind_geo, :));
        
        % Indexes that correspond to different coordinates
        d = diff(geo_sorted,1,1);
        sd = sum(abs(d),2) > 0;
        id = [1; find(sd == 1)+1; size(geo_sorted,1)+1];
        
        % Averaging color values that correspond to identical coordinates
        col = zeros(size(id,1)-1,3);
        for j = 1:size(id,1)-1
            col(j,:) = round(mean(col_sorted(id(j):id(j+1)-1, :), 1));
        end
        id(end) = [];
        
        % Unique point coordinates
        geo = geo_sorted(id,:);
    end
else
    if ~isempty(P.Color)
        col = double(P.Color(ind_geo, :));
    end
end
