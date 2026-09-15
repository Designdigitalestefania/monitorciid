#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MONITOR CIID · Diagnosticar y arreglar el Modo Presentación
# Uso: bash diagnosticar-arreglar.sh
# ============================================================

set -e

DIR="$HOME/monitor-ciid-demo"
cd "$DIR"

echo ""
echo "════════════════════════════════════════════════════"
echo "  MONITOR CIID · Diagnóstico + Arreglo"
echo "════════════════════════════════════════════════════"
echo ""

# ------------------------------------------------------------
# Backup
# ------------------------------------------------------------
STAMP=$(date +%H%M%S)
cp index.html "index.html.backup-diagnostico-$STAMP"
echo "→ Backup: index.html.backup-diagnostico-$STAMP"
echo ""

# ------------------------------------------------------------
# 1. Diagnóstico
# ------------------------------------------------------------
echo "→ [1/4] Diagnóstico inicial…"
echo ""

SCRIPT_OPEN=$(grep -c "<script>" index.html || echo "0")
SCRIPT_CLOSE=$(grep -c "</script>" index.html || echo "0")
BODY_CLOSE=$(grep -c "</body>" index.html || echo "0")
HTML_CLOSE=$(grep -c "</html>" index.html || echo "0")
BTN_COUNT=$(grep -c 'id="btnIniciarPresentacion"' index.html || echo "0")
FUNC_COUNT=$(grep -c "function iniciarPresentacion" index.html || echo "0")
GUION_COUNT=$(grep -c "var GUION_PRESENTACION" index.html || echo "0")
ADD_LISTENER=$(grep -c 'btnIniciarPresentacion.*addEventListener' index.html || echo "0")

echo "  <script>            →  $SCRIPT_OPEN"
echo "  </script>           →  $SCRIPT_CLOSE"
echo "  </body>             →  $BODY_CLOSE"
echo "  </html>             →  $HTML_CLOSE"
echo "  botón (id)          →  $BTN_COUNT"
echo "  iniciarPresentacion →  $FUNC_COUNT"
echo "  GUION_PRESENTACION  →  $GUION_COUNT"
echo "  addEventListener    →  $ADD_LISTENER"
echo ""

# ------------------------------------------------------------
# 2. Detectar dónde quedó cada cosa
# ------------------------------------------------------------
echo "→ [2/4] Ubicando cada pieza…"
echo ""

echo "  Última posición de </script>:"
grep -n "</script>" index.html | tail -3 | sed 's/^/    /'
echo ""

echo "  Posición de </body>:"
grep -n "</body>" index.html | sed 's/^/    /'
echo ""

echo "  Posición de </html>:"
grep -n "</html>" index.html | sed 's/^/    /'
echo ""

echo "  Posición de function iniciarPresentacion:"
grep -n "function iniciarPresentacion" index.html | sed 's/^/    /'
echo ""

echo "  Posición de btnIniciarPresentacion addEventListener:"
grep -n "btnIniciarPresentacion" index.html | tail -3 | sed 's/^/    /'
echo ""

# ------------------------------------------------------------
# 3. Diagnóstico con Python
# ------------------------------------------------------------
echo "→ [3/4] Análisis estructural…"
echo ""

python3 <<'PYEOF'
with open("index.html", "r", encoding="utf-8") as f:
    contenido = f.read()

# Buscar posiciones
pos_last_script_open = contenido.rfind("<script>")
pos_last_script_close = contenido.rfind("</script>")
pos_body_close = contenido.rfind("</body>")
pos_html_close = contenido.rfind("</html>")
pos_btn = contenido.find('id="btnIniciarPresentacion"')
pos_func = contenido.find("function iniciarPresentacion")
pos_guion = contenido.find("var GUION_PRESENTACION")

print(f"  Último <script>     → posición {pos_last_script_open}")
print(f"  Último </script>    → posición {pos_last_script_close}")
print(f"  </body>             → posición {pos_body_close}")
print(f"  </html>             → posición {pos_html_close}")
print(f"  botón               → posición {pos_btn}")
print(f"  iniciarPresentacion → posición {pos_func}")
print(f"  GUION_PRESENTACION  → posición {pos_guion}")
print()

# Determinar problemas
problemas = []

if pos_last_script_close == -1:
    problemas.append("No se encontró </script>")

if pos_body_close != -1 and pos_last_script_close != -1:
    if pos_last_script_close > pos_body_close:
        problemas.append("⚠ El </script> está DESPUÉS del </body> (JS no se ejecuta)")

if pos_html_close != -1 and pos_last_script_close != -1:
    if pos_last_script_close > pos_html_close:
        problemas.append("⚠ El </script> está DESPUÉS del </html>")

if pos_func != -1 and pos_last_script_close != -1:
    if pos_func > pos_last_script_close:
        problemas.append("⚠ La función iniciarPresentacion está FUERA del <script>")

if pos_guion != -1 and pos_last_script_close != -1:
    if pos_guion > pos_last_script_close:
        problemas.append("⚠ GUION_PRESENTACION está FUERA del <script>")

if pos_btn == -1:
    problemas.append("⚠ No se encontró el botón")

if not problemas:
    print("  ✅ No se detectaron problemas estructurales")
else:
    print("  ❌ PROBLEMAS DETECTADOS:")
    for p in problemas:
        print(f"     {p}")
PYEOF

echo ""

# ------------------------------------------------------------
# 4. Reparar si es necesario
# ------------------------------------------------------------
echo "→ [4/4] Reparando si es necesario…"
echo ""

python3 <<'PYEOF'
with open("index.html", "r", encoding="utf-8") as f:
    contenido = f.read()

# Detectar si el bloque de presentación quedó fuera del último </script>
pos_last_script_close = contenido.rfind("</script>")
pos_body_close = contenido.rfind("</body>")

if pos_last_script_close == -1:
    print("  ❌ No hay </script> para reparar")
    exit(1)

# Buscar si hay código de presentación DESPUÉS del </script>
despues_script = contenido[pos_last_script_close:]

# Si detectamos "iniciarPresentacion" fuera del script, lo movemos dentro
if "function iniciarPresentacion" in despues_script:
    print("  → Detectado: código JS fuera del </script>")

    # Extraer el bloque desde "function iniciarPresentacion" (o desde el comentario MODO)
    pos_modo = despues_script.find("MODO PRESENTACION")
    if pos_modo == -1:
        pos_modo = despues_script.find("function iniciarPresentacion")
    if pos_modo == -1:
        print("  ❌ No se pudo ubicar el inicio del bloque a mover")
        exit(1)

    # Encontrar el final: hasta justo antes de </body>
    pos_body_in_despues = despues_script.find("</body>")
    if pos_body_in_despues == -1:
        pos_body_in_despues = len(despues_script)

    bloque_fuera = despues_script[pos_modo:pos_body_in_despues]

    # Quitar ese bloque del archivo original
    contenido_sin = contenido[:pos_last_script_close + len("</script>")] + despues_script[pos_body_in_despues:]

    # Insertar el bloque justo ANTES del último </script>
    pos_insertar = contenido_sin.rfind("</script>")
    contenido_final = contenido_sin[:pos_insertar] + bloque_fuera + "\n" + contenido_sin[pos_insertar:]

    with open("index.html", "w", encoding="utf-8") as f:
        f.write(contenido_final)

    print("  ✓ Bloque JS movido dentro del <script>")
else:
    print("  ✓ No se detectó código JS fuera del script (no requiere reparación)")
PYEOF

echo ""

# ------------------------------------------------------------
# 5. Verificación final
# ------------------------------------------------------------
echo "→ Verificación final:"
echo ""

P1=$(grep -c "MODO PRESENTACIÓN + GUION + NARRACIÓN" index.html || echo "0")
P2=$(grep -c "var GUION_PRESENTACION = \[" index.html || echo "0")
P3=$(grep -c "function renderStageDemo1" index.html || echo "0")
P4=$(grep -c "function renderStageDemo2" index.html || echo "0")

echo "  Bloques CSS:      $P1 (esperado: 1)"
echo "  Guion JS:         $P2 (esperado: 1)"
echo "  renderStageDemo1: $P3 (esperado: 1)"
echo "  renderStageDemo2: $P4 (esperado: 1)"
echo ""

if [ "$P1" = "1" ] && [ "$P2" = "1" ] && [ "$P3" = "1" ] && [ "$P4" = "1" ]; then
  echo "  ✅ Estructura OK"
else
  echo "  ⚠ Estructura incompleta"
fi

echo ""
echo "════════════════════════════════════════════════════"
echo "  Listo. Siguiente:"
echo "════════════════════════════════════════════════════"
echo ""
echo "  python -m http.server 8080"
echo ""
echo "  Abre en el navegador:"
echo "  http://localhost:8080/?demo=2"
echo ""
echo "  Toca el botón '▶ Iniciar presentación (Demo 2)'."
echo ""
echo "  Si NO funciona todavía, revisa la consola del navegador:"
echo "    1) Abre chrome://flags en Chrome"
echo "    2) Activa 'Enable Usb Web Pages' → no, mejor:"
echo "    3) Conecta el celular a una PC y usa chrome://inspect"
echo ""
echo "  O pega este comando en la barra de direcciones de Chrome"
echo "  cuando la página esté abierta:"
echo ""
echo "    javascript:alert('iniciarPresentacion=' + typeof iniciarPresentacion)"
echo ""
