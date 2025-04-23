extends CharacterBody2D

@export var move_speed: float
@export var jump_speed:  float
@export var fly_gravity: float 
@onready var animated_sprite = $AnimatedSprite
var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0
var max_jumps = 2  
var is_flying = false

func _physics_process(delta):
	handle_flight_input()
	jump(delta)
	move_x()
	flip()
	update_animations()
	move_and_slide()

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
	
	if velocity.x:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func jump(delta):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed
			jump_count = 1
		elif jump_count < max_jumps:
			velocity.y = -jump_speed
			jump_count += 1 
	if is_flying:
		velocity.y += fly_gravity * delta
		return  
	
	if not is_on_floor():
		velocity.y += gravity * delta

func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func move_x():
	var input_axis = Input.get_axis("move_left", "move_right")
	velocity.x = input_axis * move_speed


func _on_floor():
	if is_on_floor():
		jump_count = 0  


func handle_flight_input():
		if Input.is_action_just_pressed("fly") and not is_on_floor():
			is_flying = true
		if Input.is_action_just_released("fly"):
			is_flying = false
