#version 150 core

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;


vec4 createTexture( in vec2 p );

void main()
{
	theColor = createTexture(fragCoord/resolution.xy);
}


vec4 createTexture( in vec2 p )
{
    vec2 cc = vec2( -0.1, 0.68 );

	vec4 dmin = vec4(1000.0);
    float w = 0.0;
    vec2 z = 1.1*(-1.0 + 2.0*p)*vec2(resolution.x/resolution.y,1.0);
    for( int i=0; i<80; i++ )
    {
        z = cc + vec2( z.x*z.x - z.y*z.y, 2.0*z.x*z.y );

		dmin=min(dmin, vec4(length( z-0.5), 
							abs(-0.5+z.x + 0.2*sin(5.0*z.y)), 
							dot(z,z),
						    length( fract(z/8.0)-0.5) ) );
        if( dot(z,z)>4.0 ) w=1.0;
    }
   
    vec3 col = vec3(0.6,0.6,0.6);
    col * 0.4+0.6*w;
    col *= mix( vec3(1.0,0.45,0.1), vec3(1.0), w );
    col *= 0.65 + dmin.w;
    col = mix( col, 1.5*vec3(0.7,0.7,0.7),1.0-clamp(dmin.y*15.0,0.0,1.0) );
    col = mix( col, vec3(1.1,1.1,1.0),1.0-clamp(dmin.x*2.0,0.0,1.0) );
	col *= 0.5 + 0.5*clamp(dmin.z*50.0,0.0,1.0);


    return vec4( col, 1.0 );
}
