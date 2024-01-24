#include "res://shader/quad_bezier_solver.gdshaderinc"

const vec3 black = vec3(0.0, 0.0, 0.0);
const vec3 white = vec3(1.0, 1.0, 1.0);

bool is_in_range(float value, float t) {
	return (value >= 0.0) && (value <= min(1.0, t));
}

void get_next_branch_vector(float t, vec2 p0, vec2 p1, vec2 p2, out vec2 p_root, out vec2 unit_normal, out vec2 unit_tangent) {
	p_root = qbezier_curve(t, p0, p1, p2); 
	unit_normal = qbezier_curve_unit_normal(t, p0, p1, p2);
	unit_tangent = qbezier_curve_unit_tangent(t, p0, p1, p2);
}

float get_main_branch_length(float t) {
	return 12.0 * pow(t, 2.0) * pow(1.0 - t, 3.0);
}

vec4 draw_leaf(vec2 uv, float progress) {
	
	vec4 return_col = vec4(white, 0.0);
	
	vec3 base_color = vec3(0.1, 0.75, 0.1);
	
	float main_branch_interval = 0.05;
	float sub_branch_interval = 0.025;
	
	float main_branch_start = 0.2;
	float main_branch_end = 0.85;
	
	float sub_branch_start = 0.25;
	float sub_branch_end = 0.9;
	
	float hwidth = 0.02;
	float hwidth_ratio_main_branch = 0.33;
	float hwidth_ratio_sub_branch = 0.15;
	
	float location_max = main_branch_end + sub_branch_end + 1.0; 
	float t = progress * location_max;
	
	vec2 p_root = vec2(0.5, 1.0);
	vec2 p_terminal = vec2(0.5, 0.1);
	
	vec2 p_center = (p_root + p_terminal) / 2.0;
	
	p_terminal += vec2(0.25*sin(PI/2.0), 0.0);
	
	// root
	vec2 qb_coord = qbezier_get_principal_coord(uv, p_root, p_center, p_terminal);
		
	float location = qb_coord.x;
	float displacement = qb_coord.y;
	
	
	// main branch
	float main_branch_location = main_branch_start;
	for (; main_branch_location < main_branch_end; main_branch_location += main_branch_interval) {
		
		float length_main_branch = get_main_branch_length(main_branch_location) * length(p_terminal - p_root) / 2.0;
		
		vec2 p_main_branch_root;
		vec2 unit_normal_main_branch;
		vec2 unit_tangent_main_branch;
		
		get_next_branch_vector(main_branch_location, p_root, p_center, p_terminal, p_main_branch_root, unit_normal_main_branch, unit_tangent_main_branch); 
		
		vec2 p_terminal_main_branch_left = p_main_branch_root + length_main_branch * unit_normal_main_branch;
		
		vec2 p_center_main_branch_left = (p_main_branch_root + p_terminal_main_branch_left) / 2.0;
		
		p_terminal_main_branch_left += 0.1 * unit_tangent_main_branch;
		
		vec2 qb_coord_main_branch_left = qbezier_get_principal_coord(uv, p_main_branch_root, p_center_main_branch_left, p_terminal_main_branch_left);
		
		float location_main_branch_left = qb_coord_main_branch_left.x;
		float displacement_main_branch_left = qb_coord_main_branch_left.y;
		
		//float length_main_branch_left = qbezier_calc_curve_length(1.0, p_main_branch_root, p_center_main_branch_left, p_terminal_main_branch_left);
		
		if (is_in_range(location_main_branch_left, t - main_branch_location)) {
			float hw = hwidth * hwidth_ratio_main_branch * pow(1.0 - location_main_branch_left, 0.25);
			if (abs(displacement_main_branch_left) <= hw) {
				float a = (hw-abs(displacement_main_branch_left))/hw;
				return_col.rgb = a * base_color + (1.0 - a) * black;
				return_col.a = 1.0;
			}
		}
		
		// sub branch (left)
		float left_sub_branch_location = sub_branch_start;
		for (; left_sub_branch_location < sub_branch_end; left_sub_branch_location += sub_branch_interval / length_main_branch) {
			
			float length_sub_branch = main_branch_interval * 0.4;
			
			vec2 p_left_sub_branch_root;
			vec2 unit_normal_left_sub_branch;
			vec2 unit_tangent_left_sub_branch;
			
			get_next_branch_vector(left_sub_branch_location, p_main_branch_root, p_center_main_branch_left, p_terminal_main_branch_left, p_left_sub_branch_root, unit_normal_left_sub_branch, unit_tangent_left_sub_branch); 
		
			vec2 p_terminal_left_sub_branch_left = p_left_sub_branch_root + length_sub_branch * unit_normal_left_sub_branch;
			
			vec2 p_center_left_sub_branch_left = (p_left_sub_branch_root + p_terminal_left_sub_branch_left) / 2.0;
			
			p_terminal_left_sub_branch_left += 0.01 * unit_tangent_left_sub_branch;
			
			vec2 qb_coord_left_sub_branch_left = qbezier_get_principal_coord(uv, p_left_sub_branch_root, p_center_left_sub_branch_left, p_terminal_left_sub_branch_left);
			
			float location_left_sub_branch_left = qb_coord_left_sub_branch_left.x;
			float displacement_left_sub_branch_left = qb_coord_left_sub_branch_left.y;
			
			if (is_in_range(location_left_sub_branch_left, t - main_branch_location - left_sub_branch_location)) {
				float hw = hwidth * hwidth_ratio_sub_branch * pow(1.0 - location_left_sub_branch_left, 0.25);
				if (abs(displacement_left_sub_branch_left) <= hw) {
					float a = (hw-abs(displacement_left_sub_branch_left))/hw;
					return_col.rgb = a * base_color + (1.0 - a) * black;
					return_col.a = 1.0;
				}
			}
			
			vec2 p_terminal_left_sub_branch_right = p_left_sub_branch_root - length_sub_branch * unit_normal_left_sub_branch;
			
			vec2 p_center_left_sub_branch_right = (p_left_sub_branch_root + p_terminal_left_sub_branch_right) / 2.0;
			
			p_terminal_left_sub_branch_right += 0.01 * unit_tangent_left_sub_branch;
			
			vec2 qb_coord_left_sub_branch_right = qbezier_get_principal_coord(uv, p_left_sub_branch_root, p_center_left_sub_branch_right, p_terminal_left_sub_branch_right);
			
			float location_left_sub_branch_right = qb_coord_left_sub_branch_right.x;
			float displacement_left_sub_branch_right = qb_coord_left_sub_branch_right.y;
			
			if (is_in_range(location_left_sub_branch_right, t - main_branch_location - left_sub_branch_location)) {
				float hw = hwidth * hwidth_ratio_sub_branch * pow(1.0 - location_left_sub_branch_right, 0.25);
				if (abs(displacement_left_sub_branch_right) <= hw) {
					float a = (hw-abs(displacement_left_sub_branch_right))/hw;
					return_col.rgb = a * base_color + (1.0 - a) * black;
					return_col.a = 1.0;
				}
			}
		}
		
		vec2 p_terminal_main_branch_right = p_main_branch_root - length_main_branch * unit_normal_main_branch;
		
		vec2 p_center_main_branch_right = (p_main_branch_root + p_terminal_main_branch_right) / 2.0;
		
		p_terminal_main_branch_right += 0.1 * unit_tangent_main_branch;
		
		vec2 qb_coord_main_branch_right = qbezier_get_principal_coord(uv, p_main_branch_root, p_center_main_branch_right, p_terminal_main_branch_right);
		
		float location_main_branch_right = qb_coord_main_branch_right.x;
		float displacement_main_branch_right = qb_coord_main_branch_right.y;
		
		if (is_in_range(location_main_branch_right, t - main_branch_location)) {
			float hw = hwidth * hwidth_ratio_main_branch * pow(1.0 - location_main_branch_right, 0.25);
			if (abs(displacement_main_branch_right) <= hw) {
				float a = (hw-abs(displacement_main_branch_right))/hw;
				return_col.rgb = a * base_color + (1.0 - a) * black;
				return_col.a = 1.0;
			}
		}
		
		// sub branch (right)
		float right_sub_branch_location = sub_branch_start;
		for (; right_sub_branch_location < sub_branch_end; right_sub_branch_location += sub_branch_interval / length_main_branch) {
			
			float length_sub_branch = main_branch_interval * 0.4;
			
			vec2 p_right_sub_branch_root;
			vec2 unit_normal_right_sub_branch;
			vec2 unit_tangent_right_sub_branch;
			
			get_next_branch_vector(right_sub_branch_location, p_main_branch_root, p_center_main_branch_right, p_terminal_main_branch_right, p_right_sub_branch_root, unit_normal_right_sub_branch, unit_tangent_right_sub_branch); 
		
			vec2 p_terminal_right_sub_branch_left = p_right_sub_branch_root + length_sub_branch * unit_normal_right_sub_branch;
			
			vec2 p_center_right_sub_branch_left = (p_right_sub_branch_root + p_terminal_right_sub_branch_left) / 2.0;
			
			p_terminal_right_sub_branch_left += 0.01 * unit_tangent_right_sub_branch;
			
			vec2 qb_coord_right_sub_branch_left = qbezier_get_principal_coord(uv, p_right_sub_branch_root, p_center_right_sub_branch_left, p_terminal_right_sub_branch_left);
			
			float location_right_sub_branch_left = qb_coord_right_sub_branch_left.x;
			float displacement_right_sub_branch_left = qb_coord_right_sub_branch_left.y;
			
			if (is_in_range(location_right_sub_branch_left, t - main_branch_location - right_sub_branch_location)) {
				float hw = hwidth * hwidth_ratio_sub_branch * pow(1.0 - location_right_sub_branch_left, 0.25);
				if (abs(displacement_right_sub_branch_left) <= hw) {
					float a = (hw-abs(displacement_right_sub_branch_left))/hw;
					return_col.rgb = a * base_color + (1.0 - a) * black;
					return_col.a = 1.0;
				}
			}
			
			vec2 p_terminal_right_sub_branch_right = p_right_sub_branch_root - length_sub_branch * unit_normal_right_sub_branch;
			
			vec2 p_center_right_sub_branch_right = (p_right_sub_branch_root + p_terminal_right_sub_branch_right) / 2.0;
			
			p_terminal_right_sub_branch_right += 0.01 * unit_tangent_right_sub_branch;
			
			vec2 qb_coord_right_sub_branch_right = qbezier_get_principal_coord(uv, p_right_sub_branch_root, p_center_right_sub_branch_right, p_terminal_right_sub_branch_right);
			
			float location_right_sub_branch_right = qb_coord_right_sub_branch_right.x;
			float displacement_right_sub_branch_right = qb_coord_right_sub_branch_right.y;
			
			if (is_in_range(location_right_sub_branch_right, t - main_branch_location - right_sub_branch_location)) {
				float hw = hwidth * hwidth_ratio_sub_branch * pow(1.0 - location_right_sub_branch_right, 0.25);
				if (abs(displacement_right_sub_branch_right) <= hw) {
					float a = (hw-abs(displacement_right_sub_branch_right))/hw;
					return_col.rgb = a * base_color + (1.0 - a) * black;
					return_col.a = 1.0;
				}
			}
		}
		
	}
	
	// root
	if (is_in_range(location, t)) {
		float hw = hwidth * pow(1.0 - location, 0.25);
		if (abs(displacement) <= hw) {
			float a = (hw-abs(displacement))/hw;
			return_col.rgb = a * base_color + (1.0 - a) * black;
			return_col.a = 1.0;
		}
	}
	
	return return_col;
}