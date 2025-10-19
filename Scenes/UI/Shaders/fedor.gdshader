shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 vapor_color : source_color = vec4(0.4, 1.0, 0.3, 0.35);
uniform float wave_strength : hint_range(0.0, 0.2) = 0.05;
uniform float wave_speed : hint_range(0.0, 10.0) = 2.5;
uniform float wave_freq : hint_range(1.0, 20.0) = 8.0;
uniform float vertical_fade : hint_range(0.0, 1.0) = 0.8;

// === DISTORÇÃO DO FUNDO ===
uniform float distortion_strength : hint_range(0.0, 0.05) = 0.02;
uniform float distortion_speed : hint_range(0.0, 10.0) = 1.5;

// PARTÍCULAS ===
uniform float particle_density : hint_range(5.0, 100.0) = 30.0;
uniform float particle_speed : hint_range(0.0, 5.0) = 1.0;
uniform float particle_size : hint_range(0.0, 0.1) = 0.03;

// =============== SHADER ===============
void fragment() {
    vec2 uv = UV;
    
    float offset = sin(uv.y * wave_freq + TIME * wave_speed) * wave_strength;
    uv.x += offset;
    
    // --- DISTORÇÃO ---
    vec2 distort_uv = uv;
    distort_uv.x += sin(uv.y * 12.0 + TIME * distortion_speed) * distortion_strength;
    distort_uv.y += cos(uv.x * 6.0 + TIME * distortion_speed * 0.5) * distortion_strength;
    
    vec4 screen_col = textureLod(SCREEN_TEXTURE, distort_uv, 0.0);
    
    float fade = 1.0 - smoothstep(0.0, vertical_fade, uv.y);
    vec4 vapor = vec4(vapor_color.rgb, vapor_color.a * fade);
    COLOR = mix(screen_col, vapor, vapor.a);
    
    // --- PARTÍCULAS ---
   float noise = fract(sin(dot(uv * particle_density, vec2(12.9898,78.233))) * 43758.5453);
   float move = mod(uv.y + TIME * particle_speed, 1.0);
   if (noise < particle_size && move < 1.0) {
    COLOR.rgb += vec3(0.6, 1.0, 0.4) * 0.4;
    COLOR.a += 0.3;
  }
}
