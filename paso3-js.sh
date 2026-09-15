#!/data/data/com.termux/files/usr/bin/bash
cd ~/monitor-ciid-demo

if grep -q "GUION_PRESENTACION" index.html; then
  echo "Ya tiene JS. Abortando."
  exit 0
fi

python3 <<'PYEOF'
with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()

js_block = """
/* ============================================================
   MODO PRESENTACION + NARRACION
   ============================================================ */

var presentacionActiva = false;
var presentacionTimers = [];
var presentacionStepIndex = 0;
var guionVisible = true;
var vozActiva = true;
var vozSeleccionada = null;
var audioActual = null;
var ultimoPasoNarrado = -1;

var GUION_PRESENTACION = [
  { estado: "RECEIVED", espera: 12000, mensaje: "1/8 - Llega la denuncia ciudadana", accion: "Paso 1 - Ingesta ciudadana", texto: "Escuchen esto. Una persona de una comunidad de la Sierra Norte nos manda un audio en su lengua originaria, una fotografia y un texto. Su pregunta es simple: que esta pasando con el camino? Esto no llego a un correo perdido. Esto entro al ecosistema CIID.", pausa: "Reproduce el audio. Deja que suene 5 segundos." },
  { estado: "PROCESSING", espera: 8000, mensaje: "2/8 - CIID recibe y estructura", accion: "Paso 2 - Normalizacion", texto: "El sistema no traduce. El sistema estructura. Extrae texto, preserva el audio tal cual llego, detecta la posible variante linguistica, y marca esto como patrimonio potencial. El audio nunca se borra.", pausa: "Senala la linea morada en el log." },
  { estado: "CLASSIFIED", espera: 7000, mensaje: "3/8 - Territorio y lengua identificados", accion: "Paso 3 - Clasificacion", texto: "El sistema no solo dice esto es infraestructura. Dice territorio, tipo, lengua detectada, nivel de sensibilidad patrimonial, y un porcentaje de confianza.", pausa: "Deja que las etiquetas aparezcan una a una." },
  { estado: "EDITORIAL_REVIEW", espera: 22000, mensaje: "4/8 - Asistencia editorial en vivo", accion: "Paso 4 - Generacion bilingue", texto: "Esto que estan viendo no es un copy-paste. El sistema esta generando un borrador completo: kicker, titular, sumario, cuerpo, firma. Y ahora viene lo que ningun otro sistema hace: la nota se genera tambien en la lengua originaria. No es una traduccion. Es una version paralela.", pausa: "Pausa dramatica. Cuando empiece a escribirse la version en lengua, guarda silencio." },
  { estado: "VERIFICATION", espera: 14000, mensaje: "5/8 - Verificacion y validacion linguistica", accion: "Paso 5 - Verificacion", texto: "Aqui esta la regla de oro: el reporte ciudadano NO se convierte automaticamente en noticia. No se publica hasta que se contrasta con la autoridad, con documentos, y con otras fuentes. Y aqui aparece algo unico: entra un hablante nativo. No para traducir. Para validar sentido, contexto, variante y cosmovision.", pausa: "Habla despacio. Es tu argumento mas fuerte." },
  { estado: "DECISION", espera: 8000, mensaje: "6/8 - Decision periodistica", accion: "Paso 6 - Decision humana", texto: "Aqui llega el periodista. No la inteligencia artificial. El sistema ya hizo todo el trabajo pesado. Pero el boton verde de Aprobar y publicar solo lo puede tocar un humano. La tecnologia asiste. El periodista decide.", pausa: "Pausa 2 segundos. Mira al publico." },
  { estado: "PUBLISHED", espera: 12000, mensaje: "7/8 - Publicacion multiformato", accion: "Paso 7 - Publicacion", texto: "Una sola informacion. Miren cuantos formatos salen al mismo tiempo: card de portada, nota completa en espanol, nota completa en lengua originaria, audio, formato para radio comunitaria, archivo. La misma historia contada en dos idiomas, en paralelo.", pausa: "Toca el toggle Ver ambas para que se vean lado a lado." },
  { estado: "PRESERVED", espera: 16000, mensaje: "8/8 - Archivo patrimonial vivo", accion: "Paso 8 - Preservacion", texto: "Y aqui esta el cierre. Esta informacion no desaparece despues de publicarse. No se borra. No se sobreescribe. Se convierte en memoria digital de una comunidad. Con su lengua, su territorio, su voz, su hablante que valido. Innovar para informar. Digitalizar para preservar.", pausa: "Cuando termine este paso, aparecera el overlay final." }
];

function limpiarTimers() {
  presentacionTimers.forEach(function(t){ clearTimeout(t); });
  presentacionTimers = [];
}

function actualizarBarraPresentacion() {
  var paso = GUION_PRESENTACION[presentacionStepIndex];
  var total = GUION_PRESENTACION.length;
  var pct = ((presentacionStepIndex + 1) / total) * 100;
  document.getElementById("presentacionPaso").textContent = paso.mensaje + " - " + (presentacionStepIndex + 1) + "/" + total;
  document.getElementById("presentacionFill").style.width = pct + "%";
}

function actualizarGuion() {
  var paso = GUION_PRESENTACION[presentacionStepIndex];
  if (!paso) return;
  document.getElementById("guionPasoNum").textContent = (presentacionStepIndex + 1) + " / " + GUION_PRESENTACION.length;
  document.getElementById("guionAccion").innerHTML = "<strong>" + paso.accion + "</strong>";
  document.getElementById("guionTexto").innerHTML = paso.texto;
  var pausaEl = document.getElementById("guionPausa");
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
  document.querySelector(".tab[data-view='demo2']").click();
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
  var paso = GUION_PRESENTACION[presentacionStepIndex];
  var estadoIdx = ESTADOS.indexOf(paso.estado);
  demo2.estado = estadoIdx;
  actualizarBarraPresentacion();
  actualizarGuion();
  actualizar(2);
  var t = setTimeout(function() {
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
  var btn = document.getElementById("btnToggleGuion");
  var panel = document.getElementById("guionPanel");
  if (guionVisible) {
    btn.textContent = "Guion: ON";
    if (presentacionActiva) panel.classList.add("activa");
  } else {
    btn.textContent = "Guion: OFF";
    panel.classList.remove("activa");
  }
}

function seleccionarVoz() {
  if (!("speechSynthesis" in window)) return null;
  var voces = speechSynthesis.getVoices();
  if (!voces.length) return null;
  for (var i = 0; i < voces.length; i++) {
    if (voces[i].lang === "es-MX") return voces[i];
  }
  for (var j = 0; j < voces.length; j++) {
    if (voces[j].lang.indexOf("es") === 0) return voces[j];
  }
  return voces[0];
}

if ("speechSynthesis" in window) {
  speechSynthesis.onvoiceschanged = function() { vozSeleccionada = seleccionarVoz(); };
  setTimeout(function(){ vozSeleccionada = seleccionarVoz(); }, 800);
}

function narrarPaso(index) {
  if (!vozActiva) return;
  detenerNarracion();
  var paso = GUION_PRESENTACION[index];
  if (!paso) return;
  narrarConTTS(paso.texto);
}

function narrarConTTS(texto) {
  if (!("speechSynthesis" in window)) return;
  var utt = new SpeechSynthesisUtterance(texto);
  utt.lang = "es-MX";
  utt.rate = 0.95;
  if (vozSeleccionada) utt.voice = vozSeleccionada;
  var btn = document.getElementById("btnToggleVoz");
  if (btn) btn.classList.add("hablando");
  utt.onend = function() { if (btn) btn.classList.remove("hablando"); };
  utt.onerror = function() { if (btn) btn.classList.remove("hablando"); };
  speechSynthesis.speak(utt);
}

function detenerNarracion() {
  if ("speechSynthesis" in window) speechSynthesis.cancel();
  var btn = document.getElementById("btnToggleVoz");
  if (btn) btn.classList.remove("hablando");
}

function toggleVoz() {
  vozActiva = !vozActiva;
  var btn = document.getElementById("btnToggleVoz");
  if (!btn) return;
  if (vozActiva) {
    btn.textContent = "Voz: ON";
    if (presentacionActiva) narrarPaso(presentacionStepIndex);
  } else {
    btn.textContent = "Voz: OFF";
    detenerNarracion();
  }
}

setInterval(function() {
  if (!presentacionActiva) { ultimoPasoNarrado = -1; return; }
  if (presentacionStepIndex !== ultimoPasoNarrado) {
    ultimoPasoNarrado = presentacionStepIndex;
    narrarPaso(presentacionStepIndex);
  }
}, 400);

document.addEventListener("keydown", function(e) {
  if (e.code === "Space" && !e.target.matches("button, input, textarea")) {
    e.preventDefault();
    if (presentacionActiva) detenerPresentacion();
    else iniciarPresentacion();
  }
  if (e.code === "Escape") {
    document.getElementById("impactoOverlay").classList.remove("activa");
  }
});
"""

pos = c.rfind("</script>")
c = c[:pos] + js_block + "\n" + c[pos:]

with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)

print("JS insertado")
PYEOF

echo "GUION: $(grep -c 'GUION_PRESENTACION' index.html)"
echo "btnIniciar: $(grep -c 'btnIniciarPresentacion' index.html)"
