# Carpeta `procesamiento`

Scripts que transforman los datos y generan los resultados (protocolo IPO).

- `01-preparacion.R`: carga `input/data-orig/ELSOC_Long_2016_2022_v1.00.RData`,
  selecciona y recodifica variables, filtra casos válidos (olas 2016 y 2018) y guarda el
  dataset analítico en `input/data-proc/elsoc_analitico.rds`.
- `02-analisis.R`: estima los modelos MCO (M1–M3) con errores estándar agrupados por
  individuo (*cluster-robust* por `idencuesta`), calcula los resultados para el informe y
  genera las figuras. Escribe `output/modelos.rds`, `output/vcovs.rds`,
  `output/resultados.rds` y `output/figuras/*.png`.

## Reproducir

```bash
Rscript procesamiento/01-preparacion.R
Rscript procesamiento/02-analisis.R
```

Las tablas de regresión se construyen dentro de los capítulos (`05-resultados.qmd`,
`apendices/B-tablas.qmd`) a partir de los objetos guardados. Con `freeze: auto` los
resultados se regeneran solo al cambiar datos o código.
