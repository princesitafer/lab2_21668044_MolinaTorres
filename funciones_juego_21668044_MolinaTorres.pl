:- module(funciones_juego_21668044_MolinaTorres, [createDeck/2, shuffleDeck/3, initGame/4, printGame/2]).

:- use_module('tda_card_21668044_MolinaTorres.pl').
:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').



createDeck(Cartas, ["Baraja", Cartas]) :-
    length(Cartas, 60),                              
    verificar_limite_copias(Cartas, Cartas),         
    tiene_pokemon_basico(Cartas).


shuffleDeck(["Baraja", CartasIn], Semilla, ["Baraja", CartasOut]) :-
    mezclar_recursivo(CartasIn, Semilla, CartasOut).


initGame(["Baraja", CartasJ1], ["Baraja", CartasJ2], Semilla, ["Juego", Jugador1, Jugador2, TurnoInicial]) :-

    length(CartasJ1, 60),
    length(CartasJ2, 60),
    
    preparar_jugador(CartasJ1, Semilla, Mano1, Premios1, Deck1, SemillaJ2),
    
    preparar_jugador(CartasJ2, SemillaJ2, Mano2, Premios2, Deck2, CaraCruz),
    
    % Lanzamiento de la moneda (cara o cruz) para ver que jugador comienza (0 o 1)
    randomPuro(CaraCruz, SemillaFinal),
    TurnoInicial is (SemillaFinal mod 2) + 1,  % 0 = jugador 1 por eso se le suma +1
                                               % 1 = jugador 2 
    
  % tda game
  %["Jugador", turno, pokemons activo, banca, mano, premios,mazo, pila descarte]
    Jugador1 = ["Jugador", 1, null, [], Mano1, Premios1, Deck1, []],
    Jugador2 = ["Jugador", 2, null, [], Mano2, Premios2, Deck2, []].



printGame(["Juego", J1, J2, Turno], StringFinal) :-

    texto_player(J1, Turno, StrJ1),
    texto_player(J2, Turno, StrJ2),
    
    format(string(StringFinal), 
    "------------------------~n>> TURNO DEL JUGADOR ~w <<~n~n~w~n~w-----------------------", [Turno, StrJ1, StrJ2]).