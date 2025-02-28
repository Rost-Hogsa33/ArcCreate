﻿Shader "Gameplay/ArcTap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "Queue" = "Transparent"  "RenderType"="Transparent" "CanUseSpriteAtlas"="true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing

			#include "UnityCG.cginc"
			#include "ColorSpace.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				uint instanceID : BLENDINDICES0;
			};

			struct Properties
			{
				float4 color;
				int selected;
			};

			sampler2D _MainTex;
            float4 _MainTex_ST;

			StructuredBuffer<Properties> _Properties;
			 
			half4 Selected(half4 c)
			{
				fixed3 hsv = rgb2hsv(c.rgb);
				hsv.r += 0.4f;
				return half4(hsv2rgb(hsv),c.a);
			}

			v2f vert (appdata v, uint instanceID : SV_InstanceID)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.instanceID = instanceID;
				return o;
			}
			
			half4 frag (v2f i) : SV_Target
			{
				Properties properties = _Properties[i.instanceID];
				half4 c = half4(tex2D(_MainTex,i.uv).rgb, 1);
				if(properties.selected == 1) 
				{
					c = Selected(c);
				}
				return c * properties.color;
			}
			ENDCG
		}
	}
}
