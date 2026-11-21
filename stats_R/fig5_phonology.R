## Fig. 5: intLANG vs aLANG response to the phonological contrasts.
##
## Input: source_data/task_RhymeFace.csv and task_NonwordFix.csv, one row per
##   participant: PID, study, intLANG, aLANG (network level, mean z over all
##   vertices of the network's anchor regions), dPCSA ... pSTS (region level).
##   Rhyme > Face: Studies 1-3. Nonword > Fixation: Studies 1 and 3.
## Tests (paired, two-tailed, Cohen's dz), per study:
##   network level             : intLANG vs aLANG           (Fig. 5 left panels)
##   region level              : mean of 3 intLANG regions vs mean of 5 aLANG
##                               regions                    (Fig. 5 right panels)
##   adjacent region pairs     : vPCSA vs IFG, Spt vs pSTS
## Bars are mean +/- SEM (sample SD / sqrt(N)).

fig5_phonology <- function(data_dir) {
  out <- list()
  sets <- list(list(file = "task_RhymeFace.csv",  name = "Rhyme > Face",       studies = 1:3),
               list(file = "task_NonwordFix.csv", name = "Nonword > Fixation", studies = c(1, 3)))
  for (s in sets) {
    d <- read_source(data_dir, s$file)
    for (st in s$studies) {
      x <- d[d$study == st, ]
      lab <- paste(s$name, "|", STUDY_NAMES[st])
      cat(sprintf("=== Fig. 5 | %s ===\n", lab))
      sem <- function(v) sd(v) / sqrt(length(v))
      cat(sprintf("network mean (SEM): intLANG %.2f (%.2f), aLANG %.2f (%.2f)\n\n",
                  mean(x$intLANG), sem(x$intLANG), mean(x$aLANG), sem(x$aLANG)))
      out[[length(out) + 1]] <- paired_test(x$intLANG, x$aLANG,
        paste("network level |", lab), "intLANG", "aLANG")
      out[[length(out) + 1]] <- paired_test(rowMeans(x[, INTLANG_REGIONS]),
        rowMeans(x[, ALANG_REGIONS]), paste("mean of 3 vs mean of 5 regions |", lab),
        "intLANG", "aLANG")
      out[[length(out) + 1]] <- paired_test(x$vPCSA, x$IFG, paste("vPCSA vs IFG |", lab),
        "vPCSA", "IFG")
      out[[length(out) + 1]] <- paired_test(x$Spt, x$pSTS, paste("Spt vs pSTS |", lab),
        "Spt", "pSTS")
    }
  }
  invisible(do.call(rbind, out))
}
