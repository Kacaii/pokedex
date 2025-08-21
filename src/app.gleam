import gleam/option
import lustre

import lustre/attribute as attr
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn main() -> Nil {
  let app = lustre.application(init:, update: todo, view:)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

pub type Pokemon {
  Pokemon(name: String, sprite_url: String)
}

pub type Model {
  Model(current_pokemon: option.Option(Pokemon), pokemon_list: List(Pokemon))
}

// UPDATE ----------------------------------------------------------------------

pub type Msg {
  UserTypedPokemon(String)
  UserSearchedPokemon
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  todo
}

pub fn init(_args) -> #(Model, Effect(Msg)) {
  let kanto_starters: List(Pokemon) = [
    Pokemon(
      name: "Bulbasaur",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
    ),
    Pokemon(
      name: "Charmander",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png",
    ),
    Pokemon(
      name: "Squirtle",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png",
    ),
  ]

  let model = Model(current_pokemon: option.None, pokemon_list: kanto_starters)
  #(model, effect.none())
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  html.div([], [])
}
