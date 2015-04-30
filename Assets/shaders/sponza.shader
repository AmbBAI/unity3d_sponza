Shader "Custom/sponza" {
	Properties {
		_MainTex ("Diff Tex", 2D) = "white" {}
		_BumpTex ("Bump Tex", 2D) = "bump" {}
		_SpecTex ("Spec Tex", 2D) = "black" {}
		_Specular ("Specular", Range(0., 50.)) = 10.
		_AlphaMaskTex ( "Alpha Mask", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		ZWrite on
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _SpecTex;
		fixed _Specular;
		sampler2D _AlphaMaskTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpTex;
			float2 uv_SpecTex;
			float2 uv_AlphaMaskTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));

			half4 alpha = tex2D (_AlphaMaskTex, IN.uv_AlphaMaskTex);
			if (alpha.b < 0.3) clip(-0.1);

			o.Specular = _Specular / 32.;
			_SpecColor.rgb = tex2D(_SpecTex, IN.uv_SpecTex);
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
