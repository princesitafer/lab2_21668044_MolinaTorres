:- module(funciones_juego_21668044_MolinaTorres, [createDeck/2, shuffleDeck/3, initGame/4, 
printGame/2, playToBench/3, changeActivePokemon/3, drawCardFromDeck/3, evolvePokemon/4, useTrainerCard/4, usePokemonAbility/4, usePokemonAttack/5]).

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


%%%% BANCA

% jugador 1
playToBench(["Juego", J1, J2, 1], CartaPoke, ["Juego", J1nuevo, J2, 1]) :-
    agregar_banca(J1, CartaPoke, J1nuevo).

% jugador 2
playToBench(["Juego", J1, J2, 2], CartaPoke, ["Juego", J1, J2nuevo, 2]) :-
    agregar_banca(J2, CartaPoke, J2nuevo).


%pasar pokemon de banca a activo
%turno jugador1
changeActivePokemon(["Juego", J1, J2, 1], CartaBanca, ["Juego", J1nuevo, J2, 1]) :-
    cambia_poke_activo(J1, CartaBanca, J1nuevo).

% jugador 2
changeActivePokemon(["Juego", J1, J2, 2], CartaBanca, ["Juego", J1, J2nuevo, 2]) :-
    cambia_poke_activo(J2, CartaBanca, J2nuevo).


drawCardFromDeck(["Juego", J1, J2, Turno], CartaRobada, JuegoFinal) :-
    (
        ( Turno == 1,
          J1 = ["Jugador", 1, _, _, _, _, Mazo1, _], % mazo 
          ( 
            ( Mazo1 == [], CartaRobada = null, JuegoFinal = ["JuegoTerminado", "Jugador 2 gana porque jugador 1 no tiene + cartas"] )
            ; 
            ( Mazo1 \== [], 
              sacar_carta_baraja(J1, CartaRobada, J1Nuevo), 
              JuegoFinal = ["Juego", J1Nuevo, J2, 1] )
          )
        )
        ; % or
        ( Turno == 2,
          J2 = ["Jugador", 2, _, _, _, _, Mazo2, _], %mazo player 2
          ( 
            ( Mazo2 == [], CartaRobada = null, JuegoFinal = ["JuegoTerminado", "Jugador 1 gana porque jugador 2 no tiene + cartas "] )
            ; 
            ( Mazo2 \== [], 
              sacar_carta_baraja(J2, CartaRobada, J2Nuevo), 
              JuegoFinal = ["Juego", J1, J2Nuevo, 2] )
          )
        )
    ).



useEnergyCard(["Juego", J1, J2, 1], CartaPoke, CartaEnergia, ["Juego", J1Nuevo, J2, 1]) :-
    aplica_energia(J1, CartaPoke, CartaEnergia, J1Nuevo).

% caso de que sea el jugador 2
useEnergyCard(["Juego", J1, J2, 2], CartaPoke, CartaEnergia, ["Juego", J1, J2Nuevo, 2]) :-
    aplica_energia(J2, CartaPoke, CartaEnergia, J2Nuevo).



evolvePokemon(["Juego", J1, J2, 1], Cartaenjuego, CartaEvol, ["Juego", J1Nuevo, J2, 1]) :-
    evolucionar(J1, Cartaenjuego, CartaEvolucion, J1Nuevo).

% caso de que sea el jugador 2
evolvePokemon(["Juego", J1, J2, 2], CartaEnJuego, CartaEvol, ["Juego", J1, J2Nuevo, 2]) :-
    evolucionar(J2, Cartaenjuego, CartaEvol, J2Nuevo).



   useTrainerCard(["Juego", J1, J2, Turno], CartaTrainer, _Args, Juegofinal) :-
    
    getTrainerTexto(CartaTrainer, Texto),

    (
        ( Turno == 1,
          entrenador(J1, CartaTrainer, J1Nuevo),
          Juegoactual = ["Juego", J1Nuevo, J2, Turno]
        )
        ;
        ( Turno == 2,
          entrenador(J2, CartaTrainer, J2Nuevo),
          Juegoactual = ["Juego", J1, J2Nuevo, Turno]
        )
    ),
    
     %aqui se aplica el efecto de la carta
    (
        %si no tiene efecto
        ( Texto == null, 
          Juegofinal = Juegoactual
        )
        ;
        % arreglar alta aplicar funciones
        ( Texto \== null,
          Juegofinal = Juegoactual
        )
   ).


usePokemonAbility(["Juego", J1, J2, Turno], CartaPoke, _Args, Juegofinal) :-
    
    getPokemonHabilidad(CartaPoke, Habilidad),
    Juegoactual = ["Juego", J1, J2, Turno],

    (
 %caso de no tener habilidad
        ( Habilidad == null, 
          Juegofinal = Juegoactual
        )
        ;
        %arreglar
        % falta implementar las habilidades
        % esperare al script propio o el script de prueba para hacerlo
        ( Habilidad \== null,
          Juegofinal = Juegoactual
        )
    ).

usePokemonAttack(["Juego", J1, J2, Turno], Cartapoke, Nombreataque, Args, Juegofinal) :-
   (
    % caso en que el ataque no sea valido
    % solo se cmabia el turno
    ( Nombreataque == null,
          (
            ( Turno == 1, 
              Turnonuevo = 2, 
              Juegofinal = ["Juego", J1, J2, Turnonuevo]
            )
            ;
            ( Turno == 2, 
              Turnonuevo = 1, 
              JuegoFinal = ["Juego", J1, J2, Turnonuevo]
            )
          )
        )).