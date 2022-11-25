function [Q] = pointpca(A, B, cfg)
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
% PointPCA is a full-reference point cloud objective quality metric that 
%   relies on statistical features computed from geometric and textural 
%   descriptors. The point clouds first pass through a duplicate point 
%   merging step, before computing a correspondence function that
%   identifies matching points between the reference and the point cloud
%   under evalution. Geometric and textural descriptors are then computed, 
%   and corresponding statistical features are estimated. The latter are 
%   finally compared to produce predictors of visual quality.
% 
% 
%   [Q] = pointpca(A, B, cfg)
%
% 
%   INPUTS
%       A: Original point cloud A as a pointCloud struct
%       B: Distorted point cloud B as a pointCloud struct
%       cfg: Metric configuration as a custom struct with fields:
%           ratio   - Ratio multiplied by the maximum length of reference 
%                     bounding box to obtain a radius. The latter is used 
%                     in r-search to compute geometric descriptors
%           knn     - Number of nearest neighbors used in k-nn to compute  
%                     statistical features
%
%   OUTPUTS
%       Q: Table with 42 quality predictors corresponding to the proposed
%           statistical features


if nargin < 2
    error('Too few input arguments.');
else
    if ~isa(A, 'pointCloud') || ~isa(B, 'pointCloud')
        error('Two pointCloud structs should be given as input.');
    end
    if isempty(A.Color) || isempty(B.Color)
        error('Color data should be given for both point clouds.');
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


%% Sorting and Duplicate merging
[geoA, colA] = duplicate_merging(A);
[geoB, colB] = duplicate_merging(B);


%% Correspondence
[cBA] = correspondence(geoA, geoB);
[cAB] = correspondence(geoB, geoA);


%% Descriptors
radius = round(cfg.ratio * get_max_dim_bbox(geoA));
[dA] = descriptors(geoA, colA, radius);
[dB] = descriptors(geoB, colB, radius);


%% Statistical features
[phiA] = statistical_features(geoA, dA, cfg.knn);
[phiB] = statistical_features(geoB, dB, cfg.knn);


%% Comparison
[rBA] = comparison(phiA, phiB, cBA);
[rAB] = comparison(phiB, phiA, cAB);


%% Predictors
[s] = predictors(rBA, rAB);


%% Output quality scores
Q = array2table(s);
Q.Properties.VariableNames = get_predictor_names;
