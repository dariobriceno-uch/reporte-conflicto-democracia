# =============================================================================
# 02-analisis.R
# Entrada  : input/data-proc/elsoc_analitico.rds
# Proceso  : descriptivos, modelos OLS (H1 y H2), SE robustos, figuras
# Salida   : output/modelos.rds, output/resultados.rds, output/figuras/*.png
# =============================================================================
suppressMessages({
  library(dplyr); library(ggplot2); library(sandwich); library(lmtest)
})

df <- readRDS("input/data-proc/elsoc_analitico.rds")

# Versiones centradas para la interacción (H2) --------------------------------
df <- df %>% mutate(
  conflicto_c = conflicto - mean(conflicto, na.rm = TRUE),
  estatus_c   = estatus   - mean(estatus,   na.rm = TRUE)
)

# --- Muestras ----------------------------------------------------------------
# Muestra de casos completos para los modelos multivariados.
vars_cc <- c("satdem","conflicto","estatus","izqder","confgob","mujer","edad","anio","idencuesta")
dfc <- df[stats::complete.cases(df[, vars_cc]), ]

# --- Modelos -----------------------------------------------------------------
# M1: efecto bruto (H1), muestra amplia
m1 <- lm(satdem ~ conflicto, data = df)
# M2: efecto ajustado (H1 con controles), casos completos
m2 <- lm(satdem ~ conflicto + estatus + izqder + confgob + mujer + edad + anio, data = dfc)
# M3: interacción conflicto x estatus (H2)
m3 <- lm(satdem ~ conflicto_c * estatus_c + izqder + confgob + mujer + edad + anio, data = dfc)

modelos <- list(M1 = m1, M2 = m2, M3 = m3)
saveRDS(modelos, "output/modelos.rds")

# --- Errores estándar agrupados por individuo (cluster-robust por idencuesta) -
# Las mismas personas aparecen en las olas 2016 y 2018: se corrige la falta de
# independencia entre observaciones del mismo individuo.
vc1 <- vcovCL(m1, cluster = df$idencuesta)
vc2 <- vcovCL(m2, cluster = dfc$idencuesta)
vc3 <- vcovCL(m3, cluster = dfc$idencuesta)
saveRDS(list(M1 = vc1, M2 = vc2, M3 = vc3), "output/vcovs.rds")

ct1 <- coeftest(m1, vcov = vc1)
ct2 <- coeftest(m2, vcov = vc2)
ct3 <- coeftest(m3, vcov = vc3)

g <- function(ct, term, col) ct[term, col]
res <- list(
  n_total    = nrow(model.frame(m1)),
  n_completo = nrow(model.frame(m2)),
  n_clusters = dplyr::n_distinct(dfc$idencuesta),
  n_2016     = sum(df$anio == "2016"),
  n_2018     = sum(df$anio == "2018"),
  # Descriptivos
  media_satdem    = mean(df$satdem),    sd_satdem    = sd(df$satdem),
  media_conflicto = mean(df$conflicto), sd_conflicto = sd(df$conflicto),
  media_estatus   = mean(df$estatus, na.rm = TRUE),
  pct_insatisf    = 100 * mean(df$satdem <= 2),               # nada/poco satisfecho
  pct_conflicto   = 100 * mean(df$conflicto >= 4),            # bastante/mucho conflicto
  # H1 bruto (M1, cluster)
  b_conflicto_bruto = g(ct1,"conflicto","Estimate"),
  p_conflicto_bruto = g(ct1,"conflicto","Pr(>|t|)"),
  # H1 ajustado (M2, cluster)
  b_conflicto  = g(ct2,"conflicto","Estimate"),
  se_conflicto = g(ct2,"conflicto","Std. Error"),
  p_conflicto  = g(ct2,"conflicto","Pr(>|t|)"),
  b_estatus    = g(ct2,"estatus","Estimate"),   p_estatus = g(ct2,"estatus","Pr(>|t|)"),
  b_confgob    = g(ct2,"confgob","Estimate"),   p_confgob = g(ct2,"confgob","Pr(>|t|)"),
  b_edad       = g(ct2,"edad","Estimate"),      p_edad    = g(ct2,"edad","Pr(>|t|)"),
  b_mujer      = g(ct2,"mujer","Estimate"),     p_mujer   = g(ct2,"mujer","Pr(>|t|)"),
  b_anio2018   = g(ct2,"anio2018","Estimate"),  p_anio    = g(ct2,"anio2018","Pr(>|t|)"),
  # H2 (M3, interacción, cluster)
  b_interaccion  = g(ct3,"conflicto_c:estatus_c","Estimate"),
  se_interaccion = g(ct3,"conflicto_c:estatus_c","Std. Error"),
  p_interaccion  = g(ct3,"conflicto_c:estatus_c","Pr(>|t|)"),
  r2_m1 = summary(m1)$r.squared,
  r2_m2 = summary(m2)$r.squared,
  r2_m3 = summary(m3)$r.squared
)
saveRDS(res, "output/resultados.rds")

# --- Figuras -----------------------------------------------------------------
dir.create("output/figuras", showWarnings = FALSE, recursive = TRUE)
tema <- theme_minimal(base_size = 13) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold"))
azul <- "#2c3e50"; rojo <- "#c0392b"

# Fig 1: distribución de la satisfacción con la democracia
etq_sat <- c("Nada","Poco","Algo","Bastante","Muy")
f1 <- df %>% count(satdem) %>% mutate(pct = 100*n/sum(n)) %>%
  ggplot(aes(factor(satdem, labels = etq_sat), pct)) +
  geom_col(fill = azul, width = .7) +
  geom_text(aes(label = sprintf("%.1f%%", pct)), vjust = -0.4, size = 4) +
  labs(x = "Satisfacción con la democracia", y = "Porcentaje",
       title = "Distribución de la satisfacción con la democracia",
       caption = "ELSOC 2016 y 2018 (COES)") + tema
ggsave("output/figuras/fig-descriptivos.png", f1, width = 7, height = 4.3, dpi = 150)

# Fig 2 (H1): satisfacción media según nivel de conflicto percibido
etq_conf <- c("Nada","Poco","Algo","Bastante","Mucho")
f2 <- df %>% group_by(conflicto) %>%
  summarise(m = mean(satdem), se = sd(satdem)/sqrt(n()), .groups = "drop") %>%
  ggplot(aes(factor(conflicto, labels = etq_conf), m)) +
  geom_errorbar(aes(ymin = m-1.96*se, ymax = m+1.96*se), width = .15, color = azul) +
  geom_point(size = 3, color = rojo) +
  geom_line(aes(group = 1), color = rojo, linewidth = .8) +
  labs(x = "Percepción de conflicto entre clase alta y baja",
       y = "Satisfacción media con la democracia",
       title = "H1: a mayor conflicto percibido, menor satisfacción",
       caption = "Promedios con IC 95%. ELSOC 2016 y 2018 (COES)") + tema
ggsave("output/figuras/fig-h1.png", f2, width = 7, height = 4.3, dpi = 150)

# Fig 3 (H2): predicción según conflicto para estatus bajo vs alto
q <- quantile(df$estatus, c(.25,.75), na.rm = TRUE)
nd <- expand.grid(conflicto = 1:5,
                  estatus = q,
                  izqder = mean(df$izqder, na.rm = TRUE),
                  confgob = mean(df$confgob, na.rm = TRUE),
                  mujer = 0, edad = mean(df$edad, na.rm = TRUE),
                  anio = factor("2018", levels = levels(df$anio)))
nd$conflicto_c <- nd$conflicto - mean(df$conflicto)
nd$estatus_c   <- nd$estatus   - mean(df$estatus, na.rm = TRUE)
nd$pred <- predict(m3, nd)
nd$Estatus <- factor(nd$estatus, labels = c("Estatus bajo (p25)","Estatus alto (p75)"))
f3 <- ggplot(nd, aes(conflicto, pred, color = Estatus)) +
  geom_line(linewidth = 1) + geom_point(size = 2) +
  scale_color_manual(values = c(rojo, azul)) +
  labs(x = "Percepción de conflicto de clases",
       y = "Satisfacción predicha con la democracia",
       title = "H2: el efecto no varía según el estatus subjetivo",
       caption = "Pendientes casi paralelas: interacción no significativa. ELSOC (COES)") +
  tema + theme(legend.position = "top", legend.title = element_blank())
ggsave("output/figuras/fig-h2.png", f3, width = 7, height = 4.3, dpi = 150)

cat("== Análisis completo ==\n")
cat(sprintf("H1: conflicto b=%.4f (SE=%.4f) p=%.5f\n", res$b_conflicto, res$se_conflicto, res$p_conflicto))
cat(sprintf("H2: interaccion b=%.4f (SE=%.4f) p=%.4f\n", res$b_interaccion, res$se_interaccion, res$p_interaccion))
cat(sprintf("R2: M1=%.3f M2=%.3f M3=%.3f\n", res$r2_m1, res$r2_m2, res$r2_m3))
cat(sprintf("N=%d (2016=%d, 2018=%d) | insatisf=%.1f%% conflicto alto=%.1f%%\n",
            res$n_completo, res$n_2016, res$n_2018, res$pct_insatisf, res$pct_conflicto))
