shader_type spatial;
render_mode cull_disabled, unshaded, blend_mix;

uniform sampler2D texture_albedo : source_color;
uniform float sway_strength : hint_range(0.0, 2.0) = 0.3;
uniform float sway_speed : hint_range(0.0, 10.0) = 2.0;
uniform vec2 wind_direction = vec2(1.0, 0.5);
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.4;

void vertex() {
    float height_factor = VERTEX.y;
    float sway = sin(TIME * sway_speed + VERTEX.x * 3.0 + VERTEX.z * 3.0) * sway_strength;
    VERTEX.x += wind_direction.x * sway * height_factor;
    VERTEX.z += wind_direction.y * sway * height_factor;
}

void fragment() {
    vec4 albedo_tex = texture(texture_albedo, UV);
    ALBEDO = albedo_tex.rgb;
    ALPHA = albedo_tex.a;
    if (ALPHA < alpha_cutoff) discard;
}
