extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animatedS: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking:=false
var combo_timer := 0.0
var combo_time_limit := 0.6
var combos = {
	"heavy_combo": ["attack1","attack2"],
}
var actions:=["attack1","attack2"]
var input_buffer:=[]
var hold:=false
func _ready() -> void:
	combo_timer=combo_time_limit
	
func _physics_process(delta: float) -> void:
	if combo_timer <= 0 and  not hold:
		input_buffer.remove_at(0)
	else:
		combo_timer -= delta
		
	if not is_attacking and input_buffer.size() > 0:
		attack(input_buffer[0])
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	animation(velocity)
	move_and_slide()
	print(input_buffer)
func _input(event):
	if event.is_pressed():
		for action in actions:
			if InputMap.event_is_action(event, action):
				if action in actions:
					input_buffer.append(action)
					combo_timer = combo_time_limit
					check_combos()
				

func check_combos():
	for combo_name in combos.keys():
		var combo = combos[combo_name]

		# Prevent overflow
		if input_buffer.size() > combo.size():
			continue

		var matching = true
		for i in range(input_buffer.size()):
			if input_buffer[i] != combo[i]:
				matching = false
				break
		if matching:
			# FULL match
			if input_buffer.size() == combo.size():
				execute_combo(combo_name)
				input_buffer.append(combo_name)
				return
				
			
			# PARTIAL match → wait for next input
			return
	

	
func execute_combo(name: String):
	print("Combo triggered: ", name)
	hold=true
		

func animation(velocity:Vector2):
	if is_attacking:
		return
	if  velocity.x>5:
		animatedS.flip_h=false
		animatedS.play("run")
	elif velocity.x<-5:
		animatedS.flip_h=true
		animatedS.play("run")
	else:
		animatedS.play("idle")
	
func attack(attack:String):
	if is_attacking:
		return
	is_attacking=true
	
	match attack:
		"attack1":
			animatedS.play("attack1")
		"attack2":
			animatedS.play("attack2")
		"heavy_combo":
			animatedS.play("heavy_combo")
			hold=false

func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking=false
	if input_buffer.size() > 0:
		input_buffer.remove_at(0)
