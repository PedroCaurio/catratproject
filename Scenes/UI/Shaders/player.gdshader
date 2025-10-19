shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform vec4 beam_color : source_color = vec4(0.3, 0.8, 1.0, 0.6);
uniform float thickness : hint_range(0.01, 0.5) = 0.15;       // largura do feixe 
uniform float edge_softness : hint_range(0.0, 0.2) = 0.04;    // suavidade da borda
uniform float pulse_strength : hint_range(0.0, 0.2) = 0.02;  // amplitude do pulso
uniform float pulse_speed : hint_range(0.0, 20.0) = 6.0;     // velocidade do pulso



void fragment() {
    float center = 0.5;
    float pulse = sin(TIME * pulse_speed) * pulse_strength;
    float r = thickness + pulse;

    float d = abs(UV.y - center);

    float t = smoothstep(r - edge_softness, r, d);
    float a = 1.0 - t;

    COLOR = vec4(beam_color.rgb, beam_color.a * a);
}
