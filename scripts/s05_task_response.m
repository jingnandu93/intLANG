function vals = s05_task_response(cfg, label_file, task_map_file, label_ids)
% S05_TASK_RESPONSE  Mean task z-value within each label of a label map (Fig. 5, 6).
%
%   vals = s05_task_response(cfg, label_file, task_map_file, label_ids)
%
%   label_file    : fsaverage6 dscalar with integer labels, e.g.
%                   - anchor regions (s02), labels 1-8 -> region-level values
%                   - network map, 1 = intLANG, 2 = aLANG -> network-level values
%   task_map_file : first-level task contrast z-map on fsaverage6
%                   (Rhyme > Face, Nonword > Fixation or Sentence > Nonword)
%   label_ids     : labels to extract, in the order wanted in the output
%
%   vals : 1 x numel(label_ids), mean z over the vertices of each label

labels = read_cifti(label_file, cfg);
zmap   = read_cifti(task_map_file, cfg);
vals = nan(1, numel(label_ids));
for k = 1:numel(label_ids)
    vals(k) = mean(zmap(labels == label_ids(k)), 'omitnan');
end
end
