extends Area3D

@export var damage = .75
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_multiplayer_authority(): 
		body.health -= damage
		print(body.health)
		pass # Replace with function body.
