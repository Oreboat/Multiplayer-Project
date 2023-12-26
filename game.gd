extends Node
@onready var main_menu = $HostUI/CanvasLayer/MainMenu
@onready var address_entry = $HostUI/CanvasLayer/MainMenu/MarginContainer/VBoxContainer/LineEditnew

const PORT = 9999
const Player = preload("res://src/nodes/general/client_controller.tscn")
const Camera = preload("res://src/nodes/general/camera.tscn")
var enetPeer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_pressed():
	main_menu.hide()
	enetPeer.create_server(PORT)
	multiplayer.multiplayer_peer = enetPeer
	add_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(add_player)
	pass # Replace with function body.
func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	#await get_tree().create_timer(.05).timeout
	#var camera = Camera.instantiate()
	#add_child(camera)

func _on_join_button_pressed():
	main_menu.hide()
	enetPeer.create_client("LocalHost", 9999)
	multiplayer.multiplayer_peer = enetPeer
	pass # Replace with function body.
