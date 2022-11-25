function [dP] = descriptors(geoP, colP, r)
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
% Computation of geometric and textural descriptors. A total of 21 
%   descriptors are obtained (15 geometric and 6 textural) per point. 
%   PCA-based descriptors are computed based on r-search, given a radius r.
%   The luminance, which is the only non-PCA-based descriptor, is computed 
%   from RGB values using the Recommendation ITU-R BT.709.
%   
%
%   [descP] = descriptors(geoP, colP, r)
%
% 
%   INPUTS
%       geoP: Geometry of point cloud P, with size Mx3
%       colP: Color of point cloud P in RGB, with size Mx3
%       r: Radius used in r-search to compute PCA-based descriptors
%
%   OUTPUTS
%       descP: Descriptors of point cloud P, with size Mx21


if r <= 0
    error('The radius should be a positive real number.'); 
end

if size(geoP,1) ~= size(colP,1)
    error('Geometry and color should be of the same size.'); 
end


% Console output
fprintf('### \tDescriptors\n');

% Conversion from RGB to YCbCr
[texP] = rgb_to_yuv(colP);

% Initialization of descriptors
dgP = nan(size(geoP,1), 15);
dtP = nan(size(geoP,1), 6);
dtP(:,1) = texP(:,1);

% Support region for computation of geometric descriptors
[id, ~] = rangesearch(geoP, geoP, r);

% Minimum support region as backup for very sparse point clouds
[idTilde, ~] = knnsearch(geoP, geoP, 'k', 3);

% Computation of descriptors
for i = 1:size(geoP,1)
    if length(id{i}) < 3
        id{i} = idTilde(i,:);
    end
    
    % Geometric descriptors
    gPoint = geoP(i,:);
    gNeighb = geoP(id{i},:);
    gCentroid = mean(gNeighb);
    gCovMatrix = cov(gNeighb,1);
    if sum(isnan(gCovMatrix(:))) > 1
        continue;
    end
    [gEigvecs, gEigvals] = pcacov(gCovMatrix);
    if size(gEigvecs,2) ~= 3
        continue;
    end
    gNormal = gEigvecs(:,3);
    
    dgP(i,1:3) = gEigvals';                             % eigval1-eigval3
    dgP(i,4) = sum(gEigvals);                           % sum of eigvals
    dgP(i,5) = (gEigvals(1) - gEigvals(2))/gEigvals(1); % linearity
    dgP(i,6) = (gEigvals(2) - gEigvals(3))/gEigvals(1); % planarity
    dgP(i,7) = gEigvals(3)/gEigvals(1);                 % sphericity
    dgP(i,8) = (gEigvals(1) - gEigvals(3))/gEigvals(1); % anisotropy
    dgP(i,9) = prod(gEigvals)^(1/3);                    % omnivariance
    dgP(i,10) = -sum(gEigvals.*log(gEigvals));          % eigenetropy
    dgP(i,11) = gEigvals(3)/sum(gEigvals);              % surface variation
    dgP(i,12) = abs(dot(gPoint-gCentroid, gNormal));    % roughness
    dgP(i,13) = 1 - dot([1;0;0], gNormal);              % parallelity_x 
    dgP(i,14) = 1 - dot([0;1;0], gNormal);              % parallelity_y
    dgP(i,15) = 1 - dot([0;0;1], gNormal);              % parallelity_z
    
    
    % Textural descriptors
    tNeighb = texP(id{i},:);
    tCovMatrix = cov(tNeighb,1);
    if sum(isnan(tCovMatrix(:))) > 1
        continue;
    end
    [tEigvecs, tEigvals] = pcacov(tCovMatrix);
    if size(tEigvecs,2) ~= 3
        continue;
    end
    
    dtP(i,2:4) = tEigvals';                             % eigval1-eigval3
    dtP(i,5) = sum(tEigvals);                           % sum of eigvals
    dtP(i,6) = -sum(tEigvals.*log(tEigvals));           % eigenetropy
end

dP = [dgP, dtP];
