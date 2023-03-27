extends KinematicBody
var velocity = Vector3()
var gravity = -30
var max_speed = -8
var mouse_sentivity = 0.0025
signal Walkin
signal idle

onready var punch= preload("res://Scenes/Punch.tscn")
onready var bitcrusher= preload("res://Scenes/Bitcrusher.tscn")
var currentGun = 0
onready var carriedGun = [punch,bitcrusher]


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("ui_down"):
		input_dir += -global_transform.basis.z
		
	if Input.is_action_pressed("ui_up"):
			input_dir += global_transform.basis.z
			
	if Input.is_action_pressed("ui_right"):
			input_dir += -global_transform.basis.x
			
	if Input.is_action_pressed("ui_left"):
			input_dir += global_transform.basis.x
	
	input_dir = input_dir.normalized()
	return input_dir
	
func _physics_process(delta):
	velocity.y += gravity * delta
	var desire_vel = get_input() * max_speed
	velocity.x= desire_vel.x
	velocity.z = desire_vel.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if velocity != Vector3():
		$AnimationPlayer.play("Wankin")
		emit_signal("Walkin")
	else:
		$AnimationPlayer.play("Idle")
		emit_signal("idle")
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sentivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sentivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2,1.2)

func _process(delta):
	if Input.is_action_just_released("changeup"):
		currentGun += 1
		if currentGun > len(carriedGun)-1:
			currentGun =0
			change_gun(currentGun)
	elif Input.is_action_just_released("changedown"):
		currentGun = -1
		if currentGun< 0:
			currentGun = len(carriedGun)-1
			change_gun(currentGun)
func change_gun(gun):
	$Pivot/Hand.get_child(0).queue_free()
	var newGun= carriedGun[gun].instance()
	$Pivot/Hand.add_child(newGun) 
	Payerstats.current_gun = newGun
func get_key(color):
	var key = preload("res://test_procedural_maze/key_icon.tscn").instance()
	key.position.x = 64*$Keys.get_child_count()
	key.modulate = color
	$Keys.add_child(key)

func has_key(color):
	for c in $Keys.get_children():
		if c.modulate == color:
			return true
	return false
