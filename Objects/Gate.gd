extends Node2D

@export var animation_name : String = "OpenDefault"
@export var conditional : int = 99
var ot : bool = true

func Open() -> void:
	if ot:
		$Gearwheel.RunAuto()
		$AnimationPlayer.play( animation_name )
		$TileMap.process_mode = Node.PROCESS_MODE_DISABLED
		ot = false

func OpenSignal( conditional_count ) -> void:
	if conditional_count >= conditional: Open()
