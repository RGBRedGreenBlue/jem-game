extends CharacterBody2D

@export var speed: int = 160
@export var acceleration: int = 5
@export var jump_speed: int = -speed * 2
@export var gravity: int = speed * 5
@export var down_gravity_factor: float = 3

@onready var jump_buffer: Timer = $JumpBuffer
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

enum State{IDLE, WALK, JUMP, DOWN}
var current_state: State = State.IDLE

func _physics_process(delta: float) -> void:
	handle_input()
	update_movement(delta)
	update_states()
	update_animation()
	move_and_slide()
	print(coyote_timer.time_left)



func handle_input() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_buffer.start()
	
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else:
		velocity.x = move_toward(velocity.x, speed * direction, acceleration)



func update_movement(delta: float) -> void:
	if (is_on_floor() || coyote_timer.time_left > 0) && jump_buffer.time_left < 0:
		velocity.y = jump_speed
		current_state = State.JUMP
		jump_buffer.stop()
		coyote_timer.stop()
		print("coyote stop")
		
	if current_state == State.JUMP:
		velocity.y += gravity * delta
	else:
		velocity.y += gravity * down_gravity_factor * delta



func update_states() -> void:
	match current_state:
		State.IDLE when velocity.x != 0:
			current_state = State.WALK
			
		State.WALK:
			if velocity.x == 0:
				current_state = State.IDLE
			if not is_on_floor() && velocity.y > 0:
				current_state = State.DOWN
				coyote_timer.start()
				print("coyote")
				
		State.JUMP when velocity.y > 0:
			current_state = State.DOWN
			
		State.DOWN when is_on_floor():
			if velocity.x == 0:
				current_state = State.IDLE
			else:
				current_state = State.WALK



func update_animation() -> void:
	if velocity.x != 0:
		animations.scale.x = sign(velocity.x)
		
	match current_state:
		State.IDLE: animations.play("idle")
		State.WALK: animations.play("walk")
		State.JUMP: animations.play("jump_up")
		State.DOWN: animations.play("jump_down")
