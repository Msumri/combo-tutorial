# Godot Combo Input Buffer System

A lightweight combo system for Godot 4 that buffers player inputs and detects combos based on action sequences.

## Overview

This system allows you to:

* Track player inputs using `InputMap`
* Store inputs in a timed buffer
* Detect combos based on input sequences
* Trigger animations or actions from combos

It is designed for games like fighting games, action games, or any system requiring chained inputs.

---

## Features

* Input buffering with time limit
* Combo detection using sequence matching
* Priority-based combo resolution (longer combos checked first)
* Easy integration with player scripts
* Fully customizable actions and combos

---

## How It Works

1. Player inputs are captured in `_input()`
2. Matching actions are stored in `input_buffer`
3. A timer controls how long inputs stay valid
4. When the resolve timer expires:

   * The system checks if the buffer matches any combo
   * If matched, the combo name is added to the buffer
5. The player script reads the buffer and executes actions

---

## Setup

### 1. Add the Combo System

Attach or instance the `Combo_system`:

```gdscript
var combo_system := Combo_system.new()
add_child(combo_system)
```

---

### 2. Define Tracked Actions

These must match your InputMap actions:

```gdscript
combo_system.tracked_actions = ["attack1", "attack2"]
```

---

### 3. Define Combos

Combos are stored as a dictionary:

```gdscript
combo_system.combos = {
	"combo_3": ["attack1","attack2","attack1","attack1","attack2"],
	"combo_2": ["attack1","attack1","attack2"],
	"combo_1": ["attack1","attack2"],
}
```

---

### 4. Configure Timers

```gdscript
combo_system.input_buffer_time_limit = 1.0
combo_system.combo_resolve_delay = 0.2
```

* `input_buffer_time_limit`: how long inputs stay in buffer
* `combo_resolve_delay`: delay before checking combos

---

## Usage Example

### Detect and Execute Actions

```gdscript
if combo_system.input_buffer.size() > 0:
	attack(combo_system.excute_action())
```

---

### Example Attack Handling

```gdscript
func attack(attack: String):
	match attack:
		"attack1":
			animatedS.play("attack1")
		"attack2":
			animatedS.play("attack2")
		"combo_1":
			animatedS.play("heavy_combo")
```

---

## Core Functions

### `_input(event)`

Captures input and adds matching actions to buffer.

### `_process(delta)`

Handles:

* Buffer timing
* Combo resolution timing

### `check_combos()`

Checks if the buffer ends with any combo sequence.

### `ends_with_sequence(buffer, sequence)`

Utility function to match input sequences.

### `excute_action()`

Returns the next action to perform.

### `cancel_buffer_input()`

Clears the input buffer (useful on jump, interruptions, etc.)

---

## Notes / Limitations

* Uses `StringName` internally (Godot 4 InputMap)
* All actions must exist in InputMap
* UI actions (`ui_*`) may be included unless filtered
* `excute_action()` only returns the first buffered action
* Combo priority depends on sorting (longer combos should be checked first)

---

## Suggested Improvements

* Convert buffer to queue system with better priority handling
* Add combo cooldowns
* Add directional inputs (for fighting games)
* Support for hold / charge inputs
* Debug visualization of input buffer

---

## Example Use Case

This system is ideal for:

* Fighting games (combo chains)
* Hack-and-slash combat
* Action platformers with attack chaining

---

## Credits

Created by Mr. AL
Built using Godot 4
