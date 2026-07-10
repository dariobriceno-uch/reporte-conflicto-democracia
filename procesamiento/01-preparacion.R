# =============================================================================
# 01-preparacion.R
# Entrada  : input/data-orig/ELSOC_Long_2016_2022_v1.00.RData
# Proceso  : selección, recodificación y filtrado de casos válidos
# Salida   : input/data-proc/elsoc_analitico.rds
# Proyecto : Percepción del conflicto de clases y satisfacción con la democracia
# =============================================================================
suppressMessages({library(haven); library(dplyr)})

# Rutas relativas a la raíz del proyecto Quarto -------------------------------
ruta_orig <- "input/data-orig/ELSOC_Long_2016_2022_v1.00.RData"
ruta_proc <- "input/data-proc/elsoc_analitico.rds"

load(ruta_orig)                      # crea el objeto elsoc_long_2016_2022.2
d <- elsoc_long_2016_2022.2

# Función: convertir códigos perdidos ELSOC (-999,-888,-777,-666) en NA --------
na_elsoc <- function(x) { x <- as.numeric(x); ifelse(x < 0, NA, x) }

df <- d %>% transmute(
  idencuesta,
  ola      = as.numeric(ola),
  # Variable dependiente: satisfacción con la democracia (1 Nada – 5 Muy)
  satdem   = na_elsoc(c01),
  # Predictor focal: percepción de conflicto clase alta/baja (1 Nada – 5 Mucho)
  conflicto= na_elsoc(f01_03),
  # Moderador (H2): estatus social subjetivo (0 más bajo – 10 más alto)
  estatus  = na_elsoc(d01_01),
  # Covariables
  izqder   = { v <- na_elsoc(c15); ifelse(v %in% c(11, 12), NA, v) }, # 11=Indep,12=Ninguno -> NA
  confgob  = na_elsoc(c05_01),                                        # confianza gobierno (1-5)
  mujer    = ifelse(na_elsoc(m0_sexo) == 2, 1, 0),
  edad     = na_elsoc(m0_edad)
) %>%
  # f01_03 solo se midió en olas 1 (2016) y 3 (2018): restringimos a casos válidos
  filter(!is.na(satdem), !is.na(conflicto)) %>%
  mutate(anio = factor(ifelse(ola == 1, "2016", "2018")))

# Etiquetas para gráficos -----------------------------------------------------
attr(df, "labels_satdem")    <- c("Nada","Poco","Algo","Bastante","Muy")
attr(df, "labels_conflicto") <- c("Nada","Poco","Algo","Bastante","Mucho")

dir.create("input/data-proc", showWarnings = FALSE, recursive = TRUE)
saveRDS(df, ruta_proc)

cat("Dataset analítico guardado en", ruta_proc, "\n")
cat("N total (satdem + conflicto):", nrow(df), "\n")
cat("Casos por año:\n"); print(table(df$anio))
cat("N casos completos (todas las covariables):",
    sum(complete.cases(df[c("satdem","conflicto","estatus","izqder","confgob","mujer","edad")])), "\n")
