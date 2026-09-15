#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MONITOR CIID · Actualizar guion narrativo + pausa final
# Reemplaza GUION_PRESENTACION por la versión documental
# Uso: bash actualizar-guion.sh
# ============================================================

set -e

DIR="$HOME/monitor-ciid-demo"
cd "$DIR"

echo ""
echo "════════════════════════════════════════════════════"
echo "  MONITOR CIID · Actualizar guion narrativo"
echo "════════════════════════════════════════════════════"
echo ""

if [ ! -f "index.html" ]; then
  echo "❌ No existe index.html"
  exit 1
fi

# Backup
cp index.html "index.html.backup-guion-$(date +%H%M%S)"
echo "→ Backup guardado"
echo ""

# ------------------------------------------------------------
# Reemplazar GUION_PRESENTACION con la nueva versión
# ------------------------------------------------------------
echo "→ Reemplazando GUION_PRESENTACION…"

python3 <<'PYEOF'
import re

with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()

# Bloque nuevo de GUION_PRESENTACION (versión documental)
nuevo_guion = '''var GUION_PRESENTACION = [
  {
    estado: "RECEIVED",
    espera: 22000,
    mensaje: "1/8 · El origen",
    accion: "Paso 1 · El origen",
    texto: "Todo comienza con algo muy sencillo: una persona que tiene información y necesita ser escuchada. En este caso, una ciudadana comparte un reporte desde su comunidad. Puede enviar texto, una fotografía o incluso un audio en su propia lengua. Y desde ese momento, esa información entra a MONITOR CIID.",
    pausa: "Reproduce el audio. Deja que suene. Es la voz de alguien que quiere ser escuchada."
  },
  {
    estado: "PROCESSING",
    espera: 20000,
    mensaje: "2/8 · La información entra al ecosistema",
    accion: "Paso 2 · La información entra al ecosistema",
    texto: "CIID recibe la información, identifica su origen, registra el territorio y organiza los elementos que la acompañan. No se trata solamente de almacenar un mensaje. Se trata de convertir una información dispersa en un registro estructurado que pueda ser analizado, verificado y seguido durante todo su recorrido.",
    pausa: "Señala la línea morada del log: el audio original se preserva, no se borra."
  },
  {
    estado: "CLASSIFIED",
    espera: 18000,
    mensaje: "3/8 · Entender antes de publicar",
    accion: "Paso 3 · Entender antes de publicar",
    texto: "Ahora comienza el procesamiento. MONITOR CIID identifica el tema, el territorio, los actores involucrados y las características de la información. Pero hay una regla fundamental: recibir información no significa publicarla. Antes de convertirse en noticia, debe pasar por un proceso de análisis y contraste.",
    pausa: "Deja que las etiquetas aparezcan una a una. La sensibilidad patrimonial es clave."
  },
  {
    estado: "VERIFICATION",
    espera: 24000,
    mensaje: "4/8 · Verificar y contrastar",
    accion: "Paso 4 · Verificar y contrastar",
    texto: "En esta etapa, la información ciudadana se confronta con otras fuentes. Se buscan antecedentes, documentos, fuentes institucionales y referencias comunitarias. El objetivo no es publicar más rápido. El objetivo es publicar mejor. Porque la velocidad puede distribuir información, pero la verificación construye confianza.",
    pausa: "Pausa dramática antes de: El objetivo no es publicar más rápido. El objetivo es publicar mejor."
  },
  {
    estado: "EDITORIAL_REVIEW",
    espera: 32000,
    mensaje: "5/8 · Lengua, contexto y cultura",
    accion: "Paso 5 · Lengua, contexto y cultura",
    texto: "Y aquí aparece uno de los elementos que distingue a MONITOR CIID. Cuando la información llega en una lengua originaria, el proceso no consiste simplemente en traducir palabras. Se busca preservar significado, contexto, expresión, territorio y memoria. La validación con hablantes nativos permite que la información conserve aquello que una traducción literal puede perder: su sentido cultural.",
    pausa: "Pausa. Deja que la versión en lengua se escriba completa. No interrumpas."
  },
  {
    estado: "DECISION",
    espera: 20000,
    mensaje: "6/8 · La decisión periodística",
    accion: "Paso 6 · La decisión periodística",
    texto: "Después de recorrer este proceso, llega el momento más importante. La decisión. Es el periodista quien determina si la información está suficientemente sustentada para convertirse en contenido periodístico. CIID puede organizar, analizar, contrastar y asistir. Pero la decisión editorial permanece en manos humanas. La tecnología asiste. El periodista decide.",
    pausa: "Pausa 2 segundos. Mira al público. Tú mismo presionas Aprobar y publicar."
  },
  {
    estado: "PUBLISHED",
    espera: 22000,
    mensaje: "7/8 · De información a contenido y memoria",
    accion: "Paso 7 · De información a contenido y memoria",
    texto: "Una vez aprobada, la información puede convertirse en distintos formatos: una nota, contenido para redes, audio, una versión en lengua originaria o materiales para medios comunitarios. Pero el proceso no termina con la publicación. La información también puede preservarse. Porque una noticia puede ser algo más que un contenido de un día. Puede convertirse en registro de un territorio, de una lengua y de una comunidad.",
    pausa: "Muestra el toggle Ver ambas. Deja que se vean las dos versiones lado a lado."
  },
  {
    estado: "PRESERVED",
    espera: 32000,
    mensaje: "8/8 · Archivo patrimonial vivo",
    accion: "Paso 8 · Archivo patrimonial vivo",
    texto: "Y aquí llegamos al propósito más profundo de este recorrido. Lo que comenzó como un reporte ciudadano puede terminar convertido en información verificada, contenido periodístico y memoria digital. Cada registro puede conservar su territorio, su contexto, su lengua y su historia. Eso es un Archivo Patrimonial Vivo. Una infraestructura que no solamente procesa información para el presente. También ayuda a preservarla para el futuro. MONITOR CIID. Innovar para informar. Digitalizar para preservar. De Oaxaca para el mundo.",
    pausa: "Después de esta línea: silencio. La demo entra en negro 5 segundos y aparece el overlay final."
  }
];'''

# Buscar el bloque actual de GUION_PRESENTACION y reemplazarlo
patron = r'var GUION_PRESENTACION = \[.*?\n\];'
resultado = re.sub(patron, nuevo_guion, c, count=1, flags=re.DOTALL)

if resultado == c:
    print("  ⚠ No se pudo reemplazar GUION_PRESENTACION")
    exit(1)

c = resultado
with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)

print("  ✓ Guion reemplazado")
PYEOF

echo ""

# ------------------------------------------------------------
# Agregar pausa de 5 segundos antes del overlay final
# ------------------------------------------------------------
echo "→ Agregando pausa de 5 segundos antes del overlay final…"

python3 <<'PYEOF'
with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()

# Buscar la función terminarPresentacion original
viejo = '''function terminarPresentacion() {
  presentacionActiva = false;
  limpiarTimers();
  detenerNarracion();
  document.getElementById("presentacionBar").classList.remove("activa");
  document.getElementById("guionPanel").classList.remove("activa");
  document.getElementById("impactoOverlay").classList.add("activa");
}'''

nuevo = '''function terminarPresentacion() {
  presentacionActiva = false;
  limpiarTimers();
  detenerNarracion();
  document.getElementById("presentacionBar").classList.remove("activa");
  document.getElementById("guionPanel").classList.remove("activa");
  // Pausa de silencio antes del overlay final
  document.body.style.transition = "background-color 1.5s ease";
  document.body.style.backgroundColor = "#000";
  setTimeout(function() {
    document.body.style.backgroundColor = "";
    document.getElementById("impactoOverlay").classList.add("activa");
  }, 5000);
}'''

if viejo in c:
    c = c.replace(viejo, nuevo, 1)
    print("  ✓ Pausa de 5s agregada")
else:
    print("  ⚠ No se encontró la función terminarPresentacion, saltando")

with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)
PYEOF

echo ""

# ------------------------------------------------------------
# Verificar
# ------------------------------------------------------------
echo "→ Verificación:"

P1=$(grep -c "var GUION_PRESENTACION = \[" index.html || echo "0")
P2=$(grep -c "El objetivo es publicar mejor" index.html || echo "0")
P3=$(grep -c "setTimeout.*5000\|5000);" index.html || echo "0")
P4=$(grep -c "De Oaxaca para el mundo" index.html || echo "0")

echo "  GUION_PRESENTACION:              $P1 (esperado: 1)"
echo "  Frase 'publicar mejor':          $P2 (esperado: ≥1)"
echo "  Pausa 5000ms:                    $P3 (esperado: ≥1)"
echo "  'De Oaxaca para el mundo':       $P4 (esperado: ≥1)"
echo ""

echo "════════════════════════════════════════════════════"
echo "  ✅ Guion actualizado"
echo "════════════════════════════════════════════════════"
echo ""
echo "Siguientes pasos:"
echo ""
echo "  1) Prueba local:"
echo "     python -m http.server 8080"
echo "     Abre: http://localhost:8080/?demo=2"
echo ""
echo "  2) Si funciona, sube a Netlify:"
echo "     git add ."
echo "     git commit -m 'Guion narrativo documental + pausa final'"
echo "     git push"
echo ""
echo "  3) Prueba en producción:"
echo "     https://monitorciid.netlify.app/?demo=2"
echo ""
