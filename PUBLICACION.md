# Guía de publicación (OSF + GitHub Pages)

Este documento resume los pasos para cumplir los requisitos de ciencia abierta:
registro en OSF, preprint y despliegue del libro en GitHub Pages.

---

## 1. OSF (Open Science Framework)

> **Proyecto creado:** <https://osf.io/dfxvz> — pre-registro enviado y en ventana de
> revisión (~48 h). Al aprobarse, copiar el **DOI** de la registración al campo `doi:` de
> `_quarto.yml` y a `input/prereg/preregistro.md`.

1. **Crear el proyecto:** en OSF, *Create Project* → título:
   "Percepción del conflicto de clases y satisfacción con la democracia en Chile".
2. **Subir materiales** (pestaña *Files*):
   - `input/prereg/preregistro.md` — hipótesis, diseño y plan de análisis.
   - `procesamiento/01-preparacion.R` y `02-analisis.R` — código reproducible.
   - Un PDF del reporte (`docs/reportes-facso-plantilla.pdf`) como preprint/manuscrito.
   - Enlace al repositorio de GitHub (en la descripción del proyecto).
3. **Pre-registro:** *Registrations* → *New registration* → plantilla
   "OSF Preregistration" → pegar el contenido de `input/prereg/preregistro.md`.
   Al registrar, OSF **congela** (time-stamp) las hipótesis: hazlo **antes** de difundir
   los resultados para que el contraste sea confirmatorio.
4. **Hacer público** el proyecto y (opcional) solicitar un **DOI** desde la configuración.
5. Copiar el enlace/DOI de OSF a:
   - `input/prereg/preregistro.md` (campo "Repositorio OSF").
   - `_quarto.yml` (campo `doi:` del bloque `book:`), para que aparezca en la portada.

## 2. Preprint

**Publicado** en SocArXiv (OSF Preprints): <https://osf.io/preprints/socarxiv/65czf_v1>.
Corresponde al PDF renderizado (`docs/reportes-facso-plantilla.pdf`).

---

## 3. GitHub Pages

> Requiere una cuenta en <https://github.com>. El repositorio local ya está inicializado
> y `docs/` contiene el sitio con un archivo `.nojekyll` (necesario para que GitHub sirva
> las carpetas `site_libs/`).

### 3a. Crear el repositorio y subirlo

**Opción A — con GitHub CLI (`gh`), si lo instalas** (<https://cli.github.com>):

```bash
gh auth login
gh repo create reporte-conflicto-democracia --public --source=. --remote=origin --push
```

**Opción B — manual (sin `gh`):**

1. Crea un repositorio vacío y **público** en github.com (p. ej. `reporte-conflicto-democracia`),
   sin README ni .gitignore (ya existen aquí).
2. En este proyecto, conéctalo y sube:

```bash
cd C:\csa-book                 # usar el junction (ruta ASCII); ver README
git branch -M main
git remote add origin https://github.com/<tu-usuario>/reporte-conflicto-democracia.git
git push -u origin main
```

### 3b. Activar Pages

En el repositorio: **Settings → Pages → Build and deployment**
- **Source:** *Deploy from a branch*
- **Branch:** `main` y carpeta **`/docs`** → *Save*.

En ~1 minuto el libro estará en:
`https://<tu-usuario>.github.io/reporte-conflicto-democracia/`

### 3c. Actualizar el sitio

Cada vez que cambies contenido:

```bash
cd C:\csa-book
quarto render          # regenera docs/ (HTML + PDF)
git add -A && git commit -m "Actualiza reporte" && git push
```

---

## Nota sobre los datos

Los microdatos de ELSOC **no** se versionan en el repositorio (respetando los términos de
acceso de COES). Se obtienen bajo registro gratuito en <https://coes.cl/encuesta-panel/>
(ver `input/data-orig/README.md`). El sitio se reconstruye igualmente porque los resultados
quedan congelados en `_freeze/`.
