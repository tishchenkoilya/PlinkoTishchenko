embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"rect\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/game.atlas\"\n"
  "}\n"
  ""
  position {
    z: 0.1
  }
  scale {
    y: 1.5
  }
}
embedded_components {
  id: "floor"
  type: "sprite"
  data: "default_animation: \"rect\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/game.atlas\"\n"
  "}\n"
  ""
  position {
    y: -24.0
    z: 1.0
  }
  scale {
    y: 0.1
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_STATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"slot\"\n"
  "mask: \"ball\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "      y: -24.0\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"floor\"\n"
  "  }\n"
  "  data: 16.0\n"
  "  data: 1.6\n"
  "  data: 10.0\n"
  "}\n"
  ""
}
