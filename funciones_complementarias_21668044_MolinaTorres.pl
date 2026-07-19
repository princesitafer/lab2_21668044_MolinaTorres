:- module(funciones_complementarias_21668044_MolinaTorres, [obtenerposde/3, contar_cartas_por_nombre/3, verificar_limite_copias/2, tiene_pokemon_basico/1,
            sacar_carta_en_posicion/4, mezclar_recursivo/3, robar_cartas/4, preparar_jugador/6, randomPuro/2, texto_player/3, sacar_carta_mano/3, agregar_banca/3,
            saca_lista/3, cambia_poke_activo/3, sacar_carta_baraja/3, aplica_energia/4, evolucionar/4, entrenador/3, dano_pokemon/6, buscar_ataque/3,
            curar_pokemon/3, aplica_pocion/4, usar_hau/2, robar_hasta/4, saca_pokemon_banca/4, profesor_oak/2, tieneEnergiaSuf/2, calcularDanoConEfect/5]).

%IMPORTACIONES
:- use_module('tda_card_21668044_MolinaTorres.pl').
:- use_module('tda_attack_21668044_MolinaTorres.pl').

%primero/2, noprimero/2
% funcion para mejorar la manipulacion de listas en tdas
primero([Primero|_], Primero).
noprimero([_|Resto], Resto).


% obtenerposde/3
% accede al elemento de una lista con el indice usando recursion
% args: indice, lista, retorno
obtenerposde(0, U, Retorno) :-     
    primero(U, Retorno).  

obtenerposde(Pos, U, Retorno) :- 
    Pos > 0, 
    PosAux is Pos - 1, 
    noprimero(U, Resto), 
    obtenerposde(PosAux, Resto, Retorno).


%contar_cartas_por_nombre/3
% cuenta cuántas cartas con el mismo nombre existen en una lista.
% recursion con acumulador
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


%verificar_limite_copias/2
% valida que no haya mas de 4 copias de una misma carta (excluye energia)
% iterativo comparando el mazo completo
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


%tiene_pokemon_basico/1
%valida si el mazo tiene minimo un pokemon basico usando
%recursion viendo su evolucion y tipo de carta
tiene_pokemon_basico([Carta|_]) :-
    getCardType(Carta, "Pokemon"),
    getPokemonEvolucionaDe(Carta, null).            

tiene_pokemon_basico([_|Resto]) :-
    tiene_pokemon_basico(Resto).  


%randomPuro/2
%generador para tener numeros random
randomPuro(Xn, Xn1) :-
   Xn1 is (1103515245 * Xn + 12345) mod 2147483648.


% sacar_carta_en_posicion/4
% sacacarta de una lista (mazo o mano) y devuelve la lista resultante.
% recursion pero también reconstruye la lista manteniendo su orden 
% args: posicion, lista_original, Carta_extraida, lista_resultado
sacar_carta_en_posicion(0, [CartaBuscada|Resto], CartaBuscada, Resto).

sacar_carta_en_posicion(Posicion, [CartaActual|Resto], CartaExtraida, [CartaActual|RestoSobrante]) :-
    Posicion > 0,
    NuevaPosicion is Posicion - 1,
    sacar_carta_en_posicion(NuevaPosicion, Resto, CartaExtraida, RestoSobrante).



%mezclar_recursivo/3
%mezca las cartas de manera random
% recursion usando el predicado anterior randomPuro.
% args: cartas_en_mesa, semilla_actual, resultado_mezclado
mezclar_recursivo([], _, []).

mezclar_recursivo(CartasEnMesa, SemillaActual, [CartaElegida | RestoMezclado]) :-
    CartasEnMesa \= [],
    length(CartasEnMesa, Cantidad),
    Cantidad > 0,
    randomPuro(SemillaActual, SemillaSiguiente),
    Posicion is SemillaSiguiente mod Cantidad,
    
    sacar_carta_en_posicion(Posicion, CartasEnMesa, CartaElegida, CartasSobrantes),
    mezclar_recursivo(CartasSobrantes, SemillaSiguiente, RestoMezclado).



%robar_cartas/4
% extrae N cartas del mazo del jugador
% recursion con indices (N) que devuelve  lista de cartas robadas y el mazo resultante
robar_cartas(0, Mazo, [], Mazo).

robar_cartas(N, [Carta|RestoMazo], [Carta|RestoRobadas], MazoSalida) :-
    N > 0,
    N1 is N - 1,
    robar_cartas(N1, RestoMazo, RestoRobadas, MazoSalida).


%robar_hasta/4
% intenta robar N cartas y en el caso que el mazo tiene menos de N, roba todo 
%              el mazo disponible sin fallar (evita bugs)
robar_hasta(N, Mazo, Robadas, MazoSalida) :-
    length(Mazo, Cantidad),
    ( Cantidad >= N -> CantidadRobar = N ; CantidadRobar = Cantidad ),
    robar_cartas(CantidadRobar, Mazo, Robadas, MazoSalida).



%preparar_jugador/6
% atributos iniciales de un jugador, mezcla el mazo, roba mano inicial, 
% verifica que el mazo sea valido y reparte premios
% Estrategia: Recursión (con validaciones).
% entrada: mazoinicial, semilla.
% salida: ManoFinal, Premios, MazoFinal, SemillaFinal.

preparar_jugador(MazoIni, Semilla, ManoFinal, Premios, MazoFinal, SemillaFinal) :-
    mezclar_recursivo(MazoIni, Semilla, MazoMezc),
    robar_cartas(7, MazoMezc, ManoTmp, RestoTmp),
    

    (
        % caso de que el mazo tenga basico (exitoso y sigue el prox paso)
        ( tiene_pokemon_basico(ManoTmp),
          ManoFinal = ManoTmp,                         %confirmar la mano
          robar_cartas(6, RestoTmp, Premios, MazoFinal), % sacar premios 
          randomPuro(Semilla, SemillaFinal)              % nueva semilla para el sgte turno
        )

        ; % or

        % caso de que el mazo NO tenga basico (volver a mezclar)
        ( \+ tiene_pokemon_basico(ManoTmp), 
          randomPuro(Semilla, SemillaTemporal),    

          % llamada recursiva con semillatemporal % (CON LA MISMA SEMILLA DARIA SIEMPRE EL MISMO RESULTADO)
          preparar_jugador(MazoIni, SemillaTemporal, ManoFinal, Premios, MazoFinal, SemillaFinal) 
        )
    ).



% obtener_nombre_carta/2
% saca el nombre de una carta para que se vea mas limpio en el codigo (sin numeros de memorias raros/simbolos)
% independiente del tipo de carta
obtener_nombre_carta(["Pokemon", _, _, Nombre | _], Nombre).
obtener_nombre_carta(["Energia", _, _, Tipo | _], NombreCarta):-
    format(string(NombreCarta), "Energia ~w", [Tipo]).
obtener_nombre_carta(["Entrenador", _, _, Nombre | _], Nombre).


%texto_mano/4
%Representacion textual de los objetos de un jugador para hacer mas facil al printear
%Verificando el turno, revelando objetos en caso de que sea el turno del jugador o sino la oculta
% args: Mano, Turnoactual, Playerpropietario, Resultado_texto.
texto_mano(Mano, Turno, Player, StrMano) :-
    Turno == Player,
    nombres_cartas(Mano, StrNombres),
    format(string(StrMano), "~w", [StrNombres]).

% si no es el turno del jugador solo se ve la cantidad de cartas
texto_mano(Mano, Turno, Player, StrMano) :-
    Turno \== Player,
    length(Mano, Cantidad),
    format(string(StrMano), "Oculta (~w cartas)", [Cantidad]).



%nombres_cartas/2
%cadena con los nombres de las cartas
% recursion con la lista de cartas
nombres_cartas([], "Vacia").

nombres_cartas([Carta], TextoFinal) :-
    obtener_nombre_carta(Carta, Nombre), 
    format(string(TextoFinal), "~w", [Nombre]).

nombres_cartas([Carta1, Carta2 | RestoCarta], TextoFinal) :-
    obtener_nombre_carta(Carta1, Nombre1),
    nombres_cartas([Carta2 | RestoCarta], TextoResto),
    format(string(TextoFinal), "~w, ~w", [Nombre1, TextoResto]).


%armar_texto/2
% descripcion detallada de pokemon, su estado, vida, debilidades y energias equipadas
armar_texto(null, "Ninguno").

armar_texto(CartaPoke, TextoPoke) :-
    CartaPoke = ["Pokemon", _, _, Nombre, Evolucion, PS, Tipo, Debilidad, Resistencia | _], %datos a mostrar
    (Evolucion == null -> Etapa = "Basico" ; Etapa = "Evolucion"),
    
    length(Base, 13),
    append(Base, [Dano, Estado | EnergiasPegadas], CartaPoke),
    
    length(EnergiasPegadas, CantEnergias),

    (
        ( CantEnergias == 0, % caso de que no tenga energias = se muestra 0
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

                                                                   
% texto_player/3
% printea de mejor manera visualmente el estado de un jugador usando solo strings
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


%sacar_carta_mano/3
%saca una carta especifica de la mano usando recursion

sacar_carta_mano(CartaBuscada, [CartaBuscada|Resto], Resto).
sacar_carta_mano(CartaBuscada, [Carta|Resto], [Carta|Lista]) :-
    CartaBuscada \== Carta,
    sacar_carta_mano(CartaBuscada, Resto, Lista).



%agregar_banca/3
% mueve un pokemon basico de la mano a la lista representativa de la banca
% validando que haya espacio, que sea un pokemon, y actualizando si es movimiento valido
agregar_banca(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], CartaPoke, ["Jugador", ID, Activo, NuevaBanca, NuevaMano, Premios, Mazo, Descarte]) :-
    
 % valida que sea posible que este en banca (sea pokemon basico)
    isPokemonCard(CartaPoke),
    getPokemonEvolucionaDe(CartaPoke, null),
    
    %la banca no puede tener 5 o + cartas
    length(Banca, CantBanca),
    CantBanca < 5,
    
    sacar_carta_mano(CartaPoke, Mano, NuevaMano), % saca de la mano para ir a la lista de banca
    append(CartaPoke, [0, "Normal"], CartaEnJuego), % mete la carta en juego con dano 0 y sin estados

    % mete al pokemon a la banca (inicio de la lista)
    NuevaBanca = [CartaEnJuego | Banca].    


% saca_lista/3
% manipulacioon de listas, se selecciona una carta y se devuelve la lista sin la carta seleccionada
% ideal para descartar
saca_lista(Carta, [Carta|Resto], Resto).
saca_lista(Carta, [Otro|Resto], [Otro|Nuevoresto]) :-
    Carta \== Otro,
    saca_lista(Carta, Resto, Nuevoresto).


%cambia_poke_activo/3
%cambia un pokemon activo de su lista y se va a la lista de banca
cambia_poke_activo(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte],
    CartaBanca, ["Jugador", ID, Nuevoactivo, Nuevabanca, Mano, Premios, Mazo, NuevoDescarte]) :-
    
    isPokemonCard(CartaBanca),

% se saca el pokemon considerando sus caracteristicas, dano/estado
    saca_pokemon_banca(CartaBanca, Banca, CartaBancaReal, BancaSinActivo),

    (
        % Caso en que no haya pokemon activo
        ( Activo == null,
          Nuevoactivo = CartaBancaReal,
          Nuevabanca = BancaSinActivo,
          NuevoDescarte = Descarte
        )
        ;
        %si hay un pokemon activo
        ( Activo \== null,
          Nuevoactivo = CartaBancaReal,
          Nuevabanca = [Activo | BancaSinActivo],
          NuevoDescarte = Descarte
        )
    ).


%sacar_carta_baraja/3
%roba una carta del mazo y la anade a la mano
% usa el predicado anterior robar_cartas/4 para actualizar el mazo anadir a la mano
sacar_carta_baraja(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], CartaRobada, 
    ["Jugador", ID, Activo, Banca, NuevaMano, Premios, NuevoMazo, Descarte]) :-

        %saca 1 carta de la baraja
        robar_cartas(1, Mazo, [CartaRobada], NuevoMazo),
        
        % agrega la carta robada a la mano
        NuevaMano = [CartaRobada | Mano].


%aplica_energia/4
% se anade una carta de energia a un pokemon
%validando que sea del tipo, sea posible por turno y se reemplace el estado
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


%evolucionar/4
%transforma un pokemon pre evolucion a su evolucion, validando sus nombres, y traspasando
%  atributos (posicion/energia)
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

%buscar_ataque/3
%busca un ataque especifico dentro de la lista de ataques de un pokemon 
% en base su nombre por medio de recursion
% args: lista_Ataque, NombreBuscar, Resultado
buscar_ataque([Ataque|_], Nombre, Ataque) :-
    getAttackNombre(Ataque, Nombre).

buscar_ataque([Ataque|Resto], Nombre, AtaqueEncontrado) :-
    getAttackNombre(Ataque, NombreAtaque),
    Nombre \== NombreAtaque,
    buscar_ataque(Resto, Nombre, AtaqueEncontrado).



%%%%%%%% --------  efectos de cartas entrenador.........

% curar_pokemon/3
%reduce el dano acumulado de un pokemon, min 0 max (vida del pokemon)
curar_pokemon(CartaPokemon, Cantidad, CartaPokemonCurada) :-
    length(Base, 13),
    append(Base, [Dano, Estado | EnergiasPegadas], CartaPokemon),
    DanoCurado is max(0, Dano - Cantidad),
    append(Base, [DanoCurado, Estado | EnergiasPegadas], CartaPokemonCurada).


% buscar_por_nombre/4
% saca una carta por su nombre de una lista banca o activo por recursion
buscar_por_nombre(Nombre, [C|Resto], C, Resto) :-
    getCardName(C, Nombre), !.
buscar_por_nombre(Nombre, [C|Resto], Encontrada, [C|RestoSin]) :-
    buscar_por_nombre(Nombre, Resto, Encontrada, RestoSin).


%aplica_pocion/4
% cura a un pokemon de banca o activo (reduce su dano acumulado)
% buscando su nombre y actualizando el estao del jugador
aplica_pocion(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], NombrePokemon, Cantidad,
    ["Jugador", ID, NuevoActivo, NuevaBanca, Mano, Premios, Mazo, Descarte]) :-
    (
        %caso de que el pokemon sea activo
        Activo \== null,
        getCardName(Activo, NombrePokemon)-> curar_pokemon(Activo, Cantidad, NuevoActivo),
        NuevaBanca = Banca
    ;
    %pokemon en banca
        NuevoActivo = Activo,
        buscar_por_nombre(NombrePokemon, Banca, CartaEncontrada, BancaSinCarta),
        curar_pokemon(CartaEncontrada, Cantidad, CartaCurada),
        NuevaBanca = [CartaCurada | BancaSinCarta]
    ).

%usar_hau/2
% efecto trainer hau el cual roba 3 cartas, y mantiene el turno
% usa el predicado anterior robar_hasta/4 (robar cantidad especif)
usar_hau(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte],
         ["Jugador", ID, Activo, Banca, ManoNueva, Premios, MazoNuevo, Descarte]) :-
    robar_hasta(3, Mazo, Robadas, MazoNuevo),
    append(Robadas, Mano, ManoNueva).



%profesor_oak/2
%descarta la mano actual, saca 7 cartas y pasa turno
profesor_oak(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte],
             ["Jugador", ID, Activo, Banca, ManoNueva, Premios, MazoNuevo, DescarteNuevo]) :-
    append(Mano, Descarte, DescarteNuevo), %mano actual pasa a pila de descarte
    (length(Mazo, N), N >= 7 ->            % se valida que se puedan robar 7 cartas
        length(ManoNueva, 7), append(ManoNueva, MazoNuevo, Mazo)
    ; 
        ManoNueva = Mazo, MazoNuevo = []
    ).


%entrenador/3
%logica para cualquier carta de entrenador en donde se valida el tipo, se elimina de 
% la mano y luego de usarla se agrega a la pila de descartes
entrenador(["Jugador", ID, Activo, Banca, Mano, Premios, Mazo, Descarte], 
    CartaEntrenador, ["Jugador", ID, Activo, Banca, NuevaMano, Premios, Mazo, NuevoDescarte]) :-
    
        isTrainerCard(CartaEntrenador),              %validacion
        sacar_carta_mano(CartaEntrenador, Mano, NuevaMano),
    
        NuevoDescarte = [CartaEntrenador | Descarte]. %anade a descarte

%contarEnergiasTipo/3
% cuenta las energias de un tipo especifico hay en una lista para predicados futuros
%usando recursion en listas de energias
contarEnergiasTipo(_, [], 0).
contarEnergiasTipo(Tipo, [Energia|Resto], Cantidad) :-
    getCardName(Energia, TipoEnergia),
    contarEnergiasTipo(Tipo, Resto, CantidadResto),
    ( TipoEnergia == Tipo -> Cantidad is CantidadResto + 1 ; Cantidad = CantidadResto ).

%sumaCostoEnergia/2
%calcula el costo de una energia (en caso de que un ataque necesite 3 energias (2fuego + 1 incolora, etc))
sumaCostoEnergia([], 0).
sumaCostoEnergia([[Cantidad, _Tipo]|Resto], Total) :-
    sumaCostoEnergia(Resto, TotalResto),
    Total is TotalResto + Cantidad.



%cumpleCostoEspecific/2
%verifica que tenga del tipo de energia necesario, exceptuando incoloras ya que son un comodin
cumpleCostoEspecific([], _).

%TIPO INCOLORA DA IGUAL (COMODIN)
cumpleCostoEspecific([[_Cantidad, "Incolora"]|Resto], EnergiasDisponibles) :-
    cumpleCostoEspecific(Resto, EnergiasDisponibles).

%TIPO ELEMENTALES (DIFERENTES A INCOLORAS)
cumpleCostoEspecific([[Cantidad, Tipo]|Resto], EnergiasDisponibles) :-
    Tipo \== "Incolora",
    contarEnergiasTipo(Tipo, EnergiasDisponibles, CantidadDisponible),
    CantidadDisponible >= Cantidad,
    cumpleCostoEspecific(Resto, EnergiasDisponibles).


%tieneEnergiaSuf/2
%valida si el pokemon puede atacar dependiendo de energias que tenga
tieneEnergiaSuf(EnergiasPegadas, CostoAtaque) :-
    cumpleCostoEspecific(CostoAtaque, EnergiasPegadas),
    length(EnergiasPegadas, TotalDisponible),
    sumaCostoEnergia(CostoAtaque, TotalRequerido),
    TotalDisponible >= TotalRequerido.

%alcularDanoConEfect/5
%calcula el dano final considerando resistencias y debilidades del pokemon
% si es debil se duplica, si es resistente al tipo de dano es -30puntos
calcularDanoConEfect(TipoAtacante, Debilidad, Resistencia, DanoBase, DanoFinal) :-
    ( TipoAtacante == Debilidad -> DanoConDebilidad is DanoBase * 2 ; DanoConDebilidad = DanoBase ),
    ( TipoAtacante == Resistencia -> DanoFinal is max(0, DanoConDebilidad - 30) ; DanoFinal = DanoConDebilidad ).




%dano_pokemon/6
% Dano, donde se debe ver si sobreviove el pokemon, repartir/descartar premios y pokemons, ver 
%el dano acumulado, resistencias, entre otros
dano_pokemon(Jugadorrival, Jugadoractual, DanoAtaque, TipoAtacante, Jugadorrivalsalida, Jugadoractualsalida) :-
    Jugadorrival = ["Jugador", Idrival, Activorival, Bancarival, Manorival, Premiosrival, Mazorival, Descarterival],
    
    ( 
        % caso que el rival no tenga pokemon activo (evitar bug)
        ( Activorival == null,
          Jugadorrivalsalida = Jugadorrival,
          Jugadoractualsalida = Jugadoractual
        )
        ;
        ( Activorival \== null,
          length(Base, 13),
          append(Base, [DanoAcumulado, Estado | Energias], Activorival),
          Base = ["Pokemon", _, _, _, _, PS, _, Debilidad, Resistencia, _, EsEX | _],
          calcularDanoConEfect(TipoAtacante, Debilidad, Resistencia, DanoAtaque, 
          DanoEfectivo),
          DanoNuevo is DanoAcumulado + DanoEfectivo,
        (
              %pokemon sobrevive entonces hay que actulizar sus ps
              ( DanoNuevo < PS,
                append(Base, [DanoNuevo, Estado | Energias], ActivorivalNuevo),
                Jugadorrivalsalida = ["Jugador", Idrival, ActivorivalNuevo, Bancarival, Manorival, Premiosrival, Mazorival, Descarterival],
                Jugadoractualsalida = Jugadoractual
              )
              ;
              %si el pokemon muere la carta tiene que ser descartada y se sacan premios
              
              ( DanoNuevo >= PS,
                append(Base, [DanoNuevo, Estado | Energias], ActivorivalMuerto),
                Nuevodescarterival = [ActivorivalMuerto | Descarterival],
                Jugadorrivalsalida = ["Jugador", Idrival, null, Bancarival, Manorival, Premiosrival, Mazorival, Nuevodescarterival],

                Jugadoractual = ["Jugador", IdActual, ActivoActual, BancaActual, ManoActual, PremiosActual, MazoActual, DescarteActual],
                (
                    (EsEX == true, CantidadPremios = 2)
                    ;
                    (EsEX == false, CantidadPremios = 1)
                ),

                robar_hasta(CantidadPremios, PremiosActual, PremiosRobados, NuevosPremiosActual),
                append(PremiosRobados, ManoActual, NuevaManoActual),
                Jugadoractualsalida = ["Jugador", IdActual, ActivoActual, BancaActual, NuevaManoActual, NuevosPremiosActual, MazoActual, DescarteActual]
              )
          )
        )
    ).

% Predicado: saca_pokemon_banca/4
%saca a un pokemon de la banca por su nombre, para en la primera coincidencia
saca_pokemon_banca(CartaBuscada, [CartaBanca|Resto], CartaBanca, Resto) :-
    getCardName(CartaBuscada, Nombre),
    getCardName(CartaBanca, Nombre), !.
saca_pokemon_banca(CartaBuscada, [Otro|Resto], CartaBancaEncontrada, [Otro|Nuevoresto]) :-
    saca_pokemon_banca(CartaBuscada, Resto, CartaBancaEncontrada, Nuevoresto).