shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// --- CONTROLE DO SHAKE (será atualizado via GDScript) ---
uniform float shake_strength : hint_range(0.0, 0.05) = 0.0; // 0.0 = sem shake, > 0.0 = com shake

// Função para gerar um valor de ruído (quase randômico) com base no UV e no tempo
// Ajuda a dar um "salto" diferente a cada frame.
float rand(vec2 co, float t) {
    // Adicionar 't' faz com que o ruído mude a cada frame
    return fract(sin(dot(co.xy + t, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;
    
    // Se não houver força, apenas desenhe a tela normalmente
    if (shake_strength <= 0.0) {
        COLOR = texture(SCREEN_TEXTURE, uv);
        return;
    }
    
    // --- CÁLCULO DO SHAKE ---
    // 1. Gera um offset 'randômico' para X e Y
    // rand() retorna entre 0 e 1, então (rand() * 2.0 - 1.0) retorna entre -1 e 1
    float shake_x = (rand(uv, TIME) * 2.0 - 1.0) * shake_strength;
    float shake_y = (rand(uv, TIME + 1.0) * 2.0 - 1.0) * shake_strength; // TIME + 1.0 para gerar um ruído diferente para Y
    
    // 2. Aplica o offset
    uv.x += shake_x;
    uv.y += shake_y;
    
    // 3. Lê a tela com as coordenadas deslocadas
    vec4 screen_col = texture(SCREEN_TEXTURE, uv);
    
    COLOR = screen_col;
}