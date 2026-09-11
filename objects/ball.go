components {
  id: "script"
  component: "/scripts/ball.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"ball_1\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/game.atlas\"\n"
  "}\n"
  ""
  position {
    y: -2.0
    z: 1.0
  }
  scale {
    x: 0.7
    y: 0.7
    z: 0.7
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 1.0\n"
  "friction: 0.0\n"
  "restitution: 0.0\n"
  "group: \"ball\"\n"
  "mask: \"peg\"\n"
  "mask: \"wall\"\n"
  "mask: \"slot\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_SPHERE\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 1\n"
  "  }\n"
  "  data: 8.5\n"
  "}\n"
  "linear_damping: 0.9\n"
  "locked_rotation: true\n"
  ""
}
