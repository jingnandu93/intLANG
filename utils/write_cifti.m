function write_cifti(data, out_file, cfg)
% WRITE_CIFTI  Save a vertices x 1 vector as an fsaverage6 dense-scalar file.
g = ciftiopen(cfg.fs6_template, cfg.wb_command, 1);
g.cdata = data;
out_dir = fileparts(out_file);
if ~isempty(out_dir) && ~exist(out_dir, 'dir'), mkdir(out_dir); end
ciftisavereset(g, out_file, cfg.wb_command);
end
