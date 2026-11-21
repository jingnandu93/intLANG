## Fig. 6: network x contrast double dissociation (Studies 1 and 3, N = 13).
##
## Input: source_data/task_NonwordFix.csv and task_SentenceNonword.csv
##   (network-level columns intLANG, aLANG; Study 2 has no Sentence Processing task).
## 2 (network: intLANG, aLANG) x 2 (contrast: Nonword > Fixation,
## Sentence > Nonword) repeated-measures ANOVA, followed by paired two-tailed
## post hoc t-tests:
##   Nonword > Fixation : intLANG vs aLANG
##   Sentence > Nonword : aLANG vs intLANG

fig6_double_dissociation <- function(data_dir) {
  nf <- read_source(data_dir, "task_NonwordFix.csv")
  sn <- read_source(data_dir, "task_SentenceNonword.csv")
  nf <- nf[complete.cases(nf$intLANG, nf$aLANG), ]
  sn <- sn[match(nf$PID, sn$PID), ]
  stopifnot(identical(nf$PID, sn$PID), !anyNA(sn$intLANG), !anyNA(sn$aLANG))

  long <- data.frame(
    PID      = factor(rep(nf$PID, 4)),
    contrast = factor(rep(c("Nonword > Fixation", "Sentence > Nonword"), each = 2 * nrow(nf))),
    network  = factor(rep(rep(c("intLANG", "aLANG"), each = nrow(nf)), 2),
                      levels = c("intLANG", "aLANG")),
    meanZ    = c(nf$intLANG, nf$aLANG, sn$intLANG, sn$aLANG))

  cat(sprintf("=== Fig. 6 | 2 x 2 repeated-measures ANOVA (N = %d) ===\n", nrow(nf)))
  fit <- aov(meanZ ~ contrast * network + Error(PID / (contrast * network)), data = long)
  print(summary(fit)); cat("\n")

  paired_test(nf$intLANG, nf$aLANG, "Nonword > Fixation: intLANG vs aLANG", "intLANG", "aLANG")
  paired_test(sn$aLANG, sn$intLANG, "Sentence > Nonword: aLANG vs intLANG", "aLANG", "intLANG")
  invisible(fit)
}
