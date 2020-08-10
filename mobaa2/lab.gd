extends RigidBody2D

var start_health = 100
var health = start_health
var alive
var speed = 500


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(amount):
	#$HealthBar.show()
	health -= amount
	emit_signal("health_changed", (health * 100 / start_health))
	#health * 100 / start_health
	#$Bar.rect_size.x = 50 * health / start_health
	if health <= 0:
		alive = false
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
