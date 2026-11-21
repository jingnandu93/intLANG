function data = read_cifti(file, cfg)
% READ_CIFTI  Return the data matrix (vertices x maps) of a CIFTI file.
g = ciftiopen(file, cfg.wb_command, 1);
data = g.cdata;
end
