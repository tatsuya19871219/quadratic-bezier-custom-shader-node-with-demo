shader_type canvas_item;

#include "leaf.gdshaderinc"

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	float T = 3.0; // Animation cycle [sec]
	float progress = fract(TIME/T);
	
	COLOR = draw_leaf(UV, progress);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
