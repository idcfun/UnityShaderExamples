Shader "IDnc/DepthOutline"
{
	Properties{
		_MainTex("MainTex",2D) = "white"{}
		_RimColor("RimColor",Color)=(1,0,0,1)
		_Color("Color",Color)=(1,1,1,1)
	}
		SubShader{
			Tags{"Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector"="true"}
			Pass{
				Blend SrcAlpha OneMinusSrcAlpha
				ZWrite Off
				Cull Off
				CGPROGRAM
				#include "UnityCG.cginc"
				#pragma vertex vert
				#pragma fragment frag

				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _CameraDepthTexture;
				float4 _Color;
				float4 _RimColor;
				
				struct a2v {
					float4 vertex:POSITION;
					float2 uv:TEXCOORD0;
					float3 normal:NORMAL;
				};
			
				struct v2f {
					float2 uv:TEXCOORD0;
					float4 pos:SV_POSITION;
					float4 screenPos:TEXCOORD1;
					float3 worldNormal:TEXCOORD2;
					float3 worldViewDir:TEXCOORD3;
				};

				v2f vert(a2v v) {
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					//ComputeScreenPos函数，得到归一化前的视口坐标xy
					//z分量为裁剪空间的z值，范围[-Near,Far]
					o.screenPos = ComputeScreenPos(o.pos);
					o.uv = TRANSFORM_TEX(v.uv,_MainTex);
					//COMPUTE_EYEDEPTH函数，将z分量范围[-Near,Far]转换为[Near,Far]
					COMPUTE_EYEDEPTH(o.screenPos.z);
					o.worldNormal = UnityObjectToWorldNormal(v.normal);
					o.worldViewDir = WorldSpaceViewDir(v.vertex).xyz;
					return o;
				}

				float4 frag(v2f i):SV_Target {
					float3 mainTex = tex2D(_MainTex,i.uv).xyz;
					//获取深度纹理,通过LinearEyeDepth函数将采样的深度纹理值转换为对应的深度范围[Near~Far]
					float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture,UNITY_PROJ_COORD(i.screenPos)));
					
					//观察空间深度差,值越小颜色值越大
					float distance = 1 - saturate(sceneZ - i.screenPos.z);
					//消除内部深度变化较大时产生的锯齿
					if (distance>0.999999)
					{
						distance = 0;
					}

					if(distance > 0.0)
					{
						return _RimColor;
					}

					return float4(mainTex, _Color.w);
				}

				ENDCG
		}
	}
}