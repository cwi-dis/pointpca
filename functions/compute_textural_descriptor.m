function [dtP] = compute_textural_descriptor(colP)
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
% Compute textural descriptor. This is the luminance, which is computed
%   from corresponding RGB values using the Recommendation ITU-R BT.709.
%   
%
%   [dtP] = compute_textural_descriptor(colP)
%
% 
%   INPUTS
%       colP: Color of point cloud P in RGB, with size Mx3
%
%   OUTPUTS
%       dtP: Textural descriptor of point cloud P, with size Mx1


% Console output
fprintf('### Computing textural descriptor\n');

% Conversion to double
r = double(colP(:,1));
g = double(colP(:,2));
b = double(colP(:,3));

% Coefficients
coeff = [ 0.2126,  0.7152,  0.0722;
         -0.1146, -0.3854,  0.5000;
          0.5000, -0.4542, -0.0468];

% Computation of textural descriptor
dtP = coeff(1,1)*r + coeff(1,2)*g + coeff(1,3)*b;
