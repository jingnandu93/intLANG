function s = paired_ttest(a, b, tail)
% PAIRED_TTEST  Paired t-test with Cohen's dz (no toolbox needed).
%   s = paired_ttest(a, b, tail)
%   tail: 'both' (default), 'right' (a > b) or 'left' (a < b)
%   Returns t, df, p, dz = mean(a-b)/std(a-b), and descriptive stats.
%
%   Conventions used in the manuscript:
%     Fig. 3 (within > between network FC)      : tail = 'right' (one-tailed)
%     Fig. 5, Fig. 6 post hoc, Table 1          : tail = 'both'  (two-tailed)
if nargin < 3, tail = 'both'; end
a = a(:); b = b(:);
d  = a - b;
n  = numel(d);
df = n - 1;
t  = mean(d) / (std(d) / sqrt(n));
p_two = betainc(df / (df + t^2), df/2, 0.5);    % two-tailed p from Student t
switch tail
    case 'both',  p = p_two;
    case 'right', p = p_two/2 * (t > 0) + (1 - p_two/2) * (t <= 0);
    case 'left',  p = p_two/2 * (t < 0) + (1 - p_two/2) * (t >= 0);
    otherwise, error('tail must be both, right or left');
end
s = struct('n', n, 'df', df, 't', t, 'p', p, 'tail', tail, ...
           'dz', mean(d) / std(d), 'mean_a', mean(a), 'mean_b', mean(b), ...
           'mean_diff', mean(d), 'sd_diff', std(d));
end
