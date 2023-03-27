extends KinematicBody

onready var nav = get_tree().get_nodes_in_group("NavMesh")[0]
onready var player = get_tree().get_nodes_in_group("Player")[0]
var path = []
var path_index = 0

var speed = 6
var health = 12

func _ready():
	pass
	
func take_damage(dmg_amount):
	$AnimationPlayer.play("Damage")
	health -= dmg_amount
	set_process(false)
	set_physics_process(false)
	
	if health <= 0:
		death()
	yield ($AnimationPlayer,"animation_finished")
	set_process(true)
	set_physics_process(true)
	$AnimationPlayer.play("idle")
func find_path(target):
	path = nav.get_simple_path(global_transform.origin,target)
	path_index = 0
	
		
	
func death():
	set_process(false)
	set_physics_process(false)
	$CollisionShape.disabled = true
	$AnimationPlayer.play("Death")
	$AudioStreamPlayer3D.play()
	yield ($AnimationPlayer,"animation_finished")
	queue_free()
	
func _physics_process(delta):
	
		
	if path_index< path.size():
		var direction = (path[path_index] - global_transform.origin)
		if direction.length() < 1:
			path_index += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
	else:
		find_path(player.global_transform.origin)
