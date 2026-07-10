# Datos originales

## `ELSOC_Long_2016_2022_v1.00.RData`

- **Fuente:** Estudio Longitudinal Social de Chile (ELSOC), Centro de Estudios de
  Conflicto y Cohesión Social (COES).
- **Tipo:** encuesta panel probabilística de población adulta residente en Chile.
- **Versión:** `v1.00` (formato largo, olas 2016–2022).
- **Acceso / licencia:** datos de acceso público bajo registro gratuito en
  <https://coes.cl/encuesta-panel/>. El uso es para fines académicos citando a COES.
- **Objeto R contenido:** `elsoc_long_2016_2022.2` (18.035 filas × 750 variables).
- **Uso en este proyecto:** solo las olas **2016 y 2018** contienen el ítem `f01_03`
  (percepción de conflicto de clases), por lo que el análisis se restringe a ellas.

> El archivo se conserva sin modificaciones. Toda transformación se realiza en
> `procesamiento/01-preparacion.R`, que escribe el dataset analítico en
> `input/data-proc/elsoc_analitico.rds`.
