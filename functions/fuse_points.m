function [geoP, colP] = fuse_points(P)
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
%   [geoP, colP] = fuse_points(P)
%
% 
%   INPUTS
%       P: Point cloud P as a pointCloud struct, with size Nx3 for the
%          Location and Color (optional) fields
%
%   OUTPUTS
%       geoP: Geometry of point cloud P after discarding duplicated 
%             coordinates, with size Mx3 and M <= N
%       colP: Color of point cloud P after averaging across duplicated 
%             coordinates, with size Mx3 and M <= N (optional)


% Console output
fprintf('# \tPoint fusion\n');

% Unique point coordinates and corresponding indexes
[geoP, ind_geo] = unique(double(P.Location), 'rows');

if (size(P.Location,1) ~= size(geoP,1)) 
    warning('Duplicated coordinates are found.');
    % If the point cloud contains color
    if ~isempty(P.Color)
        warning('Color averaging is applied.');
        % Sorting of coordinates and corresponding color values
        [geoP_sorted, ind_geo] = sortrows(double(P.Location));
        colP_sorted = double(P.Color(ind_geo, :));
        
        % Indexes that correspond to different coordinates
        d = diff(geoP_sorted,1,1);
        sd = sum(abs(d),2) > 0;
        id = [1; find(sd == 1)+1; size(geoP_sorted,1)+1];
        
        % Averaging color values that correspond to identical coordinates
        colP = zeros(size(id,1)-1,3);
        for j = 1:size(id,1)-1
            colP(j,:) = round(mean(colP_sorted(id(j):id(j+1)-1, :), 1));
        end
        id(end) = [];
        
        % Unique point coordinates
        geoP = geoP_sorted(id,:);
    end
else
    % If the point cloud contains color
    if ~isempty(P.Color)
        colP = double(P.Color(ind_geo, :));
    end
end
