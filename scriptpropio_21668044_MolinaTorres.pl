:- module(scriptpropio_21668044_MolinaTorres, [corre_prueba/0]).

%IMPORTACIONES 
:- use_module('tda_card_21668044_MolinaTorres.pl').
:- use_module('tda_attack_21668044_MolinaTorres.pl').
:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').
:- use_module('funciones_juego_21668044_MolinaTorres.pl').

set_prolog_flag(answer_write_options,[max_depth(0)]).

%PREDICADOS
sinEfecto(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoParalizar(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoGreatBall(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoHau(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoCynthia(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoPokemonFanClub(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoPotion(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoProfessorKukui(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoSwitch(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoPokemonCatcher(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.


% TODO UNIDO POR COMAS!!
corre_prueba :-


createEnergyCard("XY-Evoluciones", 100, "Agua", EnergiaAgua),
createEnergyCard("XY-Evoluciones", 101, "Incolora", EnergiaIncolora),

createAttack([[1, "Agua"]], "Pistola Agua", "Daño básico", 20, sinEfecto, A_PistolaAgua),
createAttack([[2, "Agua"]], "Burbuja", "Lanza moneda, si sale cara Paraliza", 30, efectoParalizar, A_Burbuja),
createAttack([[1, "Incolora"]], "Golpe", "Daño simple", 10, sinEfecto, A_Golpe),
createAttack([[3, "Agua"]], "Hidrobomba", "Daño fuerte", 80, sinEfecto, A_Hidrobomba),


createPokemonCard("XY-Evoluciones", 40, "Squirtle", null, 60, "Agua", "Planta", null, 1, false, null, [A_PistolaAgua], Squirtle),
createPokemonCard("XY-Evoluciones", 41, "Wartortle", "Squirtle", 80, "Agua", "Planta", null, 1, false, null, [A_Burbuja], Wartortle),
createPokemonCard("XY-Evoluciones", 42, "Blastoise", "Wartortle", 140, "Agua", "Planta", null, 2, false, null, [A_Hidrobomba], Blastoise),
createPokemonCard("XY-Evoluciones", 38, "Poliwag", null, 50, "Agua", "Planta", null, 1, false, null, [A_Golpe], Poliwag),
createPokemonCard("XY-Evoluciones", 28, "Magikarp", null, 30, "Agua", "Electrico", null, 1, false, null, [A_Golpe], Magikarp),
createPokemonCard("Sun & Moon", 40, "Popplio", null, 60, "Agua", "Planta", null, 1, false, null, [A_PistolaAgua], Popplio),
createPokemonCard("Sun & Moon", 25, "Psyduck", null, 60, "Agua", "Planta", null, 1, false, null, [A_PistolaAgua], Psyduck),
createPokemonCard("Team Up", 32, "Lapras", null, 110, "Agua", "Planta", null, 2, false, null, [A_PistolaAgua, A_Hidrobomba], Lapras),
createPokemonCard("Burning Shadows", 25, "Horsea", null, 50, "Agua", "Planta", null, 1, false, null, [A_Golpe], Horsea),
createPokemonCard("Ultra Prism", 30, "Spheal", null, 60, "Agua", "Planta", null, 2, false, null, [A_PistolaAgua], Spheal),
createPokemonCard("Lost Thunder", 50, "Totodile", null, 60, "Agua", "Planta", null, 1, false, null, [A_Golpe], Totodile),

createPokemonCard("XY-Evoluciones", 102, "Blastoise-EX", null, 180, "Agua", "Planta", null, 2, true, null, [A_Hidrobomba], BlastoiseEX),


createTrainerCard("Sun & Moon", 127, "Pocion", "objeto", "Cura 30 daño", efectoPotion, Potion),
createTrainerCard("Celestial Storm", 132, "Hau", "partidario", "Roba 3 cartas", efectoHau, Hau),
createTrainerCard("Sun & Moon", 147, "Cambio", "objeto", "Cambia activo", efectoSwitch, Switch),

createDeck([
    % Pokémon
    Squirtle, Squirtle, Squirtle, Squirtle,
    Wartortle, Wartortle, Wartortle, Wartortle,
    Blastoise, Blastoise, 
    BlastoiseEX, BlastoiseEX, Totodile, Totodile, Totodile,
    Horsea, Horsea, Horsea, Psyduck, Psyduck,

    
    Potion, Potion, Potion, Potion,
    Hau, Hau, Hau, Hau,
    Switch, Switch, Switch, Switch,
    
    EnergiaAgua, EnergiaAgua, EnergiaAgua, EnergiaAgua, EnergiaAgua, 
    EnergiaAgua, EnergiaAgua, EnergiaAgua, EnergiaAgua, EnergiaAgua, 
    EnergiaAgua, EnergiaAgua, EnergiaAgua, EnergiaAgua, 
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, 
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, 
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora,
    EnergiaIncolora, EnergiaIncolora
], Deck1),

%juego
shuffleDeck(Deck1, 7777, Deck1Barajado),

%mismas cartas pero diferente semilla en el deck2
shuffleDeck(Deck1, 8888, Deck2Barajado),

initGame(
    Deck1Barajado,
    Deck2Barajado,
    11111,
    JuegoInicial
),
printGame(JuegoInicial, StrJ1),
write(StrJ1),
playToBench(JuegoInicial, Psyduck, J2),

usePokemonAttack(J2, Psyduck, "Pistola Agua", [], J3),
printGame(J3, StrJ3),
write(StrJ3),
playToBench(J3, Squirtle, J4),
changeActivePokemon( J4, Squirtle, J5),
printGame(J5, StrJ5),
write(StrJ5),
usePokemonAttack(J5, Squirtle, "Pistola Agua", [A_PistolaAgua], J6), %NO TIENE OBJETIVO VALIDO POR LO TANTO SE PASA TURNO
printGame(J6, StrJ6),
write(StrJ6),
changeActivePokemon(J6, Psyduck, J7),
gameGetActivePokemon(J7, Activo),
useEnergyCard( J7, Activo, EnergiaRayo, J8),
usePokemonAttack(J8, Psyduck, "Pistola Agua", [A_PistolaAgua], J9),

printGame(J9, StrFinal),
write(StrFinal).

