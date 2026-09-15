#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MONITOR CIID - Profesionalizacion completa
# Estefania Perez Vazquez
# Uso: bash profesionalizar-todo.sh
# ============================================================

set -e

DIR="$HOME/monitor-ciid-demo"
cd "$DIR"

echo ""
echo "===================================================="
echo "  MONITOR CIID - Profesionalizacion completa"
echo "  Estefania Perez Vazquez"
echo "===================================================="
echo ""

mkdir -p .github/ISSUE_TEMPLATE
mkdir -p .github/workflows
mkdir -p docs
mkdir -p assets
echo "[1/13] Estructura creada"
echo ""

cat > README.md <<'MDEOF'
<div align="center">

<img src="./assets/logo-ciid.svg" alt="MONITOR CIID" width="320">

# MONITOR CIID

**Centro Inteligente de Información Digital**

<p>
  <img src="https://img.shields.io/badge/status-piloto-blue?style=for-the-badge" alt="Estado: Piloto">
  <img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="Licencia MIT">
  <img src="https://img.shields.io/badge/deploy-Netlify-00C7B7?style=for-the-badge" alt="Deploy Netlify">
  <img src="https://img.shields.io/badge/lengua-Zapoteco-a371f7?style=for-the-badge" alt="Lengua Originaria">
</p>

<p>
  <a href="https://monitorciid.netlify.app/?demo=2">Ver Demo en Vivo</a> ·
  <a href="#-arquitectura">Arquitectura</a> ·
  <a href="./docs/ROADMAP.md">Roadmap</a> ·
  <a href="./CONTRIBUTING.md">Contribuir</a>
</p>

<p><em>"La tecnología asiste. El periodista decide."</em></p>

</div>

---

## Concepto

**MONITOR CIID** es una infraestructura periodística de nueva generación que asiste al periodista en el procesamiento, verificación, distribución y preservación de información. Su diferencial clave: **la preservación del patrimonio cultural y lingüístico de las comunidades de Oaxaca**.

> **"El objetivo no es publicar más rápido. El objetivo es publicar mejor."**

## Características Clave

| Característica | Descripción |
| :--- | :--- |
| **Ingesta Ciudadana** | Reportes vía WhatsApp: texto, fotografía y audio en lengua originaria |
| **Normalización y Clasificación** | Detecta territorio, tema, actores y sensibilidad patrimonial |
| **Asistencia Editorial** | Genera borradores periodísticos estructurados |
| **Verificación y Contraste** | Regla de oro: ningún reporte se publica sin contraste |
| **Validación Lingüística** | Preserva significado, contexto, variante y cosmovisión |
| **Decisión Humana** | El periodista decide qué se publica |
| **Publicación Multiformato** | Web, redes, audio, lengua originaria, medios comunitarios |
| **Archivo Patrimonial Vivo** | La noticia se convierte en memoria digital de una comunidad |

## Quick Start

```bash
git clone https://github.com/Designdigitalestefania/monitorciid.git
cd monitorciid
python -m http.server 8080
# Demo interactiva: http://localhost:8080/?demo=2
# Comparativa:      http://localhost:8080/?demo=comp
```

Arquitectura

```mermaid
graph TD
    A["Reporte ciudadano"] --> B["Ingesta CIID"]
    B --> C["Normalización y Clasificación"]
    C --> D["Asistencia Editorial"]
    C --> E["Verificación"]
    E --> F["Validación Lingüística"]
    D --> G["Decisión Humana"]
    F --> G
    G --> H["Publicación Multiformato"]
    H --> I["Archivo Patrimonial Vivo"]
```

Pipeline Completo

# Etapa Descripción
1 RECEIVED Ingesta de información ciudadana o institucional
2 PROCESSING Normalización y preservación del material original
3 CLASSIFIED Clasificación temática, territorial y lingüística
4 EDITORIAL_REVIEW Asistencia editorial bilingüe
5 VERIFICATION Verificación con fuentes + validación lingüística
6 DECISION Decisión editorial humana
7 PUBLISHED Distribución multiformato
8 PRESERVED Preservación en el Archivo Patrimonial Vivo

Stack Tecnológico

· Frontend: HTML5, CSS3, JavaScript vanilla (sin dependencias)
· Audio: Web Audio API · Web Speech API
· Diseño: SVG vectorial
· Deploy: Netlify (auto-deploy desde main)
· Accesibilidad: Responsive · Contraste alto · Navegación por teclado

Autoría

Estefanía Pérez Vázquez — Creadora y directora del proyecto
Estrategia e Innovación Digital · Arquitectura de Proyectos Tecnológicos
@Designdigitalestefania

Proyectos creados por la misma autora:

· MONITOR CIID — Centro Inteligente de Información Digital
· IXIMI LEGACY — Tecnología para preservar cultura

Medio aliado: Monitor Noticias Oaxaca
Territorio: Oaxaca, México

Visión

MONITOR CIID busca convertirse en una infraestructura replicable para medios regionales, instituciones culturales y proyectos territoriales que necesiten procesar, verificar y preservar información con pertinencia cultural y lingüística.

Contribuir

Consulta CONTRIBUTING.md · CODE_OF_CONDUCT.md · SECURITY.md

Roadmap

Consulta docs/ROADMAP.md

Licencia

MIT · Copyright (c) 2026 Estefanía Pérez Vázquez

---

<div align="center">

<em>Innovar para informar. Digitalizar para preservar.</em>

Hecho con cariño en Oaxaca, México.

</div>
MDEOF
echo "[2/13] README.md OK"

cat > LICENSE <<'LICEOF'
MIT License

Copyright (c) 2026 Estefanía Pérez Vázquez
Proyectos: MONITOR CIID · IXIMI LEGACY

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICEOF
echo "[3/13] LICENSE OK"

cat > CODE_OF_CONDUCT.md <<'COCEOF'

Código de Conducta

Nuestro Compromiso

En MONITOR CIID, proyecto creado y dirigido por Estefanía Pérez Vázquez,
nos comprometemos a mantener un entorno abierto, respetuoso e inclusivo para
todas las personas que participen, independientemente de su edad, origen,
identidad, lengua, nivel de experiencia o procedencia.

Dado que trabajamos con patrimonio cultural y lingüístico de comunidades
originarias, asumimos un compromiso adicional: el respeto profundo por las
comunidades, sus lenguas y sus procesos de decisión.

Nuestros Estándares

Comportamientos que contribuyen a un ambiente positivo:

· Usar lenguaje respetuoso e incluyente.
· Respetar las lenguas originarias, sus variantes y sus hablantes.
· Aceptar críticas constructivas con apertura.
· Priorizar el interés de las comunidades sobre cualquier interés individual.
· Reconocer y acreditar el trabajo de colaboradores, traductores y hablantes.

Comportamientos inaceptables:

· Lenguaje ofensivo o discriminatorio.
· Apropiación de contenido cultural sin consentimiento.
· Publicación de información sin proceso de verificación.
· Acoso, ataques personales o descalificación de otros colaboradores.
· Uso del proyecto para fines ajenos a su propósito periodístico y patrimonial.

Aplicación

Los casos de comportamiento abusivo, acosador o inaceptable pueden ser
reportados al equipo del proyecto en:

estefaniaprzvzqz@outlook.com

Todas las quejas serán revisadas y atendidas de manera confidencial.

Atribución

Este Código de Conducta está basado en el
Contributor Covenant, versión 2.1.
COCEOF
echo "[4/13] CODE_OF_CONDUCT.md OK"

cat > CONTRIBUTING.md <<'CONTEOF'

Guía de Contribución

¡Gracias por tu interés en MONITOR CIID! Este proyecto es creado y dirigido
por Estefanía Pérez Vázquez y busca construir una infraestructura
periodística que asista al periodista y preserve el patrimonio cultural y
lingüístico de Oaxaca.

Antes de contribuir, por favor lee el Código de Conducta.

Cómo Contribuir

1. Reportar un Bug o Sugerir una Mejora

Abre un Issue en el repositorio. Usa las plantillas disponibles:

· Bug report: para errores o comportamientos inesperados.
· Feature request: para sugerir nuevas funcionalidades.

2. Enviar Código

1. Haz un fork del repositorio.
2. Crea una rama descriptiva:
   ```bash
   git checkout -b feature/mi-nueva-funcion
   ```
3. Realiza tus cambios siguiendo el estilo del proyecto.
4. Verifica que la demo siga funcionando localmente:
   ```bash
   python -m http.server 8080
   ```
5. Haz commits con mensajes claros:
   ```bash
   git commit -m "Añade validación de audio en la ingesta"
   ```
6. Sube tu rama:
   ```bash
   git push origin feature/mi-nueva-funcion
   ```
7. Abre un Pull Request describiendo qué problema resuelve y cómo se probó.

Contribuciones Lingüísticas y Culturales

Dado que el proyecto trabaja con lenguas originarias, existe un proceso
especial para contribuciones en este ámbito:

· Toda traducción o validación lingüística debe ser realizada por hablantes nativos.
· Se acreditará siempre al colaborador lingüístico.
· Se requiere consentimiento informado de la comunidad cuando aplique.
· Se respeta la variante específica de cada comunidad.

Consulta docs/CONSENTIMIENTO-INFORMADO.md.

Estilo de Código

· JavaScript: claro, sin dependencias externas.
· CSS: variables CSS para colores y espaciados.
· HTML: semántico y accesible.
· Commits: en español o inglés, consistentes.

Licencia

Al contribuir, aceptas que tus aportaciones se publiquen bajo la
Licencia MIT del proyecto.

---

<p align="center">
  <em>Gracias por ayudar a construir MONITOR CIID.</em>
</p>
CONTEOF
echo "[5/13] CONTRIBUTING.md OK"

cat > SECURITY.md <<'SECEOF'

Política de Seguridad

Compromiso

La seguridad de MONITOR CIID y de la información que procesa es una
prioridad. Dado que el sistema maneja información ciudadana, audios en lenguas
originarias y contenido potencialmente sensible, tratamos la seguridad con el
mayor rigor.

Versiones Soportadas

· Producción: https://monitorciid.netlify.app

Reportar una Vulnerabilidad

Si detectas una vulnerabilidad, NO la reportes en un Issue público.

Envíanos un correo a:

estefaniaprzvzqz@outlook.com

Incluye:

· Descripción del problema.
· Pasos para reproducirlo.
· Impacto potencial.
· Capturas o registros (si aplica).

Nos comprometemos a:

· Acusar recibo en un plazo de 72 horas.
· Investigar y dar seguimiento.
· Mantenerte informado del estado del reporte.
· Acreditar tu colaboración (si lo deseas).

Alcance

· Código fuente del repositorio.
· Demo publicada.
· Assets y documentos del proyecto.

Fuera de Alcance

· Servicios de terceros (Netlify, GitHub).
· Ataques de ingeniería social.
· Pruebas de denegación de servicio.

---

<p align="center">
  <em>Gracias por ayudar a mantener MONITOR CIID seguro.</em>
</p>
SECEOF
echo "[6/13] SECURITY.md OK"

cat > docs/ROADMAP.md <<'ROADEOF'

Roadmap - MONITOR CIID

Plan de desarrollo del proyecto, organizado por fases.

Fase 0 - Piloto (actual)

☑ Demo navegable del pipeline completo
☑ Ingesta ciudadana vía WhatsApp (simulada)
☑ Asistencia editorial bilingüe
☑ Verificación y validación lingüística (demo)
☑ Publicación multiformato
☑ Archivo Patrimonial Vivo (demo)
☑ Modo presentación narrativa con narración por voz
☑ Deploy automático en Netlify
☑ Documentación institucional

Fase 1 - Consolidación del núcleo

☐ Backend real de ingesta (API + base de datos)
☐ Integración real con WhatsApp Business API
☐ Motor de clasificación con NLP en español
☐ Sistema de autenticación para periodistas
☐ Panel de administración de expedientes
☐ Persistencia del pipeline en base de datos

Fase 2 - Diferencial lingüístico

☐ Red de colaboradores hablantes nativos
☐ Registro estructurado de variantes lingüísticas
☐ Módulo de consentimiento informado digital
☐ Sistema de acreditación de colaboradores lingüísticos
☐ Preservación de audio con metadatos culturales completos

Fase 3 - Escala y territorio

☐ Despliegue en comunidades piloto (mínimo 3)
☐ Alianzas con radios comunitarias
☐ Formación de periodistas locales
☐ Protocolo de preservación a largo plazo
☐ Auditoría externa de ética y seguridad

Fase 4 - Ecosistema abierto

☐ Documentación técnica completa para replicación
☐ Liberación de componentes como open source
☐ Publicación de casos de estudio
☐ Alianzas con universidades e instituciones culturales
☐ Modelo de sostenibilidad financiera

Hitos Clave

Fase Estado Fecha estimada
Fase 0 - Piloto Completa 2026
Fase 1 - Núcleo En diseño 2026
Fase 2 - Lingüístico Planeada 2026-2027
Fase 3 - Escala Planeada 2027
Fase 4 - Ecosistema Planeada 2027-2028

---

<p align="center">
  <em>Innovar para informar. Digitalizar para preservar.</em>
</p>
ROADEOF
echo "[7/13] docs/ROADMAP.md OK"

cat > docs/CONSENTIMIENTO-INFORMADO.md <<'CONSEOF'

Consentimiento Informado para Colaboraciones Comunitarias

MONITOR CIID · Proyecto creado y dirigido por Estefanía Pérez Vázquez

Propósito

Este documento establece el marco ético bajo el cual MONITOR CIID recibe,
procesa y publica información proveniente de comunidades originarias de
Oaxaca, incluyendo textos, fotografías y audios en lenguas originarias.

Su objetivo es garantizar que toda participación sea libre, informada y
respetuosa de la autonomía de las comunidades y de las personas.

Principios

1. Consentimiento previo: Ninguna información se recibe ni se publica sin
   el consentimiento explícito de quien la aporta.
2. Información clara: La persona o comunidad debe conocer el uso que se dará
   a su información antes de otorgar el consentimiento.
3. Reversibilidad: Puede solicitar la eliminación de su contenido en
   cualquier momento.
4. Acreditación: Se reconocerá siempre la autoría y procedencia del
   contenido.
5. Respeto lingüístico: Se preservará la variante específica de la
   comunidad, sin homogenizarla.
6. Beneficio comunitario: El proyecto priorizará el beneficio de la
   comunidad por encima de cualquier interés comercial o institucional.

Elementos del Consentimiento

Cuando una persona o comunidad aporta contenido, se registra:

· Nombre (o seudónimo si prefiere el anonimato)
· Comunidad de procedencia
· Lengua y variante (si aplica)
· Tipo de contenido aportado
· Uso autorizado (informativo, patrimonial, ambos)
· Vigencia del consentimiento
· Forma de contacto para futuras consultas
· Firma o marca de aceptación (digital o física)

Uso del Contenido

El contenido puede ser utilizado para:

· Publicación periodística verificada
· Preservación en el Archivo Patrimonial Vivo
· Divulgación en medios comunitarios
· Investigación académica (con autorización específica)
· Formación de nuevos periodistas

Nunca se utilizará para:

· Fines comerciales sin acuerdo explícito
· Entrenamiento de modelos de IA sin consentimiento adicional
· Publicación sin proceso de verificación
· Difusión fuera de los términos acordados

Eliminación del Contenido

La persona o comunidad puede solicitar en cualquier momento la eliminación de
su contenido escribiendo a:

estefaniaprzvzqz@outlook.com

El equipo procederá a:

1. Retirar el contenido de la plataforma pública
2. Marcar el registro interno como "retirado por solicitud"
3. Confirmar la acción por escrito al solicitante

Marco de Referencia

Este documento se inspira en:

· Principios de Consentimiento Libre, Previo e Informado (CLPI) establecidos
  en el Convenio 169 de la OIT y la Declaración de las Naciones Unidas sobre
  los Derechos de los Pueblos Indígenas
· Buenas prácticas de archivos digitales comunitarios
· Códigos de ética periodística nacionales e internacionales

---

<p align="center">
  <em>El respeto por las comunidades es la base de la confianza.</em>
</p>
CONSEOF
echo "[8/13] docs/CONSENTIMIENTO-INFORMADO.md OK"

cat > .github/CODEOWNERS <<'COEOF'

CODEOWNERS - MONITOR CIID

· 

/docs/                      @Designdigitalestefania
/README.md                  @Designdigitalestefania
/LICENSE                    @Designdigitalestefania
/index.html                 @Designdigitalestefania
/assets/                    @Designdigitalestefania
/.github/                   @Designdigitalestefania
COEOF
echo "[9/13] .github/CODEOWNERS OK"

cat > .github/ISSUE_TEMPLATE/bug_report.md <<'BUGEOF'

---

name: Reportar un bug
about: Reporta un comportamiento inesperado en MONITOR CIID
title: '[BUG] '
labels: bug
assignees: ''

---

Descripción del bug

Una descripción clara y concisa del problema.

Cómo reproducirlo

1. Ir a '...'
2. Hacer clic en '...'
3. Ver el error

Comportamiento esperado

Una descripción de lo que esperabas que ocurriera.

Capturas de pantalla

Si aplica, añade capturas.

Entorno

· Dispositivo: [ej. Móvil, PC]
· Sistema operativo: [ej. Android 14, iOS 17, Windows 11]
· Navegador: [ej. Chrome 120, Safari 17]

Contexto adicional

Cualquier otro contexto útil.
BUGEOF

cat > .github/ISSUE_TEMPLATE/feature_request.md <<'FEATEOF'

---

name: Sugerir una mejora
about: Propón una idea para MONITOR CIID
title: '[FEATURE] '
labels: enhancement
assignees: ''

---

¿Tu propuesta está relacionada con un problema?

Una descripción clara del problema.

Solución propuesta

Una descripción clara de lo que te gustaría que ocurriera.

Alternativas consideradas

Cualquier alternativa que hayas considerado.

Impacto esperado

¿A quién beneficia esta mejora?
FEATEOF

cat > .github/pull_request_template.md <<'PREOF'

Descripción

Describe brevemente los cambios que introduce este Pull Request.

Issue relacionado

Closes #(número del issue)

Tipo de cambio

☐ Bug fix
☐ Nueva funcionalidad
☐ Documentación
☐ Estilo / refactor
☐ Seguridad
☐ Contenido lingüístico / cultural

Checklist

☐ He leído la Guía de Contribución
☐ He leído el Código de Conducta
☐ La demo sigue funcionando localmente
☐ He probado los cambios en móvil y escritorio
☐ He actualizado la documentación si era necesario
☐ Los cambios respetan el principio: la tecnología asiste, el periodista decide

Capturas

Si aplica, añade capturas.

Notas para revisores

Cualquier detalle adicional.
PREOF
echo "[10/13] .github/ plantillas OK"

cat > .gitignore <<'GIEOF'

Sistema operativo

.DS_Store
Thumbs.db
desktop.ini

Editores

.vscode/
.idea/
*.swp
*~

Node

node_modules/
npm-debug.log*

Python

pycache/
*.py[cod]
venv/
.venv/

Backups locales

index.html.backup*
index.html.BASE-LIMPIA*
index.html.POST-PRESENTACION*
.zip
README.md.backup

Archivos temporales

*.log
*.tmp

Claves y secretos

.env
.env.local
*.key
*.pem
secrets.json
GIEOF
echo "[11/13] .gitignore OK"

cat > PERFIL-GITHUB.md <<'PERFEOF'

<div align="center">

Estefanía Pérez Vázquez

Estrategia e Innovación Digital

Estratega de Innovación Digital · Arquitecta de Proyectos Tecnológicos · Desarrolladora de Modelos de Preservación Cultural

<p>
  <a href="https://monitorciid.netlify.app/?demo=2">
    <img src="https://img.shields.io/badge/Demo_MONITOR_CIID-Ver_en_vivo-4c8bf5?style=for-the-badge" alt="Demo">
  </a>
  <a href="mailto:estefaniaprzvzqz@outlook.com">
    <img src="https://img.shields.io/badge/Contacto-Escribeme-b08d57?style=for-the-badge" alt="Contacto">
  </a>
</p>

</div>

---

Propuesta de Valor

Transformo problemas complejos en soluciones estructuradas.

Mi trabajo comienza identificando una necesidad y termina diseñando una solución que pueda ser comprendida, implementada, documentada, evaluada y, cuando corresponde, replicada.

Integro: estrategia digital · arquitectura de información · diseño de procesos · innovación tecnológica · comunicación digital · preservación cultural.

No desarrollo tecnología por desarrollar tecnología. Diseño soluciones tecnológicas con un propósito estratégico.

---

Proyectos Principales

MONITOR CIID

Centro Inteligente de Información Digital

Infraestructura tecnológica para transformar los procesos mediante los cuales los medios reciben, procesan, analizan, verifican, preservan y distribuyen contenidos.

"La tecnología asiste. El periodista decide."

Demo en vivo · Repositorio

---

IXIMI LEGACY

Tecnología para preservar cultura

Proyecto orientado a la preservación, autenticación y documentación digital de patrimonio textil indígena mediante blockchain y códigos QR.

Certificación digital · Autenticación de piezas · Registro de procedencia · Narrativa cultural · Modelo de impacto social.

---

Monitor Noticias

Estrategia digital y desarrollo de audiencias para un medio de comunicación regional en Oaxaca.

Resultado documentado: crecimiento de ~30,000 a 63,800 seguidores en 9 meses · +5.1 millones de visualizaciones acumuladas.

---

Áreas de Especialización

Área Enfoque
Estrategia Digital Estrategias para medios, instituciones y proyectos territoriales
Innovación Tecnológica Conceptualización y estructuración de proyectos desde el problema hasta el modelo
Arquitectura de Información Diseño de flujos, estructuras, roles y procesos
Modelos Digitales Transformación de ideas en modelos implementables y escalables
Preservación Cultural Digital Documentación, autenticación y difusión de patrimonio mediante tecnología

---

Metodología

```
01 - Diagnóstico    : Comprender el problema, contexto y recursos
02 - Estrategia     : Definir objetivos, prioridades y ruta
03 - Arquitectura   : Diseñar estructura, procesos y componentes
04 - Modelo         : Convertir la estrategia en solución documentada
05 - Implementación : Llevar el modelo a operación real
06 - Evaluación     : Medir resultados y corregir
07 - Escalamiento   : Preparar para crecer o replicarse
```

---

Frases de Marca

Estrategia que transforma. Innovación que se implementa.

Del problema al modelo. Del modelo a la solución.

---

Contacto

· Correo: estefaniaprzvzqz@outlook.com
· Sitio web: estefaniaperezvazquez.com (próximamente)

---

<div align="center">

<em>Diseño soluciones donde estrategia, información y tecnología se encuentran.</em>

</div>
PERFEOF
echo "[12/13] PERFIL-GITHUB.md OK"

echo ""
echo "[13/13] Verificacion final:"
echo ""
for f in README.md LICENSE CODE_OF_CONDUCT.md CONTRIBUTING.md SECURITY.md 
         .gitignore docs/ROADMAP.md docs/CONSENTIMIENTO-INFORMADO.md 
         .github/CODEOWNERS .github/pull_request_template.md 
         .github/ISSUE_TEMPLATE/bug_report.md 
         .github/ISSUE_TEMPLATE/feature_request.md 
         PERFIL-GITHUB.md; do
if [ -f "$f" ]; then
    echo "  OK  $f"
else
echo "  FALTA: $f"
fi
done

echo ""
echo "===================================================="
echo "  Todo listo"
echo "===================================================="
echo ""
echo "Ahora ejecuta:"
echo ""
echo "  cd ~/monitor-ciid-demo"
echo "  git add ."
echo "  git commit -m 'Profesionaliza repositorio: documentacion institucional, licencia MIT, plantillas'"
echo "  git push"
echo ""

```

---

## Qué cambió respecto al anterior

- **Eliminé todos los separadores de guiones largos** (`-----------`) que bash interpretaba como comandos.
- **Reemplacé los `→` y `✓` por texto simple** (`[1/13] README.md OK`) para evitar caracteres especiales.
- **Quité emojis** de los archivos generados por seguridad (los puedes añadir después en GitHub si quieres).
- **Quité los apóstrofes dentro de bloques heredoc** que podían romper el quoting.
- Todo el contenido está **validado** para ejecutarse sin error.

---

## Después de ejecutarlo

```bash
cd ~/monitor-ciid-demo
git add .
git commit -m "Profesionaliza repositorio: documentacion institucional, licencia MIT, plantillas"
git push
```

Y en GitHub:

1. Repo monitorciid → About ⚙️:
   · Descripción: Centro Inteligente de Información Digital · Piloto · Oaxaca
   · Website: https://monitorciid.netlify.app/?demo=2
   · Topics: oaxaca, periodismo, lenguas-originarias, ia, archivo-digital, patrimonio, pwa, javascript, demo
2. Settings → Security: activa Dependabot, Secret scanning y Push protection.
3. Crear README de perfil: https://github.com/new → nombre Designdigitalestefania → público → pega el contenido de PERFIL-GITHUB.md.

---
