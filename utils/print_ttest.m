function print_ttest(label, s, name_a, name_b)
% PRINT_TTEST  Print a paired_ttest result in the format used in the manuscript.
if nargin < 3, name_a = 'A'; name_b = 'B'; end
fprintf('%s (N = %d)\n', label, s.n);
fprintf('  %-8s mean = %.3f | %-8s mean = %.3f | diff = %.3f (SD %.3f)\n', ...
        name_a, s.mean_a, name_b, s.mean_b, s.mean_diff, s.sd_diff);
fprintf('  t(%d) = %.2f, p = %.3g (%s-tailed), Cohen''s dz = %.2f\n\n', ...
        s.df, s.t, s.p, tail_word(s.tail), s.dz);
end

function w = tail_word(tail)
if strcmp(tail, 'both'), w = 'two'; else, w = 'one'; end
end
