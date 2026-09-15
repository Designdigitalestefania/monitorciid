#!/data/data/com.termux/files/usr/bin/bash
cd ~/monitor-ciid-demo

if grep -q 'id="btnIniciarPresentacion"' index.html; then
  echo "Ya tiene el HTML. Abortando."
  exit 0
fi

python3 <<'PYEOF'
with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()

html_block = """
<button id="btnIniciarPresentacion" class="btn-presentacion-inicio">
  ▶ Iniciar presentación (Demo 2)
</button>

<div id="presentacionBar" class="presentacion-bar">
  <div class="presentacion-info" id="presentacionPaso">Preparando...</div>
  <div class="presentacion-progress"><div class="fill" id="presentacionFill"></div></div>
  <button class="presentacion-btn" id="btnToggleGuion" onclick="toggleGuion()">Guion: ON</button>
  <button class="presentacion-btn voz-on" id="btnToggleVoz" onclick="toggleVoz()">Voz: ON</button>
  <button class="presentacion-btn stop" onclick="detenerPresentacion()">Detener</button>
</div>

<div id="guionPanel" class="guion-panel">
  <div class="guion-head">
    <h3>Guion narrador</h3>
    <span class="paso-num" id="guionPasoNum">1 / 8</span>
  </div>
  <div class="guion-accion" id="guionAccion">Accion</div>
  <div class="guion-texto" id="guionTexto">Texto</div>
  <div class="guion-pausa" id="guionPausa" style="display:none;"></div>
  <div class="guion-hint">Barra espaciadora = pausar / reanudar</div>
</div>

<div id="impactoOverlay" class="impacto-overlay">
  <div class="impacto-contenido">
    <p class="frase">Una informacion que llego como un reporte ciudadano</p>
    <p class="frase">puede terminar convertida en <strong>informacion verificada</strong>,</p>
    <p class="frase"><strong>contenido periodistico</strong> y <strong>memoria digital de una comunidad</strong>.</p>
    <p class="frase oro" style="font-size: 22px; margin-top: 40px;">La tecnologia asiste. El periodista decide.</p>
    <div class="cierre-final">
      <h2>MONITOR CIID</h2>
      <p>Innovar para informar. Digitalizar para preservar.</p>
      <p class="oro">De Oaxaca para el mundo.</p>
    </div>
    <button class="impacto-cerrar" onclick="cerrarImpacto()">Cerrar</button>
  </div>
</div>
"""

pos = c.rfind("</main>")
c = c[:pos] + html_block + "\n" + c[pos:]

with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)

print("HTML insertado")
PYEOF

echo "btnIniciar: $(grep -c 'btnIniciarPresentacion' index.html)"
