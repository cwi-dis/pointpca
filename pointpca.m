function [q] = pointpca(A, B, cfg)
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
% PointPCA is a full-reference point cloud objective quality metric that 
%   relies on statistical features computed from geometric and textural 
%   descriptors. The point clouds first pass through point fusion, and
%   correspondences are computed based on the fused geometry. Geometric and
%   textural descriptors are computed for both point clouds, before 
%   estimating corresponding statistical features. The latter are compared 
%   providing individual quality predictions. A final quality score is 
%   obtained as their linear combination using a selected set of weights.
%
% 
%   [q] = pointpca(A, B, cfg)
%
% 
%   INPUTS
%       A: Point cloud A
%       B: Point cloud B
%       cfg: Metric configuration
%           ratio   - Ratio multiplied by the maximum length of reference 
%                     bounding box to obtain the radius. The latter is used 
%                     in r-search to compute geometric descriptors
%           knn     - Number of nearest neighbors used in k-nn to compute  
%                     statistical features
%           weights - Weights to compute a quality score from individual 
%                     predictors, with options: {'learned', 'equal'}
%
%   OUTPUTS
%       q: Table with quality scores obtained from PointPCA and every  
%          statistical feature


if nargin < 2
    error('Too few input arguments.');
else
    if ~isa(A, 'pointCloud') || ~isa(B, 'pointCloud')
        error('Two pointCloud structs should be given as input.');
    end
    if nargin == 2
        cfg.ratio = 0.01;
        cfg.knn = 25;
        cfg.weights = 'learned';
    else
        if ~isfield(cfg, 'ratio')
            cfg.ratio = 0.01;
        else
            if cfg.ratio <= 0 
                error('The ratio should be a positive real number.');
            end
        end
        if ~isfield(cfg, 'knn')
            cfg.knn = 25;
        else
            if cfg.knn <= 0 
                error('The k should be a natural number.');
            end
        end
        if ~isfield(cfg, 'weights')
            cfg.weights = 'learned';
        else
            if ~strcmp(cfg.weights, 'equal') && ~strcmp(cfg.weights, 'learned')
                error('The selected type of weights is not supported.');
            end
        end
    end
end


%% Fusion
[geoA, colA] = fuse_points(A);
[geoB, colB] = fuse_points(B);


%% Correspondence
[cBA, cAB] = compute_correspondences(geoA, geoB);


%% Descriptors
% Max length of reference bounding box 
maxLenBB = double(max(max(geoA) - min(geoA)));
% Radius for support region 
radius = round(cfg.ratio * maxLenBB);

% Computation of geometric and textural descriptors for A
[dgA] = compute_geometric_descriptors(geoA, radius);
[dtA] = compute_textural_descriptor(colA);
dA = [dgA, dtA];

% Computation of geometric and textural descriptors for B
[dgB] = compute_geometric_descriptors(geoB, radius);
[dtB] = compute_textural_descriptor(colB);
dB = [dgB, dtB];


%% Statistical features
[phiA] = compute_statistical_features(geoA, dA, cfg.knn);
[phiB] = compute_statistical_features(geoB, dB, cfg.knn);


%% Comparison
[rAB] = compare_statistical_features(phiA, phiB, cAB);
[rBA] = compare_statistical_features(phiB, phiA, cBA);

% Pooling across points
sAB = nanmean(rAB);
sBA = nanmean(rBA);

% Symmetric error
s = max(sAB, sBA);


%% Quality score
if strcmp(cfg.weights, 'learned')
    mat = load('weights_learned.mat');
    w = mat.w;
elseif strcmp(cfg.weights, 'equal')
    w = 1/length(s) .* ones(1,length(s));
end

q = array2table([sum(w.*s), s]);
q.Properties.VariableNames = ['PointPCA', get_statistical_feature_names];


