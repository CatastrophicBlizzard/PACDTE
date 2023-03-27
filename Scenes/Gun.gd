extends Spatial

onready var gunanim = $CanvasLayer/Control/AnimatedSprite
onready var gunrays = $RayGun.get_children()
var canpunch = true
onready var blood = preload("res://Scenes/Bloodstalk.tscn")

func _ready():
	$AnimationPlayer.play("Apear")
	yield ($AnimationPlayer,"animation_finished")
	$"../../..".connect("Walkin",self, "_on_Player_Walkin")
	$"../../..".connect("idle",self, "_on_Player_idle")
	gunanim.play("default")
	
func _process(delta):
	if Input.is_action_pressed("Shoot") and canpunch:
		gunanim.play("Punch")
		$RandomAudioStreamPlayer.play()
		checkhit()
		canpunch = false
		
		
		yield (gunanim,"animation_finished")
		canpunch = true
		gunanim.play("default")
func checkhit():
	for ray in gunrays:
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Enemy"):
				ray.get_collider().take_damage(3.5)
				var newblood = blood.instance()
				get_tree().call_group("level", "add_child", newblood)
				newblood.global_transform.origin = ray.get_collision_point()
				newblood.emitting = true
				
		

func _on_Player_Walkin():
	$AnimationPlayer.play("WAlk")
	
func _on_Player_idle():
	$AnimationPlayer.play("Idle")
