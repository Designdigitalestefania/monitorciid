#!/data/data/com.termux/files/usr/bin/bash
cd ~/monitor-ciid-demo

if grep -q "MODO PRESENTACIÓN + GUION + NARRACIÓN" index.html; then
  echo "Ya tiene el CSS. Abortando."
  exit 0
fi

cp index.html "index.html.backup-paso1-$(date +%H%M%S)"

python3 <<'PYEOF'
with open("index.html", "r", encoding="utf-8") as f:
    c = f.read()

css = """
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
  .presentacion-btn.stop { background: rgba(248,81,73,.15); color: var(--err); border-color: var(--err); }
  .presentacion-btn.voz-on { background: rgba(46,160,67,.15); color: var(--ok); border-color: var(--ok); }
  .presentacion-btn.voz-off { background: var(--panel-2); color: var(--muted); }
  .presentacion-btn.hablando { animation: hablar 1.2s ease-in-out infinite; }
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
    font-family: ui-monospace, monospace; font-size: 11px; color: var(--muted);
  }
  .guion-panel .guion-accion {
    font-size: 11px; background: rgba(255,92,138,.12);
    color: var(--live); padding: 6px 10px; border-radius: 6px;
    margin-bottom: 12px; border-left: 3px solid var(--live);
  }
  .guion-panel .guion-texto {
    font-family: Georgia, serif; font-size: 15px; line-height: 1.65;
    color: #e6edf3; margin-bottom: 14px;
  }
  .guion-panel .guion-pausa {
    font-size: 11px; background: rgba(210,153,34,.12);
    color: var(--warn); padding: 6px 10px; border-radius: 6px;
    border-left: 3px solid var(--warn);
  }
  .guion-panel .guion-hint {
    font-family: ui-monospace, monospace; font-size: 10px;
    color: var(--muted); margin-top: 12px; text-align: center;
  }
  .impacto-overlay {
    position: fixed; inset: 0; background: rgba(5,7,10,.96);
    display: none; align-items: center; justify-content: center;
    z-index: 200; padding: 40px; text-align: center;
  }
  .impacto-overlay.activa { display: flex; }
  .impacto-contenido { max-width: 900px; }
  .impacto-contenido .frase {
    font-family: Georgia, serif; font-size: 32px; line-height: 1.4;
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
    animation: fadeUp 1s ease forwards; animation-delay: 4.8s;
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
"""

pos = c.rfind("</style>")
c = c[:pos] + css + "\n" + c[pos:]

with open("index.html", "w", encoding="utf-8") as f:
    f.write(c)

print("CSS insertado")
PYEOF

echo "Bloques: $(grep -c 'MODO PRESENTACIÓN + GUION + NARRACIÓN' index.html)"
