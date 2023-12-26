extends CharacterBody3D

@export var currentWeapon = Node3D
@export var runSpeed = 10
@export var sprintSpeed = 20
@export var exhaustionSpeed = 5
@export var sprintTime = 5
@export var climbSpeed = 10
@export var acceleration = 70
@export var rotSpeed = 25
@export var friction = 60
@export var airFriction = 10
@export var jumpImpulse = 20
@export var gravity = -40
@export var staminaModifier = 5.00
@export var maxHealth = 30
var health
var currentSpeed = runSpeed
var isClimbing = false
var pivot
var currentTime = sprintTime
var exhausted = false
#var swordSpawn = $Pivot/Node3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	gb.id = str(name)
	if not is_multiplayer_authority(): 
		$HUD.queue_free()
func _ready():
	#swordSpawn = $Pivot/Node3D
	if not is_multiplayer_authority(): 
		$HUD.queue_free()
		return
	gb.player = self
	#$HUD.get_child(0).createHeart(maxHealth)
	print(gb.id)
	health = maxHealth
	pivot = $Pivot
	
func applyGravity(delta):
	if !isClimbing:
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y,gravity,jumpImpulse)
func applyFriction(direction, delta):
	if direction == Vector3.ZERO and !isClimbing:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(direction * runSpeed, airFriction * delta).x
			velocity.z = velocity.move_toward(direction * runSpeed, airFriction * delta).z
	elif direction == Vector3.ZERO and isClimbing:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var input_vector = Input.get_vector("move_left","move_right","move_forward","move_backward").normalized()
	var direction = get_direction(input_vector)
	applyGravity(delta)
	Sprint(delta)
	applyFriction(direction,delta)
	apply_movement(input_vector, direction, delta)
	Jump()
	#meleeAttack()
	move_and_slide()
	$HUD.get_child(0).Hearts()
	#$HUD.get_child(0).Stamina(sprintTime,currentTime)
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_forward")
	input_vector.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	if !isClimbing:
		pass
	#else:
		#input_vector.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	return input_vector.normalized() if input_vector.length() > 1 else  input_vector
func  get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.y * transform.basis.z)
	return direction
func apply_movement(input_vector, direction, delta):
	#velocity.x = input_vector.x * runSpeed
	if !isClimbing:
		if direction != Vector3.ZERO and !isClimbing:
			velocity.x = velocity.move_toward(direction * currentSpeed, acceleration * delta).x
			velocity.z = velocity.move_toward(direction * currentSpeed, acceleration * delta).z
		#pivot.look_at(global_transform.origin + direction, Vector3.UP)
			pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.y), rotSpeed * delta)
	elif isClimbing:
		velocity.y = velocity.move_toward(direction * currentSpeed, acceleration * delta).y
func Jump():
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_pressed("Jump"):
			velocity.y = jumpImpulse
func Sprint(delta):
	
	if currentTime <= sprintTime and currentTime > 0 and Input.is_action_pressed("Sprint") and !exhausted:
		currentTime -= (delta * staminaModifier)
		currentSpeed = sprintSpeed
		if currentTime <= 0:
			exhausted = true
			currentSpeed = exhaustionSpeed	
	elif currentTime < sprintTime:
		if !exhausted:
			currentTime += (delta * staminaModifier)
			currentSpeed = runSpeed
		else:
			currentTime += ((delta * staminaModifier)/2)
	else:
		currentTime = sprintTime
		if exhausted:
			exhausted = false
			currentSpeed = runSpeed

func addWeapon(weapon):
	print(weapon)
	var weaponLoad = load(weapon)
	currentWeapon = weaponLoad.instantiate()
	#swordSpawn.add_child(currentWeapon)
	rpc_add_weapon.rpc()
	#print(swordSpawn.get_children())
@rpc
func rpc_add_weapon(weapon):
	var weaponLoad = load(weapon)
	currentWeapon = weaponLoad.instantiate()
	#swordSpawn.add_child(currentWeapon)
#func meleeAttack():
	#if Input.is_action_just_pressed("Melee_Attack") and swordSpawn.get_child(0):
		#attack.rpc()
#func setAttack():
	#swordSpawn.get_child(0).get_child(1).show()
	##pass
func stopAttack():
	#swordSpawn.get_child(0).get_child(1).hide()
	print("no longer attacking")
	pass
func resetAnim():
	$AnimationPlayer.play("RESET")
	

#@rpc(call_local)
func attack():
	pass
	#$AnimationPlayer.play("Attack")

