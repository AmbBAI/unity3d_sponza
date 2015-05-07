Shader "Custom/sponza_alpha 1" {
	Properties {
		_MainTex ("Diff Tex", 2D) = "white" {}
		_BumpTex ("Bump Tex", 2D) = "bump" {}
		_SpecTex ("Spec Tex", 2D) = "black" {}
		_Specular ("Specular", Range(0., 50.)) = 10.
		_AlphaMaskTex ( "Alpha Mask", 2D) = "white" {}
		_Cutoff ("Cutoff", Range(0., .9)) = .5
	}
	SubShader {
		Cull Off
		LOD 200

		Tags { "Queue" = "AlphaTest" }
		ZWrite on
		ZTest Less

		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _SpecTex;
		fixed _Specular;
		sampler2D _AlphaMaskTex;
		fixed _Cutoff;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float2 uv_SpecTex;
			float2 uv_AlphaMaskTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
			half4 alpha = tex2D (_AlphaMaskTex, IN.uv_AlphaMaskTex);
			o.Alpha = alpha.b;
			clip(o.Alpha - _Cutoff);
			o.Specular = _Specular / 32.0;
			o.Gloss = 1.0;
			_SpecColor.rgb = tex2D(_SpecTex, IN.uv_SpecTex);
		}
		
		ENDCG

		Tags { "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite off
		ZTest Less

		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _SpecTex;
		fixed _Specular;
		sampler2D _AlphaMaskTex;
		fixed _Cutoff;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float2 uv_SpecTex;
			float2 uv_AlphaMaskTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
			half4 alpha = tex2D (_AlphaMaskTex, IN.uv_AlphaMaskTex);
			o.Alpha = alpha.b;
			clip(_Cutoff - o.Alpha);
			o.Specular = _Specular / 32.0;
			o.Gloss = 1.0;
			_SpecColor.rgb = tex2D(_SpecTex, IN.uv_SpecTex);
		}
		
		ENDCG

	} 
	FallBack "Diffuse"
}
