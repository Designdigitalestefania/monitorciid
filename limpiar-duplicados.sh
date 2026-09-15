#!/data/data/com.termux/files/usr/bin/bash
# Limpia bloques CSS duplicados de MODO PRESENTACIÓN en index.html
# Uso: bash limpiar-duplicados.sh

set -e
cd ~/monitor-ciid-demo

cp index.html "index.html.backup-antes-limpieza-$(date +%Y%m%d-%H%M%S)"

python3 - <<'PYEOF'
import re

with open("index.html", "r", encoding="utf-8") as f:
    contenido = f.read()

# Patrón del bloque CSS completo de MODO PRESENTACIÓN
patron = r'/\*\s*=+\s*\n\s*MODO PRESENTACIÓN \+ GUION NARRADOR.*?@keyframes fadeUp\s*\{[^}]*\}\s*\.impacto-cerrar\s*\{[^}]*\}\s*\.impacto-cerrar:hover\s*\{[^}]*\}'

# Buscar todas las ocurrencias
ocurrencias = list(re.finditer(patron, contenido, flags=re.DOTALL))
print(f"Bloques CSS encontrados: {len(ocurrencias)}")

if len(ocurrencias) > 1:
    # Conservar solo el primero, eliminar los demás
    primero = ocurrencias[0]
    # Construir nuevo contenido saltando los duplicados
    partes = []
    cursor = 0
    for i, match in enumerate(ocurrencias):
        if i == 0:
            partes.append(contenido[cursor:match.end()])
        else:
            # Saltar el bloque duplicado
            partes.append(contenido[cursor:match.start()])
        cursor = match.end()
    partes.append(contenido[cursor:])
    contenido_nuevo = "".join(partes)

    with open("index.html", "w", encoding="utf-8") as f:
        f.write(contenido_nuevo)
    print("✓ Duplicados eliminados")
else:
    print("No hay duplicados, nada que hacer")
PYEOF

echo ""
echo "Verificación final:"
grep -c "MODO PRESENTACIÓN + GUION NARRADOR" index.html
