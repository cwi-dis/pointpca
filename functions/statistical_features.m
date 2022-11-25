function [phiP] = statistical_features(geoP, dP, k)
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
% Computation of statistical features. A total of 42 statistical features 
%   are obtained per point. Statistical features are computed as the mean 
%   and the standard deviation of descriptor values using k-nn, given a k. 
%   In the output, the first half of columns correspond to statistical 
%   features using mean and the second half using standard deviation, with 
%   both following the order of the input descriptors.
% 
% 
%   [phiP] = statistical_features(geoP, dP, k)
%
% 
%   INPUTS
%       geoP: Geometry of point cloud P, with size Mx3
%       dP: Descriptors of point cloud P, with size Mx21
%       k: Number of nearest neighbors used in k-nn for the computation of
%          statistical features
%
%   OUTPUTS
%       phiP: Statistical features of point cloud P, with size Mx42

    
% Console output
fprintf('#### \tStatistical fearures\n');

% Support region for computation of statistical features
[id, ~] = knnsearch(geoP, geoP, 'K', k);

% Computation of point statistical features, per descriptor
mu = nan(size(id,1), size(dP,2));
sigma = nan(size(id,1), size(dP,2));
for i = 1:size(dP,2)
    d_ = dP(:,i);
    
    mu(:,i) = nanmean(d_(id),2);
    sigma(:,i) = nanstd(d_(id),[],2);
end

phiP = [mu, sigma];
phiP = real(phiP);
