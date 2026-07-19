:- module(funciones_juego_21668044_MolinaTorres, [createDeck/2, shuffleDeck/3, initGame/4, 
printGame/2, playToBench/3, changeActivePokemon/3, drawCardFromDeck/3, evolvePokemon/4, useTrainerCard/4, useEnergyCard/4,
usePokemonAbility/4, usePokemonAttack/5, gameGetActivePokemon/2, getCartaBanca/3, imprimirResultado/1, getCartaMano/3]).

%IMPORTACIONES
:- use_module('tda_card_21668044_MolinaTorres.pl').
:- use_module('tda_attack_21668044_MolinaTorres.pl').
:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').


%createDeck/2 
%Crea y valida una baraja considerando reglas del pokemon tcg (energias, pokemon basico...)
createDeck(Cartas, ["Baraja", Cartas]) :-
    length(Cartas, 60),                              
    verificar_limite_copias(Cartas, Cartas),         
    tiene_pokemon_basico(Cartas).

%shuffleDeck/3
%Revuelve en caso de que la baraja no sea valida
shuffleDeck(["Baraja", CartasIn], Semilla, ["Baraja", CartasOut]) :-
    mezclar_recursivo(CartasIn, Semilla, CartasOut).


%initGame/4
%Inicia el estado del juego (primero turno), prepara manos, premios y lanza moneda para ver quien comienza
initGame(["Baraja", CartasJ1], ["Baraja", CartasJ2], Semilla, ["Juego", Jugador1, Jugador2, TurnoInicial, false]) :-

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


%printGame/2
% imprime cartas, numero de cartas, caracteristicas, dependiendo del turno del jugador y todo en un string.
% En caso de haber terminado el juego, imprime el turno final donde un jugador no le queden premios o pokemon en banca y activo.
printGame(["Juego", J1, J2, Turno, _EnergiaUsada], StringFinal) :-

    texto_player(J1, Turno, StrJ1),
    texto_player(J2, Turno, StrJ2),
    
    format(string(StringFinal), 
    "------------------------~n>> TURNO DEL JUGADOR ~w <<~n~n~w~n~w-----------------------", [Turno, StrJ1, StrJ2]).

%mensaje de victoria (juego ya terminado)
printGame(["JuegoTerminado", Mensaje], StringFinal) :-
    format(string(StringFinal), "--------------------~n~w~n----------------------", [Mensaje]).


% Imprime tablero completo desde el turno del ganador
printGame(["JuegoTerminado", Mensaje, JuegoDelGanador], StringFinal) :-
    printGame(JuegoDelGanador, StringTurnoGanador),
    format(string(StringFinal), "----------------------~n~w~n----------------------~n~w",
    [Mensaje, StringTurnoGanador]).


%imprimirResultado/1 
%Estado final del juego
% recorrido: representación en string mediante predicado printGame
% salida: imprime en consola el TDA (juego en curso o mensaje de termino) si todo sale bien retorna TRUE
imprimirResultado(Juego) :-
    printGame(Juego, StringResultado),
    write(StringResultado), nl.



%gameGetActivePokemon/2
%extrae al pokemon activo del turno
% filtra por Turno (1 o 2)y valida que no sea nulo el pokemon activo
% salida: pokemon activo si existe o sino falla el predicado
% necesaria para el script de prueba dada por el profe
gameGetActivePokemon(["Juego", J1, _, 1, _], Activo) :-
    J1 = ["Jugador", 1, Activo, _, _, _, _, _],
    Activo \== null.
gameGetActivePokemon(["Juego", _, J2, 2, _], Activo) :-
    J2 = ["Jugador", 2, Activo, _, _, _, _, _],
    Activo \== null.

% getCartaBanca/3
% busca carta especifica de la banca del jugador de turno actual
getCartaBanca(["Juego", J1, J2, Turno, _], Nombre, CartaBanca) :-
    ( Turno == 1
    -> J1 = ["Jugador", 1, _, Banca, _, _, _, _]
    ;  J2 = ["Jugador", 2, _, Banca, _, _, _, _]
    ),
    member(CartaBanca, Banca),
    getCardName(CartaBanca, Nombre).


%getCartaMano/3 
%busca carta especifica de la mano del jugador del turno actual
getCartaMano(["Juego", J1, J2, Turno, _], Nombre, CartaMano) :-
    ( Turno == 1
    -> J1 = ["Jugador", 1, _, _, Mano, _, _, _]
    ;  J2 = ["Jugador", 2, _, _, Mano, _, _, _]
    ),
    member(CartaMano, Mano),
    getCardName(CartaMano, Nombre).

%%%% -------- BANCA---------


%playToBench/3 
% pokemon de la mano pasa a la banca
%Recorrido: identifica al jugador que tiene el turno, se usa el predicado 'agregar_banca' y se entrega nuevo estado del tdagame
% salida: estado nuevo de juego
% jugador 1
playToBench(["Juego", J1, J2, 1, EU], CartaPoke, ["Juego", J1nuevo, J2, 1, EU]) :-
    agregar_banca(J1, CartaPoke, J1nuevo).

% jugador 2
playToBench(["Juego", J1, J2, 2, EU], CartaPoke, ["Juego", J1, J2nuevo, 2, EU]) :-
    agregar_banca(J2, CartaPoke, J2nuevo).



%changeActivePokemon/3 
%Se retira el pokemon de activo, pasa a
%CARTA NULA
changeActivePokemon(Juego, null, Juego) :- !.
%J1
changeActivePokemon(["Juego", J1, J2, 1, EU], CartaBanca, ["Juego", J1N, J2, 1, EU]) :-
    cambia_poke_activo(J1, CartaBanca, J1N).

% J2
changeActivePokemon(["Juego", J1, J2, 2, EU], CartaBanca, ["Juego", J1, J2N, 2, EU]) :-
    cambia_poke_activo(J2, CartaBanca, J2N).

%evita bugs en caso de que falle algo (para que no retorne falso y pare la ejecucion del codigo)
changeActivePokemon(Juego, _, Juego) :-
    write('no se puede cambiar el pokemon activo'), nl, fail.


%drawCardFromDeck/3
%verifica el turno actual, si el mazo esta vacio pasa a juego terminado
% si el mazo tiene cartas se utiliza el predicado sacar_carta_baraja y actualiza estado del juego con menos cartas en mazo
drawCardFromDeck(["Juego", J1, J2, Turno, EU], CartaRobada, JuegoFinal) :-
    (
        ( Turno == 1,
          J1 = ["Jugador", 1, _, _, _, _, Mazo1, _], % mazo 
          ( 
            ( Mazo1 == [], CartaRobada = null, JuegoFinal = ["JuegoTerminado", "Jugador 2 gana porque jugador 1 no tiene + cartas"] )
            ; 
            ( Mazo1 \== [], 
              sacar_carta_baraja(J1, CartaRobada, J1Nuevo), 
              JuegoFinal = ["Juego", J1Nuevo, J2, 1, EU] )
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
              JuegoFinal = ["Juego", J1, J2Nuevo, 2, EU] )
          )
        )
    ).

%useEnergyCard/4
% Verifica y se hace uso de la carta tipo energia
%, se verifica que sea del tipo,
% se verifica que no se haya ocupado el predicado antes en la funcion (1 uso por turno)
% el tda game entregado tiene true en la energia usada
% caso 1: se puede usar energia (ener no usada)
useEnergyCard(["Juego", J1, J2, Turno, false], CartaPoke, CartaEnergia, JuegoFinal) :-
    (Turno == 1 ->
        aplica_energia(J1, CartaPoke, CartaEnergia, J1Nuevo),
        JuegoFinal = ["Juego", J1Nuevo, J2, Turno, true]
    ; Turno == 2 ->
        aplica_energia(J2, CartaPoke, CartaEnergia, J2Nuevo),
        JuegoFinal = ["Juego", J1, J2Nuevo, Turno, true]
    ).

%caso 2, ya se uso energia, se hace lo siguiente para que el programa siga y no falle
useEnergyCard(["Juego", J1, J2, Turno, true], _, _, ["Juego", J1, J2, Turno, true]) :-
    write('Error: Ya se uso una carta de energia este turno.'), nl.


%getPokemonBanca/3
% obtener pokemon de la banca buscandolo por su nombre (solo se busca en lista banca)
getPokemonBanca(["Juego", J1, _, Turno, _], Nombre, Carta) :-
    (Turno == 1 -> J1 = ["Jugador", _, _, Banca, _, _, _, _] ; ...),
    member(Carta, Banca),
    getCardName(Carta, Nombre).


% evolvePokemon/4
% identifica al jugador en turno, verifica si es posible evolucionar con predicados anteriores 
% y actualiza el estado
% salida nuevo estado de juego con el pokemon evolucionado
%jugador 1
evolvePokemon(["Juego", J1, J2, 1, EU], CartaEnJuego, CartaEvol, ["Juego", J1Nuevo, J2, 1, EU]) :-
    evolucionar(J1, CartaEnJuego, CartaEvol, J1Nuevo).

% caso de que sea el jugador 2
evolvePokemon(["Juego", J1, J2, 2, EU], CartaEnJuego, CartaEvol, ["Juego", J1, J2Nuevo, 2, EU]) :-
    evolucionar(J2, CartaEnJuego, CartaEvol, J2Nuevo).



%useTrainerCard/4
% Recorrido: 
% Ejecuta cartas de tipo trainer, objeto o partidarios, solamente estan aplicadas hau, profesoroak y pocion
% salida: tda juego tras aplicar el efecto de la carta o fail si no es valido
useTrainerCard(["Juego", J1, J2, Turno, EU], CartaTrainer, Args, Juegofinal) :-
    getTrainerTexto(CartaTrainer, Texto),
    getTrainerPredicado(CartaTrainer, Predicado),

    (
        ( Turno == 1,
          entrenador(J1, CartaTrainer, J1Nuevo),
          Juegoactual = ["Juego", J1Nuevo, J2, Turno, EU]
        )
        ;
        ( Turno == 2,
          entrenador(J2, CartaTrainer, J2Nuevo),
          Juegoactual = ["Juego", J1, J2Nuevo, Turno, EU]
        )
    ),

    (
        ( Texto == null,
          Juegofinal = Juegoactual
        )
        ;
        ( Texto \== null,
          Juegoactual = ["Juego", J1Actual, J2Actual, Turno, EU],
          (

            %CODIGO DE LA POCION +30 DANO ACUMULADO
              ( Predicado == efectoPotion,
                Args = [NombrePokemon],
                (
                    ( Turno == 1,
                      aplica_pocion(J1Actual, NombrePokemon, 30, J1Final),
                      Juegofinal = ["Juego", J1Final, J2Actual, Turno, EU]
                    )
                    ;
                    ( Turno == 2,
                      aplica_pocion(J2Actual, NombrePokemon, 30, J2Final),
                      Juegofinal = ["Juego", J1Actual, J2Final, Turno, EU]
                    )
                )
              )
              ;
            
            %CODIGO DE PROFESOR OAK, DESCARTA MANO, RECOJE 7 CARTAS Y PASATURNO
              ( Predicado == efectoProfessorOak,
                (
                    ( Turno == 1,
                      profesor_oak(J1Actual, J1Final),
                      Juegofinal = ["Juego", J1Final, J2Actual, 2, EU]
                    )
                    ;
                    ( Turno == 2,
                      profesor_oak(J2Actual, J2Final),
                      Juegofinal = ["Juego", J1Actual, J2Final, 1, EU]
                    )
                )
              )
              ;
              %codigo efecto hau, roba 3 cartas
              ( Predicado == efectoHau,
                (
                    ( Turno == 1,
                      usar_hau(J1Actual, J1Final),
                      Juegofinal = ["Juego", J1Final, J2Actual, Turno, EU]
                    )
                    ;
                    ( Turno == 2,
                      usar_hau(J2Actual, J2Final),
                      Juegofinal = ["Juego", J1Actual, J2Final, Turno, EU]
                    )
                )
              );
              ( Predicado \== efectoPotion, Predicado \== efectoProfessorOak, 
              Predicado \== efectoHau,
                Juegofinal = Juegoactual
              )
          )
        )
    ).

%usePokemonAbility/4
% ex la la habilidad del pokemon usando getPokemonHabilidad, si es nula se mantiene el estado
% si existe, se ejecuta el predicado asociado a la habilidad 
% salida; nuevo tda game despues de aplicar su efecto
usePokemonAbility(["Juego", J1, J2, Turno, EU], CartaPoke, _Args, Juegofinal) :-
    
    getPokemonHabilidad(CartaPoke, Habilidad),
    Juegoactual = ["Juego", J1, J2, Turno, EU],

    (
 %caso de no tener habilidad
        ( Habilidad == null, 
          Juegofinal = Juegoactual
        )
         ;
        %Habilidad torbelino para blastoise: robar +1 carta extra del mazo
        ( Habilidad == efectoRobarCarta,
          (
              ( Turno == 1,
                J1 = ["Jugador", 1, Activo1, Banca1, Mano1, Premios1, Mazo1, Descarte1],
                robar_hasta(1, Mazo1, Robada1, MazoNuevo1),
                append(Robada1, Mano1, ManoNueva1),
                J1Nuevo = ["Jugador", 1, Activo1, Banca1, ManoNueva1, Premios1, MazoNuevo1, Descarte1],
                Juegofinal = ["Juego", J1Nuevo, J2, Turno, EU]
              )
              ;
              ( Turno == 2,
                J2 = ["Jugador", 2, Activo2, Banca2, Mano2, Premios2, Mazo2, Descarte2],
                robar_hasta(1, Mazo2, Robada2, MazoNuevo2),
                append(Robada2, Mano2, ManoNueva2),
                J2Nuevo = ["Jugador", 2, Activo2, Banca2, ManoNueva2, Premios2, MazoNuevo2, Descarte2],
                Juegofinal = ["Juego", J1, J2Nuevo, Turno, EU]
              )
          )
        )
        ;
        % otras habilidades no implementadas: no alteran el estado
        ( Habilidad \== null, Habilidad \== efectoRobarCarta,
          Juegofinal = Juegoactual
        )
    ).

% usePokemonAttack/5 | Objetivo: Ejecuta ataque y finaliza turno.
% valida si es un ataque valido, existente y posible por las energias, si lo es se ejecuta su logica y resultados 
% entregando un nuevo tda game y pasa el turno.
%si no es valido, se pasa el turno solamente
usePokemonAttack(["Juego", J1, J2, Turno, _EU], Cartapoke, Nombreataque, _Args, Juegofinal) :-
    (   ataque_valido(Cartapoke, Nombreataque, DanoAtaque, TipoAtacante)
    ->  ejecutar_ataque(J1, J2, Turno, DanoAtaque, TipoAtacante, Juegofinal)
    ;   pasar_turno(J1, J2, Turno, Juegofinal)
    ).

%ataque_valido/4
%verifica que sea un ataque valido por el nombre en el pokemon y si tiene las energias necesarias
ataque_valido(Cartapoke, Nombreataque, DanoAtaque, TipoAtacante) :-
    Nombreataque \== null,
    getPokemonAtaques(Cartapoke, Ataques),
    buscar_ataque(Ataques, Nombreataque, AtaqueUsado),
    getAttackCosto(AtaqueUsado, CostoAtaque),
    length(Base, 13),
    append(Base, [_Dano, _Estado | Energias], Cartapoke),
    tieneEnergiaSuf(Energias, CostoAtaque),
    getAttackDano(AtaqueUsado, DanoAtaque),
    getPokemonTipo(Cartapoke, TipoAtacante).

%ejecutar_ataque/6
% aplica el dano al rival, guardandolo en dano acumulado y en caso de derrotar al pokemon, 
% debe sacar un premio. 
%salida: tda game resultante, debe estar constantemente revisando si ya se termino la partida o no
ejecutar_ataque(J1, J2, 1, DanoAtaque, TipoAtacante, Juegofinal) :-
    dano_pokemon(J2, J1, DanoAtaque, TipoAtacante, J2Final, J1Final),
    J1Final = ["Jugador", _, _, _, _, Premios1, _, _],
    J2Final = ["Jugador", _, Activo2, Banca2, _, _, _, _],
    (   Premios1 == [] -> mensaje_ganador(1, sinPremios, J1Final, J2Final, Juegofinal)
    ;   (Activo2 == null, Banca2 == []) -> mensaje_ganador(1, rivalSinPokemon, J1Final, J2Final, Juegofinal)
    ;   Juegofinal = ["Juego", J1Final, J2Final, 2, false]
    ).

ejecutar_ataque(J1, J2, 2, DanoAtaque, TipoAtacante, Juegofinal) :-
    dano_pokemon(J1, J2, DanoAtaque, TipoAtacante, J1Final, J2Final),
    J2Final = ["Jugador", _, _, _, _, Premios2, _, _],
    J1Final = ["Jugador", _, Activo1, Banca1, _, _, _, _],
    (   Premios2 == [] -> mensaje_ganador(2, sinPremios, J1Final, J2Final, Juegofinal)
    ;   (Activo1 == null, Banca1 == []) -> mensaje_ganador(2, rivalSinPokemon, J1Final, J2Final, Juegofinal)
    ;   Juegofinal = ["Juego", J1Final, J2Final, 1, false]
    ).


%mensaje_ganador/5
% arma el tda del final con un mensaje claro que indique porque se ha ganado (premios o falta de pokemons o cartas)
mensaje_ganador(Jugador, sinPremios, J1, J2, ["JuegoTerminado", Mensaje, ["Juego", J1, J2, Jugador, false]]) :-
    format(string(Mensaje), "Jugador ~w ha ganado porque ya no le quedan cartas de premio", [Jugador]).
mensaje_ganador(Jugador, rivalSinPokemon, J1, J2, ["JuegoTerminado", Mensaje, ["Juego", J1, J2, Jugador, false]]) :-
    format(string(Mensaje), "Jugador ~w ha ganado porque el rival se quedo sin pokemon activo ni en banca", [Jugador]).
    
%pasar_turno/4, 
%en caso de que el ataque no sea valido, no se aplica dano y solo se pasa el turno al otro jugador
%salida: nuevo tda juego 

pasar_turno(J1, J2, Turno, ["Juego", J1, J2, TurnoNuevo, false]) :-
    TurnoNuevo is (Turno mod 2) + 1.