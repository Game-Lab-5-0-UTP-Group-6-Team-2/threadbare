# Apariencia propia de Estación Echo 9.
#
# Arrastra echo9_skin.tscn a cada escena de este juego. Solo cambia la imagen de la tejedora
# (checkpoint), de los coleccionables y del cuadro de diálogo mientras estés en este juego.
# No modifica ningún archivo compartido ni cambia las mecánicas: lo que no configures se queda igual.
extends Node

const BALLOON_SETTING := "dialogue_manager/runtime/balloon_path"
const SKIN_GROUP := &"echo9_skin"

static var _original_balloon_path: String = ""
static var _original_saved: bool = false

## Cuadros de la tejedora. Debe tener las animaciones "idle" y "appear" (esta última sin loop).
## Si se deja vacío, se queda la tejedora original.
@export var checkpoint_frames: SpriteFrames

## Cuadros de los monstruos que patrullan dando vueltas (rutas "RunningInCircles").
## Necesita las animaciones "idle", "walk" y "alerted". Vacío = se queda el guardia original.
@export var guard_circle_frames: SpriteFrames

## Cuadros de los guardias de tramos largos (rutas "GoingBackAndForth" y "PatrolPath").
## Necesita las animaciones "idle", "walk" y "alerted". Vacío = se queda el guardia original.
@export var guard_long_frames: SpriteFrames

## Imagen del coleccionable en el mapa. Si se deja vacío, se queda la original.
@export var collectible_texture: Texture2D

## Escala extra para la imagen del coleccionable (1 = sin cambio).
@export var collectible_scale: float = 1.0

## Cuadro de diálogo propio. Déjalo vacío para usar el cuadro original.
@export_file("*.tscn") var balloon_scene: String = "res://scenes/quests/story_quests/estation _echo_9/ui/estation _echo_9_balloon.tscn"


func _enter_tree() -> void:
	add_to_group(SKIN_GROUP)
	if balloon_scene.is_empty() or not ResourceLoader.exists(balloon_scene):
		return
	if not _original_saved:
		_original_balloon_path = str(ProjectSettings.get_setting(BALLOON_SETTING, ""))
		_original_saved = true
	ProjectSettings.set_setting(BALLOON_SETTING, balloon_scene)


func _exit_tree() -> void:
	# Si otra escena de Echo 9 ya está activa, el cuadro propio se queda.
	var tree := get_tree()
	if tree != null:
		for other in tree.get_nodes_in_group(SKIN_GROUP):
			if other != self and other.is_inside_tree():
				return
	if _original_saved:
		ProjectSettings.set_setting(BALLOON_SETTING, _original_balloon_path)
		_original_saved = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	# Esperamos un frame para que el resto de la escena ya esté lista.
	await get_tree().process_frame
	var scene_root: Node = owner if owner != null else get_parent()
	if scene_root != null:
		_apply(scene_root)


func _apply(node: Node) -> void:
	if node is Checkpoint and checkpoint_frames != null:
		if checkpoint_frames.has_animation(&"idle") and checkpoint_frames.has_animation(&"appear"):
			node.sprite_frames = checkpoint_frames
		else:
			push_warning("Echo9Skin: checkpoint_frames necesita las animaciones 'idle' y 'appear'.")
	elif node is Guard:
		var frames: SpriteFrames = _frames_for_guard(node)
		if frames != null:
			node.sprite_frames = frames
	elif node is CollectibleItem and collectible_texture != null:
		var sprite: Sprite2D = node.get_node_or_null("Sprite2D")
		if sprite != null:
			sprite.texture = collectible_texture
			if collectible_scale != 1.0:
				sprite.scale = sprite.scale * collectible_scale
	for child in node.get_children():
		_apply(child)


## Decide qué monstruo corresponde según el nombre del guardia o de su ruta de patrulla.
func _frames_for_guard(guard: Guard) -> SpriteFrames:
	var key: String = String(guard.name)
	if guard.patrol_path != null:
		key += " " + String(guard.patrol_path.name)
	var wanted: SpriteFrames = guard_long_frames
	if key.contains("Circles") or key.contains("Running"):
		wanted = guard_circle_frames
	if wanted == null:
		return null
	for animation_name in [&"idle", &"walk", &"alerted"]:
		if not wanted.has_animation(animation_name):
			push_warning("Echo9Skin: a los cuadros del guardia les falta la animación '%s'." % animation_name)
			return null
	return wanted
