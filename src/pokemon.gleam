import gleam/dynamic/decode

pub type Pokemon {
  Pokemon(name: String, sprite_url: String)
}

pub fn pokemon_decoder() -> decode.Decoder(Pokemon) {
  use name <- decode.field("name", decode.string)
  use sprite_url <- decode.subfield(["sprites", "front_default"], decode.string)
  decode.success(Pokemon(name:, sprite_url:))
}
