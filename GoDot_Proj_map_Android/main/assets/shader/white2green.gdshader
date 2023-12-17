shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // 获取当前像素的颜色
    vec4 current_color = texture(TEXTURE, UV);

    // 判断像素颜色是否接近白色（可以根据需要调整阈值）
    float threshold = 1.0; // 调整接近白色的阈值
    bool is_near_white = (current_color.r >= threshold &&
                          current_color.g >= threshold &&
                          current_color.b >= threshold);

    // 如果像素接近白色，则将其转换为绿色
    if (is_near_white) {
        current_color = vec4(0.0, 1.0, 0.0, current_color.a); // 将白色像素转换为绿色，保留透明度
    }

    // 输出最终颜色
    COLOR = current_color;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
