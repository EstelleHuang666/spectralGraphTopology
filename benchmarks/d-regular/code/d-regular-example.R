library(spectralGraphTopology)
library(extrafont)
library(igraph)
library(pals)
library(corrplot)

n <- 64
d <- 4
regular <- sample_k_regular(n, d)
Ltrue <- as.matrix(laplacian_matrix(regular))
Y <- MASS::mvrnorm(5e1 * n, mu = rep(0, n), Sigma = MASS::ginv(Ltrue))
S <- cov(Y)
graph <- learn_dregular_graph(S, w0 = "qp", eta = 1e4, beta = 1e4, record_weights = TRUE, record_objective = TRUE)
niter <- length(graph$obj_fun)
d_seq <- c()
for (i in 1:niter)
  d_seq <- c(d_seq, mean(diag(L(as.array(graph$w_seq[[i]])))))
gr = .5 * (1 + sqrt(5))
setEPS()
postscript("true_mat.ps", family = "Times", height = 5, width = gr * 3.5)
corrplot(Ltrue / max(Ltrue), is.corr = FALSE, method = "square", addgrid.col = NA, tl.pos = "n", cl.cex = 1.25)
dev.off()
setEPS()
postscript("est_mat.ps", family = "Times", height = 5, width = gr * 3.5)
corrplot(graph$Laplacian / max(graph$Laplacian), is.corr = FALSE, method = "square",
         addgrid.col = NA, tl.pos = "n", cl.cex = 1.25)
dev.off()

setEPS()
legend <- c("estimate of d", "true value of d")
cairo_ps("d_trend.ps", family = "Serif", height = 5, width = gr * 3.5)
plot(graph$elapsed_time, d_seq, xlab = "CPU time", ylab = "", type = "l",
     lty=1, cex=.75, col = "black")
abline(h=d, lty=2)
legend("topright", legend=legend, col=c("black", "black"), lty=c(1, 2), bty="n")
dev.off()
embed_fonts("d_trend.ps", outfile="d_trend.ps")
