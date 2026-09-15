
Guía de Contribución

¡Gracias por tu interés en MONITOR CIID! Este proyecto es creado y dirigido
por Estefanía Pérez Vázquez y busca construir una infraestructura
periodística que asista al periodista y preserve el patrimonio cultural y
lingüístico de Oaxaca.

Antes de contribuir, por favor lee el Código de Conducta.

Cómo Contribuir

1. Reportar un Bug o Sugerir una Mejora

Abre un Issue en el repositorio. Usa las plantillas disponibles:

· Bug report: para errores o comportamientos inesperados.
· Feature request: para sugerir nuevas funcionalidades.

2. Enviar Código

1. Haz un fork del repositorio.
2. Crea una rama descriptiva:
   ```bash
   git checkout -b feature/mi-nueva-funcion
   ```
3. Realiza tus cambios siguiendo el estilo del proyecto.
4. Verifica que la demo siga funcionando localmente:
   ```bash
   python -m http.server 8080
   ```
5. Haz commits con mensajes claros:
   ```bash
   git commit -m "Añade validación de audio en la ingesta"
   ```
6. Sube tu rama:
   ```bash
   git push origin feature/mi-nueva-funcion
   ```
7. Abre un Pull Request describiendo qué problema resuelve y cómo se probó.

Contribuciones Lingüísticas y Culturales

Dado que el proyecto trabaja con lenguas originarias, existe un proceso
especial para contribuciones en este ámbito:

· Toda traducción o validación lingüística debe ser realizada por hablantes nativos.
· Se acreditará siempre al colaborador lingüístico.
· Se requiere consentimiento informado de la comunidad cuando aplique.
· Se respeta la variante específica de cada comunidad.

Consulta docs/CONSENTIMIENTO-INFORMADO.md.

Estilo de Código

· JavaScript: claro, sin dependencias externas.
· CSS: variables CSS para colores y espaciados.
· HTML: semántico y accesible.
· Commits: en español o inglés, consistentes.

Licencia

Al contribuir, aceptas que tus aportaciones se publiquen bajo la
Licencia MIT del proyecto.

---

<p align="center">
  <em>Gracias por ayudar a construir MONITOR CIID.</em>
</p>
