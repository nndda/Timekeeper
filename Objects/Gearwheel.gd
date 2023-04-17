extends Node2D

var running : bool = false

@export var auto_run : bool = false
@export_enum("Running","Ticking") var movement_type = 0
@export_range(15,360) var ticking_speed = 15
@export_range(1,30) var running_speed = 25

@export_category( "Gearwheel Objects" )
@export var gearwheels : Array[ NodePath ]
@export var chains : Array[ NodePath ]
@export var chains_speed : PackedFloat32Array
@export_node_path("Node2D") var sub_gearwheel : NodePath
#@export var has_chain : bool = false
#@export_range(1.0,20.0) var chain_speed : float = 2.0

@export_category( "Switches" )
@export var cobwebs : Array[ NodePath ]
@export var switchable : bool = false
@export var switch_nodes : Array[ NodePath ]
var cobwebs_objects : Array[ Node ]



var ticking_tween : Tween
func TickingAnim() -> void:
	ticking_tween = create_tween().\
	set_loops().set_parallel().\
	set_ease( Tween.EASE_OUT ).\
	set_trans( Tween.TRANS_BOUNCE )

	for gears in gearwheels:
		var rotate_dir : float = ticking_speed if get_node( gears ).get_name().ends_with( "+" ) else -ticking_speed
#		if get_node( gears ).get_name().ends_with( "+" ): rotate_dir = ticking_speed
#		else: rotate_dir = -ticking_speed
#		rotate_dir *= ticking_speed

		ticking_tween.tween_property(get_node( gears ), "rotation_degrees", -rotate_dir, 1).as_relative()
		ticking_tween.tween_property(get_node( gears ), "rotation_degrees", rotate_dir, 1).as_relative()

	ticking_tween.play()


var running_tween : Tween
func RunningAnim() -> void:
	running_tween = create_tween().set_loops().set_parallel()

	for gears in gearwheels:
		var rotate_dir : float = 360 if get_node( gears ).get_name().ends_with( "+" ) else -360

		running_tween.tween_property(
			get_node( gears ), "rotation_degrees",
			rotate_dir,
			remap( running_speed, 1, 30, 30, 1 )
		).from( 0 )
	running_tween.play()


func _ready():
	if auto_run: RunAuto()
	else:
		for obj in cobwebs:
			cobwebs_objects.append(
			get_node( obj ) )

func RunAuto() -> void:

	match movement_type:
		0: RunningAnim()
		1: TickingAnim()

	if chains.size() > 0 and chains_speed.size() > 0:
		for chain in chains.size():
			get_node( chains[ chain ] ).Run( chains_speed[ chain ] )

	if get_node_or_null( sub_gearwheel ) != null:
		get_node_or_null( sub_gearwheel ).RunAuto()

func Run() -> void:
	if cobwebs_objects.size() == 0:
		RunAuto()

func _on_child_exiting_tree( node ):
#	Run()
	if cobwebs_objects.has( node ):
		cobwebs_objects.erase( node )
	Run()










