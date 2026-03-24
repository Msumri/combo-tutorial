extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animatedS: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking:=false
var combo_system:=Combo_system.new()
var tracked_actions:=["attack1","attack2"]

func _ready() -> void:
	add_child(combo_system)
	combo_system.combos={
	"combo_3":["attack1","attack2","attack1","attack1","attack2"],
	"combo_2":["attack1","attack1","attack2"],
	"combo_1":["attack1","attack2"],
	}
	combo_system.tracked_actions=tracked_actions
	
func _physics_process(delta: float) -> void:
	# Add the gravity
	if is_attacking:
		
		move_and_slide()
		
		return
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		combo_system.cancel_buffer_input()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if combo_system.input_buffer.size()>0:
		attack(combo_system.excute_action())
		
	animation(velocity)
	move_and_slide()


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
	velocity.x=0
	if is_attacking:
		return
	is_attacking=true
	var displacment:=10
	if animatedS.flip_h:
			displacment*=-1
	velocity.x+=move_toward(velocity.x, velocity.x+displacment, SPEED)
	match attack:

		"attack1":
			animatedS.play("attack1")
			
		"attack2":
			animatedS.play("attack2")
		"combo_1":
			animatedS.play("heavy_combo")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	combo_system.input_buffer.remove_at(0)
	is_attacking=false
	
