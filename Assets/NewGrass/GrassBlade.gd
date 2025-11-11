@tool
extends MeshInstance3D

@export_tool_button("Generate Grass Blades", "Callable")
var generate_grass_blades = grass_generation

@export_range(2,5,1,"The number of subdivisions along the height of the grass blade. This determines how detailed the sway of the grass is. A higher number is higher rendering cost too.") var verticalSegments: int = 3
@export_range(0,0.1,0.001, "This determines how wide the base of the blade of grass will be.") var baseWidth: float = 0.2
@export_range(0,0.1,0.001,"This determines how wide the tip of the blade of grass will be. If set to 0 the grass will end in a point.") var tipWidth: float = 0.01
@export_range(0,5,0.1, "This determines how tall the grass will be in the scene. If you would like to adjust how detailed the flow of grass is then adjust the 'Vertical Segments' parameter instead.") var grassHeight: float = 2

func grass_generation():
	var array_mesh = ArrayMesh.new()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	# Grass Blade generation
	for i in verticalSegments:
		if (i == verticalSegments-1 && tipWidth == 0):
			var vert = Vector3(0.0,grassHeight,0.0)
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2.ZERO)
		else:
			var x = (baseWidth/2) * (1 - (float(i)/(verticalSegments-1))) + (tipWidth/2) * (float(i)/(verticalSegments-1))
			var y = (float(i))*(grassHeight/(verticalSegments-1))
			var vert = Vector3(x,y,0.0) 
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2.ZERO)
			x = -x
			vert = Vector3(x,y,0.0) 
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2.ZERO)
	
	var lastPoint = 0
	for j in range(0,len(verts),1):
		indices.append(j)
		indices.append(j+1)
		indices.append(j+2)

	
	print("Completed Vertices iteration")
	
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	print("The following is all of the array information that will be provided to the mesh generation\nArray Vertex: ",str(verts),"\nArray Texture uv: ",str(uvs),"\nArray Normals: ",str(normals),"\nArray Index: ", str(indices))
	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	var mMesh = MeshInstance3D.new()
	mMesh = array_mesh
	self.mesh = mMesh
