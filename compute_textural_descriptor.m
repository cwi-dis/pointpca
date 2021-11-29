function [dt] = compute_textural_descriptor(col)
% function [dscTex] = compute_textural_descriptor(col)
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
% Compute textural descriptor. The luminance is computed per point from 
%   corresponding RGB values, using the Recommendation ITU-R BT.709.
%   
%
%   [dt] = compute_textural_descriptor(col)
%
% 
%   INPUTS
%       col: Color of point cloud
%
%   OUTPUTS
%       dt: Textural descriptor of point cloud


% Conversion to double
r = double(col(:,1));
g = double(col(:,2));
b = double(col(:,3));

% Coefficients
coeff = [ 0.2126,  0.7152,  0.0722;
         -0.1146, -0.3854,  0.5000;
          0.5000, -0.4542, -0.0468];

% Computation of textural descriptor
dt = coeff(1,1)*r + coeff(1,2)*g + coeff(1,3)*b;
