shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform float base_alpha : hint_range(0.1, 1.0) = 0.6; 
uniform vec4 beam_color : source_color = vec4(0.3, 0.8, 1.0, 1.0);
uniform float thickness : hint_range(0.1, 2.0) = 0.5;
uniform float edge_softness : hint_range(0.0, 0.2) = 0.04;
uniform float pulse_strength : hint_range(0.0, 0.5) = 0.2;
uniform float pulse_speed : hint_range(0.0, 20.0) = 6.0;

// NOVO: Define a opacidade mínima quando o feixe está "murcho".
// Evita que o alpha vá a zero, tornando o pulso mais suave.
uniform float min_alpha_factor : hint_range(0.0, 1.0) = 0.4; // Ex: 0.4 significa que o alpha mínimo será 40% do base_alpha

// O uniform CUSTOM_TIME é recomendado para controlar a pausa.
// Se você está usando o script, substitua TIME por CUSTOM_TIME:
// uniform float CUSTOM_TIME = 0.0; 

void fragment() {
    float center = 0.5;
    
    // 1. Calcula a onda senoidal do pulso (entre -1 e 1)
    // Usamos TIME, ou CUSTOM_TIME se estiver controlando por script.
    float pulse_wave = sin(TIME * pulse_speed);
    
    // 2. Efeito de pulso na largura
    // Continua sendo o mesmo:
    float pulse_effect = pulse_wave * pulse_strength;
    float r = thickness + pulse_effect;

    // 3. NOVO: Modulação da Opacidade (intensidade visual) com um mínimo
    // Transforma a onda de pulso de (-1, 1) para (0, 1)
    float normalized_pulse = pulse_wave * 0.5 + 0.5; 
    
    // Interpola entre min_alpha_factor e 1.0 com base no normalized_pulse
    // Quando normalized_pulse é 0, o fator é min_alpha_factor.
    // Quando normalized_pulse é 1, o fator é 1.0.
    float brightness_factor = mix(min_alpha_factor, 1.0, normalized_pulse);
    
    float modulated_alpha = base_alpha * brightness_factor; 

    // 4. Distância do centro da linha (UV.y = 0.5)
    float d = abs(UV.y - center);

    // 5. Suaviza a transição
    float t = smoothstep(r - edge_softness, r, d);
    
    // 6. Inverte a transição (a = 1.0 dentro, a = 0.0 fora)
    float a = 1.0 - t;
    
    // 7. Cor final: Aplica a opacidade modulada à cor, e a transição 'a' à opacidade final.
    COLOR = vec4(beam_color.rgb, a * modulated_alpha);
}