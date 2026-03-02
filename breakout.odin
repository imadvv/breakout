package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"


APP_NAME :: "Braekout"
SCREEN_X :: 1080
SCREEN_Y :: 720

PADDLE_WIDTH :: 200
PADDLE_HEIGHT :: 20
PADDLE_POS_Y :: SCREEN_Y * 0.95
PADDLE_SPEED :: 200
paddle_pos_x: f32

BALL_SPEED :: 260
BALL_RADIUS :: 15
BALL_START_Y :: PADDLE_POS_Y - PADDLE_HEIGHT
ball_pos: rl.Vector2
ball_dir: rl.Vector2

started: bool
score: u32


restart :: proc() {
	paddle_pos_x = (SCREEN_X * 0.5) - (PADDLE_WIDTH * 0.5)
	ball_pos = {(SCREEN_X * 0.5), BALL_START_Y}
	started = false
}

main :: proc() {
	fmt.println("========================")
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(SCREEN_X, SCREEN_Y, "Breakout")

	rl.SetWindowState(rl.ConfigFlags{.WINDOW_RESIZABLE})
	rl.SetTargetFPS(30)

	restart()
	for !rl.WindowShouldClose() {

		dt: f32

		// TODO: uodate game state
		///////////////////////////////////////////////////////
		// UPDATE GAME
		if rl.IsKeyDown(.SPACE) {
			started = true
		}

		// if started {
		// 	ball_pos = {SCREEN_X / 2 + f32(math.cos(rl.GetTime()) * SCREEN_X / 1.5), BALL_START_Y}
		// 	if rl.IsKeyPressed(.SPACE) {
		// 		paddle_middle := rl.Vector2{paddle_pos_x + PADDLE_WIDTH / 2, PADDLE_POS_Y}
		// 		ball_to_paddle := paddle_middle - ball_pos
		//
		// 		ball_dir = linalg.normalize0(ball_to_paddle)
		// 		started = true
		// 	}
		// } else {
		// 	dt = rl.GetFrameTime()
		// }
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
			SCREEN_X - PADDLE_WIDTH + (PADDLE_WIDTH * 4) - (PADDLE_WIDTH / 2),
		)

		// ////////////////////////////////////////////////
		// DRAW GAME
		rl.BeginDrawing()

		rl.ClearBackground({12, 1, 34, 255})

		rl.DrawText(rl.TextFormat("score: %d", score), 50, 50, 30, rl.WHITE)

		// Camera := rl.Camera2D {
		// 	zoom = f32(rl.GetScreenHeight() / SCREEN_SIZE),
		// 	// zoom = 2.5,
		// }
		// rl.BeginMode2D(Camera)

		paddle_rect := rl.Rectangle{paddle_pos_x, PADDLE_POS_Y, PADDLE_WIDTH, PADDLE_HEIGHT}

		rl.DrawRectangleRec(paddle_rect, {255, 3, 122, 255})

		rl.DrawCircleV(ball_pos, BALL_RADIUS, {244, 122, 234, 255})
		// rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()

}
