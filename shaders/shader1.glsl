uniform float iTime;
uniform vec2 iResolution;
out vec4 fragColor;

void main() {
    vec2 sp = gl_FragCoord.xy / iResolution;
    float time = 2 * iTime;
    vec3 color = cos(time + sp.xyx + vec3(1, 1, 1));
    fragColor = vec4(color, 1);
}