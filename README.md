# Percepción del conflicto de clases y satisfacción con la democracia en Chile

Reporte de investigación abierta (Ciencia Social Abierta 2026) que analiza, con datos
ELSOC (COES), la relación entre la percepción del conflicto de clases y la satisfacción
con la democracia. Se contrastan dos hipótesis **pre-registradas**: H1 (el conflicto
percibido reduce la satisfacción con la democracia) y H2 (ese efecto es más intenso en
personas de menor estatus subjetivo).

## Reproducir el análisis

```bash
# 1. Generar el dataset analítico y los resultados
Rscript procesamiento/01-preparacion.R
Rscript procesamiento/02-analisis.R

# 2. Renderizar el libro
quarto render --to html        # sitio en docs/
quarto render                  # HTML + PDF (requiere LaTeX)
```

Los datos originales (`input/data-orig/ELSOC_Long_2016_2022_v1.00.RData`) son de acceso
público bajo registro en <https://coes.cl/encuesta-panel/>.

## Prácticas de ciencia abierta

- **Pre-registro** de hipótesis y protocolo en OSF: <https://osf.io/dfxvz> (`input/prereg/preregistro.md`).
- **Protocolo IPO** reproducible: `input/` → `procesamiento/` → `output/`.
- **Preprint** (SocArXiv): <https://osf.io/preprints/socarxiv/65czf_v1>.
- **GitHub Pages** desde `docs/`.

---

