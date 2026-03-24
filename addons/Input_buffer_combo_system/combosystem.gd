extends Node

class_name Combo_system
var input_buffer:=[]
var combos:={
	
}

var input_buffer_timer := 0.0
var input_buffer_time_limit := 1
var tracked_actions:=[]

var combo_resolve_timer := 0.0
var combo_resolve_delay := 0.2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var combo_list = combos.keys()
	combo_list.sort_custom(func(a, b):
		return combos[b].size() - combos[a].size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if input_buffer.size()>0:
		if  input_buffer_timer <= 0:
			input_buffer.remove_at(0)
		else:
			input_buffer_timer -= delta
		
	if combos.size()>0:
		if combo_resolve_timer > 0:
			combo_resolve_timer -= delta
		if combo_resolve_timer <= 0:
			if check_combos():
				excute_action()

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if tracked_actions.size()==0:
			return
		for action in tracked_actions:
			if InputMap.event_is_action(event, action):
					input_buffer.append(action)
					input_buffer_timer =  input_buffer_time_limit
					combo_resolve_timer = combo_resolve_delay
						
func check_combos()->bool:

	for combo_name in combos.keys():
		var combo = combos[combo_name]
		
		if ends_with_sequence(input_buffer, combo):			
			input_buffer.append(combo_name)
			return true
	return false
func excute_action()-> String:
	var action:=""
	if input_buffer.size()>0:
		action=input_buffer[0]

	return action
	
func cancel_buffer_input():
	input_buffer.clear()
	
func ends_with_sequence(buffer: Array, sequence: Array) -> bool:
	if buffer.size() < sequence.size():
		return false
		
	for i in range(sequence.size()):
		if buffer[buffer.size() - sequence.size() + i] != sequence[i]:
			return false
			
	return true
