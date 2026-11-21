function ts = load_surface_run(lh_file, rh_file)
% LOAD_SURFACE_RUN  Load one fsaverage6 run as a [time x 81,924] matrix.
%   Left-hemisphere vertices come first, then right (fsaverage6 order).
%   Requires FreeSurfer's MRIread on the MATLAB path.
lh = MRIread(lh_file);
rh = MRIread(rh_file);
lh_data = reshape(lh.vol, lh.nvoxels, lh.nframes);
rh_data = reshape(rh.vol, rh.nvoxels, rh.nframes);
ts = [lh_data; rh_data]';
end
