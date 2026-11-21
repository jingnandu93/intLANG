## Statistical tests reported in Du et al. (2026), run in R v4.4.1 (base R only).
##
## Usage:  Rscript stats_R/run_all_stats.R <source_data_dir>
##   <source_data_dir> holds the per-participant CSV files written by
##   run_all_example.m (steps 4 and 5): fig3_study{1,2,3}.csv and
##   task_{RhymeFace,NonwordFix,SentenceNonword}.csv

args <- commandArgs(trailingOnly = TRUE)
data_dir <- if (length(args) >= 1) args[1] else file.path("outputs", "source_data")

this_file <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
here <- if (length(this_file)) dirname(normalizePath(this_file)) else "stats_R"
for (f in c("stats_utils.R", "fig3_within_between.R", "fig5_phonology.R",
            "table1_region_pairs.R", "fig6_double_dissociation.R")) {
  source(file.path(here, f))
}

cat("R", R.version$major, ".", R.version$minor, " | source data: ", data_dir, "\n\n", sep = "")
fig3_within_between(data_dir)
fig5_phonology(data_dir)
table1_region_pairs(data_dir)
fig6_double_dissociation(data_dir)
