:- module(funciones_juego, [createDeck/2, shuffleDeck/3]).
:- use_module('tda_card.pl').
:- use_module('funciones_complementarias.pl').



createDeck(Cartas, ["Baraja", Cartas]) :-
    length(Cartas, 60),                              
    verificar_limite_copias(Cartas, Cartas),         
    tiene_pokemon_basico(Cartas).


shuffleDeck(["Baraja", CartasIn], Semilla, ["Baraja", CartasOut]) :-
    mezclar_recursivo(CartasIn, Semilla, CartasOut).


initGame(["Baraja", CartasJ1], ["Baraja", CartasJ2], Semilla, ["Juego", Jugador1, Jugador2, TurnoInicial]) :-

    length(CartasJ1, 60),
    length(CartasJ2, 60),
    
    funciones_complementarias:preparar_jugador(CartasJ1, Semilla, Mano1, Premios1, Deck1, SemillaJ2),
    
    funciones_complementarias:preparar_jugador(CartasJ2, SemillaJ2, Mano2, Premios2, Deck2, CaraCruz),
    
    % Lanzamiento de la moneda (cara o cruz) para ver que jugador comienza (0 o 1)
    funciones_complementarias:randomPuro(CaraCruz, SemillaFinal),
    TurnoInicial is (SemillaFinal mod 2) + 1,  % 0 = jugador 1 por eso se le suma +1
                                               % 1 = jugador 2 
    
  % tda game
  %["Jugador", turno, pokemons activo, banca, mano, premios,mazo, pila descarte]
    Jugador1 = ["Jugador", 1, null, [], Mano1, Premios1, Deck1, []],
    Jugador2 = ["Jugador", 2, null, [], Mano2, Premios2, Deck2, []].



printGame(["Juego", J1, J2, Turno], StringFinal) :-

    funciones_complementarias:generar_string_jugador(J1, Turno, StrJ1),
    funciones_complementarias:generar_string_jugador(J2, Turno, StrJ2),
    
    format(string(StringFinal), 
    "------------------------~n>> TURNO DEL JUGADOR ~w <<~n~n~w~n~w-----------------------", [Turno, StrJ1, StrJ2]).