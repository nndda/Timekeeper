extends CharacterBody2D

var move : Vector2 = Vector2.ZERO
var speed : float = 6500
@export_range( 0, 9000 ) var attack_speed : float = 0

var allow_clean : bool = true

@onready var animation		: AnimationPlayer	= $Sprite2D/AnimationPlayer
@onready var sprite			: Sprite2D			= $Sprite2D

func Movementnput() -> void:
	move.x = 0

	if allow_clean: if Input.is_action_just_pressed( "Clean" ): Clean()
	else:

		if		Input.is_action_pressed( "Right" ):	Walk()
		elif	Input.is_action_pressed( "Left" ):	Walk( -1 )
		else:	animation.play( "Idle" )

		if Input.is_action_just_pressed( "Jump" ): Jump()

func _process( _delta ): Movementnput()

func _physics_process( delta ):

	if !allow_clean:
		velocity.x = attack_speed * sprite.scale.x * delta
	else:
		velocity.x = move.x * speed * delta
		velocity.y = move.y * delta

	move_and_slide()

#	Player's Action		========================================================

func Walk( direction : int = 1 ) -> void:
	sprite.scale.x	= direction
	move.x			= direction
	animation.play( "Walk" )

func Jump() -> void:
	pass

func Clean() -> void:
	allow_clean = false
	animation.play( "Clean" )

#	Signals		================================================================

func _on_AnimationPlayer_finished( anim_name ):
	if anim_name == "Clean":
		allow_clean = true
		animation.play( "Idle" )
