#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MONITOR CIID · Agrega Modo Presentación + Guion Narrador
# Modifica index.html sin romper lo que ya existe.
# Uso: bash agregar-presentacion.sh
# ============================================================

set -e

DIR="$HOME/monitor-ciid-demo"
HTML="$DIR/index.html"

if [ ! -f "$HTML" ]; then
  echo "❌ No se encontró $HTML"
  echo "   Ejecuta primero: bash crear-demo.sh"
  exit 1
fi

echo ""
echo "════════════════════════════════════════════════════"
echo "  MONITOR CIID · Modo Presentación + Guion"
echo "════════════════════════════════════════════════════"
echo ""

# ------------------------------------------------------------
# Backup
# ------------------------------------------------------------
cp "$HTML" "$HTML.backup-$(date +%Y%m%d-%H%M%S)"
echo "→ Backup creado"
echo ""

# ------------------------------------------------------------
# 1. Insertar CSS antes de </style>
# ------------------------------------------------------------
echo "→ [1/4] Insertando CSS…"

CSS_BLOCK='
  /* ============================================================
     MODO PRESENTACIÓN + GUION NARRADOR
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

  /* Panel del guion narrador */
  .guion-panel {
    position: fixed; bottom: 80px; right: 24px;
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
  .guion-panel .guion-texto em {
    color: var(--oro); font-style: italic;
  }
  .guion-panel .guion-texto strong {
    color: #fff;
  }
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

  /* Overlay de impacto final */
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

# Insertar antes del último </style>
python3 - "$HTML" "$CSS_BLOCK" <<'PYEOF'
import sys
html_path, css_block = sys.argv[1], sys.argv[2]
with open(html_path, "r", encoding="utf-8") as f:
    contenido = f.read()

if "MODO PRESENTACIÓN + GUION NARRADOR" in contenido:
    print("  ⚠ CSS ya estaba insertado, saltando…")
else:
    # Insertar antes del último </style>
    pos = contenido.rfind("</style>")
    if pos == -1:
        print("  ❌ No se encontró </style>")
        sys.exit(1)
    contenido = contenido[:pos] + css_block + "\n" + contenido[pos:]
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(contenido)
    print("  ✓ CSS insertado")
PYEOF

# ------------------------------------------------------------
# 2. Insertar HTML antes de </main>
# ------------------------------------------------------------
echo ""
echo "→ [2/4] Insertando HTML…"

HTML_BLOCK='
<!-- ============================================================
     MODO PRESENTACIÓN + GUION NARRADOR
     ============================================================ -->
<button id="btnIniciarPresentacion" class="btn-presentacion-inicio">
  ▶ Iniciar presentación (Demo 2)
</button>

<div id="presentacionBar" class="presentacion-bar">
  <div class="presentacion-info" id="presentacionPaso">Preparando…</div>
  <div class="presentacion-progress"><div class="fill" id="presentacionFill"></div></div>
  <button class="presentacion-btn" id="btnToggleGuion" onclick="toggleGuion()">📖 Guion: ON</button>
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

python3 - "$HTML" "$HTML_BLOCK" <<'PYEOF'
import sys
html_path, html_block = sys.argv[1], sys.argv[2]
with open(html_path, "r", encoding="utf-8") as f:
    contenido = f.read()

if "btnIniciarPresentacion" in contenido:
    print("  ⚠ HTML ya estaba insertado, saltando…")
else:
    pos = contenido.rfind("</main>")
    if pos == -1:
        print("  ❌ No se encontró </main>")
        sys.exit(1)
    contenido = contenido[:pos] + html_block + "\n" + contenido[pos:]
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(contenido)
    print("  ✓ HTML insertado")
PYEOF

# ------------------------------------------------------------
# 3. Insertar JavaScript antes de </script> final
# ------------------------------------------------------------
echo ""
echo "→ [3/4] Insertando JavaScript…"

JS_BLOCK='
/* ============================================================
   MODO PRESENTACIÓN + GUION NARRADOR
   ============================================================ */

let presentacionActiva = false;
let presentacionTimers = [];
let presentacionStepIndex = 0;
let guionVisible = true;

const GUION_PRESENTACION = [
  {
    estado: "RECEIVED",
    espera: 12000,
    mensaje: "1/8 · Llega la denuncia ciudadana",
    accion: "Paso 1 · Ingesta ciudadana",
    texto: `<strong>Escuchen esto.</strong> Una persona de una comunidad de la Sierra Norte nos manda un audio en su lengua originaria, una fotografía y un texto. Su pregunta es simple: <em>¿qué está pasando con el camino?</em><br><br>Esto no llegó a un correo perdido. Esto entró al ecosistema CIID.`,
    pausa: "🎯 Reproduce el audio. Deja que suene 5 segundos. Detenlo y comenta: *«es la voz de alguien que quiere saber qué pasa en su comunidad»*."
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
    pausa: "🎯 Aquí es donde el proyecto se separa de cualquier otro. Habla despacio. Es tu argumento más fuerte."
  },
  {
    estado: "DECISION",
    espera: 8000,
    mensaje: "6/8 · Decisión periodística",
    accion: "Paso 6 · Decisión humana",
    texto: `Aquí llega el <strong>periodista</strong>. No la IA.<br><br>El sistema ya hizo todo el trabajo pesado: verificó, contrastó, validó la lengua, generó los borradores.<br><br>Pero el botón verde de <strong>«Aprobar y publicar»</strong> solo lo puede tocar un humano.<br><br><em>La tecnología asiste. El periodista decide.</em>`,
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
  document.getElementById("guionAccion").innerHTML =
    `<strong>${paso.accion}</strong>`;
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

  document.querySelector('.tab[data-view="demo2"]').click();

  demo2.estado = 0;
  actualizar(2);

  document.getElementById("presentacionBar").classList.add("activa");
  document.getElementById("btnIniciarPresentacion").style.display = "none";

  if (guionVisible) {
    document.getElementById("guionPanel").classList.add("activa");
  }

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
  document.getElementById("presentacionBar").classList.remove("activa");
  document.getElementById("guionPanel").classList.remove("activa");
  document.getElementById("btnIniciarPresentacion").style.display = "flex";
}

function terminarPresentacion() {
  presentacionActiva = false;
  limpiarTimers();
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

python3 - "$HTML" "$JS_BLOCK" <<'PYEOF'
import sys
html_path, js_block = sys.argv[1], sys.argv[2]
with open(html_path, "r", encoding="utf-8") as f:
    contenido = f.read()

if "MODO PRESENTACIÓN + GUION NARRADOR" in contenido and "GUION_PRESENTACION" in contenido:
    print("  ⚠ JS ya estaba insertado, saltando…")
else:
    pos = contenido.rfind("</script>")
    if pos == -1:
        print("  ❌ No se encontró </script>")
        sys.exit(1)
    contenido = contenido[:pos] + js_block + "\n" + contenido[pos:]
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(contenido)
    print("  ✓ JavaScript insertado")
PYEOF

# ------------------------------------------------------------
# 4. Verificación
# ------------------------------------------------------------
echo ""
echo "→ [4/4] Verificando…"

for needle in "MODO PRESENTACIÓN + GUION NARRADOR" "btnIniciarPresentacion" "GUION_PRESENTACION"; do
  if grep -q "$needle" "$HTML"; then
    echo "  ✓ $needle"
  else
    echo "  ❌ Falta: $needle"
  fi
done

echo ""
echo "════════════════════════════════════════════════════"
echo "  ✅ Modo presentación + guion instalados"
echo "════════════════════════════════════════════════════"
echo ""
echo "Siguiente paso · subir a Netlify:"
echo ""
echo "  cd $DIR"
echo "  git add ."
echo "  git commit -m 'Modo presentación narrativa + guion integrado'"
echo "  git push"
echo ""
echo "Netlify republica solo en ~20 segundos."
echo ""
echo "Cómo probarlo:"
echo "  1) Abre https://monitorciid.netlify.app/?demo=2"
echo "  2) Verás el botón flotante '▶ Iniciar presentación (Demo 2)'"
echo "  3) Tócalo. La demo avanza sola."
echo "  4) El panel del guion aparece abajo a la derecha."
echo "  5) Barra espaciadora = pausar / reanudar"
echo ""
