#version 150 core

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;

void main()
{
	vec2 uv = fragCoord / resolution.xy * 2.0f - 1.0f;

	float siri = abs(sin(time - uv.y)) / length(uv.y) * 0.05f;

	vec3 col = siri * mix(vec3(0.2f, 0.7f, 0.4f), vec3(0.1f, 0.4f, 0.9f), abs(uv.x));

	theColor = vec4(col, 1.0f);
}
