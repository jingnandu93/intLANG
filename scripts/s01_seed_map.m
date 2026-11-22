function [zcol, mask] = s01_seed_map(cfg, corr_mat_file, seed, thr, out_prefix)
% S01_SEED_MAP  Seed-region-based network estimate from the vertex-wise FC matrix (Fig. 1).
%
%   [zcol, mask] = s01_seed_map(cfg, corr_mat_file, 12417, 0.50, out_prefix)
%
%   corr_mat_file : participant's vertex-wise functional connectivity matrix
%                   (variable zCorrs, 81,924 x 81,924, Fisher z, averaged
%                   across runs), one file per dataset (Dataset 1 / Dataset 2)
%   seed          : single seed vertex (1-based column index; see config)
%   thr           : per-participant z(r) threshold (see config)
%
% The seed column contains the Fisher z map. The network
% mask includes vertices with z(r) > thr. matfile() reads the
% requested column from a v7.3 MAT-file.
% Networks are defined in Dataset 1; the same seed applied to the Dataset 2
% matrix gives the within-individual replication.

m    = matfile(corr_mat_file);
zcol = m.zCorrs(:, seed);
mask = double(zcol > thr);

if nargin >= 5 && ~isempty(out_prefix)
    write_cifti(zcol, [out_prefix '_seed' num2str(seed) '_zmap.dscalar.nii'], cfg);
    write_cifti(mask, [out_prefix '_seed' num2str(seed) '_thr' num2str(thr) '_mask.dscalar.nii'], cfg);
end
end
