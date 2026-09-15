#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MONITOR CIID · Arreglar demo + agregar narración (versión segura)
# Uso: bash arreglar-todo.sh
# ============================================================

set -e

DIR="$HOME/monitor-ciid-demo"
HTML="$DIR/index.html"

echo ""
echo "════════════════════════════════════════════════════"
echo "  MONITOR CIID · Arreglar + Narración segura"
echo "════════════════════════════════════════════════════"
echo ""

# ------------------------------------------------------------
# 0. Verificar que existe la carpeta
# ------------------------------------------------------------
if [ ! -d "$DIR" ]; then
  echo "❌ No existe $DIR"
  exit 1
fi
cd "$DIR"

# ------------------------------------------------------------
# 1. Restaurar el backup funcional
# ------------------------------------------------------------
echo "→ [1/6] Restaurando backup funcional…"

BACKUP="index.html.backup-narracion-20260915-073310"

if [ ! -f "$BACKUP" ]; then
  echo "  ⚠ No existe $BACKUP, buscando alternativas…"
  BACKUP=$(ls -t index.html.backup-narracion-* 2>/dev/null | head -1)
fi

if [ -z "$BACKUP" ] || [ ! -f "$BACKUP" ]; then
  BACKUP=$(ls -t index.html.backup-* 2>/dev/null | head -1)
fi

if [ -z "$BACKUP" ] || [ ! -f "$BACKUP" ]; then
  echo "  ❌ No hay backups disponibles"
  exit 1
fi

cp "$BACKUP" index.html
echo "  ✓ Restaurado desde: $BACKUP"

# Verificar que quedó limpio
COUNT=$(grep -c "MODO PRESENTACIÓN + GUION NARRADOR" index.html || true)
if [ "$COUNT" != "1" ]; then
  echo "  ⚠ El archivo tiene $COUNT bloques de presentación (debe ser 1)"
  echo "     Abortando para no empeorar."
  exit 1
fi
echo "  ✓ Verificado: 1 bloque de presentación"

# ------------------------------------------------------------
# 2. Backup de seguridad del estado bueno
# ------------------------------------------------------------
echo ""
echo "→ [2/6] Guardando backup de seguridad…"

cp index.html "index.html.backup-funcional-$(date +%Y%m%d-%H%M%S)"
echo "  ✓ Backup funcional guardado"

# ------------------------------------------------------------
# 3. Verificar que NO tenga narración previa
# ------------------------------------------------------------
echo ""
echo "→ [3/6] Verificando estado…"

if grep -q "NARRACIÓN POR VOZ" index.html; then
  echo "  ⚠ Ya tiene un bloque de narración. Limpiando…"
  python3 - <<'PYEOF'
import re
with open("index.html", "r", encoding="utf-8") as f:
    contenido = f.read()
# Eliminar bloque anterior de narración
contenido = re.sub(
    r'/\* =+\s*NARRACIÓN POR VOZ.*?(?=</script>)',
    '', contenido, flags=re.DOTALL
)
# Eliminar CSS de voz
contenido = re.sub(
    r'/\* Narración por voz \*/.*?(?=  /\* =+)',
    '', contenido, flags=re.DOTALL
)
with open("index.html", "w", encoding="utf-8") as f:
    f.write(contenido)
print("  ✓ Bloque antiguo eliminado")
PYEOF
else
  echo "  ✓ No hay narración previa"
fi

# ------------------------------------------------------------
# 4. Insertar CSS del botón de voz
# ------------------------------------------------------------
echo ""
echo "→ [4/6] Insertando CSS de voz…"

CSS_VOZ='
  /* Narración por voz */
  .presentacion-btn.voz-on {
    background: rgba(46,160,67,.15);
    color: var(--ok);
    border-color: var(--ok);
  }
  .presentacion-btn.voz-off {
    background: var(--panel-2);
    color: var(--muted);
  }
  .presentacion-btn.hablando {
    animation: hablar 1.2s ease-in-out infinite;
  }
  @keyframes hablar {
    0%, 100% { box-shadow: 0 0 0 0 rgba(46,160,67,.4); }
    50% { box-shadow: 0 0 0 8px rgba(46,160,67,0); }
  }
'

python3 - "$CSS_VOZ" <<'PYEOF'
import sys
css_block = sys.argv[1]
with open("index.html", "r", encoding="utf-8") as f:
    contenido = f.read()
pos = contenido.rfind("</style>")
contenido = contenido[:pos] + css_block + "\n" + contenido[pos:]
with open("index.html", "w", encoding="utf-8") as f:
    f.write(contenido)
print("  ✓ CSS insertado")
PYEOF

# ------------------------------------------------------------
# 5. Insertar botón de voz en la barra de presentación
# ------------------------------------------------------------
echo ""
echo "→ [5/6] Insertando botón de voz…"

python3 - <<'PYEOF'
with open("index.html", "r", encoding="utf-8") as f:
    contenido = f.read()

if 'id="btnToggleVoz"' in contenido:
    print("  ⚠ Botón ya existía, saltando…")
else:
    needle = '<button class="presentacion-btn stop" onclick="detenerPresentacion()">■ Detener</button>'
    replacement = '''<button class="presentacion-btn voz-on" id="btnToggleVoz" onclick="toggleVoz()">🔊 Voz: ON</button>
  <button class="presentacion-btn stop" onclick="detenerPresentacion()">■ Detener</button>'''
    if needle in contenido:
        contenido = contenido.replace(needle, replacement, 1)
        with open("index.html", "w", encoding="utf-8") as f:
            f.write(contenido)
        print("  ✓ Botón insertado")
    else:
        print("  ⚠ No se encontró botón Detener, abortando")
        sys.exit(1)
PYEOF

# ------------------------------------------------------------
# 6. Insertar JS de narración (versión segura, sin reasignar)
# ------------------------------------------------------------
echo ""
echo "→ [6/6] Insertando JS de narración (segura)…"

JS_VOZ='
/* ============================================================
   NARRACIÓN POR VOZ · versión segura (sin reasignar funciones)
   ============================================================ */

let vozActiva = true;
let vozSeleccionada = null;
let audioActual = null;
let ultimoPasoNarrado = -1;

function limpiarTextoParaVoz(html) {
  const tmp = document.createElement("div");
  tmp.innerHTML = html;
  return tmp.textContent
    .replace(/🎯/g, "Punto clave.")
    .replace(/\*|\*«|»\*/g, "")
    .replace(/«|»/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

function seleccionarVoz() {
  if (!("speechSynthesis" in window)) return null;
  const voces = speechSynthesis.getVoices();
  if (!voces.length) return null;
  const pref = [
    v => v.lang === "es-MX",
    v => v.lang === "es-419",
    v => v.lang === "es-US",
    v => v.lang.startsWith("es-"),
    v => v.lang.startsWith("es")
  ];
  for (const f of pref) {
    const found = voces.find(f);
    if (found) return found;
  }
  return voces[0];
}

if ("speechSynthesis" in window) {
  speechSynthesis.onvoiceschanged = () => { vozSeleccionada = seleccionarVoz(); };
  setTimeout(() => { vozSeleccionada = seleccionarVoz(); }, 800);
}

function narrarPaso(index) {
  if (!vozActiva) return;
  detenerNarracion();

  if (typeof GUION_PRESENTACION === "undefined") return;
  const paso = GUION_PRESENTACION[index];
  if (!paso || !paso.texto) return;

  const texto = limpiarTextoParaVoz(paso.texto);
  const rutaMP3 = `assets/guion-${index + 1}.mp3`;

  fetch(rutaMP3, { method: "HEAD" })
    .then(r => {
      if (r.ok) {
        audioActual = new Audio(rutaMP3);
        audioActual.play().catch(() => narrarConTTS(texto));
      } else {
        narrarConTTS(texto);
      }
    })
    .catch(() => narrarConTTS(texto));
}

function narrarConTTS(texto) {
  if (!("speechSynthesis" in window)) return;
  const utt = new SpeechSynthesisUtterance(texto);
  utt.lang = "es-MX";
  utt.rate = 0.95;
  utt.pitch = 1.0;
  utt.volume = 1.0;
  if (vozSeleccionada) utt.voice = vozSeleccionada;

  const btn = document.getElementById("btnToggleVoz");
  if (btn) btn.classList.add("hablando");
  utt.onend = () => { if (btn) btn.classList.remove("hablando"); };
  utt.onerror = () => { if (btn) btn.classList.remove("hablando"); };
  speechSynthesis.speak(utt);
}

function detenerNarracion() {
  if ("speechSynthesis" in window) speechSynthesis.cancel();
  if (audioActual) {
    audioActual.pause();
    audioActual.currentTime = 0;
    audioActual = null;
  }
  const btn = document.getElementById("btnToggleVoz");
  if (btn) btn.classList.remove("hablando");
}

function toggleVoz() {
  vozActiva = !vozActiva;
  const btn = document.getElementById("btnToggleVoz");
  if (!btn) return;
  if (vozActiva) {
    btn.textContent = "🔊 Voz: ON";
    btn.classList.remove("voz-off");
    btn.classList.add("voz-on");
    // Reanudar narración si la presentación está activa
    if (typeof presentacionActiva !== "undefined" && presentacionActiva) {
      narrarPaso(presentacionStepIndex);
    }
  } else {
    btn.textContent = "🔇 Voz: OFF";
    btn.classList.remove("voz-on");
    btn.classList.add("voz-off");
    detenerNarracion();
  }
}

/* Observador: detecta cambio de paso y narra sin tocar funciones existentes */
setInterval(() => {
  if (typeof presentacionActiva === "undefined") return;
  if (!presentacionActiva) {
    ultimoPasoNarrado = -1;
    return;
  }
  if (presentacionStepIndex !== ultimoPasoNarrado) {
    ultimoPasoNarrado = presentacionStepIndex;
    narrarPaso(presentacionStepIndex);
  }
}, 400);

/* Detener voz cuando termina la presentación */
setInterval(() => {
  const overlay = document.getElementById("impactoOverlay");
  if (overlay && overlay.classList.contains("activa")) {
    detenerNarracion();
  }
}, 800);
'

python3 - "$JS_VOZ" <<'PYEOF'
import sys
js_block = sys.argv[1]
with open("index.html", "r", encoding="utf-8") as f:
    contenido = f.read()
pos = contenido.rfind("</script>")
contenido = contenido[:pos] + js_block + "\n" + contenido[pos:]
with open("index.html", "w", encoding="utf-8") as f:
    f.write(contenido)
print("  ✓ JS insertado")
PYEOF

# ------------------------------------------------------------
# 7. Verificación final
# ------------------------------------------------------------
echo ""
echo "→ Verificando…"
echo ""

P1=$(grep -c "MODO PRESENTACIÓN + GUION NARRADOR" index.html || echo "0")
P2=$(grep -c "NARRACIÓN POR VOZ" index.html || echo "0")
P3=$(grep -c "function renderStageDemo1" index.html || echo "0")
P4=$(grep -c "function renderStageDemo2" index.html || echo "0")
P5=$(grep -c "btnToggleVoz" index.html || echo "0")

echo "  Bloques presentación:      $P1 (debe ser 1)"
echo "  Bloques narración:         $P2 (debe ser 1)"
echo "  Función renderStageDemo1:  $P3 (debe ser 1)"
echo "  Función renderStageDemo2:  $P4 (debe ser 1)"
echo "  Referencias btnToggleVoz:  $P5 (debe ser ≥ 2)"

if [ "$P1" = "1" ] && [ "$P2" = "1" ] && [ "$P3" = "1" ] && [ "$P4" = "1" ]; then
  echo ""
  echo "  ✅ Todo verificado correctamente"
else
  echo ""
  echo "  ⚠ Algunas verificaciones no cuadran"
  echo "     Restaura el backup funcional si algo falla:"
  echo "     cp index.html.backup-funcional-* index.html"
  exit 1
fi

# ------------------------------------------------------------
# Fin
# ------------------------------------------------------------
echo ""
echo "════════════════════════════════════════════════════"
echo "  ✅ Demo lista con narración segura"
echo "════════════════════════════════════════════════════"
echo ""
echo "Siguientes pasos:"
echo ""
echo "  1) Prueba local primero:"
echo "     python -m http.server 8080"
echo "     Abre: http://localhost:8080/?demo=2"
echo ""
echo "  2) Si funciona, sube a Netlify:"
echo "     cd $DIR"
echo "     git add ."
echo "     git commit -m 'Demo con narración segura'"
echo "     git push"
echo ""
echo "  3) En 20 segundos Netlify republica. Abre:"
echo "     https://monitorciid.netlify.app/?demo=2"
echo ""
echo "Cómo probar:"
echo "  - Toca '▶ Iniciar presentación (Demo 2)'"
echo "  - La voz narra cada paso automáticamente"
echo "  - Botón 🔊 Voz: ON/OFF para controlarla"
echo "  - Barra espaciadora pausa/reanuda"
echo ""
