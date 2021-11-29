function [rXY] = compare_statistical_features(phiX, phiY, cXY)
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
% Compare statistical features, given a correspondence function.
%   
%
%   [rXY] = compare_statistical_features(phiX, phiY, cXY)
%
% 
%   INPUTS
%       phiX: Statistical features of point cloud X, with size KxF
%       phiY: Statistical features of point cloud Y, with size LxF
%       cXY: Correspondences between point clouds X and Y after setting Y 
%            as the reference, with size Lx1
%
%   OUTPUTS
%       rXY: Relative difference between statistical features, with size 
%            LxF


% Comparison of corresponding statistical features
rXY = nan(size(phiX));
for i = 1:size(phiX,2)
    rXY(:,i) = abs(phiY(cXY,i) - phiX(:,i))./(max([abs(phiY(cXY,i)), abs(phiX(:,i))], [], 2) + eps(1));
end

rXY = real(rXY);
