function vals = s05_task_response(cfg, label_file, task_map_file, label_ids)
% S05_TASK_RESPONSE  Mean task z-value within each label of a label map (Fig. 5, 6).
%
%   vals = s05_task_response(cfg, label_file, task_map_file, label_ids)
%
%   label_file    : anchor-region labels from s02 (labels 1-8)
%   task_map_file : first-level task contrast z-map on fsaverage6
%                   (Rhyme > Face, Nonword > Fixation or Sentence > Nonword)
%   label_ids     : numeric vector -> one value per region, e.g. cfg.roi_ids
%                   cell array     -> one value per group of regions, e.g.
%                   {cfg.intLANG_ids, cfg.aLANG_ids} gives the network-level
%                   values [intLANG aLANG] over all vertices of that network's
%                   anchor regions
%
%   vals : 1 x numel(label_ids), mean z over the vertices of each label / group

labels = read_cifti(label_file, cfg);
zmap   = read_cifti(task_map_file, cfg);
if ~iscell(label_ids), label_ids = num2cell(label_ids); end
vals = nan(1, numel(label_ids));
for k = 1:numel(label_ids)
    vals(k) = mean(zmap(ismember(labels, label_ids{k})), 'omitnan');
end
end
