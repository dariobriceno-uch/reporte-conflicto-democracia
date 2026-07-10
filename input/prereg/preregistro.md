# Pre-registro

**Título:** Percepción del conflicto de clases y satisfacción con la democracia en Chile
**Marco:** Evaluación final — Ciencia Social Abierta 2026
**Fecha de registro:** previo al análisis confirmatorio
**Proyecto OSF:** <https://osf.io/dfxvz>  (pre-registro en revisión; el DOI se añadirá al aprobarse)

## 1. Pregunta de investigación
¿Qué relación existe entre la percepción del conflicto de clases (entre clase alta y baja)
y la satisfacción con la democracia en Chile? ¿Depende esa relación de la posición
subjetiva de clase de las personas?

## 2. Hipótesis (confirmatorias)
- **H1.** A mayor percepción de conflicto de clases, menor será la satisfacción con la
  democracia (efecto principal negativo).
- **H2.** El efecto negativo de H1 será más intenso entre las personas con menor estatus
  social subjetivo. Como `estatus` se codifica de 0 (más bajo) a 10 (más alto), esta
  hipótesis implica un **coeficiente de interacción `conflicto × estatus` positivo** (la
  pendiente del conflicto se vuelve menos negativa a mayor estatus).

## 3. Datos
- Fuente: Estudio Longitudinal Social de Chile (ELSOC), COES. Versión pública
  `ELSOC_Long_2016_2022_v1.00`.
- Acceso: público bajo registro en <https://coes.cl/encuesta-panel/>.
- Olas analizadas: **2016 y 2018** (únicas con el ítem `f01_03`).

## 4. Variables
| Rol | Variable | Código ELSOC | Escala |
|-----|----------|--------------|--------|
| Dependiente | Satisfacción con la democracia | `c01` | 1–5 |
| Predictor focal | Percepción de conflicto clase alta/baja | `f01_03` | 1–5 |
| Moderador (H2) | Estatus social subjetivo | `d01_01` | 0–10 |
| Control | Autoubicación izquierda–derecha | `c15` | 0–10 |
| Control | Confianza en el gobierno | `c05_01` | 1–5 |
| Control | Sexo (mujer) | `m0_sexo` | 0/1 |
| Control | Edad | `m0_edad` | años |

## 5. Plan de análisis
1. Recodificar los códigos perdidos de ELSOC (−999, −888, −777, −666) como `NA`;
   tratar los valores 11 (Independiente) y 12 (Ninguno) de `c15` como `NA`.
2. Estimar regresión lineal (MCO) con **errores estándar agrupados por individuo**
   (*cluster-robust* por `idencuesta`, dado que las personas se repiten entre olas):
   - M1: `satdem ~ conflicto`
   - M2: `satdem ~ conflicto + estatus + izqder + confgob + mujer + edad + año`
   - M3 (H2): `satdem ~ conflicto*estatus + izqder + confgob + mujer + edad + año`
     (con `conflicto` y `estatus` centradas).
3. Criterio de decisión: se rechaza la hipótesis nula con *p* < 0,05 (dos colas).

## 6. Análisis exploratorios (declarados)
Como robustez, se examinarán moderadores alternativos (ideología y confianza en el
gobierno). Se reportarán explícitamente como **exploratorios** (ver Anexo B).
