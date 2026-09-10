components {
  id: "spawner"
  component: "/scripts/hole.script"
}
components {
  id: "ball_factory"
  component: "/factories/ball.factory"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"ball_3\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/game.atlas\"\n"
  "}\n"
  ""
  position {
    x: -0.5
    y: 1.0
    z: 0.5
  }
}
