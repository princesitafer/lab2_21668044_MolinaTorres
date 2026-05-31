:- module(funciones_complementarias_21668044_MolinaTorres, [obtenerposde/3, contar_cartas_por_nombre/3, verificar_limite_copias/2, tiene_pokemon_basico/1,
            sacar_carta_en_posicion/4, mezclar_recursivo/3, robar_cartas/4, preparar_jugador/6, randomPuro/2, texto_player/3]).

:- use_module('tda_card_21668044_MolinaTorres.pl').


primero([Primero|_], Primero).
noprimero([_|Resto], Resto).

obtenerposde(0, U, Retorno) :-     
    primero(U, Retorno).  

obtenerposde(Pos, U, Retorno) :- 
    Pos > 0, 
    PosAux is Pos - 1, 
    noprimero(U, Resto), 
    obtenerposde(PosAux, Resto, Retorno).

contar_cartas_por_nombre(_, [], 0).

contar_cartas_por_nombre(NombreBuscado, [Carta|Resto], Cantidad) :-
    getCardName(Carta, NombreCarta),
    ( 
        (NombreBuscado == NombreCarta, 
         contar_cartas_por_nombre(NombreBuscado, Resto, CantResto), 
         Cantidad is CantResto + 1)
        ; 
        (NombreBuscado \== NombreCarta, 
         contar_cartas_por_nombre(NombreBuscado, Resto, Cantidad))
    ).


verificar_limite_copias(_, []).

verificar_limite_copias(MazoCompleto, [Carta|Resto]) :-
    getCardType(Carta, Tipo),
    (
        (Tipo == "Energia", 
         verificar_limite_copias(MazoCompleto, Resto))
        ;
        (Tipo \== "Energia", 
         getCardName(Carta, Nombre),
         contar_cartas_por_nombre(Nombre, MazoCompleto, Cantidad),
         Cantidad =< 4,
         verificar_limite_copias(MazoCompleto, Resto))
    ).


tiene_pokemon_basico([Carta|_]) :-
    getCardType(Carta, "Pokemon"),
    getPokemonEvolucionaDe(Carta, null).            

tiene_pokemon_basico([_|Resto]) :-
    tiene_pokemon_basico(Resto).  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

randomPuro(Xn, Xn1) :-
   Xn1 is (1103515245 * Xn + 12345) mod 2147483648.


sacar_carta_en_posicion(0, [CartaBuscada|Resto], CartaBuscada, Resto).

sacar_carta_en_posicion(Posicion, [CartaActual|Resto], CartaExtraida, [CartaActual|RestoSobrante]) :-
    Posicion > 0,
    NuevaPosicion is Posicion - 1,
    sacar_carta_en_posicion(NuevaPosicion, Resto, CartaExtraida, RestoSobrante).


mezclar_recursivo([], _, []).

mezclar_recursivo(CartasEnMesa, SemillaActual, [CartaElegida | RestoMezclado]) :-
    length(CartasEnMesa, Cantidad),
    randomPuro(SemillaActual, SemillaSiguiente),
    Posicion is SemillaSiguiente mod Cantidad,
    
    sacar_carta_en_posicion(Posicion, CartasEnMesa, CartaElegida, CartasSobrantes),
    mezclar_recursivo(CartasSobrantes, SemillaSiguiente, RestoMezclado).


% INIT GAME

% SACA N CARTAS
robar_cartas(0, Mazo, [], Mazo).

robar_cartas(N, [Carta|RestoMazo], [Carta|RestoRobadas], MazoSalida) :-
    N > 0,
    N1 is N - 1,
    robar_cartas(N1, RestoMazo, RestoRobadas, MazoSalida).


% PREPARAR: MEZCLA, SACA 7CARTAS, DEBE HABER UN POKEMON BaSICO Y 6PREMIOS 

preparar_jugador(MazoIni, Semilla, ManoFinal, Premios, MazoFinal, SemillaFinal) :-

    shuffleDeck(["Baraja", MazoIni], Semilla, ["Baraja", MazoMezc]),
    robar_cartas(7, MazoMezc, ManoTmp, RestoTmp),
    

    (
        % caso de que el mazo tenga basico (exitoso y sigue el prox paso)
        ( tiene_pokemon_basico(ManoTmp),
          ManoFinal = ManoTmp,                         %confirmar la mano
          robar_cartas(6, RestoTmp, Premios, MazoFinal), % sacar premios 
          randomPuro(Semilla, SemillaFinal)                  % nueva semilla para el sgte turno
        )

        ; % or

        % caso de que el mazo NO tenga basico (volver a mezclar)
        ( \+ tiene_pokemon_basico(ManoTmp),
          randomPuro(Semilla, SemillaTemporal),    

          % llamada recursiva con semillatemporal
          preparar_jugador(MazoIni, SemillaTemporal, ManoFinal, Premios, MazoFinal, SemillaFinal) 
        )
    ).


%%%%%%%%%% print game

obtener_nombre_carta(["Pokemon", _, _, Nombre | _], Nombre).
obtener_nombre_carta(["Energia", _, _, Tipo | _], Tipo).
obtener_nombre_carta(["Entrenador", _, _, Nombre | _], Nombre).


% solo se muestran cartas en mano del player que tiene el turno
texto_mano(Mano, Turno, Player, StrMano) :-
    Turno == Player,
    nombres_cartas(Mano, StrNombres),
    format(string(StrMano), "Visible: ~w", [StrNombres]).

% si no es el turno del jugador solo se ve la cantidad de cartas
texto_mano(Mano, Turno, Player, StrMano) :-
    Turno \== Player,
    length(Mano, Cantidad),
    format(string(StrMano), "Oculta (~w cartas)", [Cantidad]).



nombres_cartas([], "Vacia").

nombres_cartas([Carta], TextoFinal) :-
    obtener_nombre_carta(Carta, Nombre), 
    format(string(TextoFinal), "~w", [Nombre]).

nombres_cartas([Carta1, Carta2 | RestoCarta], TextoFinal) :-
    obtener_nombre_carta(Carta1, Nombre1),
    nombres_cartas([Carta2 | RestoCarta], TextoResto),
    format(string(TextoFinal), "~w, ~w", [Nombre1, TextoResto]).


% datos de cada pokemon (POR TURNO)
armar_texto(null, "Ninguno").

armar_texto(["Pokemon", _, _, Nombre, Evolucion, PS, Tipo, Debilidad, Resistencia | _], TextoPoke) :-
    (Evolucion == null -> Etapa = "Basico" ; Etapa = "Evolucion"),

    format(string(TextoPoke), "~w [~w | ~w] - PS: ~w/~w | Debilidad: ~w | Resistencia: ~w | energia: 0 | Dano: 0 | Estado: Normal",
           [Nombre, Tipo, Etapa, PS, PS, Debilidad, Resistencia]). % 100/100 DE VIDA, FALTA IMPLEMENTAR LA FUNCION DE DANO PARA que
                                                                   % SEA FIEL AL FUNCIONAMIENTO DE POKEMON

texto_player(["Jugador", Player, PokeActivo, Banca, Mano, Premios, Mazo, Descarte], Turno, TextoPlayer) :-
    armar_texto(PokeActivo, TextoActivo),
    nombres_cartas(Banca, TextoBanca),
    texto_mano(Mano, Turno, Player, TextoMano),
    length(Premios, CantPremio),
    length(Mazo, CantMazo),
    nombres_cartas(Descarte, TextoDescarte),

    format(string(TextoPlayer),
        "--- PLAYER ~w ---~nActivo: ~w~nBanca: ~w~nMano: ~w~nPremios: ~w~nMazo: ~w~nDescarte: ~w~n",
        [Player, TextoActivo, TextoBanca, TextoMano, CantPremio, CantMazo, TextoDescarte]).

        


