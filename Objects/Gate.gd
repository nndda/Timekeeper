extends Node2D

@export_node_path( "AnimationPlayer" ) var animation_node : NodePath
var animation_name : String = "OpenDefault"
@export var conditional : int = 99
var ot : bool = true

signal opened

func _ready():
	get_node( animation_node ).connect(
		"animation_finished",
		Callable( self, "AnimationFinished" ) )

func Open() -> void: if ot:
	$Gearwheel.RunAuto()
	get_node( animation_node ).play( animation_name )
	$TileMap.process_mode = Node.PROCESS_MODE_DISABLED
	ot = false

func OpenSignal( conditional_count ) -> void:
	if conditional_count >= conditional: Open()

func AnimationFinished( anim_name ) -> void:
	if anim_name == animation_name: emit_signal( "opened" )
