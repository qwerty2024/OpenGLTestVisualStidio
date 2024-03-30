#version 150 core

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;

void main()
{
	vec2 uv = fragCoord / resolution.xy;

	vec3 col = 0.5f + 0.5f * cos(time + uv.xyx + vec3(0, 2, 4));

	theColor = vec4(col, 1.0f);
}
