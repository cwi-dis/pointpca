function [dg] = compute_geometric_descriptors(geo, r)
% function [dscGeo] = compute_geometric_descriptors(geo, r)
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
% Compute geometric descriptors. A total of 15 geometric descriptors are 
%   computed per point, using r-search and based on a selected r.
%   
%
%   [dg] = compute_geometric_descriptors(geo, r)
%
% 
%   INPUTS
%       geo: Geometry of point cloud
%       r: Radius used in r-search for the computation of descriptors
%
%   OUTPUTS
%       dg: Geometric descriptors of point cloud

if r <= 0
    error('The radius should be a positive real number.'); 
end
if size(geo,2) < 3
    error('The coordinates should be in 3D to compute geometric descriptors.');
end


% Initialization
dg = nan(size(geo,1), 15);

% Support region for computation of geometric descriptors
[id, ~] = rangesearch(geo, geo, r);

% Computation of geometric descriptors
for i = 1:size(geo,1)
    point = geo(i,:);
    neighb = geo(id{i},:);
    centroid = mean(neighb);
    
    covMatrix = cov(neighb,1);
    if sum(isnan(covMatrix(:))) > 1
        continue;
    end
    
    [eigvecs, eigvals] = pcacov(covMatrix);
    if size(eigvecs,2) ~= 3
        continue;
    end
    normal = eigvecs(:,3);
    
    dg(i,1:3) = eigvals';                           % eigval1-eigval3
    dg(i,4) = sum(eigvals);                         % sum of eigvals
    dg(i,5) = (eigvals(1) - eigvals(2))/eigvals(1); % linearity
    dg(i,6) = (eigvals(2) - eigvals(3))/eigvals(1); % planarity
    dg(i,7) = eigvals(3)/eigvals(1);                % sphericity
    dg(i,8) = (eigvals(1) - eigvals(3))/eigvals(1); % anisotropy
    dg(i,9) = prod(eigvals)^(1/3);                  % omnivariance
    dg(i,10) = -sum(eigvals.*log(eigvals));         % eigenetropy
    dg(i,11) = eigvals(3)/sum(eigvals);             % surface variation
    dg(i,12) = abs(dot(point-centroid, normal));    % roughness
    dg(i,13) = 1 - dot([1;0;0], normal);            % parallelity_x 
    dg(i,14) = 1 - dot([0;1;0], normal);            % parallelity_y
    dg(i,15) = 1 - dot([0;0;1], normal);            % parallelity_z
end
