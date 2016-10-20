#version 330

#pragma include "lights.glsl"
#pragma include "material.glsl"

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 normalMatrix;

in vec4 position;
in vec3 normal;
in vec2 texcoord;

uniform sampler2DRect tex0;
uniform sampler2DRect tex1;
uniform float maxHeight;

out vec4 eyeSpaceVertexPos, ambientGlobal;
out vec3 vertex_normal;
out vec3 interp_eyePos;
out vec2 varyingtexcoord;

void main(void) {
    

    //Displacement:
    vec4 bumpColor = texture(tex1, texcoord);
    float df = 0.30 * bumpColor.r + 0.59 * bumpColor.g + 0.11 * bumpColor.b;
    vertex_normal = normalize((normalMatrix * vec4(normal, 0.0)).xyz);
    vec4 newVertexPos = vec4(normal * df * float(maxHeight), 0.0) + position;

    //Phong:
    //vertex_normal = normalize((normalMatrix * vec4(normal, 0.0)).xyz);
    ambientGlobal = material.emission;
    eyeSpaceVertexPos = modelViewMatrix * newVertexPos;
    interp_eyePos = vec3(-eyeSpaceVertexPos);
    
    varyingtexcoord = vec2(texcoord.x, texcoord.y);
    gl_Position = modelViewProjectionMatrix * newVertexPos;
}