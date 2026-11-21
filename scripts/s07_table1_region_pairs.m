function T = s07_table1_region_pairs(cfg, roi_vals, label, out_csv)
% S07_TABLE1_REGION_PAIRS  Every intLANG region vs every aLANG region (Table 1).
%

rows = cfg.intLANG_ids; cols = cfg.aLANG_ids;
nR = numel(rows); nC = numel(cols);
t = nan(nR, nC); p = nan(nR, nC); dz = nan(nR, nC); cell_txt = cell(nR, nC);
for r = 1:nR
    for c = 1:nC
        s = paired_ttest(roi_vals(:, rows(r)), roi_vals(:, cols(c)), 'both');
        t(r, c) = s.t; p(r, c) = s.p; dz(r, c) = s.dz;
        cell_txt{r, c} = sprintf('%s (%.2f/%.2f)', stars(s.p, s.t), s.mean_a, s.mean_b);
    end
end

row_names = cfg.roi_names(rows);
col_names = cfg.roi_names(cols);
T = cell2table(cell_txt, 'VariableNames', col_names, 'RowNames', row_names);

fprintf('=== Table 1 | %s (N = %d) ===\n', label, size(roi_vals, 1));
disp(T);
if any(t(:) <= 0)
    fprintf('NOTE: %d pair(s) where the intLANG region is not > the aLANG region.\n', nnz(t <= 0));
end
if nargin >= 4 && ~isempty(out_csv)
    writetable(T, out_csv, 'WriteRowNames', true);
    save(strrep(out_csv, '.csv', '.mat'), 't', 'p', 'dz', 'row_names', 'col_names', 'label');
end
end

function s = stars(p, t)
if t <= 0,        s = 'n.s.(<0)';
elseif p < .001,  s = '***';
elseif p < .01,   s = '**';
elseif p < .05,   s = '*';
else,             s = 'n.s.';
end
end
