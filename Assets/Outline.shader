// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
/*o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
float2 offset = TransformViewToProjection(norm.xy);
o.pos.xy += offset  * _Outline;*/



Shader "Custom/Outline" {
	Properties {			
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
	
	}
	SubShader {
			Tags{ "Queue" = "Transparent" }
			// draw after all opaque geometry has been drawn
			Pass{			

					CGPROGRAM
					#include "UnityCG.cginc"
					#pragma vertex vert
					#pragma fragment frag

					sampler2D _MainTex;

					struct v2f {
						float4 pos : SV_POSITION;
						float2 uv : TEXCOORD0;
					};

					struct fout {
						half4 color : COLOR;
						float depth : DEPTH;
					};

					v2f vert(appdata_base v) {
						v2f o;
						o.pos = UnityObjectToClipPos(v.vertex);
						o.uv = v.texcoord;
						return o;
					}


					fout frag(v2f i)
					{
						fout o;
						o.color = tex2D(_MainTex, i.uv);
						o.depth = 0.1;
						return o;
					}


					ENDCG
			}

			Pass{
				Cull Front // first pass renders only back faces 
						   // (the "inside")
				ZWrite Off // don't write to depth buffer 
						   // in order not to occlude other objects
				Blend SrcAlpha OneMinusSrcAlpha // use alpha blending

				CGPROGRAM

				#include "UnityCG.cginc"
				#pragma vertex vert 
				#pragma fragment frag

				fixed4 _Color;

				sampler2D _ShadowTex;

				struct v2f {
					float4 pos : SV_POSITION;
					float4 color : COLOR;
					float2 uv : TEXCOORD0;
				};

				struct fout {
					half4 color : COLOR;
					float depth : DEPTH;
				};

				v2f vert(appdata_base v) {
					v2f o;
					o.uv = v.texcoord;
					o.pos = UnityObjectToClipPos(v.vertex);
					float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
					float3 offset = TransformViewToProjection(normal.xyz);

					o.pos = UnityObjectToClipPos(v.vertex*2);
					//o.pos.xyz += offset.xyz*0.1;
					o.color = _Color;
					return o;
				}		

				fout frag(v2f i)
				{
					fout o;					
					o.color = float4(i.color.r, i.color.g, i.color.b, i.color.a);
					o.depth = 0;
					return o;
				}
			
				ENDCG
			}		

	}
	FallBack "Diffuse"
}
/*
		Pass {
			Tags{"RenderType" = "Transparent" }
			LOD 200
					
			CGPROGRAM
				#include "UnityCG.cginc"
				#pragma vertex vert
				#pragma fragment frag
	
				fixed4 _Color;

				struct v2f {
					float4 pos : SV_POSITION;
					float4 color : COLOR;
				};

				struct fout {
					half4 color : COLOR;
					float depth : DEPTH;
				};

				v2f vert(appdata_base v) {
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					float3 normal = mul((float3x3)UNITY_MATRIX_T_MV, v.normal);
					float2 offset = TransformViewToProjection(normal.xy);
					o.pos.xy += offset*sin(_Time.z)*0.1;

					o.color = _Color;
					return o;
				}

				fout frag(v2f i)
				{
					fout o;
					o.color = i.color;
					o.depth = 0.1;
					return o;
				}

			ENDCG
		}

			Pass{
					Tags{ "RenderType" = "Transparent" }
					LOD 200

						CGPROGRAM
						#include "UnityCG.cginc"
						#pragma vertex vert
						#pragma fragment frag
						
						sampler2D _MainTex;

						struct v2f {
							float4 pos : SV_POSITION;
							float2 uv : TEXCOORD0;
						};

						struct fout {
							half4 color : COLOR;
							float depth : DEPTH;
						};

						v2f vert(appdata_base v) {
							v2f o;
							o.pos = UnityObjectToClipPos(v.vertex);
							o.uv = v.texcoord;
							return o;
						}


						fout frag(v2f i)
						{
							fout o;
							o.color = tex2D(_MainTex, i.uv);
							o.depth = 0.1;
							return o;
						}

						
					ENDCG
				}

		}
			FallBack "Diffuse"
}
*/
			//Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
			//LOD 200
			//			
			//CGPROGRAM
			//	// Physically based Standard lighting model, and enable shadows on all light types
			//	#pragma surface surf Standard fullforwardshadows alpha:fade vertex:vert

			//	// Use shader model 3.0 target, to get nicer looking lighting
			//	#pragma target 3.0

			//	sampler2D _MainTex;

			//	struct verInput {
			//		float4 normal : NORMAL;
			//		float4 vert : SV_POSITION;
			//	};

			//	struct Input {
			//		float2 uv_MainTex;
			//	};

			//	half _Glossiness;
			//	half _Metallic;
			//	fixed4 _Color;

			//	// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			//	// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			//	// #pragma instancing_options assumeuniformscaling
			//	UNITY_INSTANCING_CBUFFER_START(Props)
			//		// put more per-instance properties here
			//	UNITY_INSTANCING_CBUFFER_END

			//	void vert(inout appdata_full v) {

			//	}

			//	void surf(Input IN, inout SurfaceOutputStandard o) {
			//		fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			//		o.Albedo = c.rgb*_Color.rgb;
			//		o.Alpha = c.a;
			//	}
			//ENDCG

		//}
	