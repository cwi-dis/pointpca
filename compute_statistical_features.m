function [phi] = compute_statistical_features(geo, d, k)
% function [phi] = compute_statistical_features(geo, dsc, k)
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
% Compute statistical features. The mean and the standard deviation of 
%   descriptor values are computed using k-nn and based on a selected k.
%   In the output, the first half of columns correspond to statistical 
%   features using mean and the second half using standard deviation, with
%   both following the order of the input descriptors.
% 
% 
%   [phi] = compute_statistical_features(geo, d, k)
%
% 
%   INPUTS
%       geo: Geometry of point cloud
%       d: Descriptor values of point cloud
%       k: Number of nearest neighbors used in k-nn for the computation of
%          statistical features
%
%   OUTPUTS
%       phi: Statistical features of point cloud


% Support region for computation of statistical features
[id, ~] = knnsearch(geo, geo, 'K', k);

% Computation of point statistical features, per descriptor
mu = nan(size(id,1), size(d,2));
sigma = nan(size(id,1), size(d,2));
for i = 1:size(d,2)
    d_ = d(:,i);
    
    mu(:,i) = nanmean(d_(id),2);
    sigma(:,i) = nanstd(d_(id),[],2);
end

phi = [mu, sigma];
phi = real(phi);
