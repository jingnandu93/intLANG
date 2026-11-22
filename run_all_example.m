%% Example analyses for Du et al. (2026).
%
% Run one section at a time (Ctrl+Enter). Step 3 reads full fMRI time series and
% can be run one participant at a time on a cluster.
%
% Software: MATLAB R2019a, FreeSurfer 6.0.0 (MRIread),
% cifti-matlab (ciftiopen/ciftisavereset), Connectome Workbench (wb_command).

clear; clc;
here = fileparts(mfilename('fullpath'));
addpath(fullfile(here, 'utils'), fullfile(here, 'scripts'));
cfg = config_example();
addpath(genpath(cfg.cifti_matlab), cfg.freesurfer_matlab);
if ~exist(cfg.out_dir, 'dir'), mkdir(cfg.out_dir); end
S = cfg.subjects;

%% 1. intLANG and aLANG seed maps, Dataset 1 (define) and Dataset 2 (replicate)  (Fig. 1)
for i = 1:numel(S)
    o = fullfile(cfg.out_dir, S(i).pid);
    for ds = {'dataset1', 'dataset2'}
        cm = fullfile(cfg.subj_dir(S(i).pid), ds{1}, 'corr_mat_r2z.mat');
        s01_seed_map(cfg, cm, S(i).intLANG_seed, S(i).intLANG_thr, [o '_' ds{1} '_intLANG']);
        s01_seed_map(cfg, cm, S(i).aLANG_seed,  S(i).aLANG_thr,  [o '_' ds{1} '_aLANG']);
    end
end

%% 2. Anchor regions
%  a) draw one generous border per region in wb_view on the inflated surface
%  b) bash scripts/s02_border_to_roi.sh <surf> <border> <rh_empty> <out_dir>
%  c) intersect with the Dataset 1 network estimates:
for i = 1:numel(S)
    pid = S(i).pid; o = fullfile(cfg.out_dir, pid);
    zones = struct();
    for k = 1:numel(cfg.roi_names)
        zones.(cfg.roi_names{k}) = fullfile(cfg.subj_dir(pid), 'zones', ...
                                            [pid '_' cfg.roi_names{k} '_zone.dscalar.nii']);
    end
    s02_anchor_regions(cfg, pid, zones, ...
        sprintf('%s_dataset1_intLANG_seed%d_thr%g_mask.dscalar.nii', o, S(i).intLANG_seed, S(i).intLANG_thr), ...
        sprintf('%s_dataset1_aLANG_seed%d_thr%g_mask.dscalar.nii',   o, S(i).aLANG_seed,  S(i).aLANG_thr), ...
        fullfile(cfg.subj_dir(pid), 'anchor_regions.dscalar.nii'));
end

%% 3. Region-to-region FC from the independent Dataset 2  (Fig. 3)
for i = 1:numel(S)
    pid = S(i).pid;
    s03_roi2roi_fc(cfg, pid, fullfile(cfg.subj_dir(pid), 'anchor_regions.dscalar.nii'), ...
                   fullfile(cfg.out_dir, [pid '_roi2roi_fc.mat']));
end

%% 4. Within- vs between-network connectivity, per study  (Fig. 3)
for st = 1:3
    pids  = {S([S.study] == st).pid};
    zmats = cellfun(@(p) getfield(load(fullfile(cfg.out_dir, [p '_roi2roi_fc.mat'])), 'zmat'), ...
                    pids, 'UniformOutput', false);
    res = s04_fig3_within_between(cfg, zmats, cfg.study_names{st}, ...
                                  fullfile(cfg.out_dir, sprintf('Fig3_study%d.png', st)));
    % per-participant values (Fisher z) for the R statistics in stats_R/
    src = fullfile(cfg.out_dir, 'source_data');
    if ~exist(src, 'dir'), mkdir(src); end
    writetable(table(pids(:), res.within_I, res.within_A, res.between, 'VariableNames', ...
               {'PID', 'within_intLANG', 'within_aLANG', 'between'}), ...
               fullfile(src, sprintf('fig3_study%d.csv', st)));
end

%% 5. Task responses per region and per network  (Fig. 5, 6, Table 1)
%  Contrasts: RhymeFace (all studies); NonwordFix, SentenceNonword (Studies 1, 3)
contrasts = {'RhymeFace', 'NonwordFix', 'SentenceNonword'};
task = struct();
for c = 1:numel(contrasts)
    task.(contrasts{c}).roi = nan(numel(S), 8);
    task.(contrasts{c}).net = nan(numel(S), 2);
end
for i = 1:numel(S)
    pid = S(i).pid; sd = cfg.subj_dir(pid);
    for c = 1:numel(contrasts)
        f = fullfile(sd, 'task', [contrasts{c} '.dscalar.nii']);
        if ~exist(f, 'file'), continue; end      % Study 2 has no Sentence Processing task
        anchors = fullfile(sd, 'anchor_regions.dscalar.nii');
        task.(contrasts{c}).roi(i, :) = s05_task_response(cfg, anchors, f, cfg.roi_ids);
        task.(contrasts{c}).net(i, :) = s05_task_response(cfg, anchors, f, ...
                                        {cfg.intLANG_ids, cfg.aLANG_ids});   % [intLANG aLANG]
    end
end
save(fullfile(cfg.out_dir, 'task_responses.mat'), 'task', 'S', 'contrasts');
% per-participant values for the R statistics in stats_R/ (NA = contrast not acquired)
for c = 1:numel(contrasts)
    T = [table({S.pid}', [S.study]', 'VariableNames', {'PID', 'study'}), ...
         array2table(task.(contrasts{c}).net, 'VariableNames', {'intLANG', 'aLANG'}), ...
         array2table(task.(contrasts{c}).roi, 'VariableNames', cfg.roi_names)];
    writetable(T, fullfile(cfg.out_dir, 'source_data', ['task_' contrasts{c} '.csv']));
end

%% 6. Phonological contrasts: intLANG vs aLANG, per study  (Fig. 5)
for st = 1:3
    sel = [S.study] == st;
    s06_fig5_phonology(cfg, task.RhymeFace.roi(sel, :), task.RhymeFace.net(sel, :), ...
                       ['Rhyme > Face | ' cfg.study_names{st}]);
    if st ~= 2
        s06_fig5_phonology(cfg, task.NonwordFix.roi(sel, :), task.NonwordFix.net(sel, :), ...
                           ['Nonword > Fixation | ' cfg.study_names{st}]);
    end
end

%% 7. Table 1: every intLANG region vs every aLANG region, pooled
s07_table1_region_pairs(cfg, task.RhymeFace.roi, 'Rhyme > Face (N = 22)', ...
                        fullfile(cfg.out_dir, 'Table1_RhymeFace.csv'));
sel = [S.study] ~= 2;
s07_table1_region_pairs(cfg, task.NonwordFix.roi(sel, :), 'Nonword > Fixation (N = 13)', ...
                        fullfile(cfg.out_dir, 'Table1_NonwordFix.csv'));

%% 8. Double dissociation: network x contrast, Studies 1 + 3 (N = 13)  (Fig. 6)
s08_fig6_double_dissociation(task.NonwordFix.net(sel, :), task.SentenceNonword.net(sel, :));
