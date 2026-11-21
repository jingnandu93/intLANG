## Fig. 3: within- vs between-network functional connectivity.
##
## Input: source_data/fig3_study{1,2,3}.csv, one row per participant, Fisher z:
##   PID, within_intLANG (mean of 3 pairs), within_aLANG (10 pairs), between (15 pairs)
## Tests run on z: within > between, paired, one-tailed, with Cohen's dz.
## Mean connectivity is also reported as r = tanh(mean z).

fig3_within_between <- function(data_dir) {
  out <- list()
  for (st in 1:3) {
    d <- read_source(data_dir, sprintf("fig3_study%d.csv", st))
    cat(sprintf("=== Fig. 3 | %s ===\n", STUDY_NAMES[st]))
    cat(sprintf("mean r (z): within-intLANG %.2f (%.2f), within-aLANG %.2f (%.2f), between %.2f (%.2f)\n\n",
                tanh(mean(d$within_intLANG)), mean(d$within_intLANG),
                tanh(mean(d$within_aLANG)),   mean(d$within_aLANG),
                tanh(mean(d$between)),        mean(d$between)))
    out[[length(out) + 1]] <- paired_test(d$within_intLANG, d$between,
      paste("within-intLANG > between |", STUDY_NAMES[st]), "within", "between", "greater")
    out[[length(out) + 1]] <- paired_test(d$within_aLANG, d$between,
      paste("within-aLANG > between |", STUDY_NAMES[st]), "within", "between", "greater")
  }
  invisible(do.call(rbind, out))
}
