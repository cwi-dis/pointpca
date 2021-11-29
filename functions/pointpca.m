function [Q] = pointpca(A, B, cfg)
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
%   textural descriptors are extracted from both point clouds, before 
%   estimating corresponding statistical features. The latter are compared 
%   to provide quality predictions. A final quality score is obtained as a 
%   weighted linear combination of the individual quality predictions.
% 
% 
%   [Q] = pointpca(A, B, cfg)
%
% 
%   INPUTS
%       A: Point cloud A as a pointCloud struct
%       B: Point cloud B as a pointCloud struct
%       cfg: Metric configuration as a custom struct with fields:
%           ratio   - Ratio multiplied by the maximum length of reference 
%                     bounding box to obtain a radius. The latter is used 
%                     in r-search to compute geometric descriptors
%           knn     - Number of nearest neighbors used in k-nn to compute  
%                     statistical features
%           weights - Weights used for a final quality score, with options: 
%                     {'learned', 'equal'}
%
%   OUTPUTS
%       Q: Table with 33 quality scores of PointPCA (1) and every 
%          statistical feature (32)


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
                error('The k should be a positive integer number.');
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


% Console output
fprintf('Execution of PointPCA\n');


%% Fusion
[geoA, colA] = fuse_points(A);
[geoB, colB] = fuse_points(B);


%% Correspondence
[cBA] = compute_correspondence(geoA, geoB);
[cAB] = compute_correspondence(geoB, geoA);


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

% Indexes of geometric and textural statistical features
gtID = 1:size(phiA,2);
gID = [1:size(dgA,2), size(phiA,2)/2+(1:size(dgA,2))];
tID = setdiff(gtID, gID);


%% Comparison
[rBA] = compare_statistical_features(phiA, phiB, cBA);
[rAB] = compare_statistical_features(phiB, phiA, cAB);

% Pooling across points
sAB = nanmean(rAB);
sBA = nanmean(rBA);

% Symmetric error
s = max(sAB, sBA);


%% Quality score
if strcmp(cfg.weights, 'learned')
    mat = load('./mat/weights_learned.mat');
    w = mat.w;
    q = sum(w.*s);
elseif strcmp(cfg.weights, 'equal')
    qg = mean(s(gID));
    qt = mean(s(tID));
    q = 0.5*qg + 0.5*qt;
end
    
Q = array2table([q, s]);
Q.Properties.VariableNames = ['PointPCA', get_statistical_feature_names];
