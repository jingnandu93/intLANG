function res = s08_fig6_double_dissociation(nonword_fix, sentence_nonword)
% S08_FIG6_DOUBLE_DISSOCIATION  Network x contrast double dissociation (Fig. 6).
%
%   res = s08_fig6_double_dissociation(nonword_fix, sentence_nonword)
%
%   nonword_fix      : [N x 2] network values [intLANG aLANG], Nonword > Fixation
%   sentence_nonword : [N x 2] network values [intLANG aLANG], Sentence > Nonword
%   (N = 13, Studies 1 and 3; from s05 net_vals)
%
nf = nonword_fix; sn = sentence_nonword;
N  = size(nf, 1);
assert(isequal(size(sn), [N 2]), 'Both inputs must be N x 2 [intLANG aLANG].');

zero = zeros(N, 1);
% main effect of network: average over contrasts, intLANG - aLANG
s_net = paired_ttest(mean([nf(:,1) sn(:,1)], 2), mean([nf(:,2) sn(:,2)], 2), 'both');
% main effect of contrast: average over networks, NF - SN
s_con = paired_ttest(mean(nf, 2), mean(sn, 2), 'both');
% interaction: difference of differences
s_int = paired_ttest((nf(:,1) - nf(:,2)) - (sn(:,1) - sn(:,2)), zero, 'both');

res.anova = struct( ...
    'network',     struct('F', s_net.t^2, 'df', [1 N-1], 'p', s_net.p), ...
    'contrast',    struct('F', s_con.t^2, 'df', [1 N-1], 'p', s_con.p), ...
    'interaction', struct('F', s_int.t^2, 'df', [1 N-1], 'p', s_int.p));
res.posthoc_NF = paired_ttest(nf(:,1), nf(:,2), 'both');   % intLANG vs aLANG
res.posthoc_SN = paired_ttest(sn(:,2), sn(:,1), 'both');   % aLANG vs intLANG

fprintf('=== Fig. 6 | 2 x 2 repeated-measures ANOVA (N = %d) ===\n', N);
f = fieldnames(res.anova);
for k = 1:numel(f)
    a = res.anova.(f{k});
    fprintf('  %-12s F(%d,%d) = %.2f, p = %.3g\n', f{k}, a.df(1), a.df(2), a.F, a.p);
end
fprintf('\n');
print_ttest('Nonword > Fixation: intLANG vs aLANG', res.posthoc_NF, 'intLANG', 'aLANG');
print_ttest('Sentence > Nonword: aLANG vs intLANG', res.posthoc_SN, 'aLANG', 'intLANG');
end
