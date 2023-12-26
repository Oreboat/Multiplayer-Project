extends CanvasLayer

var player
const row_size = 15
const row_spacing = 2.5
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent()
	#print(player.maxHealth)
	for i in player.maxHealth:
		if player.maxHealth != null:
			newHeart()
			await get_tree().create_timer(.001).timeout
	pass # Replace with function body.
func createHeart(maxHealth):
	for i in maxHealth:
		if maxHealth != null:
			newHeart()
			await get_tree().create_timer(.025).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Stamina()
	
	#Hearts()
	pass
func Hearts():
	
	for heart in $Hearts.get_children():
		
		var index = heart.get_index()
		
		var y = floor(index / row_size) * row_spacing
		var x = floor(index % row_size) * row_spacing
		
		heart.position = Vector2(x,y)
		var last_heart = floor(player.health)
		if index > last_heart:
			heart.frame = 0
		elif index == last_heart:
			heart.frame = (player.health - last_heart) * 4
		elif index < last_heart:
			heart.frame = 4
func newHeart():
	var newheart = Sprite2D.new()
	newheart.texture = $Hearts.texture
	newheart.hframes = $Hearts.hframes
	$Hearts.add_child(newheart)
	var index = newheart.get_index()
	var x = (index % row_size) * row_spacing
	var y = floor(index / row_size) * row_spacing
	newheart.position = Vector2(x, y)
func Stamina():
	var bar = $ProgressBar
	bar.max_value = player.sprintTime
	bar.value = player.currentTime
	if player.currentTime < player.sprintTime:
		bar.show()
		pass
	else: 
		bar.hide()
	pass
