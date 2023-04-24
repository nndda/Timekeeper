extends CharacterBody2D

var move_x : int = 0
var speed : float = 9500
@export_range( -1000, 18000 ) var attack_speed : float = 0

var jump_force : float = 400
var jump_count : int = 0
const MAX_FALL_SPEED = 9800

#var dead : bool = false

var allow_clean : bool = true

@onready var animation : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var camera : Camera2D = $Camera2D


func _ready(): glbl.player_dead = false

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

	if !glbl.player_dead:

		Movementnput()

		if animation.current_animation == "Clean":
			velocity.x = attack_speed * sprite.scale.x * delta
			velocity.y = 0
		else:
			velocity.x = move_x * speed * delta
			velocity.y += glbl.GRAVITY * glbl.gravity_scale * delta

		move_and_slide()



#	Player's Action        ========================================================

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
	glbl.player_dead = true
	velocity.y = 0
	$UI/AnimationPlayer.play( "Death" )


var show_dialogue_tween : Tween
var hide_dialogue_tween : Tween

func ShowDialogue( text : String = "" ) -> void:
	print()
	show_dialogue_tween = create_tween().set_ease( Tween.EASE_OUT )
	show_dialogue_tween.\
	tween_property( $UI/Dialogue, "modulate", Color.WHITE, 0.4 ).\
	from_current()

	show_dialogue_tween.play()
	$UI/Dialogue/TextureRect/Label.text = text
	print("Show Dialogue")
	print( $UI/Dialogue/TextureRect/Label.text )

func HideDialogue() -> void:
	hide_dialogue_tween = create_tween().set_ease( Tween.EASE_OUT )
	hide_dialogue_tween.\
	tween_property( $UI/Dialogue, "modulate", Color.TRANSPARENT, 0.4 ).\
	from_current()

	hide_dialogue_tween.play()
	$UI/Dialogue/TextureRect/Label.text = ""
	print("Hide Dialogue")
	print( $UI/Dialogue/TextureRect/Label.text )



#	Signals        ================================================================

func _on_AnimationPlayer_finished( anim_name ):
	if anim_name == "Clean":
		allow_clean = true# if is_on_floor() else false
		animation.play( "Idle" )
		$Sprite2D/Broom/AnimationPlayer.play( "Hide" )

func _on_AnimationPlayer_started( anim_name ):
	if anim_name == "Idle": allow_clean = true

func _on_AnimationUI_started( anim_name ):
	if anim_name == "Death":
		animation.pause()
		velocity.y = 0

func _on_AnimationUI_finished( anim_name ):
	if anim_name == "Death":
		glbl.current_level.call_deferred( "RestartLevel" )



#	Touchscreen    ================================================================

var btn_col_pressed := Color( 0.5, 0.5, 0.5 )
var btn_col_normal := Color( 0.2, 0.2, 0.2 )

func _on_left_button_down(): Input.action_press( "Left" )
func _on_left_button_up(): Input.action_release( "Left" )

func _on_right_button_down(): Input.action_press( "Right" )
func _on_right_button_up(): Input.action_release( "Right" )

func _on_clean_pressed(): Input.action_press( "Clean" )
func _on_jump_pressed(): Input.action_press( "Jump" )

func _on_button_pressed( button : String ) -> void: get_node( NodePath( button ) ).modulate = btn_col_pressed
func _on_button_release( button : String ) -> void: get_node( NodePath( button ) ).modulate = btn_col_normal


func _on_ui_ready():
	for btn in [
		$UI/Touchscreen/Move/Left,
		$UI/Touchscreen/Move/Right,
		$UI/Touchscreen/Action/Clean,
		$UI/Touchscreen/Action/Jump ]:
			btn.modulate = btn_col_normal
	if !DisplayServer.is_touchscreen_available(): $UI/Touchscreen.hide() # $UI/Touchscreen.queue_free()
#	else: $UI/Touchscreen.show()
