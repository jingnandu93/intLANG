function res = s04_fig3_within_between(cfg, zmats, cohort_label, png_file)
% S04_FIG3_WITHIN_BETWEEN  Within- vs between-network connectivity (Fig. 3).
%
%   res = s04_fig3_within_between(cfg, zmats, 'Discovery (Study 1)', png_file)
%
%   zmats : cell array, one 8 x 8 Fisher-z matrix per participant (s03 output)
%
% Manuscript values for reference:
%   Study 1: t(4) = 6.40, dz = 2.86 | t(4) = 9.47, dz = 4.24
%   Study 2: t(8) = 13.42, dz = 4.47 | t(8) = 8.15, dz = 2.72
%   Study 3: t(7) = 7.19, dz = 2.54 | t(7) = 9.71, dz = 3.43

n_roi = numel(cfg.roi_ids);
upper = triu(true(n_roi), 1);
isI = false(n_roi, 1); isI(cfg.intLANG_ids) = true;
isA = false(n_roi, 1); isA(cfg.aLANG_ids)   = true;
m_within_I = upper & (isI * isI') > 0;              %  3 pairs
m_within_A = upper & (isA * isA') > 0;              % 10 pairs
m_between  = upper & ((isI * isA') | (isA * isI')) > 0;   % 15 pairs

n = numel(zmats);
within_I = zeros(n, 1); within_A = zeros(n, 1); between = zeros(n, 1);
for i = 1:n
    z = zmats{i};
    within_I(i) = mean(z(m_within_I));
    within_A(i) = mean(z(m_within_A));
    between(i)  = mean(z(m_between));
end

res.cohort   = cohort_label;
res.within_I = within_I;  res.within_A = within_A;  res.between = between;
res.test_I = paired_ttest(within_I, between, 'right');
res.test_A = paired_ttest(within_A, between, 'right');
res.group_z = mean(cat(3, zmats{:}), 3);
res.group_r = tanh(res.group_z);

fprintf('=== Fig. 3 | %s ===\n', cohort_label);
fprintf('pairs: within-intLANG %d, within-aLANG %d, between %d\n', ...
        nnz(m_within_I), nnz(m_within_A), nnz(m_between));
fprintf('mean r (z): within-intLANG %.2f (%.2f), within-aLANG %.2f (%.2f), between %.2f (%.2f)\n', ...
        tanh(mean(within_I)), mean(within_I), tanh(mean(within_A)), mean(within_A), ...
        tanh(mean(between)), mean(between));
print_ttest('within-intLANG > between', res.test_I, 'within', 'between');
print_ttest('within-aLANG > between',   res.test_A, 'within', 'between');

if nargin >= 4 && ~isempty(png_file)
    plot_matrix(res.group_r, cfg.roi_names, cohort_label);
    print(gcf, png_file, '-dpng', '-r300');
end
end

function plot_matrix(r, names, ttl)
figure('Color', 'w');
imagesc(r, [0 1]); axis square; colormap(jet(256)); colorbar;
set(gca, 'XTick', 1:numel(names), 'XTickLabel', names, 'XTickLabelRotation', 45, ...
         'YTick', 1:numel(names), 'YTickLabel', names, 'TickLength', [0 0]);
for i = 1:size(r, 1)
    for j = 1:size(r, 2)
        text(j, i, sprintf('%.2f', r(i, j)), 'HorizontalAlignment', 'center', ...
             'FontWeight', 'bold');
    end
end
hold on;   % outline the intLANG (1:3) and aLANG (4:8) blocks
plot([3.5 3.5], [0.5 8.5], 'k-', 'LineWidth', 2);
plot([0.5 8.5], [3.5 3.5], 'k-', 'LineWidth', 2);
title(ttl);
end
