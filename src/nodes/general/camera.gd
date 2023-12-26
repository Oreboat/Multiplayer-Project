extends Node3D

@export var mouseSensitivity = .1
@export var controllerSensitivity = 3
@export var offset = Vector3(0,0,0)
var Player
var springArm

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Player = gb.player
	springArm = $SpringArm3D
	pass # Replace with function body.
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and springArm != null:
			rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity))
			springArm.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
			pass
		
func getInputVector():
	var inputVector = Vector3.ZERO
	inputVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	inputVector.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	return inputVector.normalized() if inputVector.length() > 1 else inputVector
	
func applyControllerRotation(inputVector):
	var axisVector = Vector2.ZERO
	axisVector.x = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	axisVector.y = Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
	
	if InputEventJoypadMotion:
		pass
		rotate_y(deg_to_rad(-axisVector.x) * controllerSensitivity)
		springArm.rotate_x(deg_to_rad(-axisVector.y) * controllerSensitivity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if gb.player != null:
		Player = gb.player
	if Player != null:
		self.position = Player.position
		var inputVector = getInputVector()
		if (abs(inputVector.x) > 0 or abs(inputVector.z) > 0):
			Player.rotation.y = self.rotation.y
		springArm.rotation.x = clamp(springArm.rotation.x, deg_to_rad(-75), deg_to_rad(75))
		applyControllerRotation(inputVector)
	pass
