# Example analysis code: Du et al. (2026)

**Multiple Nested Distributed Networks in the Human Brain Support Language**
Jingnan Du, Anne Billot, Wendy Sun, Gregory Hickok, Mark Eldaief, Randy L. Buckner

The MATLAB and R scripts cover the cortical analyses for Figs. 1, 3, 5, and 6
and Table 1. They take preprocessed fsaverage6 surface time series, vertex-wise
functional connectivity matrices, and task contrast z maps as input. For
preprocessing, see iProc (Braga et al. 2019). The cerebellar analysis in Fig. 4
is outside the scope of this example.

## Requirements

| Software | Version used | Purpose |
|---|---|---|
| MATLAB | R2019a | surface and task analyses (no toolboxes required) |
| R | 4.4.1 | statistical tests reported in the manuscript (`stats_R/`, base R only) |
| FreeSurfer | 6.0.0 | `MRIread` for surface runs |
| cifti-matlab | – | `ciftiopen` / `ciftisavereset` |
| Connectome Workbench | 1.3.2 | `wb_command`; border drawing and seed inspection in `wb_view` |

Edit the paths in `config_example.m` and run `run_all_example.m` one section at a time.
Sections 4 and 5 write participant-level CSV files to `outputs/source_data/`.
Run the statistical tests from the repository directory:

```
Rscript stats_R/run_all_stats.R outputs/source_data
```

The MATLAB scripts s04 and s06–s08 also implement these tests.

## Layout

```
config_example.m          paths, fixed region labels, per-participant seeds and thresholds
run_all_example.m         runs every step in order, one section per figure
scripts/
  s01_seed_map.m                  seed-region network estimates               Fig. 1
  s02_border_to_roi.sh            drawn border -> surface mask (wb_command)
  s02_anchor_regions.m            drawn zone AND network estimate -> 8 regions
  s03_roi2roi_fc.m                8 x 8 region-to-region FC from Dataset 2    Fig. 3
  s04_fig3_within_between.m       within- vs between-network FC tests         Fig. 3
  s05_task_response.m             mean task z within each label               Fig. 5, 6
  s06_fig5_phonology.m            intLANG vs aLANG, phonological contrasts    Fig. 5
  s07_table1_region_pairs.m       3 x 5 region-pair tests, pooled             Table 1
  s08_fig6_double_dissociation.m  2 x 2 repeated-measures ANOVA + post hoc    Fig. 6
utils/                    CIFTI I/O, Pearson correlation, Fisher z, paired t-test
stats_R/                  statistical tests in R (as reported in the manuscript)
  run_all_stats.R                 runs all tests below on the source_data CSV files
  fig3_within_between.R           within > between network FC, one-tailed     Fig. 3
  fig5_phonology.R                intLANG vs aLANG, network and region level  Fig. 5
  table1_region_pairs.R           3 x 5 region-pair tests, pooled             Table 1
  fig6_double_dissociation.R      2 x 2 repeated-measures ANOVA + post hoc    Fig. 6
  stats_utils.R                   paired t-test with Cohen's dz
```

`source_data/` CSV files (one row per participant):
`fig3_study{1,2,3}.csv` (PID, within_intLANG, within_aLANG, between; Fisher z) and
`task_{RhymeFace,NonwordFix,SentenceNonword}.csv` (PID, study, intLANG, aLANG, and the
eight regions; NaN where a contrast was not acquired).

## Analysis steps

1. Define each participant’s networks in Dataset 1. Read the Fisher z map from
   the seed vertex’s column of `zCorrs` and apply the participant-specific
   threshold in `config_example.m`. Use the same seed and threshold in Dataset 2
   to check whether the spatial pattern replicates. Sentence Processing runs
   are excluded from both datasets.
2. On each participant’s inflated cortical surface, draw the anatomical zones
   in Workbench. Convert the borders to masks and intersect each mask with the
   corresponding Dataset 1 network estimate. The anchor labels are 1–3 for
   intLANG (dPCSA, vPCSA, Spt) and 4–8 for aLANG (IFG, pMFG, aSTS, mSTS, pSTS).
3. Extract the mean time series for each anchor region from Dataset 2. Compute
   pairwise Pearson correlations for each run, apply the Fisher z transform,
   and average across runs. For each participant, average the 3 within-intLANG
   pairs, 10 within-aLANG pairs, and 15 between-network pairs separately.
   Compare each within-network mean with the between-network mean.
4. For each task contrast, average the task z values within each anchor region.
   The example scripts calculate network-level responses by pooling the
   vertices in each network’s anchor regions and taking their mean. Table 1
   pools the region-level data across cohorts (22 participants for Rhyme > Face,
   13 for Nonword > Fixation). Fig. 6 pools Studies 1 and 3 (13 participants).

## Statistical conventions

| Analysis | Test | Tail |
|---|---|---|
| Fig. 3 within > between network FC | paired t on Fisher z | one-tailed |
| Fig. 5 intLANG vs aLANG | paired t | two-tailed |
| Table 1 region pairs | paired t | two-tailed |
| Fig. 6 | 2 × 2 repeated-measures ANOVA with post hoc paired t-tests | two-tailed for the paired tests |

Cohen’s `dz` is the mean paired difference divided by its standard deviation.

## Expected input layout

```
<data_dir>/<PID>/dataset{1,2}/corr_mat_r2z.mat   vertex-wise FC matrix, variable zCorrs
<data_dir>/<PID>/dataset2/{lh,rh}_runs.txt       fsaverage6 surface runs, one path per line
<data_dir>/<PID>/zones/<PID>_<region>_zone.dscalar.nii
<data_dir>/<PID>/anchor_regions.dscalar.nii      written by s02
<data_dir>/<PID>/task/{RhymeFace,NonwordFix,SentenceNonword}.dscalar.nii
```

Vertex indices in `config_example.m` are 1-based MATLAB indices into the 81,924-vertex
fsaverage6 array (left hemisphere first). `wb_view` displays the 0-based index, which is
the seed value minus 1.

## Code and data availability

The [example code](https://github.com/jingnandu93/intLANG) is distributed under
the MIT License. See `LICENSE`.

Individual participant data are available through the NIH Data Archive
(https://nda.nih.gov). Task descriptions, contrast descriptions and analysis code are on
Harvard Dataverse (https://doi.org/10.7910/DVN/AVB4BW).
