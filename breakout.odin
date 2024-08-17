package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

SCREEN_SIZE :: 320
PADDLE_WIDTH :: 60
PADDLE_HEIGHT :: 8
PADDLE_POS_Y :: 280
PADDLE_SPEED :: 200
BALL_SPEED :: 260
BALL_RADIUS :: 5
BALL_START_Y :: 160
paddle_pos_x: f32
ball_pos: rl.Vector2
ball_dir: rl.Vector2

started: bool
restart :: proc() {
	paddle_pos_x = SCREEN_SIZE / 2 + PADDLE_WIDTH
	ball_pos = {SCREEN_SIZE / 2 + PADDLE_WIDTH + (PADDLE_WIDTH / 2), BALL_START_Y}
	started = false
}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(1280, 720, "Breakout")

	rl.SetTargetFPS(60)

	restart()
	for !rl.WindowShouldClose() {

		dt: f32

		if !started {
			ball_pos = {
				SCREEN_SIZE / 2 + f32(math.cos(rl.GetTime()) * SCREEN_SIZE / 1.5),
				BALL_START_Y,
			}
			if rl.IsKeyPressed(.SPACE) {
				paddle_middle := rl.Vector2{paddle_pos_x + PADDLE_WIDTH / 2, PADDLE_POS_Y}
				ball_to_paddle := paddle_middle - ball_pos

				ball_dir = linalg.normalize0(ball_to_paddle)
				started = true
			}
		} else {
			dt = rl.GetFrameTime()
		}
		ball_pos += ball_dir * BALL_SPEED * dt
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

		rl.DrawCircleV(ball_pos, BALL_RADIUS, {244, 122, 234, 255})
		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()

}
