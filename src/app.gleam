import gleam/io
import gleam/list
import lustre

import lustre/attribute as attr
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn main() -> Nil {
  let app = lustre.application(init:, update:, view:)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

pub type Pokemon {
  Pokemon(name: String, sprite_url: String)
}

pub type Model {
  Model(current_pokemon: String, pokemon_list: List(Pokemon))
}

// UPDATE ----------------------------------------------------------------------

pub type Msg {
  UserTypedPokemon(String)
  UserAddedPokemon
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserTypedPokemon(text) -> #(
      Model(..model, current_pokemon: text),
      effect.none(),
    )
    UserAddedPokemon -> {
      io.println("Tried to add a pokemon:" <> model.current_pokemon)
      #(model, effect.none())
    }
  }
}

pub fn init(_args) -> #(Model, Effect(Msg)) {
  let kanto_starters: List(Pokemon) = [
    Pokemon(
      name: "Bulbasaur",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
    ),
    Pokemon(
      name: "Charmander",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png",
    ),
    Pokemon(
      name: "Squirtle",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png",
    ),
    Pokemon(
      name: "Pikachu",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
    ),
  ]

  let model = Model(current_pokemon: "", pokemon_list: kanto_starters)
  #(model, effect.none())
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  html.div([attr.class("max-w-lg  mx-auto")], [
    html.h1([attr.class("text-center font-bold")], [html.text("Pokedex WIP")]),
    view_new_pokemon(model.current_pokemon),
    view_pokemon_list(model.pokemon_list),
  ])
}

fn view_new_pokemon(new_pokemon: String) -> Element(Msg) {
  html.div([attr.class("text-center py-2")], [
    html.input([
      attr.class("border border-gray-500 rounded-md " <> "p-1"),
      attr.placeholder("Enter Pokemon name"),
      attr.value(new_pokemon),
      event.on_input(UserTypedPokemon),
    ]),
    html.button([event.on_click(UserAddedPokemon)], [html.text("Add")]),
  ])
}

fn view_pokemon_list(pokemon_list: List(Pokemon)) -> Element(Msg) {
  html.div(
    [
      attr.class(
        "grid grid-cols-6 grid-rows-5 gap-2 "
        <> "border-2 border-emerald-500 rounded-md "
        <> "p-2",
      ),
    ],
    list.map(pokemon_list, view_pokemon_card),
  )
}

fn view_pokemon_card(pokemon: Pokemon) -> Element(Msg) {
  html.div([], [
    html.img([
      attr.class("w-full bg-emerald-200 "),
      attr.src(pokemon.sprite_url),
      attr.alt(pokemon.name),
    ]),
  ])
}
