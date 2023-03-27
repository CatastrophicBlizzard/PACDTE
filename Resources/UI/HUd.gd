extends CanvasLayer


onready var Life = $MarginContainer/Stats/Values/Lifeval
onready var bits = $MarginContainer/Stats/Ammo/Ammo


func _process(delta):
	Life.text = Payerstats.get_health()
	
	match Payerstats.current_gun:
		"bitcrusher":
			bits.text = Payerstats.get_pistol_ammo()
			
		"punch":
			bits.text = "infinite"
			
