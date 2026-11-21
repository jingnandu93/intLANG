## Shared helpers for the statistical tests (base R only; R v4.4.1).

## Paired t-test with Cohen's dz = mean(a - b) / sd(a - b).
## alternative: "two.sided" (Fig. 5, Fig. 6 post hoc, Table 1)
##              "greater"   (Fig. 3, within > between network connectivity)
paired_test <- function(a, b, label, name_a = "A", name_b = "B",
                        alternative = "two.sided") {
  ok <- complete.cases(a, b)
  a <- a[ok]; b <- b[ok]
  tt <- t.test(a, b, paired = TRUE, alternative = alternative)
  d  <- a - b
  dz <- mean(d) / sd(d)
  cat(sprintf("%s (N = %d)\n", label, length(d)))
  cat(sprintf("  %s mean = %.3f | %s mean = %.3f | diff = %.3f (SD %.3f)\n",
              name_a, mean(a), name_b, mean(b), mean(d), sd(d)))
  cat(sprintf("  t(%d) = %.2f, p = %.3g (%s), Cohen's dz = %.2f\n\n",
              as.integer(tt$parameter), tt$statistic, tt$p.value,
              ifelse(alternative == "two.sided", "two-tailed", "one-tailed"), dz))
  invisible(data.frame(label = label, n = length(d), t = unname(tt$statistic),
                       df = unname(tt$parameter), p = tt$p.value, dz = dz))
}

sig_stars <- function(p) {
  if (p < .001) "***" else if (p < .01) "**" else if (p < .05) "*" else "n.s."
}

read_source <- function(data_dir, file) {
  read.csv(file.path(data_dir, file), stringsAsFactors = FALSE)
}

INTLANG_REGIONS <- c("dPCSA", "vPCSA", "Spt")
ALANG_REGIONS   <- c("IFG", "pMFG", "aSTS", "mSTS", "pSTS")
STUDY_NAMES     <- c("Discovery (Study 1)", "Replication (Study 2)", "Triplication (Study 3)")
