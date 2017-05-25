function y = monocline(n, center, width, left, right)

% monocline -- Monocline-like distribution function.
%  monocline(n, center, width, left, right) returns n points
%   on the range [0...1], distributed with the given transition
%   center, width (st.dev.), left-side density, and right-side
%   density (both relative).  The distribution is generated by
%   "erf()".  Defaults: center = 0.5, width = 0.1, left = 1,
%   right = 2.
%  monocline(x, ...) assumes that x is "linspace(0, 1, n)".
%  monocline('demo') demonstrates itself for n = 51.
 
% svn $Id$
%=======================================================================
% Copyright (C) 1999 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
%=======================================================================
 
% Version of 01-Sep-1999 10:05:23.
% Updated    01-Sep-1999 16:59:22.

if nargin < 1, help(mfilename), n = 'demo'; end

% Demonstration.

if isequal(n, 'demo')
	n = 51;
	center = 0.5;
	width = 0.1;
	left = 1;
	right = 2;
	result = feval(mfilename, n, center, width, left, right);
	x = linspace(0, 1, n);
	plot(x, result, '-', [0*x; 0*x+1], [result; result], 'g-')
	s = [mfilename '(' int2str(n) ', ' num2str(center), ', ' ...
				num2str(width) ', ' num2str(left) ', ' num2str(right) ')'];
	title(s)
	xlabel x
	ylabel y
	grid on
	eval('zoomsafe', '')
	figure(gcf)
	if nargout > 0, y = result; end
	return
end

% Missing arguments.

if nargin < 2, center = 0.5; end
if nargin < 3, width = 0.1; end
if nargin < 4, left = 1; end
if nargin < 5, right = 2; end

% String arguments.

if ischar(n), n = eval(n); end
if ischar(center), center = eval(center); end
if ischar(width), width = eval(width); end
if ischar(left), left = eval(left); end
if ischar(right), right = eval(right); end

if length(n) > 1, n = length(n); end

% ERF and TANH are very similar, differing
%  by about 20% in the independent variable:
%  tanh(x) =~ erf(0.8*x).

fcn = 'tanh';
fcn = 'erf';

x = linspace(1/n, 1-1/n, n-1);   % Centered x-values.

y = feval(fcn, (x-center)/width);   % ERF-like.

y = (y + 1) / 2;   % ERF on a pedestal.

% Shift and scale.

y = left + y * (right-left);   % Unnormalized density.
y = cumsum(y);   % Cumulative unnormalized density.
y = y / max(y);   % Normalize.
y = [0 y];   % Prepend zero starting point.
y(end) = 1;   % Exactly one at end.

% Reverse interpolate.

x = linspace(0, 1, n);
y = interp1(y, x, x, 'linear');