#version 150 core

#define AA 2

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;

vec3 shape( in vec2 uv )
{
	float time_new = time*0.05  + 47.0;
    
	vec2 z = -1.0 + 2.0*uv;
	z *= 1.5;
    
    vec3 col = vec3(1.0);
	for( int j=0; j<48; j++ )
	{
        float s = float(j)/16.0;
        float f = 0.2*(0.5 + 1.0*fract(sin(s*20.0)));

		vec2 c = 0.5*vec2( cos(f*time_new+17.0*s),sin(f*time_new+19.0*s) );
		z -= c;
		float zr = length( z );
	    float ar = atan( z.y, z.x ) + zr*0.6;
	    z  = vec2( cos(ar), sin(ar) )/zr;
		z += c;

        // color		
        col -= 0.5*exp( -10.0*dot(z,z) )* (0.25+0.4*sin( 5.5 + 1.5*s + vec3(1.6,0.8,0.5) ));
	}
        
    return col;
}

void main()
{
    float e = 1.0/resolution.x;

    vec3 tot = vec3(0.0);
    for( int m=0; m<AA; m++ )
    for( int n=0; n<AA; n++ )
    {        
        vec2 uv = (fragCoord+vec2(m,n)/float(AA))/resolution.xy;
	    vec3 col = shape( uv );
        float f = dot(col,vec3(0.333));
        vec3 nor = normalize( vec3( dot(shape(uv+vec2(e,0.0)),vec3(0.333))-f, 
                                    dot(shape(uv+vec2(0.0,e)),vec3(0.333))-f, 
                                    e ) );
        col += 0.2*vec3(1.0,0.9,0.5)*dot(nor,vec3(0.8,0.4,0.2));;
	    col += 0.3*nor.z;
        tot += col;
    }
    tot /= float(AA*AA);
	
    tot = pow( clamp(tot,0.0,1.0), vec3(0.8,1.1,1.3) );
	
    vec2 uv = fragCoord/resolution.xy;
    tot *= 0.4 + 0.6*pow( 16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y), 0.1 );

    theColor = vec4( tot, 1.0f );
}

//uniform vec2 resolution;
//uniform float time;
//vec2 fragCoord = gl_FragCoord.xy;
//out vec4 theColor;
//
//void main()
//{
//	vec2 uv = fragCoord / resolution.xy * 2.0f - 1.0f;
//
//	float siri = abs(sin(time - uv.y)) / length(uv.y) * 0.05f;
//
//	vec3 col = siri * mix(vec3(0.2f, 0.7f, 0.4f), vec3(0.1f, 0.4f, 0.9f), abs(uv.x));
//
//	theColor = vec4(col, 1.0f);
//}
