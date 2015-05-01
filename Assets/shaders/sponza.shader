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

			o.Specular = _Specular / 32.0;
			o.Gloss = 1.0;
			_SpecColor.rgb = tex2D(_SpecTex, IN.uv_SpecTex);
		}

		inline fixed4 LightingBlinnPhongSpec (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half3 h = normalize (lightDir + viewDir);
			
			fixed diff = max (0, dot (s.Normal, lightDir));
			
			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, s.Specular * 128.0f) * s.Gloss;
			
			fixed4 c;
			c.rgb = (_LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 2);
			c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
			return c;
		}

		inline fixed4 LightingNormal (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed4 c;
			c.rgb = s.Normal;
			c.a = s.Alpha;
			return c;
		}

		inline fixed4 LightingView (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed4 c;
			c.rgb = viewDir;
			c.a = s.Alpha;
			return c;
		}

		inline fixed4 LightingLight (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed4 c;
			c.rgb = lightDir;
			c.a = s.Alpha;
			return c;
		}

		inline fixed4 LightingAtten (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed4 c;
			c.rgb = fixed3(atten, atten, atten) / 2.f;
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
