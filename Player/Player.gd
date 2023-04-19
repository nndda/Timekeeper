extends CharacterBody2D

var move_x : int = 0
var speed : float = 9500
@export_range( -1000, 18000 ) var attack_speed : float = 0

var jump_force : float = 400
var jump_count : int = 0
const MAX_FALL_SPEED = 9800


var allow_clean : bool = true

@onready var animation : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var camera : Camera2D = $Camera2D


func Movementnput() -> void:
	move_x = 0

	if allow_clean: if Input.is_action_just_pressed( "Clean" ): Clean()
	else:

		if Input.is_action_pressed( "Right" ): Walk()
		elif Input.is_action_pressed( "Left" ): Walk( -1 )
		else: animation.play( "Idle" )

		if !is_on_floor(): animation.play( "Jump" )
		else: jump_count = 0

		if Input.is_action_just_pressed( "Jump" ): Jump()

func LimitCamera() -> void:
	camera.limit_left = glbl.camera_boundary[ 0 ]
	camera.limit_top = glbl.camera_boundary[ 1 ]
	camera.limit_right = glbl.camera_boundary[ 2 ]
	camera.limit_bottom = glbl.camera_boundary[ 3 ]

func _process( _delta ):
	LimitCamera()
	if is_on_floor(): mid_air_clean = false
	$LightOccluder2D.scale.x = sprite.scale.x

func _physics_process( delta ):

	Movementnput()

	if animation.current_animation == "Clean":
		velocity.x = attack_speed * sprite.scale.x * delta
		velocity.y = 0
	else:
		velocity.x = move_x * speed * delta
		velocity.y += glbl.GRAVITY * glbl.gravity_scale * delta

		if velocity.y > MAX_FALL_SPEED: velocity.y = MAX_FALL_SPEED

	move_and_slide()


#	Player's Action		========================================================

func Walk( direction : int = 1 ) -> void:
	sprite.scale.x = direction
	move_x = direction
	if is_on_floor(): animation.play( "Walk" )

func Jump() -> void:
	if is_on_floor() or jump_count < 2:
		velocity.y -= jump_force + velocity.y
		jump_count += 1

var mid_air_clean : bool = false
func Clean() -> void:
	if is_on_floor() or !mid_air_clean:
		allow_clean = false
		if !mid_air_clean: mid_air_clean = true
		animation.play( "Clean" )

func Kill() -> void:
#	glbl.gravity_scale = 0.0
	velocity.y = 0
	$UI/AnimationPlayer.play( "Death" )

#	Signals		================================================================

func _on_AnimationPlayer_finished( anim_name ):
	if anim_name == "Clean":
		allow_clean = true# if is_on_floor() else false
		animation.play( "Idle" )
		$Sprite2D/Broom/AnimationPlayer.play( "Hide" )

func _on_AnimationPlayer_started( anim_name ):
	if anim_name == "Idle": allow_clean = true

func _on_AnimationUI_finished( anim_name ):
	if anim_name == "Death":
		glbl.current_level.call_deferred( "RestartLevel" )
