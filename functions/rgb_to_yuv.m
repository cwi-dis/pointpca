function [yuv] = rgb_to_yuv(rgb)
% Copyright (c) 2023 Centrum Wiskunde & Informatica (CWI), The Netherlands
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
% Conversion from RGB to YUV, using ITU-R BT.709. Simplified version of: 
%   "Nikola Sprljan (2020). YUV files reading and converting, 
%   https://www.mathworks.com/matlabcentral/fileexchange/36417-yuv-files-
%   reading-and-converting, MATLAB Central File Exchange"
% 
% 
%   [yuv] = rgb_to_yuv(rgb)
%
% 
%   INPUTS
%       rgb: RGB color values, with size Mx3
%
%   OUTPUTS
%       yuv: YUV values, with size Mx3


r = double(rgb(:,1));
g = double(rgb(:,2));
b = double(rgb(:,3));

% Coefficients
c = [ 0.2126,  0.7152,  0.0722;
     -0.1146, -0.3854,  0.5000;
      0.5000, -0.4542, -0.0468];

% Offset
o = [0; 128; 128];

y = c(1,1)*r + c(1,2)*g + c(1,3)*b + o(1);
u = c(2,1)*r + c(2,2)*g + c(2,3)*b + o(2);
v = c(3,1)*r + c(3,2)*g + c(3,3)*b + o(3);

yuv = [round(y), round(u), round(v)];
