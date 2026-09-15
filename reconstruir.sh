#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MONITOR CIID · Reconstruir demo desde backup limpio
# Base: index.html.backup-20260915-072849 (0 bloques)
# Agrega: modo presentación + narración segura
# Uso: bash reconstruir.sh
# ============================================================

set -e

DIR="$HOME/monitor-ciid-demo"
cd "$DIR"

BASE="index.html.backup-20260915-072849"

echo ""
echo "════════════════════════════════════════════════════"
echo "  MONITOR CIID · Reconstruir demo limpia"
echo "════════════════════════════════════════════════════"
echo ""

# ------------------------------------------------------------
# 0. Verificar base
# ------------------------------------------------------------
if [ ! -f "$BASE" ]; then
  echo "❌ No existe $BASE"
  exit 1
fi

COUNT=$(grep -c "MODO PRESENTACIÓN + GUION NARRADOR" "$BASE" 2>/dev/null || echo "0")
if [ "$COUNT" != "0" ]; then
  echo "❌ El backup base tiene $COUNT bloques de presentación."
  echo "   Se necesita uno con 0 bloques."
  exit 1
fi

echo "→ Base limpia verificada: $BASE (0 bloques)"
echo ""

# ------------------------------------------------------------
# 1. Restaurar base
# ------------------------------------------------------------
echo "→ [1/6] Restaurando base limpia…"
cp "$BASE" index.html
cp index.html "index.html.backup-limpio-SEGURO"

# ------------------------------------------------------------
# 2. CSS · Modo presentación + narración
# ------------------------------------------------------------
echo "→ [2/6] Insertando CSS…"

CSS_BLOCK='
  /* ============================================================
     MODO PRESENTACIÓN + GUION + NARRACIÓN
     ============================================================ */
  .presentacion-bar {
    position: fixed; bottom: 0; left: 0; right: 0;
    background: linear-gradient(180deg, rgba(14,17,22,.92), rgba(14,17,22,.99));
    border-top: 1px solid var(--border);
    padding: 12px 20px;
    display: none; align-items: center; gap: 14px;
    z-index: 100; backdrop-filter: blur(10px);
    flex-wrap: wrap;
  }
  .presentacion-bar.activa { display: flex; }

  .presentacion-progress {
    flex: 1; min-width: 200px; height: 6px;
    background: var(--panel-2); border-radius: 3px;
    overflow: hidden;
  }
  .presentacion-progress .fill {
    height: 100%; width: 0%;
    background: linear-gradient(90deg, var(--accent), var(--patrimonio));
    transition: width .6s ease;
  }
  .presentacion-info {
    font-family: ui-monospace, monospace; font-size: 11px;
    color: var(--muted); letter-spacing: 1px; white-space: nowrap;
  }
  .presentacion-btn {
    background: var(--panel-2); border: 1px solid var(--border);
    color: var(--text); padding: 8px 14px;
    border-radius: 6px; font-size: 12px;
    cursor: pointer; font-weight: 600;
  }
  .presentacion-btn:hover { border-color: var(--accent); }
  .presentacion-btn.stop { background: rgba(248,81,73,.15); color: var(--err); border-color: var(--err); }
  .presentacion-btn.activo { background: var(--accent); border-color: var(--accent); color: #fff; }
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

  .btn-presentacion-inicio {
    position: fixed; bottom: 24px; right: 24px;
    background: linear-gradient(135deg, var(--accent), var(--patrimonio));
    color: white; border: none;
    padding: 16px 24px; border-radius: 50px;
    font-size: 14px; font-weight: 700;
    letter-spacing: 1px; cursor: pointer;
    box-shadow: 0 8px 24px rgba(76,139,245,.35);
    z-index: 90; display: flex; align-items: center; gap: 10px;
    transition: all .2s;
  }
  .btn-presentacion-inicio:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(163,113,247,.45);
  }
  .btn-presentacion-inicio::before {
    content: ""; width: 10px; height: 10px;
    border-radius: 50%; background: #fff;
    animation: pulse 1.6s infinite;
  }

  .guion-panel {
    position: fixed; bottom: 90px; right: 24px;
    width: 420px; max-width: calc(100vw - 48px);
    max-height: 60vh; overflow-y: auto;
    background: #05070a;
    border: 1px solid var(--patrimonio);
    border-radius: 12px;
    padding: 18px 20px;
    z-index: 95;
    box-shadow: 0 12px 40px rgba(0,0,0,.6), 0 0 0 1px rgba(163,113,247,.2);
    display: none;
  }
  .guion-panel.activo { display: block; }
  .guion-panel .guion-head {
    display: flex; justify-content: space-between;
    align-items: center; margin-bottom: 12px;
    padding-bottom: 10px; border-bottom: 1px solid var(--border);
  }
  .guion-panel .guion-head h3 {
    margin: 0; font-size: 11px;
    text-transform: uppercase; letter-spacing: 2px;
    color: var(--patrimonio); font-weight: 700;
  }
  .guion-panel .guion-head .paso-num {
    font-family: ui-monospace, monospace;
    font-size: 11px; color: var(--muted);
  }
  .guion-panel .guion-accion {
    font-size: 11px;
    background: rgba(255,92,138,.12);
    color: var(--live);
    padding: 6px 10px; border-radius: 6px;
    margin-bottom: 12px;
    letter-spacing: .5px;
    border-left: 3px solid var(--live);
  }
  .guion-panel .guion-accion strong { color: #fff; }
  .guion-panel .guion-texto {
    font-family: Georgia, serif;
    font-size: 15px; line-height: 1.65;
    color: #e6edf3;
    margin-bottom: 14px;
  }
  .guion-panel .guion-texto em { color: var(--oro); font-style: italic; }
  .guion-panel .guion-texto strong { color: #fff; }
  .guion-panel .guion-pausa {
    font-size: 11px;
    background: rgba(210,153,34,.12);
    color: var(--warn);
    padding: 6px 10px; border-radius: 6px;
    margin-top: 10px;
    border-left: 3px solid var(--warn);
  }
  .guion-panel .guion-hint {
    font-family: ui-monospace, monospace;
    font-size: 10px; color: var(--muted);
    margin-top: 12px; text-align: center;
    letter-spacing: 1px;
  }

  .impacto-overlay {
    position: fixed; inset: 0;
    background: rgba(5,7,10,.96);
    display: none; align-items: center; justify-content: center;
    z-index: 200; padding: 40px; text-align: center;
    animation: fadeIn .8s ease;
  }
  .impacto-overlay.activa { display: flex; }
  @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

  .impacto-contenido { max-width: 900px; }
  .impacto-contenido .frase {
    font-family: Georgia, serif;
    font-size: 32px; line-height: 1.4;
    color: #fff; margin-bottom: 24px;
    opacity: 0; animation: fadeUp 1s ease forwards;
  }
  .impacto-contenido .frase:nth-child(2) { animation-delay: 1.2s; }
  .impacto-contenido .frase:nth-child(3) { animation-delay: 2.4s; }
  .impacto-contenido .frase:nth-child(4) { animation-delay: 3.6s; }
  .impacto-contenido .frase strong { color: var(--patrimonio); font-weight: 700; }
  .impacto-contenido .frase.oro { color: var(--oro); }
  .impacto-contenido .cierre-final {
    margin-top: 40px; opacity: 0;
    animation: fadeUp 1s ease forwards;
    animation-delay: 4.8s;
  }
  .impacto-contenido .cierre-final h2 {
    font-size: 28px; letter-spacing: 4px; margin: 0 0 12px;
  }
  .impacto-contenido .cierre-final p { color: var(--muted); margin: 6px 0; }
  .impacto-contenido .cierre-final .oro {
    color: var(--oro); font-weight: 700; font-size: 18px;
  }
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }
  .impacto-cerrar {
    margin-top: 40px; background: transparent;
    border: 1px solid var(--border); color: var(--muted);
    padding: 10px 24px; border-radius: 6px;
    cursor: pointer; font-size: 12px; letter-spacing: 1.5px;
    opacity: 0; animation: fadeUp 1s ease forwards;
    animation-delay: 5.5s;
  }
  .impacto-cerrar:hover { color: var(--text); border-color: var(--accent); }
'

python3 - "$CSS_BLOCK" <<'PYEOF'
import sys
css = sys.argv[1]
with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()
pos = c.rfind("</style>")
c = c[:pos] + css + "\n" + c[pos:]
with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)
print("  ✓ CSS insertado (1 bloque)")
PYEOF

# ------------------------------------------------------------
# 3. HTML · Botones, barra, guion, overlay
# ------------------------------------------------------------
echo "→ [3/6] Insertando HTML…"

HTML_BLOCK='
<!-- MODO PRESENTACIÓN + GUION + NARRACIÓN -->
<button id="btnIniciarPresentacion" class="btn-presentacion-inicio">
  ▶ Iniciar presentación (Demo 2)
</button>

<div id="presentacionBar" class="presentacion-bar">
  <div class="presentacion-info" id="presentacionPaso">Preparando…</div>
  <div class="presentacion-progress"><div class="fill" id="presentacionFill"></div></div>
  <button class="presentacion-btn" id="btnToggleGuion" onclick="toggleGuion()">📖 Guion: ON</button>
  <button class="presentacion-btn voz-on" id="btnToggleVoz" onclick="toggleVoz()">🔊 Voz: ON</button>
  <button class="presentacion-btn stop" onclick="detenerPresentacion()">■ Detener</button>
</div>

<div id="guionPanel" class="guion-panel">
  <div class="guion-head">
    <h3>Guion narrador</h3>
    <span class="paso-num" id="guionPasoNum">1 / 8</span>
  </div>
  <div class="guion-accion" id="guionAccion">Acción</div>
  <div class="guion-texto" id="guionTexto">Texto</div>
  <div class="guion-pausa" id="guionPausa" style="display:none;"></div>
  <div class="guion-hint">Barra espaciadora = pausar / reanudar</div>
</div>

<div id="impactoOverlay" class="impacto-overlay">
  <div class="impacto-contenido">
    <p class="frase">Una información que llegó como un reporte ciudadano</p>
    <p class="frase">puede terminar convertida en <strong>información verificada</strong>,</p>
    <p class="frase"><strong>contenido periodístico</strong> y <strong>memoria digital de una comunidad</strong>.</p>
    <p class="frase oro" style="font-size: 22px; margin-top: 40px;">La tecnología asiste. El periodista decide.</p>
    <div class="cierre-final">
      <h2>MONITOR CIID</h2>
      <p>Innovar para informar. Digitalizar para preservar.</p>
      <p class="oro">De Oaxaca para el mundo. 🌎</p>
    </div>
    <button class="impacto-cerrar" onclick="cerrarImpacto()">Cerrar</button>
  </div>
</div>
'

python3 - "$HTML_BLOCK" <<'PYEOF'
import sys
html_block = sys.argv[1]
with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()
pos = c.rfind("</main>")
c = c[:pos] + html_block + "\n" + c[pos:]
with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)
print("  ✓ HTML insertado")
PYEOF

# ------------------------------------------------------------
# 4. JS · Motor presentación + guion + narración (todo junto, sin reasignar)
# ------------------------------------------------------------
echo "→ [4/6] Insertando JavaScript…"

JS_BLOCK='
/* ============================================================
   MODO PRESENTACIÓN + GUION + NARRACIÓN (todo integrado)
   ============================================================ */

let presentacionActiva = false;
let presentacionTimers = [];
let presentacionStepIndex = 0;
let guionVisible = true;
let vozActiva = true;
let vozSeleccionada = null;
let audioActual = null;
let ultimoPasoNarrado = -1;

const GUION_PRESENTACION = [
  {
    estado: "RECEIVED",
    espera: 12000,
    mensaje: "1/8 · Llega la denuncia ciudadana",
    accion: "Paso 1 · Ingesta ciudadana",
    texto: `<strong>Escuchen esto.</strong> Una persona de una comunidad de la Sierra Norte nos manda un audio en su lengua originaria, una fotografía y un texto. Su pregunta es simple: <em>¿qué está pasando con el camino?</em><br><br>Esto no llegó a un correo perdido. Esto entró al ecosistema CIID.`,
    pausa: "🎯 Reproduce el audio. Deja que suene 5 segundos. Detenlo y comenta: «es la voz de alguien que quiere saber qué pasa en su comunidad»."
  },
  {
    estado: "PROCESSING",
    espera: 8000,
    mensaje: "2/8 · CIID recibe y estructura",
    accion: "Paso 2 · Normalización",
    texto: `El sistema <strong>no traduce</strong>. El sistema <strong>estructura</strong>.<br><br>Extrae texto, preserva el audio tal cual llegó, detecta la posible variante lingüística, y marca esto como <em>patrimonio potencial</em>.<br><br>Fíjense en la línea morada: <strong>«Registro lingüístico original conservado»</strong>. El audio nunca se borra. Nunca se sobreescribe.`,
    pausa: "🎯 Señala la línea morada en el log. Es el primer diferenciador técnico."
  },
  {
    estado: "CLASSIFIED",
    espera: 7000,
    mensaje: "3/8 · Territorio y lengua identificados",
    accion: "Paso 3 · Clasificación",
    texto: `El sistema no solo dice <em>«esto es infraestructura»</em>. Dice territorio, tipo, lengua detectada, nivel de sensibilidad patrimonial, y un porcentaje de confianza.<br><br>Fíjense en <strong>«Sensibilidad: Patrimonio lingüístico»</strong>. Esa etiqueta cambia por completo cómo se va a tratar este contenido de aquí en adelante.`,
    pausa: "🎯 Deja que las etiquetas aparezcan una a una. No interrumpas."
  },
  {
    estado: "EDITORIAL_REVIEW",
    espera: 22000,
    mensaje: "4/8 · Asistencia editorial en vivo",
    accion: "Paso 4 · Generación bilingüe · MOMENTO CLAVE",
    texto: `Esto que están viendo <strong>no es un copy-paste</strong>. El sistema está generando un borrador completo: kicker, titular, sumario, cuerpo, firma.<br><br>Y ahora viene lo que ningún otro sistema hace: la nota se genera <strong>también en la lengua originaria</strong>, con su propio titular, su propio sumario, su propio cuerpo.<br><br><em>No es una traducción. Es una versión paralela.</em>`,
    pausa: "🎯 Pausa dramática. Cuando empiece a escribirse la versión en lengua, guarda silencio. Deja que el público vea la animación completa."
  },
  {
    estado: "VERIFICATION",
    espera: 14000,
    mensaje: "5/8 · Verificación + validación lingüística",
    accion: "Paso 5 · Verificación y validación",
    texto: `Aquí está la <strong>regla de oro</strong>: el reporte ciudadano <em>NO se convierte automáticamente en noticia</em>.<br><br>No importa que tengamos un audio, una foto y un texto. No se publica hasta que se contrasta con la autoridad, con documentos, y con otras fuentes.<br><br>Y aquí aparece algo único: entra un <strong>hablante nativo</strong>. No para traducir. Para validar sentido, contexto, variante y cosmovisión.`,
    pausa: "🎯 Aquí es donde el proyecto se separa de cualquier otro. Habla despacio."
  },
  {
    estado: "DECISION",
    espera: 8000,
    mensaje: "6/8 · Decisión periodística",
    accion: "Paso 6 · Decisión humana",
    texto: `Aquí llega el <strong>periodista</strong>. No la inteligencia artificial.<br><br>El sistema ya hizo todo el trabajo pesado: verificó, contrastó, validó la lengua, generó los borradores.<br><br>Pero el botón verde de <strong>«Aprobar y publicar»</strong> solo lo puede tocar un humano.<br><br><em>La tecnología asiste. El periodista decide.</em>`,
    pausa: "🎯 Pausa 2 segundos. Mira al público. Presiona tú mismo «Aprobar y publicar»."
  },
  {
    estado: "PUBLISHED",
    espera: 12000,
    mensaje: "7/8 · Publicación multiformato",
    accion: "Paso 7 · Publicación",
    texto: `Una sola información. Miren cuántos formatos salen al mismo tiempo: card de portada, nota completa en español, nota completa en lengua originaria, audio, formato para radio comunitaria, archivo.<br><br>Y aquí está la diferencia: <em>la misma historia contada en dos idiomas, en paralelo. Las dos son originales.</em>`,
    pausa: "🎯 Toca el toggle «Ver ambas» para que se vean lado a lado."
  },
  {
    estado: "PRESERVED",
    espera: 16000,
    mensaje: "8/8 · Archivo patrimonial vivo",
    accion: "Paso 8 · Preservación",
    texto: `Y aquí está el cierre.<br><br>Esta información <strong>no desaparece después de publicarse</strong>. No se borra. No se sobreescribe.<br><br>Se convierte en <strong>memoria digital de una comunidad</strong>. Con su lengua, su territorio, su voz, su hablante que validó, y su evidencia de verificación.<br><br><em>Innovar para informar. Digitalizar para preservar.</em>`,
    pausa: "🎯 Cuando termine este paso, aparecerá el overlay con la frase final. Guarda silencio 3 segundos."
  }
];

function limpiarTimers() {
  presentacionTimers.forEach(t => clearTimeout(t));
  presentacionTimers = [];
}

function actualizarBarraPresentacion() {
  const paso = GUION_PRESENTACION[presentacionStepIndex];
  const total = GUION_PRESENTACION.length;
  const pct = ((presentacionStepIndex + 1) / total) * 100;
  document.getElementById("presentacionPaso").textContent =
    `${paso.mensaje} · ${presentacionStepIndex + 1}/${total}`;
  document.getElementById("presentacionFill").style.width = pct + "%";
}

function actualizarGuion() {
  const paso = GUION_PRESENTACION[presentacionStepIndex];
  if (!paso) return;
  document.getElementById("guionPasoNum").textContent =
    `${presentacionStepIndex + 1} / ${GUION_PRESENTACION.length}`;
  document.getElementById("guionAccion").innerHTML = `<strong>${paso.accion}</strong>`;
  document.getElementById("guionTexto").innerHTML = paso.texto;
  const pausaEl = document.getElementById("guionPausa");
  if (paso.pausa) {
    pausaEl.style.display = "block";
    pausaEl.innerHTML = paso.pausa;
  } else {
    pausaEl.style.display = "none";
  }
}

function iniciarPresentacion() {
  if (presentacionActiva) return;
  presentacionActiva = true;
  presentacionStepIndex = 0;
  ultimoPasoNarrado = -1;

  document.querySelector(\'.tab[data-view="demo2"]\').click();
  demo2.estado = 0;
  actualizar(2);

  document.getElementById("presentacionBar").classList.add("activa");
  document.getElementById("btnIniciarPresentacion").style.display = "none";
  if (guionVisible) document.getElementById("guionPanel").classList.add("activa");

  ejecutarPasoPresentacion();
}

function ejecutarPasoPresentacion() {
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

  const t = setTimeout(() => {
    if (!presentacionActiva) return;
    presentacionStepIndex++;
    ejecutarPasoPresentacion();
  }, paso.espera);
  presentacionTimers.push(t);
}

function detenerPresentacion() {
  presentacionActiva = false;
  limpiarTimers();
  detenerNarracion();
  document.getElementById("presentacionBar").classList.remove("activa");
  document.getElementById("guionPanel").classList.remove("activa");
  document.getElementById("btnIniciarPresentacion").style.display = "flex";
}

function terminarPresentacion() {
  presentacionActiva = false;
  limpiarTimers();
  detenerNarracion();
  document.getElementById("presentacionBar").classList.remove("activa");
  document.getElementById("guionPanel").classList.remove("activa");
  document.getElementById("impactoOverlay").classList.add("activa");
}

function cerrarImpacto() {
  document.getElementById("impactoOverlay").classList.remove("activa");
  document.getElementById("btnIniciarPresentacion").style.display = "flex";
  demo2.estado = 0;
  actualizar(2);
}

function toggleGuion() {
  guionVisible = !guionVisible;
  const btn = document.getElementById("btnToggleGuion");
  const panel = document.getElementById("guionPanel");
  if (guionVisible) {
    btn.textContent = "📖 Guion: ON";
    btn.classList.remove("activo");
    if (presentacionActiva) panel.classList.add("activa");
  } else {
    btn.textContent = "📖 Guion: OFF";
    btn.classList.add("activo");
    panel.classList.remove("activa");
  }
}

/* ---------------- NARRACIÓN ---------------- */

function limpiarTextoParaVoz(html) {
  const tmp = document.createElement("div");
  tmp.innerHTML = html;
  return tmp.textContent
    .replace(/🎯/g, "Punto clave.")
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
    if (presentacionActiva) narrarPaso(presentacionStepIndex);
  } else {
    btn.textContent = "🔇 Voz: OFF";
    btn.classList.remove("voz-on");
    btn.classList.add("voz-off");
    detenerNarracion();
  }
}

/* Observador de paso actual para disparar narración */
setInterval(() => {
  if (!presentacionActiva) {
    ultimoPasoNarrado = -1;
    return;
  }
  if (presentacionStepIndex !== ultimoPasoNarrado) {
    ultimoPasoNarrado = presentacionStepIndex;
    narrarPaso(presentacionStepIndex);
  }
}, 400);

document.getElementById("btnIniciarPresentacion").addEventListener("click", iniciarPresentacion);

document.addEventListener("keydown", (e) => {
  if (e.code === "Space" && !e.target.matches("button, input, textarea")) {
    e.preventDefault();
    if (presentacionActiva) detenerPresentacion();
    else iniciarPresentacion();
  }
  if (e.code === "Escape") {
    document.getElementById("impactoOverlay").classList.remove("activa");
  }
});
'

python3 - "$JS_BLOCK" <<'PYEOF'
import sys
js = sys.argv[1]
with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()
pos = c.rfind("</script>")
c = c[:pos] + js + "\n" + c[pos:]
with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)
print("  ✓ JS insertado (1 bloque)")
PYEOF

# ------------------------------------------------------------
# 5. Verificación
# ------------------------------------------------------------
echo "→ [5/6] Verificando…"
echo ""

P1=$(grep -c "MODO PRESENTACIÓN + GUION + NARRACIÓN" index.html || echo "0")
P2=$(grep -c "GUION_PRESENTACION = \[" index.html || echo "0")
P3=$(grep -c "function renderStageDemo1" index.html || echo "0")
P4=$(grep -c "function renderStageDemo2" index.html || echo "0")
P5=$(grep -c "btnToggleVoz" index.html || echo "0")
P6=$(grep -c "btnIniciarPresentacion" index.html || echo "0")

echo "  Bloques CSS presentación:  $P1 (debe ser 1)"
echo "  Guion definido:            $P2 (debe ser 1)"
echo "  Función renderStageDemo1:  $P3 (debe ser 1)"
echo "  Función renderStageDemo2:  $P4 (debe ser 1)"
echo "  Referencias btnToggleVoz:  $P5 (debe ser ≥ 2)"
echo "  Referencias btnIniciar:    $P6 (debe ser ≥ 2)"

if [ "$P1" = "1" ] && [ "$P2" = "1" ] && [ "$P3" = "1" ] && [ "$P4" = "1" ]; then
  echo ""
  echo "  ✅ Verificación OK"
else
  echo ""
  echo "  ❌ Verificación falló"
  echo "     Restaura: cp index.html.backup-limpio-SEGURO index.html"
  exit 1
fi

echo ""
echo "════════════════════════════════════════════════════"
echo "  ✅ Demo reconstruida con narración"
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
echo "     git commit -m 'Demo reconstruida con narración'"
echo "     git push"
echo ""
echo "Cómo usar:"
echo "  - Toca '▶ Iniciar presentación (Demo 2)'"
echo "  - La voz narra cada paso automáticamente"
echo "  - Botón 🔊 Voz: ON/OFF para controlarla"
echo "  - Barra espaciadora pausa/reanuda"
echo ""
echo "Si algo falla:"
echo "  cp index.html.backup-limpio-SEGURO index.html"
echo "  git add . && git commit -m 'restaurar' && git push"
echo ""
