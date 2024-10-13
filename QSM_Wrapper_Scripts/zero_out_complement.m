% Function to zero out regions of a matrix
function [varargout] = zero_out_complement(x_keep, y_keep, varargin)

if nargin < 3
    error('At least three inputs x_keep, y_keep, and a volume) are required.');
end

% Default matrices to empty unless passed as inputs
Magn = [];
Phs = [];

% Process optional inputs
if ~isempty(varargin)
    for i = 1:length(varargin)
        if i == 1
            Magn = varargin{i}; % First optional input is Magn
        elseif i == 2
            Phs = varargin{i}; % Second optional input is Phs
        else
            warning('Too many inputs, ignoring extra ones.');
        end
    end
end

% Full ranges for x and y
x_full = 1:size(Magn, 1);
y_full = 1:size(Magn, 2);

% Apply zeroing based on x_keep and y_keep
Magn(setdiff(x_full, x_keep), :, :, :) = 0;
Phs(setdiff(x_full, x_keep), :, :, :) = 0;
Magn(:, setdiff(y_full, y_keep), :, :) = 0;
Phs(:, setdiff(y_full, y_keep), :, :) = 0;

% Set outputs based on the requested number
if nargout >= 1
    varargout{1} = Magn;
end
if nargout >=2
    varargout{2} = Phs;
end
end