// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Simplified Bumped Specular shader. Differences from regular Bumped Specular one:
// - no Main Color nor Specular Color
// - specular lighting directions are approximated per vertex
// - writes zero to alpha channel
// - Normalmap uses Tiling/Offset of the Base texture
// - no Deferred Lighting support
// - no Lightmap support
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "Mobile/Emision Alpha Bumped Specular" {
Properties {
    [PowerSlider(5.0)] _Shininess ("Shininess", Range (0.03, 1)) = 0.078125
    _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_Illum("Illumin (A)", 2D) = "white" {}
	_EmisionMultiplier("Emision Multiplier",Range(0,2)) = 1
    [NoScaleOffset] _BumpMap ("Normalmap", 2D) = "bump" {}
}
SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 250

CGPROGRAM
#pragma surface surf MobileBlinnPhong exclude_path:prepass nolightmap noforwardadd halfasview interpolateview



inline fixed4 LightingMobileBlinnPhong (SurfaceOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
{
    fixed diff = max (0, dot (s.Normal, lightDir));
    fixed nh = max (0, dot (s.Normal, halfDir));
    fixed spec = pow (nh, s.Specular*128) * s.Gloss;
    fixed4 c;
    c.rgb = ((s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten)+s.Emission;	
    UNITY_OPAQUE_ALPHA(c.a);
    return c;
}

sampler2D _MainTex;
sampler2D _BumpMap;
sampler2D _Illum;
half _Shininess;
half _EmisionMultiplier;
struct Input {
    float2 uv_MainTex;
	float2 uv_Illum;
};

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 emision = tex2D(_Illum, IN.uv_Illum);
    o.Albedo = tex.rgb;
    o.Gloss = tex.a;
    o.Alpha = tex.a;
	o.Emission =emision.a*tex.rgb*_EmisionMultiplier ;
    o.Specular = _Shininess;
    o.Normal = UnpackNormal (tex2D(_BumpMap, IN.uv_MainTex));
}
ENDCG
}

FallBack "Mobile/VertexLit"
}
