local M = {}

M.GAME_CONTROLLER = "/game_controller#script"
M.HOLE_SPAWNER = "/hole#spawner"

M.ADD_BALL = hash("add_ball")
M.BALL_LANDED = hash("ball_landed")
M.GAME_STATE_CHANGED = hash("game_state_changed")
M.REGISTER_SLOT = hash("register_slot")
M.RESET_GAME = hash("reset_game")
M.SPAWN_BALLS = hash("spawn_balls")
M.SUBSCRIBE_GAME_STATE = hash("subscribe_game_state")
M.TRY_SPAWN_BALLS = hash("try_spawn_balls")
M.UNSUBSCRIBE_GAME_STATE = hash("unsubscribe_game_state")

return M
