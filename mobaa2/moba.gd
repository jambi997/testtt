extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Enemy = preload("res://csotany.tscn")
var t = 1
var rooms = [t]
# Called when the node enters the scene tree for the first time.
func _ready():
	#enemy_spawner()
	pass # Replace with function body.

func enemy_spawner():
	var rand = RandomNumberGenerator.new()
	#var enemy =Enemy.instance()
	
	for i in range(1,2):
		var enemy =Enemy.instance()
		#var room = rooms[1 + randi() % (rooms.size() - 1)]
		rand.randomize()
		var x =rand.randf_range(-250, 600)  #room.position.x  + 1 + randi() % int(room.size.x - 2)#rand.randf_range(-500, 500) #in $Rooms.get_children()
		rand.randomize()
		var y =rand.randf_range(-190, 320)  #room.position.y + 1 + randi() % int(room.size.y - 2) #rand.randf_range(-500, 500) #in $Rooms.get_children()
		var blocked = false
		enemy.position.y = y
		enemy.position.x = x
		add_child(enemy)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	enemy_spawner()
	#pass
