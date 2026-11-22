# Example analysis code: Du et al. (2026)

Multiple Nested Distributed Networks in the Human Brain Support Language
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

## Code and data availability

The [example code](https://github.com/jingnandu93/intLANG) is distributed under
the MIT License. See `LICENSE`.

Individual participant data are available through the NIH Data Archive
(https://nda.nih.gov). Task descriptions, contrast descriptions and analysis code are on
Harvard Dataverse (https://doi.org/10.7910/DVN/AVB4BW).
