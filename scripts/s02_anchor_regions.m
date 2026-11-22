function labels = s02_anchor_regions(cfg, pid, zone_files, intLANG_mask_file, aLANG_mask_file, out_file)
% S02_ANCHOR_REGIONS  Build the 8 anchor regions for one participant (Fig. S7, S10, S12).
%
%   labels = s02_anchor_regions(cfg, 'P1', zone_files, intLANG_mask, aLANG_mask, out_file)
%
%   zone_files : struct whose field names are the region names in
%                cfg.roi_names, each pointing to the drawn-zone mask produced
%                by s02_border_to_roi.sh, e.g.
%                  zone_files.dPCSA = '.../P1_dPCSA_zone.dscalar.nii';
%                  ...
%                  zone_files.pSTS  = '.../P1_pSTS_zone.dscalar.nii';
%   intLANG_mask_file / aLANG_mask_file :
%                binary Dataset 1 network estimates from s01_seed_map
%
% Intersect each drawn zone with the corresponding Dataset 1 network mask.



intLANG = read_cifti(intLANG_mask_file, cfg) > 0;
aLANG   = read_cifti(aLANG_mask_file,   cfg) > 0;

labels = zeros(cfg.n_vert, 1);
for k = 1:numel(cfg.roi_names)
    name = cfg.roi_names{k};
    zone = read_cifti(zone_files.(name), cfg) > 0;
    if ismember(cfg.roi_ids(k), cfg.intLANG_ids)
        roi = zone & intLANG;
    else
        roi = zone & aLANG;
    end
    overlap = roi & labels > 0;
    if any(overlap)
        warning('%s: %d vertices of %s already labelled; keeping the earlier label.', ...
                pid, nnz(overlap), name);
        roi = roi & ~overlap;
    end
    labels(roi) = cfg.roi_ids(k);
    fprintf('%s %-6s %5d vertices\n', pid, name, nnz(roi));
    if ~any(roi), warning('%s: anchor region %s is empty.', pid, name); end
end

if nargin >= 6 && ~isempty(out_file)
    write_cifti(labels, out_file, cfg);
end
end
