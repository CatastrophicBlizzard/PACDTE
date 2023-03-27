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
	if Input.is_action_pressed("Shoot") and canpunch and Payerstats.bits > 0:
		gunanim.play("Punch")
		$RandomAudioStreamPlayer.play()
		checkhit()
		Payerstats.change_pistol_ammo(-1)
		canpunch = false
		
		
		yield (gunanim,"animation_finished")
		canpunch = true
		gunanim.play("default")
	if Input.is_action_just_pressed("REcharge"):
		canpunch = false
		gunanim.play("REcharge")
		$RandomAudioStreamPlayer2.play()
		yield (gunanim,"animation_finished")
		canpunch = true
		gunanim.play("default")
		
func checkhit():
	for ray in gunrays:
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Enemy"):
				ray.get_collider().take_damage(2)
				var newblood = blood.instance()
				get_tree().call_group("level", "add_child", newblood)
				newblood.global_transform.origin = ray.get_collision_point()
				newblood.emitting = true
		


func _on_Player_Walkin():
	$AnimationPlayer.play("Walk")


func _on_Player_idle():
	$AnimationPlayer.play("Idle")
