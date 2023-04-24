extends Sprite2D

@export var auto_open : bool = false
var opened : bool = false
var conditional : int = 999

func _ready(): if auto_open: Open()

func ToNextLevel() -> void:
	get_tree().change_scene_to_file(
		"res://Levels/" +\
		str( glbl.current_level.get_name().to_int() + 1 ) +\
		".tscn"
	)

func Open() -> void:
	opened = true
	$AnimationPlayer.play( "Open" )

func OpenSignal( conditional_count ) -> void:
	if conditional_count >= conditional: Open()

func _on_interracted():
	if opened: ToNextLevel()
