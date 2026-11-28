# Guía de sprites - Estación Echo 9

Todo lo que se cambia está dentro de la carpeta de tu juego. Nada afecta a los otros juegos.

## Qué reproduce el juego (formato obligatorio)

Cada animación es una **tira horizontal** (una sola fila) en PNG con **fondo transparente**.
Cada cuadro mide **192 x 192 px**. El personaje va centrado, con los pies sobre la línea y=156
(la línea roja de las plantillas) y mide unos 110-130 px de alto.

| Quién | Animación | Cuadros | Tamaño final del PNG | Se repite |
|---|---|---|---|---|
| Guardia (monstruo y mecánico) | idle | 11 | 2112 x 192 | sí |
| Guardia | walk | 6 | 1152 x 192 | sí |
| Guardia | alerted | 6 | 1152 x 192 | no importa |
| Tejedora | idle | 6 | 1152 x 192 | sí |
| Tejedora | appear | 9 | 1728 x 192 | no (el último cuadro es el de reposo) |

Por qué esos números: el juego recorre esos cuadros por posición. Si una tira trae menos, el
último cuadro se queda congelado; si trae más, los sobrantes no se ven.

## Archivos en esta carpeta

- `plantilla_*.png`: cuadrícula numerada de cada animación. Pásasela a Gemini junto con tu
  personaje, para que respete el tamaño y la cantidad de cuadros.
- Ya hay animaciones listas hechas con tus 3 imágenes en `characters/` (úsalas también como
  referencia de movimiento: flotar, caminar y alerta).

## Sprites originales del juego (para dárselos a Gemini como referencia)

Están en tu PC, en `scenes/quests/story_quests/estation _echo_9/`, después de hacer `git lfs pull`:

- Guardias de sigilo: `1_stealth/stealth_components/estation _echo_9_guard_enemy_idle.png`, `_walk.png`, `_alerted.png`
- Guardias del laberinto: `2_containment_passages/containment_passages_components/` (mismos 3 nombres)
- Lanzador del combate: `5_combat/estation _echo_9_combat_components/estation _echo_9_combat_throwing_enemy_idle.png`, `_walk`, `_attack`, `_defeated`
- Tejedora original: `scenes/game_elements/props/checkpoint/components/Blue/Knitwitch_Idle.png` y `Knitwitch_Appear.png` (otros colores: Brown, Green, Pink)

## Mensaje sugerido para Gemini

> Adjunto el sprite original y una plantilla numerada. Dibuja mi personaje (imagen adjunta) en el mismo
> estilo, como una tira horizontal PNG de fondo transparente, con N cuadros de 192x192 px cada uno,
> igual que la plantilla. Mismo punto de apoyo en todos los cuadros (pies en y=156, centrado),
> misma escala del personaje en todos los cuadros y sin sombra de piso. Animación: [idle: flotar suave /
> walk: avanzar con balanceo / alerted: sobresalto]. Entrégame solo la tira, sin texto ni marcos.

## Cómo poner los sprites nuevos

1. Guarda tus PNG con **los mismos nombres** dentro de `characters/guard_circle/`, `characters/guard_long/` o `characters/checkpoint/`, sobrescribiendo los actuales.
2. Si las medidas coinciden con la tabla de arriba, no hay que tocar nada más: los `.tres` ya apuntan a esos archivos.
3. Abre el juego, deja que Godot reimporte y prueba.
