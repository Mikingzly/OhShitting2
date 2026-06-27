shader_type canvas_item;

uniform sampler2D ScreenTexture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform vec4 GlassColor : source_color;
uniform float Fogginess : hint_range(0.0, 10.0, 0.1) = 2.0;

group_uniforms TextureOverlay;
uniform bool TextureOverlay = false;
uniform sampler2D TextureOverlayTexture : hint_default_white, repeat_enable;
uniform float TextureMoveSpeed : hint_range(1.0, 200.0, 1.0) = 75;
uniform float TextureModulationStregnth : hint_range(0.0, 1.0, 0.1) = .1;

group_uniforms CelShading;
uniform bool CelShading = false;
uniform float CelShadingStregnth : hint_range(1.0, 20.0, 0.1) = 10;


void fragment() {
	COLOR = textureLod(ScreenTexture, SCREEN_UV, Fogginess);
	if (TextureOverlay == true) {
		COLOR.rgb = clamp(COLOR.rgb + GlassColor.rgb + (texture(TextureOverlayTexture, UV + sin(TIME / TextureMoveSpeed)).rgb * TextureModulationStregnth) , 0, 1);
	} else {
		COLOR.rgb = clamp(COLOR.rgb + GlassColor.rgb, 0, 1);
	}
	if (CelShading == true) {
		COLOR.rgb = round(COLOR.rgb * CelShadingStregnth) / CelShadingStregnth;
	}
	COLOR.a = GlassColor.a;
}
