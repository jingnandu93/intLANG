function cfg = config_example()
% CONFIG_EXAMPLE  Paths, software and per-participant parameters.
%
% Edit the paths in section 1 for your system. Everything else mirrors the
% values reported in Du et al. (2026) "Multiple Nested Distributed Networks
% in the Human Brain Support Language" and should not need changing.
%
% Naming used throughout this code release follows the manuscript:
%   intLANG = intermediate language network
%   aLANG   = association language network

%% 1. Paths (EDIT THESE) ---------------------------------------------------
cfg.wb_command   = 'wb_command';             % Connectome Workbench binary
cfg.cifti_matlab = '/path/to/cifti-matlab';   % provides ciftiopen / ciftisavereset
cfg.freesurfer_matlab = '/path/to/freesurfer/matlab';   % provides MRIread
% fsaverage6 dense-scalar template (81,924 cortical vertices, L then R)
cfg.fs6_template = '/path/to/fsaverage6_cifti_template.dscalar.nii';
% Root folder holding per-participant inputs (run lists, masks, task maps)
cfg.data_dir     = '/path/to/data';
cfg.out_dir      = fullfile(pwd, 'outputs');

%% 2. Surface constants ----------------------------------------------------
cfg.n_vert_hemi = 40962;                 % fsaverage6 vertices per hemisphere
cfg.n_vert      = 2 * cfg.n_vert_hemi;   % 81,924

%% 3. Anchor regions (fixed label IDs used in every ROI file) --------------
% Each participant's anchor-region dscalar must use THESE integer labels.
% Fixing the IDs by name avoids depending on file-listing order.
cfg.roi_names  = {'dPCSA','vPCSA','Spt','IFG','pMFG','aSTS','mSTS','pSTS'};
cfg.roi_ids    = 1:8;
cfg.intLANG_ids = 1:3;     % dPCSA, vPCSA, Spt
cfg.aLANG_ids   = 4:8;     % IFG, pMFG, aSTS, mSTS, pSTS

%% 4. Participants ---------------------------------------------------------
% Study 1 = Discovery (P1-P5), Study 2 = Replication (S1-S9),
% Study 3 = Triplication (P6-P9, P12-P15). P10/P11 were excluded (see Methods).
% intLANG seed = single fsaverage6 vertex (1-based MATLAB column index into
% the 81,924-vertex matrix; wb_view shows the 0-based index = seed - 1).
% thr = per-participant z(r) threshold used to binarize the seed map.
%            PID     study  intLANG_seed  thr    aLANG_seed  thr
P = {        'P1',   1,     12417,        0.50,  12406,      0.50
             'P2',   1,     14816,        0.40,  26944,      0.40
             'P3',   1,     26956,        0.40,  35345,      0.40
             'P4',   1,      6588,        0.35,  37241,      0.35
             'P5',   1,     26958,        0.40,  30716,      0.40
             'S1',   2,     19990,        0.40,   7256,      0.40
             'S2',   2,     12418,        0.50,   3491,      0.35
             'S3',   2,     30459,        0.45,  26939,      0.40
             'S4',   2,      7565,        0.45,  18037,      0.40
             'S5',   2,     14818,        0.40,  22233,      0.40
             'S6',   2,     30729,        0.50,  26945,      0.30
             'S7',   2,     30729,        0.50,  19948,      0.40
             'S8',   2,      6589,        0.50,  19940,      0.40
             'S9',   2,     19967,        0.50,  21193,      0.40
             'P6',   3,     19990,        0.50,   9499,      0.40
             'P7',   3,     14816,        0.50,   6763,      0.45
             'P8',   3,     37273,        0.45,  24114,      0.45
             'P9',   3,     34447,        0.45,  27690,      0.45
             'P12',  3,     30730,        0.45,   6808,      0.50
             'P13',  3,     30731,        0.45,  27693,      0.45
             'P14',  3,      6585,        0.45,  21000,      0.45
             'P15',  3,     30736,        0.50,    560,      0.40 };
cfg.subjects = cell2struct(P, {'pid','study','intLANG_seed','intLANG_thr', ...
                                'aLANG_seed','aLANG_thr'}, 2);
cfg.study_names = {'Discovery (Study 1)','Replication (Study 2)','Triplication (Study 3)'};

%% 5. Expected per-participant input files ---------------------------------
% <data_dir>/<PID>/dataset{1,2}/corr_mat_r2z.mat      : vertex-wise FC matrix (zCorrs)
% <data_dir>/<PID>/dataset2/lh_runs.txt, rh_runs.txt  : one fsaverage6 surface run per line
% <data_dir>/<PID>/anchor_regions.dscalar.nii         : labels 1-8 (section 3)
% <data_dir>/<PID>/network_mask.dscalar.nii           : 1 = intLANG, 2 = aLANG
% <data_dir>/<PID>/task/<contrast>.dscalar.nii         : task z-maps, e.g.
%        RhymeFace.dscalar.nii, NonwordFix.dscalar.nii, SentenceNonword.dscalar.nii
cfg.subj_dir = @(pid) fullfile(cfg.data_dir, pid);

end
