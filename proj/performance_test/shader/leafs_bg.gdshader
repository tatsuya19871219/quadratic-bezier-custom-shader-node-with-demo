shader_type canvas_item;

const int MAXIMUM_LEAFS = 256;
const float LCG_A = 127.0;
const float LCG_B = 3.0;
const float LCG_M = 1579327.0;

#include "leaf.gdshaderinc"

uniform vec2 canvas_size;
uniform int leafs_max;
uniform float leaf_size;

// Pseudo-random number generator
float lcg(inout float lcg_x) {
	lcg_x = mod(LCG_A * lcg_x + LCG_B, LCG_M);
	return lcg_x / LCG_M;
}

vec2 rotate(vec2 xy, float theta) {
	
	vec2 xy_rotated;
	float sin_th = sin(theta);
	float cos_th = cos(theta);
	
	xy_rotated.x = xy.x * cos_th - xy.y * sin_th;
	xy_rotated.y = xy.x * sin_th + xy.y * cos_th;
	
	return xy_rotated;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	float initial_x = PI;
	float lcg_x = initial_x;
	
	float T_leaf = 0.1; // leaf drawing cycle [sec]
	float T = T_leaf * float(leafs_max);
	
	float overall_progress = fract(TIME/T);
	float progress = fract(TIME/T_leaf);
	int leafs_progress = int(floor(overall_progress * float(leafs_max)));
	
	vec4 col = COLOR;
	vec2 XY = UV * canvas_size;
	float leaf_width = leaf_size;
	float leaf_height = leaf_width;
	
	for (int i = 0; i < max(leafs_max, MAXIMUM_LEAFS); i++) {
		
		vec2 leaf_pos = vec2(lcg(lcg_x), lcg(lcg_x));
		float leaf_rotation = lcg(lcg_x) * TAU;
		
		bool flip_leaf = lcg(lcg_x) > 0.5;
		
		vec2 leaf_origin = leaf_pos * canvas_size;
		vec2 leaf_XY = rotate(XY - leaf_origin, leaf_rotation);
		
		vec2 uv;
		
		if (leaf_XY.x >= -leaf_size/2.0 && leaf_XY.x <= leaf_size/2.0
				&& leaf_XY.y >= 0.0 && leaf_XY.y <= leaf_size) {
			uv = leaf_XY/vec2(leaf_size) + vec2(0.5, 0.0);
			if (!flip_leaf) {
				uv.y = 1.0 - uv.y;
			}
		}
		else {
			continue;
		}
		
		if (i > leafs_progress) {
			break;
		}
		else {
			vec4 leaf_col = draw_leaf(uv, (i == leafs_progress) ? progress : 1.0);
			col.rgb = leaf_col.a < 0.5 ? col.rgb : leaf_col.rgb;
		}
		
		
	}
	
	COLOR.rgb = col.a < 0.5 ? COLOR.rgb : col.rgb;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
