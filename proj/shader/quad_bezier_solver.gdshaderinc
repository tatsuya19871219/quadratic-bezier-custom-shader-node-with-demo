//////////////////////////////////////////////////////////////////////////////////////
// Shader include file for Quadratic Bezier Curve Coordinate Converter				//
//																					//
// MIT License																		//
//																					//
// Copyright (c) 2024 Tatsuya Yamada												//
//																					//
// Permission is hereby granted, free of charge, to any person obtaining a copy		//
// of this software and associated documentation files (the "Software"), to deal	//
// in the Software without restriction, including without limitation the rights		//
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell		//
// copies of the Software, and to permit persons to whom the Software is			//
// furnished to do so, subject to the following conditions:							//
//																					//
// The above copyright notice and this permission notice shall be included in all	//
// copies or substantial portions of the Software.									//
//																					//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR		//
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,			//
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE		//
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER			//
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,	//
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE	//
// SOFTWARE.																		//
//////////////////////////////////////////////////////////////////////////////////////

// Ref: https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html#flow-control
const float QBEZIER_SOLVER_EPSILON = 0.0001;

vec2 qbezier_curve(float t, vec2 p0, vec2 p1, vec2 p2) {
	return p1 + (1.0-t)*(1.0-t)*(p0 - p1) + t*t*(p2-p1);
}

vec2 qbezier_curve_tangent(float t, vec2 p0, vec2 p1, vec2 p2) {
	return -2.0*(1.0-t)*(p0 - p1) + 2.0*t*(p2 - p1); 
}

vec2 qbezier_curve_unit_tangent(float t, vec2 p0, vec2 p1, vec2 p2) {
	vec2 q = qbezier_curve_tangent(t, p0, p1, p2);
	return q / length(q);
}

vec2 qbezier_curve_unit_normal(float t, vec2 p0, vec2 p1, vec2 p2) {
	vec2 q = qbezier_curve_unit_tangent(t, p0, p1, p2);
	return vec2(q.y, -q.x);
}

float qbezier_calc_displacement(vec2 uv, float t, vec2 p0, vec2 p1, vec2 p2) {
	return dot(uv - qbezier_curve(t, p0, p1, p2), 
				qbezier_curve_unit_normal(t, p0, p1, p2));
}

float qbezier_calc_curve_length_integral(float t, float A, float B, float C) {
	float K = 2.0*A*t + B;
	float L = t*(A*t+B) + C;
	float M = pow(B, 2.0) - 4.0*A*C;
	
	float I = K*sqrt(L)/A;
	float J = 0.5 * (M*log(2.0*sqrt(A)*sqrt(L)+K))/pow(A, 1.5);
	
	return I - J;
}

float qbezier_calc_curve_length(float t, vec2 p0, vec2 p1, vec2 p2) {
	
	float a = pow(length(p2-p1), 2.0);
	float b = pow(length(p0-p1), 2.0);
	float c = dot(p2-p1, p0-p1);
	
	float A = a + b + 2.0*c;
	float B = -2.0*(b + c);
	float C = b;
	
	if (abs(A) <= QBEZIER_SOLVER_EPSILON) {
		
		if (abs(B) <= QBEZIER_SOLVER_EPSILON) {
			// \int_0^t C dt
			return sqrt(C) * t;
		}
		
		// \int_0^t {Bt + C} dt
		float It = 2.0 * pow(sqrt(B*t + C), 3.0) / (3.0 * B);
		float I0 = 2.0 * pow(sqrt(C), 3.0) / (3.0 * B);
		
		return It - I0;
	}
	
	// \int_0^t {At^2 + Bt + C} dt
	return qbezier_calc_curve_length_integral(t, A, B, C) 
			- qbezier_calc_curve_length_integral(0.0, A, B, C);
}

float qbezier_calc_curt(float x) { // cubic root
	return pow(x, 1.0/3.0);
}

// Returns possible coordinates in ascending order (t_arr[0] < t_arr[1] < t_arr[2])
void qbezier_get_possible_location_parameters(vec2 uv, vec2 p0, vec2 p1, vec2 p2, out float disc, out float[3] t_arr, out int real_solutions) {

	float a = pow(length(p2-p1), 2.0);
	float b = pow(length(p0-p1), 2.0);
	float c = dot(p2-p1, p0-p1);
	float d = dot(uv-p1, p0-p1);
	float e = dot(uv-p1, p2-p1);
	
	float A = a + b + 2.0*c;
	float B = -3.0*(b + c);
	float C = 3.0*b + c - d - e;
	float D = - b + d;
	
	
	if (abs(A) <= QBEZIER_SOLVER_EPSILON) {
		
		if (abs(B) <= QBEZIER_SOLVER_EPSILON) {
			// Ct + D = 0
			disc = 0.0;
			t_arr[0] = -D/C;
			
			//if (abs(C) <= QBEZIER_SOLVER_EPSILON) {
				//t_arr[0] = 0.0; // or undefined
			//}
			//else {
				//t_arr[0] = -D/C;
			//}
			
			real_solutions = 1;
			return;
		}
		else {
			// Bt^2 + Ct + D = 0
			disc = pow(C,2.0) - 4.0*B*D;
			
			if (abs(disc) <= QBEZIER_SOLVER_EPSILON) {
				// one real solution
				t_arr[0] = -C/(2.0*B);
				
				real_solutions = 1;
				return;
			}
			
			if (disc > 0.0) {
				if (B > 0.0) {
					t_arr[0] = (-C - sqrt(disc))/(2.0*B);
					t_arr[1] = (-C + sqrt(disc))/(2.0*B);
				}
				else {
					t_arr[0] = (-C + sqrt(disc))/(2.0*B);
					t_arr[1] = (-C - sqrt(disc))/(2.0*B);
				}
				
				real_solutions = 2;
				return;
			}
			else {
				// non real solution
				real_solutions = 0;
				return;
			}
		}
	}
	
	// At^3 + Bt^2 + Ct + D
	float Ba = B / A;
	float Ca = C / A;
	float Da = D / A;
	
	// x^3 + px + q = 0, t = x - Ba/3
	float p = (-pow(Ba, 2.0) + 3.0*Ca) / 3.0;
	float q = (2.0*pow(Ba, 3.0) - 9.0*Ba*Ca + 27.0*Da) / 27.0;
	
	disc = -1.0*( 4.0 * pow(p, 3.0) + 27.0 * pow(q, 2.0) );
	
	if (abs(p) < QBEZIER_SOLVER_EPSILON) {
		// one real solution
			
		if (abs(q) < QBEZIER_SOLVER_EPSILON) {
			t_arr[0] = - Ba/3.0;
		}
		else if (q > 0.0) {
			t_arr[0] = -qbezier_calc_curt(q) - Ba/3.0;
		}
		else {
			t_arr[0] = qbezier_calc_curt(-q) - Ba/3.0;
		}
		
		real_solutions = 1;
		return;
	}
	
	if (disc <= 0.0) { 
		// one real solution
		
		if (p > 0.0) {
			
			float th;
			
			//th = 1.0/3.0 * asinh(3.0*q/(2.0*p)*sqrt(3.0/p));
			
			float y = 3.0*q/(2.0*p)*sqrt(3.0/p);
			float ash = sign(y) * acosh(sqrt(1.0 + pow(y,2.0))); 
			th = 1.0/3.0 * ash;
			
			float x = -2.0 * sqrt(p/3.0) * sinh(th);
			t_arr[0] = x - Ba/3.0;
		}
		else { 
			float th = 1.0/3.0 * acosh(-3.0*abs(q)/(2.0*p)*sqrt(-3.0/p));
			float x = -2.0 * abs(q)/q*sqrt(-p/3.0) * cosh(th);
			t_arr[0] = x - Ba/3.0;
		}
		
		real_solutions = 1;
		return;
	}
	else { 
		// three real solutions
		
		float w = 3.0*q/(2.0*p)*sqrt(3.0/-p);
		
		float th = 1.0/3.0*acos(w);
		float th_0 = th;
		float th_1 = th - TAU/3.0;
		float th_2 = th - 2.0*TAU/3.0;
		
		float cos_0 = cos(th_0);
		float cos_1 = cos(th_1);
		float cos_2 = cos(th_2);
		
		float f = -Ba/3.0;
		float g = 2.0*sqrt(-p/3.0);
		
		if (cos_0 <= min(cos_1, cos_2)) {
			t_arr[0] = f + g*cos_0;
			if (cos_1 <= cos_2) {
				t_arr[1] = f + g*cos_1;
				t_arr[2] = f + g*cos_2;
			}
			else {
				t_arr[1] = f + g*cos_2;
				t_arr[2] = f + g*cos_1;
			}
		}
		
		if (cos_1 <= min(cos_0, cos_2)) {
			t_arr[0] = f + g*cos_1;
			if (cos_0 <= cos_2) {
				t_arr[1] = f + g*cos_0;
				t_arr[2] = f + g*cos_2;
			}
			else {
				t_arr[1] = f + g*cos_2;
				t_arr[2] = f + g*cos_0;
			}
		}
		
		if (cos_2 <= min(cos_0, cos_1)) {
			t_arr[0] = f + g*cos_2;
			if (cos_0 <= cos_1) {
				t_arr[1] = f + g*cos_0;
				t_arr[2] = f + g*cos_1;
			}
			else {
				t_arr[1] = f + g*cos_1;
				t_arr[2] = f + g*cos_0;
			}
		}
		
		//t_0 = -Ba/3.0 + 2.0*sqrt(-p/3.0)*cos(th_0);
		//t_1 = -Ba/3.0 + 2.0*sqrt(-p/3.0)*cos(th_1);
		//t_2 = -Ba/3.0 + 2.0*sqrt(-p/3.0)*cos(th_2);
		
		real_solutions = 3;
		return;
	}
}

vec2 qbezier_get_coord(vec2 uv, vec2 p_init, vec2 p_control, vec2 p_last, 
						out vec2 raw_coord0, out vec2 raw_coord1, out vec2 raw_coord2,
						out int real_solutions) {
	
	float disc;
	float t_arr[3];
	
	qbezier_get_possible_location_parameters(uv, p_init, p_control, p_last, disc, t_arr, real_solutions);
	
	float displacement_arr[3];
	float minimum_distance = -1.0;
	int minimum_distance_index = -1;
	
	for (int i = 0; i < real_solutions; i++) {
		displacement_arr[i] = qbezier_calc_displacement(uv, t_arr[i], p_init, p_control, p_last);

		float distance_i = abs(displacement_arr[i]);
		
		if (distance_i <= minimum_distance || minimum_distance < 0.0) {
			if(abs(distance_i - minimum_distance) > QBEZIER_SOLVER_EPSILON) {
				minimum_distance = distance_i;
				minimum_distance_index = i;
			}
		}
	}
	
	raw_coord0 = vec2(t_arr[0], displacement_arr[0]);
	raw_coord1 = vec2(t_arr[1], displacement_arr[1]);
	raw_coord2 = vec2(t_arr[2], displacement_arr[2]);
	
	float location = t_arr[minimum_distance_index];
	float displacement = displacement_arr[minimum_distance_index];
	
	return vec2(location, displacement);
}

vec2 qbezier_get_principal_coord(vec2 uv, vec2 p_init, vec2 p_control, vec2 p_last) {
	
	vec2 raw_coord0;
	vec2 raw_coord1;
	vec2 raw_coord2;
	int real_solutions;
	
	return qbezier_get_coord(uv, p_init, p_control, p_last, 
							raw_coord0, raw_coord1, raw_coord2, real_solutions);
	
}
