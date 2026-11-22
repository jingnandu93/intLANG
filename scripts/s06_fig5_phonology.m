function res = s06_fig5_phonology(cfg, roi_vals, net_vals, label)
% S06_FIG5_PHONOLOGY  intLANG vs aLANG response to a phonological contrast (Fig. 5).
%
%   res = s06_fig5_phonology(cfg, roi_vals, net_vals, 'Rhyme > Face | Study 1')
%
%   roi_vals : [participants x 8] from s05 (cfg.roi_names order)
%   net_vals : [participants x 2] from s05, columns [intLANG aLANG]
%
% Tests (paired, two-tailed, Cohen's dz):
%   1. network level            : intLANG vs aLANG              (Fig. 5 left)
%   2. region level             : mean of 3 intLANG regions vs mean of 5 aLANG
%                                 regions                       (Fig. 5 right)
%   3. adjacent region pairs    : vPCSA vs IFG, Spt vs pSTS     (Results text)
% Bars in Fig. 5 are mean +/- SEM across participants.
%
% Manuscript network-level values for reference:
%   Rhyme > Face      : S1 t(4) = 3.72, dz = 1.66 | S2 t(8) = 5.57, dz = 1.86 |
%                       S3 t(7) = 5.88, dz = 2.08
%   Nonword > Fixation: S1 t(4) = 3.93, dz = 1.76 | S3 t(7) = 7.88, dz = 2.79

idx = @(name) find(strcmp(cfg.roi_names, name));
n = size(roi_vals, 1);

res.label = label;
res.network    = paired_ttest(net_vals(:, 1), net_vals(:, 2), 'both');
res.region_avg = paired_ttest(mean(roi_vals(:, cfg.intLANG_ids), 2), ...
                              mean(roi_vals(:, cfg.aLANG_ids),   2), 'both');
res.vPCSA_IFG  = paired_ttest(roi_vals(:, idx('vPCSA')), roi_vals(:, idx('IFG')),  'both');
res.Spt_pSTS   = paired_ttest(roi_vals(:, idx('Spt')),   roi_vals(:, idx('pSTS')), 'both');

res.net_mean = mean(net_vals, 1);   res.net_sem = std(net_vals, 0, 1) / sqrt(n);
res.roi_mean = mean(roi_vals, 1);   res.roi_sem = std(roi_vals, 0, 1) / sqrt(n);

fprintf('=== Fig. 5 | %s ===\n', label);
print_ttest('network level: intLANG vs aLANG', res.network, 'intLANG', 'aLANG');
print_ttest('region level: mean(3 intLANG) vs mean(5 aLANG)', res.region_avg, 'intLANG', 'aLANG');
print_ttest('vPCSA vs IFG', res.vPCSA_IFG, 'vPCSA', 'IFG');
print_ttest('Spt vs pSTS',  res.Spt_pSTS,  'Spt',   'pSTS');
end
