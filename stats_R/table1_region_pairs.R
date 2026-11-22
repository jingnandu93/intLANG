## Table 1: every intLANG region vs every aLANG region, data pooled across studies.
##
## Input: source_data/task_RhymeFace.csv (N = 22, Studies 1-3) and
##        source_data/task_NonwordFix.csv (N = 13, Studies 1 and 3).
## Run two-tailed paired t-tests for the 3 x 5 region pairs. The tests share
## participants and ask whether the network-level difference holds for each pair.
## Cell = significance (intLANG region mean / aLANG region mean).

table1_region_pairs <- function(data_dir, out_dir = data_dir) {
  sets <- list(list(file = "task_RhymeFace.csv",  name = "Rhyme > Face",       tag = "RhymeFace"),
               list(file = "task_NonwordFix.csv", name = "Nonword > Fixation", tag = "NonwordFix"))
  for (s in sets) {
    d <- read_source(data_dir, s$file)
    d <- d[complete.cases(d[, c(INTLANG_REGIONS, ALANG_REGIONS)]), ]
    cells <- matrix("", 3, 5, dimnames = list(INTLANG_REGIONS, ALANG_REGIONS))
    stats <- list()
    for (r in INTLANG_REGIONS) for (a in ALANG_REGIONS) {
      tt <- t.test(d[[r]], d[[a]], paired = TRUE)
      dz <- mean(d[[r]] - d[[a]]) / sd(d[[r]] - d[[a]])
      star <- if (tt$statistic > 0) sig_stars(tt$p.value) else "n.s.(<0)"
      cells[r, a] <- sprintf("%s (%.2f/%.2f)", star, mean(d[[r]]), mean(d[[a]]))
      stats[[length(stats) + 1]] <- data.frame(intLANG_region = r, aLANG_region = a,
        t = unname(tt$statistic), df = unname(tt$parameter), p = tt$p.value, dz = dz)
    }
    cat(sprintf("=== Table 1 | %s (N = %d) ===\n", s$name, nrow(d)))
    print(noquote(cells)); cat("\n")
    stats <- do.call(rbind, stats)
    write.csv(cells, file.path(out_dir, sprintf("Table1_%s.csv", s$tag)))
    write.csv(stats, file.path(out_dir, sprintf("Table1_%s_stats.csv", s$tag)), row.names = FALSE)
  }
}
