#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MONITOR CIID · Agrega narración por voz al Modo Presentación
# Requiere que ya exista el Modo Presentación en index.html
# Uso: bash agregar-narracion.sh
# ============================================================

set -e

DIR="$HOME/monitor-ciid-demo"
HTML="$DIR/index.html"

if [ ! -f "$HTML" ]; then
  echo "❌ No se encontró $HTML"
  exit 1
fi

if ! grep -q "GUION_PRESENTACION" "$HTML"; then
  echo "❌ Primero ejecuta: bash agregar-presentacion.sh"
  exit 1
fi

echo ""
echo "════════════════════════════════════════════════════"
echo "  MONITOR CIID · Narración por voz"
echo "════════════════════════════════════════════════════"
echo ""

cp "$HTML" "$HTML.backup-narracion-$(date +%Y%m%d-%H%M%S)"
echo "→ Backup creado"
echo ""

# ------------------------------------------------------------
# 1. CSS · botón de voz
# ------------------------------------------------------------
echo "→ [1/3] Agregando CSS del botón de voz…"

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

python3 - "$HTML" "$CSS_VOZ" <<'PYEOF'
import sys
html_path, css_block = sys.argv[1], sys.argv[2]
with open(html_path, "r", encoding="utf-8") as f:
    contenido = f.read()

if "presentacion-btn.voz-on" in contenido:
    print("  ⚠ CSS de voz ya estaba, saltando…")
else:
    pos = contenido.rfind("</style>")
    contenido = contenido[:pos] + css_block + "\n" + contenido[pos:]
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(contenido)
    print("  ✓ CSS insertado")
PYEOF

# ------------------------------------------------------------
# 2. HTML · botón de voz en la barra
# ------------------------------------------------------------
echo ""
echo "→ [2/3] Agregando botón de voz…"

python3 - "$HTML" <<'PYEOF'
import sys
html_path = sys.argv[1]
with open(html_path, "r", encoding="utf-8") as f:
    contenido = f.read()

if 'id="btnToggleVoz"' in contenido:
    print("  ⚠ Botón ya existía, saltando…")
else:
    # Insertar antes del botón "Detener" dentro de la barra de presentación
    needle = '<button class="presentacion-btn stop" onclick="detenerPresentacion()">■ Detener</button>'
    replacement = '''<button class="presentacion-btn voz-on" id="btnToggleVoz" onclick="toggleVoz()">🔊 Voz: ON</button>
  <button class="presentacion-btn stop" onclick="detenerPresentacion()">■ Detener</button>'''
    if needle in contenido:
        contenido = contenido.replace(needle, replacement, 1)
        with open(html_path, "w", encoding="utf-8") as f:
            f.write(contenido)
        print("  ✓ Botón insertado")
    else:
        print("  ⚠ No se encontró el botón 'Detener' · saltando")
PYEOF

# ------------------------------------------------------------
# 3. JavaScript · motor de narración
# ------------------------------------------------------------
echo ""
echo "→ [3/3] Agregando motor de narración…"

JS_VOZ='
/* ============================================================
   NARRACIÓN POR VOZ · Web Speech API + MP3 opcional
   ============================================================ */

let vozActiva = true;
let vozSeleccionada = null;
let audioActual = null;

// Texto limpio para narración (sin etiquetas HTML)
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

// Detecta la mejor voz en español disponible
function seleccionarVoz() {
  const voces = speechSynthesis.getVoices();
  if (!voces.length) return null;

  // Prioridad: español mexicano > español latino > español genérico
  const preferencias = [
    v => v.lang === "es-MX",
    v => v.lang === "es-419",
    v => v.lang === "es-US",
    v => v.lang.startsWith("es-"),
    v => v.lang.startsWith("es")
  ];

  for (const filtro of preferencias) {
    const encontrada = voces.find(filtro);
    if (encontrada) return encontrada;
  }
  return voces[0];
}

// Cargar voces cuando el navegador las tenga listas
speechSynthesis.onvoiceschanged = () => {
  vozSeleccionada = seleccionarVoz();
};

// Intentar cargar al inicio
setTimeout(() => {
  vozSeleccionada = seleccionarVoz();
}, 500);

// Narra un paso del guion. Si existe MP3, lo usa. Si no, usa TTS.
function narrarPaso(index) {
  if (!vozActiva) return;

  // Detener cualquier narración previa
  detenerNarracion();

  const paso = GUION_PRESENTACION[index];
  if (!paso) return;

  const texto = limpiarTextoParaVoz(paso.texto);

  // Intentar primero con MP3
  const rutaMP3 = `assets/guion-${index + 1}.mp3`;

  // Verificamos si el archivo existe intentando cargarlo
  fetch(rutaMP3, { method: "HEAD" })
    .then(resp => {
      if (resp.ok) {
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
  utt.rate = 0.95;      // ritmo ligeramente pausado
  utt.pitch = 1.0;      // tono neutro
  utt.volume = 1.0;

  if (vozSeleccionada) {
    utt.voice = vozSeleccionada;
  }

  // Marcar botón como "hablando"
  const btn = document.getElementById("btnToggleVoz");
  if (btn) btn.classList.add("hablando");

  utt.onend = () => {
    if (btn) btn.classList.remove("hablando");
  };
  utt.onerror = () => {
    if (btn) btn.classList.remove("hablando");
  };

  speechSynthesis.speak(utt);
}

function detenerNarracion() {
  if ("speechSynthesis" in window) {
    speechSynthesis.cancel();
  }
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

  if (vozActiva) {
    btn.textContent = "🔊 Voz: ON";
    btn.classList.remove("voz-off");
    btn.classList.add("voz-on");
    // Si estamos en medio de la presentación, narrar el paso actual
    if (presentacionActiva) narrarPaso(presentacionStepIndex);
  } else {
    btn.textContent = "🔇 Voz: OFF";
    btn.classList.remove("voz-on");
    btn.classList.add("voz-off");
    detenerNarracion();
  }
}

// Envolver las funciones de presentación para que narren en cada paso

// Modificar ejecutarPasoPresentacion para que dispare narración
const _ejecutarPasoOriginal = ejecutarPasoPresentacion;
ejecutarPasoPresentacion = function() {
  if (!presentacionActiva) return;
  if (presentacionStepIndex >= GUION_PRESENTACION.length) {
    terminarPresentacion();
    return;
  }

  const paso = GUION_PRESENTACION[presentacionStepIndex];
  const estadoIdx = ESTADOS.indexOf(paso.estado);

  demo2.estado = estadoIdx;
  actualizarBarraPresentacion();
  actualizarGuion();
  actualizar(2);

  // Narrar el paso actual
  narrarPaso(presentacionStepIndex);

  const t = setTimeout(() => {
    if (!presentacionActiva) return;
    presentacionStepIndex++;
    _ejecutarPasoOriginal();
  }, paso.espera);

  presentacionTimers.push(t);
};

// Modificar detenerPresentacion para que detenga la voz
const _detenerOriginal = detenerPresentacion;
detenerPresentacion = function() {
  detenerNarracion();
  _detenerOriginal();
};

// Modificar terminarPresentacion
const _terminarOriginal = terminarPresentacion;
terminarPresentacion = function() {
  detenerNarracion();
  _terminarOriginal();
};

// Modificar cerrarImpacto
const _cerrarImpactoOriginal = cerrarImpacto;
cerrarImpacto = function() {
  detenerNarracion();
  _cerrarImpactoOriginal();
};
'

python3 - "$HTML" "$JS_VOZ" <<'PYEOF'
import sys
html_path, js_block = sys.argv[1], sys.argv[2]
with open(html_path, "r", encoding="utf-8") as f:
    contenido = f.read()

if "NARRACIÓN POR VOZ" in contenido:
    print("  ⚠ JS de voz ya estaba, saltando…")
else:
    pos = contenido.rfind("</script>")
    contenido = contenido[:pos] + js_block + "\n" + contenido[pos:]
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(contenido)
    print("  ✓ JS insertado")
PYEOF

# ------------------------------------------------------------
# Fin
# ------------------------------------------------------------
echo ""
echo "════════════════════════════════════════════════════"
echo "  ✅ Narración por voz instalada"
echo "════════════════════════════════════════════════════"
echo ""
echo "Funciona así:"
echo ""
echo "  1) Por defecto usa la voz TTS del navegador (gratis, sin archivos)"
echo "  2) Si colocas archivos assets/guion-1.mp3 … guion-8.mp3,"
echo "     la demo los usa en su lugar automáticamente."
echo ""
echo "Siguiente paso:"
echo ""
echo "  cd $DIR"
echo "  git add ."
echo "  git commit -m 'Narración por voz en modo presentación'"
echo "  git push"
echo ""
