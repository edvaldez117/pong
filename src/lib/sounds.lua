local Sounds = {
    paddleHit = love.audio.newSource("src/sounds/paddle_hit.wav", "static"),
    wallHit = love.audio.newSource("src/sounds/wall_hit.wav", "static"),
    score = love.audio.newSource("src/sounds/score.wav", "static")
}

return Sounds