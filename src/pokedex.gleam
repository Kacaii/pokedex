import gleam/io
import gleam/list
import gleam/string
import pokemon.{type Pokemon, Pokemon}

import lustre
import lustre/attribute as attr
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

import rsvp

pub fn main() -> Nil {
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
      name: "Squirrel",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png",
    ),
    Pokemon(
      name: "Pikachu",
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
    ),
  ]

  let app = lustre.application(init:, update:, view:)
  let assert Ok(_) = lustre.start(app, onto: "#app", with: kanto_starters)

  Nil
}

// MODEL -----------------------------------------------------------------------

pub type Model {
  Model(current_pokemon: String, pokemon_list: List(Pokemon))
}

// UPDATE ----------------------------------------------------------------------

pub type Msg {
  UserTypedPokemon(String)
  UserAddedPokemon
  ApiReturnedPokemons(Result(Pokemon, rsvp.Error))
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserTypedPokemon(text) -> #(
      Model(..model, current_pokemon: text),
      effect.none(),
    )

    UserAddedPokemon -> #(model, get_pokemon_from_api(model.current_pokemon))

    ApiReturnedPokemons(Ok(pokemon)) -> #(
      Model(..model, pokemon_list: [pokemon, ..model.pokemon_list]),
      effect.none(),
    )

    ApiReturnedPokemons(Error(err)) -> {
      io.println_error(string.inspect(err))
      #(model, effect.none())
    }
  }
}

fn get_pokemon_from_api(pokemon_name: String) -> Effect(Msg) {
  let decoder = pokemon.pokemon_decoder()
  let url = "https://pokeapi.co/api/v2/pokemon/" <> pokemon_name

  let handler = rsvp.expect_json(decoder, ApiReturnedPokemons)
  rsvp.get(url, handler)
}

pub fn init(with pokemons: List(Pokemon)) -> #(Model, Effect(Msg)) {
  let model = Model(current_pokemon: "", pokemon_list: pokemons)
  #(model, effect.none())
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  html.div([attr.class("max-w-md  mx-auto my-5")], [
    view_pokemon_list(model.pokemon_list),
    view_new_pokemon(model.current_pokemon),
  ])
}

fn view_new_pokemon(new_pokemon: String) -> Element(Msg) {
  html.div([attr.class("join py-2  w-full")], [
    html.input([
      attr.class("input join-item"),
      attr.placeholder("Enter a Pokemon name:"),
      attr.value(new_pokemon),
      event.on_input(UserTypedPokemon),
    ]),
    html.button(
      [
        event.on_click(UserAddedPokemon),
        attr.class("btn join-item"),
      ],
      [html.text("Add")],
    ),
  ])
}

fn view_pokemon_list(pokemon_list: List(Pokemon)) -> Element(Msg) {
  html.div(
    [
      attr.class(
        "grid grid-cols-6 grid-rows-5 gap-2 "
        <> "border-1 border-gray-300 rounded-sm p-2",
      ),
    ],
    list.map(pokemon_list, view_pokemon_card),
  )
}

fn view_pokemon_card(pokemon: Pokemon) -> Element(Msg) {
  html.div(
    [attr.class("tooltip tooltip-bottom"), attr.data("tip", pokemon.name)],
    [
      html.img([
        attr.class(
          "w-full hover:drop-shadow-md hover:scale-105 "
          <> "transform transition-transform duration-200",
        ),
        attr.src(pokemon.sprite_url),
        attr.alt(pokemon.name),
      ]),
    ],
  )
}
