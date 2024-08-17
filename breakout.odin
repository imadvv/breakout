package breakout

import rl "vendor:raylib"


main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(1280, 1280, "Breakout")

	rl.SetTargetFPS(60)
	for !rl.WindowShouldClose() {

		rl.BeginDrawing()

		rl.ClearBackground({12, 1, 34, 255})
		rl.EndDrawing()
	}

	rl.CloseWindow()

}
