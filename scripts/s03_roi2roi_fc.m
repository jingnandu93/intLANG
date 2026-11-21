function zmat = s03_roi2roi_fc(cfg, pid, anchor_file, out_file)
% S03_ROI2ROI_FC  8 x 8 region-to-region functional connectivity (Fig. 3).
%
%   zmat = s03_roi2roi_fc(cfg, 'P1', anchor_file, out_file)
%
%
% Output zmat is in cfg.roi_names order (intLANG rows/cols 1:3, aLANG 4:8).

labels = read_cifti(anchor_file, cfg);
sdir = cfg.subj_dir(pid);
lh_list = read_list(fullfile(sdir, 'dataset2', 'lh_runs.txt'));
rh_list = read_list(fullfile(sdir, 'dataset2', 'rh_runs.txt'));

n_roi  = numel(cfg.roi_ids);
n_runs = numel(lh_list);
zsum = zeros(n_roi);
for i = 1:n_runs
    fprintf('[%s dataset2] run %d/%d\n', pid, i, n_runs);
    ts = load_surface_run(lh_list{i}, rh_list{i});
    roi_ts = zeros(size(ts, 1), n_roi);
    for k = 1:n_roi
        roi_ts(:, k) = mean(ts(:, labels == cfg.roi_ids(k)), 2, 'omitnan');
    end
    zsum = zsum + fisher_z(corr_cols(roi_ts, roi_ts));
end
zmat = zsum / n_runs;

if nargin >= 4 && ~isempty(out_file)
    roi_names = cfg.roi_names;
    save(out_file, 'zmat', 'roi_names', 'pid', 'n_runs');
end
end
