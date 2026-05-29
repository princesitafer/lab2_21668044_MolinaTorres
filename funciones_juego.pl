:- module(funciones_juego, [createDeck/2, shuffleDeck/3]).
:- use_module('tda_card.pl').
:- use_module('funciones_complementarias.pl').



createDeck(Cartas, ["Baraja", Cartas]) :-
    length(Cartas, 60),                              
    verificar_limite_copias(Cartas, Cartas),         
    tiene_pokemon_basico(Cartas).


shuffleDeck(["Baraja", CartasIn], Semilla, ["Baraja", CartasOut]) :-
    mezclar_recursivo(CartasIn, Semilla, CartasOut).