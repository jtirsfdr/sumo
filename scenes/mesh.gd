extends MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var m1 = StandardMaterial3D.new()
	var m2 = StandardMaterial3D.new()
	if get_parent().mesh_color1:
		self.mesh.surface_set_material(0, m1)
		self.mesh.material.albedo_color = get_parent().mesh_color1
	elif get_parent().mesh_color2:
		self.mesh.surface_set_material(0, m2)
		self.mesh.material.albedo_color = get_parent().mesh_color2
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
