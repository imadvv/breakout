package breakout

import "core:fmt"
import rl "vendor:raylib"

SCREEN_SIZE :: 360
PADDLE_WIDTH :: 60
PADDLE_HEIGHT :: 8
PADDLE_POS_Y :: 280
PADDLE_SPEED :: 200
paddle_pos_x: f32

restart :: proc() {
	paddle_pos_x = SCREEN_SIZE / 2 + PADDLE_WIDTH
}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(1080, 720, "Breakout")

	rl.SetTargetFPS(60)

	restart()
	for !rl.WindowShouldClose() {

		dt := rl.GetFrameTime()
		paddle_move_velocity: f32

		if rl.IsKeyDown(.LEFT) {
			paddle_move_velocity -= PADDLE_SPEED
		}

		if rl.IsKeyDown(.RIGHT) {
			paddle_move_velocity += PADDLE_SPEED
		}

		paddle_pos_x += paddle_move_velocity * dt
		paddle_pos_x = clamp(
			paddle_pos_x,
			0,
			SCREEN_SIZE - PADDLE_WIDTH + (PADDLE_WIDTH * 4) - (PADDLE_WIDTH / 2),
		)
		rl.BeginDrawing()

		rl.ClearBackground({12, 1, 34, 255})

		Camera := rl.Camera2D {
			zoom = f32(rl.GetScreenHeight() / SCREEN_SIZE),
			// zoom = 2.5,
		}
		rl.BeginMode2D(Camera)

		paddle_rect := rl.Rectangle{paddle_pos_x, PADDLE_POS_Y, PADDLE_WIDTH, PADDLE_HEIGHT}

		rl.DrawRectangleRec(paddle_rect, {255, 33, 122, 255})

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()

}
