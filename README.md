# Example analysis code: Du et al. (2026)

**Multiple Nested Distributed Networks in the Human Brain Support Language**
Jingnan Du, Anne Billot, Wendy Sun, Gregory Hickok, Mark Eldaief, Randy L. Buckner

This folder contains MATLAB code for the core analyses that identify the intermediate
language network (**intLANG**) and the association language network (**aLANG**) within
individuals and test how they differ. It covers the analyses behind Figs. 1, 3, 5 and 6
and Table 1. The code starts from preprocessed data: surface time series on fsaverage6,
vertex-wise functional connectivity matrices and task contrast z-maps, all produced by the
iProc pipeline (Braga et al. 2019). Preprocessing and the cerebellar analyses (Fig. 4)
are not included here.

## Requirements

| Software | Version used | Purpose |
|---|---|---|
| MATLAB | R2019a | all analyses (no toolboxes required) |
| R | 4.4.1 | statistical tests reported in the manuscript (`stats_R/`, base R only) |
| FreeSurfer | 6.0.0 | `MRIread` for surface runs |
| cifti-matlab | – | `ciftiopen` / `ciftisavereset` |
| Connectome Workbench | 1.3.2 | `wb_command`; border drawing and seed inspection in `wb_view` |

Edit the paths in `config_example.m`, then step through `run_all_example.m` section by section.
Steps 4 and 5 write the per-participant values to `outputs/source_data/`; the statistics
reported in the manuscript are then computed in R:

```
Rscript stats_R/run_all_stats.R outputs/source_data
```

The MATLAB functions s04 and s06–s08 run the same tests and give identical results.

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

## Analysis logic

1. **Split-half design.** Each participant's data are split into independent Dataset 1
   and Dataset 2. Sentence Processing runs are kept out of both datasets so they can be
   used for the independent functional tests.
2. **Network identification (s01).** The seed vertex's column of the vertex-wise
   functional connectivity matrix is its z(r) map. Each map is thresholded at that
   participant's own threshold; seeds and thresholds for all 22 participants are listed in
   `config_example.m`. Networks are defined in Dataset 1, and the same seed applied to
   Dataset 2 gives the replication.
3. **Anchor regions (s02).** A generous border is drawn by hand around each anatomical
   zone and intersected with the participant's own Dataset 1 network estimate. This gives
   3 intLANG regions (dPCSA, vPCSA, Spt) and 5 aLANG regions (IFG, pMFG, aSTS, mSTS,
   pSTS), stored with the fixed labels 1–8.
4. **Segregation (s03–s04).** Region time series come from the independent Dataset 2.
   Pearson r is computed per run, Fisher z-transformed and averaged across runs. For each
   participant, the mean z is taken over the 3 within-intLANG pairs, the 10 within-aLANG
   pairs and the 15 between-network pairs, and within > between is tested with a
   one-tailed paired t-test.
5. **Function (s05–s08).** Task z-maps are averaged within each anchor region and within
   each network, where a network's value is the mean over all vertices of its anchor
   regions. intLANG vs aLANG is tested with two-tailed paired t-tests. Fig. 6 uses a
   2 (network) × 2 (contrast) repeated-measures ANOVA.

## Statistical conventions

| Analysis | Test | Tail |
|---|---|---|
| Fig. 3 within > between network FC | paired t on Fisher z | one-tailed |
| Fig. 5 intLANG vs aLANG | paired t | two-tailed |
| Table 1 region pairs | paired t | two-tailed |
| Fig. 6 | 2 × 2 RM-ANOVA, post hoc paired t | two-tailed |

Effect sizes are Cohen's dz = mean(difference) / SD(difference).

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

Code: https://github.com/jingnandu93/intLANG (this repository), released under the MIT
License (see `LICENSE`).

Individual participant data are available through the NIH Data Archive
(https://nda.nih.gov). Task descriptions, contrast descriptions and analysis code are on
Harvard Dataverse (https://doi.org/10.7910/DVN/AVB4BW).
