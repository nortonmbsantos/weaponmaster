extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_FRICTION = 100
const WALL_JUMP_PUSHBACK = 100
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
var current_speed

func _physics_process(delta):
	velocity = get_sprint(velocity)
	velocity = get_jump_and_gravity(velocity, delta)
	velocity = get_move_direction(velocity)
	
	move_and_slide()


func get_move_direction(velocity):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * current_speed
		if direction == -1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		animationPlayer.play("walk")
	else:   
		animationPlayer.stop()
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	return velocity
	
func get_sprint(velocity):
	if Input.is_action_pressed("sprint"):
		current_speed = SPEED * 2
	return velocity

func get_jump_and_gravity(velocity, delta):
	#if not is_on_floor():
	velocity += get_gravity() * delta
		#if is_on_wall_only():
			#velocity.y = get_gravity().y * delta 
	
			
	current_speed = SPEED
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and Input.is_action_pressed("move_left"):
				velocity.y = JUMP_VELOCITY
				velocity.x = WALL_JUMP_PUSHBACK * 1000000
		if is_on_wall() and Input.is_action_pressed("move_right"):
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_JUMP_PUSHBACK * 1000000
	#if is_on_wall() and !is_on_floor():
		#print("veio")
		#velocity = (get_gravity()) * delta

	
	return velocity
