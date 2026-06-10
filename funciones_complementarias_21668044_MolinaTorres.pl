:- module(funciones_complementarias_21668044_MolinaTorres, [obtenerposde/3, contar_cartas_por_nombre/3, verificar_limite_copias/2, tiene_pokemon_basico/1,
            sacar_carta_en_posicion/4, mezclar_recursivo/3, robar_cartas/4, preparar_jugador/6, randomPuro/2, texto_player/3, sacar_carta_mano/3, agregar_banca/3,
            saca_lista/3, cambia_poke_activo/3, sacar_carta_baraja/3, aplica_energia/4, evolucionar/4, entrenador/3, dano_pokemon/4]).

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
obtener_nombre_carta(["Energia", _, _, Tipo | _], NombreCarta):-
    format(string(NombreCarta), "Energia ~w", [Tipo]).
obtener_nombre_carta(["Entrenador", _, _, Nombre | _], Nombre).


% solo se muestran cartas en mano del player que tiene el turno
texto_mano(Mano, Turno, Player, StrMano) :-
    Turno == Player,
    nombres_cartas(Mano, StrNombres),
    format(string(StrMano), "~w", [StrNombres]).

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

armar_texto(CartaPoke, TextoPoke) :-
    CartaPoke = ["Pokemon", _, _, Nombre, Evolucion, PS, Tipo, Debilidad, Resistencia | _], %datos a mostrar
    (Evolucion == null -> Etapa = "Basico" ; Etapa = "Evolucion"),
    
    length(Base, 13),
    append(Base, [Dano, Estado | EnergiasPegadas], CartaPoke),
    
    length(EnergiasPegadas, CantEnergias),

    (
        ( CantEnergias == 0, % caso de que no tenga energias, se muestra 0
          TextoEnergias = "0" 
        );

        % ccaso de que el pokemon tenga energias en uso
        ( CantEnergias > 0, 
          nombres_cartas(EnergiasPegadas, NombresEnergias),
          format(string(TextoEnergias), "~w (~w)", [CantEnergias, NombresEnergias])
        )
    ),
    PSactual is PS - Dano,
    format(string(TextoPoke), "~w [~w | ~w] - PS: ~w/~w | Debilidad: ~w | Resistencia: ~w | energia: ~w | Dano: ~w | Estado: ~w",
           [Nombre, Tipo, Etapa, PSactual, PS, Debilidad, Resistencia, TextoEnergias, Dano, Estado]).

                                                                   

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


%%%%% play bench


% saca una cartabuscada de la mano 
sacar_carta_mano(CartaBuscada, [CartaBuscada|Resto], Resto).
sacar_carta_mano(CartaBuscada, [Carta|Resto], [Carta|Lista]) :-
    CartaBuscada \== Carta,
    sacar_carta_mano(CartaBuscada, Resto, Lista).

%agrega pokemon a la banca del jugador de turno
agregar_banca(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], CartaPoke, ["Jugador", ID, Activo, NuevaBanca, NuevaMano, Premios, Mazo, Descarte]) :-
    
 % valida que sea posible que esté en banca (sea pokemon basico)
    isPokemonCard(CartaPoke),
    getPokemonEvolucionaDe(CartaPoke, null),
    
    %la banca no puede tener 5 o + cartas
    length(Banca, CantBanca),
    CantBanca < 5,
    
    sacar_carta_mano(CartaPoke, Mano, NuevaMano), % saca de la mano para ir a la lista de banca
    append(CartaPoke, [0, "Normal"], CartaEnJuego), % mete la carta en juego con dano 0 y sin estados

    % mete al pokemon a la banca (inicio de la lista)
    NuevaBanca = [CartaPoke | Banca].    


%%%%%%% activar pokemon

saca_lista(Carta, [Carta|Resto], Resto).
saca_lista(Carta, [Otro|Resto], [Otro|Nuevoresto]) :-
    Carta \== Otro,
    saca_lista(Carta, Resto, Nuevoresto).


cambia_poke_activo(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte],
    CartaBanca, ["Jugador", ID, Nuevoactivo, Nuevabanca, Mano, Premios, Mazo, NuevoDescarte]) :-
    
        % validar que sea un pokemon y este en banca
        isPokemonCard(CartaBanca),
        saca_lista(CartaBanca, Banca, BancaSinActivo),

        (
            %caso de que no haya pokemon activo
            ( Activo == null,
            Nuevoactivo = CartaBanca,
            Nuevabanca = BancaSinActivo,
            NuevoDescarte = Descarte
            )
            ;
            % si hay un pokemon activo (hay que hacer retirada)
            ( Activo \== null,
            Nuevoactivo = CartaBanca,
            
            %el poke antiguo pasa a estar en la baca
            Nuevabanca = [Activo | BancaSinActivo],
            
            % coste de retirada del poke anterior
            getPokemonCosteRetirada(Activo, Coste),
            
            % aqui faltaria implementar usar carta de energia para ver si es posible la retirada
            %%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%% arreglar a futuro (faltan implementaciones)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            NuevoDescarte = Descarte
            )
        ).


sacar_carta_baraja(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], CartaRobada, 
    ["Jugador", ID, Activo, Banca, NuevaMano, Premios, NuevoMazo, Descarte]) :-

        %saca 1 carta de la baraja
        robar_cartas(1, Mazo, [CartaRobada], NuevoMazo),
        
        % agrega la carta robada a la mano
        NuevaMano = [CartaRobada | Mano].



%%%%%%%% usar energia

aplica_energia(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], CartaPoke, 
    CartaEnergia, ["Jugador", ID, NuevoActivo, NuevaBanca, NuevaMano, Premios, Mazo, Descarte]) :-
    
        % verifica que sea una carta de energia y se saca de la mano
        isEnergyCard(CartaEnergia),
        sacar_carta_mano(CartaEnergia, Mano, NuevaMano),
        
        % verificar que el objetivo sea pokemon
        CartaPoke = ["Pokemon" | _],
        
        % nuevo pokemon con la carta de energia en la lista
        append(CartaPoke, [CartaEnergia], NuevoPokemon),
        
        % busca al pokemon en activo o banca y lo reemplaza 
        (
            % caso de que sea pokemon activo
            ( Activo == CartaPoke,
            NuevoActivo = NuevoPokemon,
            NuevaBanca = Banca
            )
            ;
            % pokemon buscado en banca
            ( Activo \== CartaPoke,
            saca_lista(CartaPoke, Banca, BancaSinpoke),
            NuevaBanca = [NuevoPokemon | BancaSinpoke],
            NuevoActivo = Activo
            )
        ).


evolucionar(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], Cartaenjuego, 
    Cartaevol, ["Jugador", ID, NuevoActivo, NuevaBanca, NuevaMano, Premios, Mazo, Descarte]) :-
    
    % verificar que sea una carta y eliminarla de la mano
    isPokemonCard(Cartaevol),
    sacar_carta_mano(Cartaevol, Mano, NuevaMano),
    

    %verificar preevolucion y evolucion comparando nombres
    Cartaenjuego = ["Pokemon", _, _, Nombre | _],

    getPokemonEvolucionaDe(Cartaevol, Nombre),
    
    %pasar energias
    length(BaseAntigua, 13), % energias del pokemon
    append(BaseAntigua, EnergiasPegadas, Cartaenjuego),
    append(Cartaevol, EnergiasPegadas, Nuevopoke), %anade las energias a la carta ya evolucionada
    
    (
        %pokemon a evolucionar esta activo
        ( Activo == Cartaenjuego,
          NuevoActivo = Nuevopoke,
          NuevaBanca = Banca
        );

        %poke evolucionar esta en banca
        ( Activo \== Cartaenjuego,
          saca_lista(Cartaenjuego, Banca, Bancanueva),
          NuevaBanca = [Nuevopoke | Bancanueva],
          NuevoActivo = Activo
        )
    ).


entrenador(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], 
    CartaEntrenador, ["Jugador", ID, Activo, Banca, NuevaMano, Premios, Mazo, NuevoDescarte]) :-
    
        isTrainerCard(CartaEntrenador),
        sacar_carta_mano(CartaEntrenador, Mano, NuevaMano),
    
        NuevoDescarte = [CartaEntrenador | Descarte].

    %%%%%%%%%%%%%%%% falta aplicar efectos de cada carta como pociones, sacar cartas, etc
    %%%%%%%%%%%%%%%%% arreglar 



dano_pokemon(Jugadorrival, Jugadoractual, Jugadorrivalsalida, Jugadoractualsalida) :-
    Jugadorrival = ["Jugador", Idrival, Activorival, Bancarival, Manorival, Premiosrival, Mazorival, Descarterival],
    
    ((
            ( Activorival == null )
            ;
            ( Activorival \== null,
              length(Base, 13),
              append(Base, [Dano, _Estado | _Energias], Activorival),
              Base = ["Pokemon", _, _, _, _, PS | _],
              Dano < PS
            )
        ),
        
        %pokemon sobrevivio por lo que se retorna 
        Jugadorrivalsalida = Jugadorrival,
        Jugadoractualsalida = Jugadoractual
        
        ; 
         (Activorival \== null,
            length(Base, 13),
            append(Base, [Dano, _Estado | _Energias], Activorival),
            Base = ["Pokemon", _, _, _, _, PS, _, _, _, _, EsEX | _],
            Dano >= PS),
    ).