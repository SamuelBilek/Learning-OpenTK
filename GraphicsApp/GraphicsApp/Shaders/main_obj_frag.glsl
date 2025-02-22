﻿#version 330
struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;

    float shininess;
};
  
uniform Material material;

struct Light {
    vec3 position;
  
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;

    float constant;
    float linear;
    float quadratic;
};

uniform Light light;

out vec4 FragColor;

in vec2 TexCoord;

in vec3 Normal;

in vec3 FragPos;

uniform sampler2D texture1;
uniform sampler2D texture2;

uniform vec3 viewPos;

void main()
{
    vec3 lightDir = normalize(light.position - FragPos);
    float distance = length(lightDir);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));
    
    // ambient
    vec3 ambient = light.ambient * material.ambient * attenuation;
  	
    // diffuse 
    vec3 norm = normalize(Normal);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * (diff * material.diffuse) * attenuation;
    
    // specular
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);  
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = light.specular * (spec * material.specular) * attenuation;  
        
    vec3 result = ambient + diffuse + specular;
    FragColor = vec4(result, 1.0);
}