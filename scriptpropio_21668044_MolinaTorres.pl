:- module(scriptpropio_21668044_MolinaTorres, [corre_prueba/0]).

%IMPORTACIONES 
:- use_module('tda_card_21668044_MolinaTorres.pl').
:- use_module('tda_attack_21668044_MolinaTorres.pl').
:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').
:- use_module('funciones_juego_21668044_MolinaTorres.pl').

:- set_prolog_flag(answer_write_options,[max_depth(0)]).

%PREDICADOS
sinEfecto(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoParalizar(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoHau(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoPotion(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoProfessorOak(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoRobarCarta(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.

% TODO UNIDO POR COMAS!!
corre_prueba :-


    createEnergyCard("XY-Evoluciones", 100, "Agua", EnergiaAgua),
    createEnergyCard("XY-Evoluciones", 101, "Incolora", EnergiaIncolora),

    createAttack([[1, "Agua"]], "Pistola Agua", "Daño básico", 20, sinEfecto, A_PistolaAgua),
    createAttack([[2, "Agua"]], "Burbuja", "Lanza moneda, si sale cara Paraliza", 30, efectoParalizar, A_Burbuja),
    createAttack([[1, "Incolora"]], "Golpe", "Daño simple", 10, sinEfecto, A_Golpe),
    createAttack([[3, "Agua"]], "Hidrobomba", "Daño fuerte", 80, sinEfecto, A_Hidrobomba),

    %createPokemonCard("Team Up", 32, "Lapras", null, 110, "Agua", "Planta", null, 2, false, null, [A_PistolaAgua, A_Hidrobomba], Lapras),
    %createPokemonCard("XY-Evoluciones", 38, "Poliwag", null, 50, "Agua", "Planta", null, 1, false, null, [A_Golpe], Poliwag),
    %createPokemonCard("XY-Evoluciones", 28, "Magikarp", null, 30, "Agua", "Electrico", null, 1, false, null, [A_Golpe], Magikarp),
    %createPokemonCard("Ultra Prism", 30, "Spheal", null, 60, "Agua", "Planta", null, 2, false, null, [A_PistolaAgua], Spheal),
    %createPokemonCard("Sun & Moon", 40, "Popplio", null, 60, "Agua", "Planta", null, 1, false, null, [A_PistolaAgua], Popplio),

    createPokemonCard("XY-Evoluciones", 40, "Squirtle", null, 60, "Agua", "Planta", null, 1, false, null, [A_PistolaAgua], Squirtle),
    createPokemonCard("XY-Evoluciones", 41, "Wartortle", "Squirtle", 80, "Agua", "Planta", null, 1, false, null, [A_Burbuja, A_Golpe], Wartortle),
    createPokemonCard("XY-Evoluciones", 42, "Blastoise", "Wartortle", 140, "Agua", "Planta", null, 2, false, null, [A_Hidrobomba], Blastoise),
    createPokemonCard("Sun & Moon", 25, "Psyduck", null, 60, "Agua", "Planta", null, 1, false, null, [A_PistolaAgua], Psyduck),
    createPokemonCard("Burning Shadows", 25, "Horsea", null, 50, "Agua", "Planta", null, 1, false, null, [A_Golpe], Horsea),
    createPokemonCard("Lost Thunder", 50, "Totodile", null, 60, "Agua", "Planta", null, 1, false, null, [A_Golpe], Totodile),
    
    createPokemonCard("XY-Evoluciones", 102, "Blastoise-EX", null, 180, "Agua", "Planta", null, 2, true, efectoRobarCarta, [A_Hidrobomba], BlastoiseEX),


    createTrainerCard("Sun & Moon", 127, "Pocion", "objeto", "Cura 30 daño", efectoPotion, Potion),
    createTrainerCard("Celestial Storm", 132, "Hau", "partidario", "Roba 3 cartas", efectoHau, Hau),
    createTrainerCard("Sun & Moon", 88, "Profesor Oak", "partidario", "Roba 7 cartas", efectoProfessorOak, ProfeOak),



    createDeck([
        % Pokémon
        Squirtle, Squirtle, Squirtle, Squirtle,
        Wartortle, Wartortle, Wartortle, Wartortle,
        Blastoise, Blastoise, 
        BlastoiseEX, BlastoiseEX, Totodile, Totodile, Totodile,
        Horsea, Horsea, Horsea, Psyduck, Psyduck,

        
        Potion, Potion, Potion, Potion,
        Hau, Hau, Hau, Hau,
        ProfeOak, ProfeOak, ProfeOak, ProfeOak,
        
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

    %mismas cartas pero diferentes semillas en el deck2
    shuffleDeck(Deck1, 8888, Deck2Barajado),


    initGame(
        Deck1Barajado,
        Deck2Barajado,
        11111,
        JuegoInicial
    ),
    printGame(JuegoInicial, StrJ1),
    write(StrJ1),

    % jugador 1 psyduck pasa a banca y a activo
    playToBench(JuegoInicial, Psyduck, J2),
    changeActivePokemon(J2, Psyduck, J2b),

    gameGetActivePokemon(J2b, ActivoJ2),
    usePokemonAttack(J2b, ActivoJ2, "Pistola Agua", [], J3), % no tiene energia, pasa turno
    printGame(J3, StrJ3),
    write(StrJ3),

    % jugador 2 usa a squirtle y lo activa
    playToBench(J3, Squirtle, J4),
    changeActivePokemon( J4, Squirtle, J5),
    printGame(J5, StrJ5),
    write(StrJ5),

    gameGetActivePokemon(J5, ActivoJ5),
    usePokemonAttack(J5, ActivoJ5, "Pistola Agua", [], J6), % no tiene energia, ataque falla pasa turno
    printGame(J6, StrJ6),
    write(StrJ6),

    % psyduck activo, se le pone energia y ataca, deja a squirtle 40/60ps
    gameGetActivePokemon(J6, Activo),
    useEnergyCard( J6, Activo, EnergiaAgua, J7),

    %se pide el activo nuevamente ya que ahora tiene energia (cambio)
    gameGetActivePokemon(J7, ActivoConEnergia),
    usePokemonAttack(J7, ActivoConEnergia, "Pistola Agua", [], J8),

    printGame(J8, StrJ8),
    write(StrJ8),

    % jugador 2 evoluciona al squirtle (danado) a su evolucion wartortle
    % con esta semilla ya estaba en  la mano, por lo que no es necesario sacar 
    % cartas del mazo

    gameGetActivePokemon(J8, ActivoSquirtle),
    evolvePokemon(J8, ActivoSquirtle, Wartortle, J9),

    printGame(J9, Str9),
    write(Str9),

    % jugador 2 deja a Blastoise en banca
    playToBench(J9, BlastoiseEX, J10),

    % wartortle intenta atacar pero no tiene energia
    % su ataque falla y pasa turno
    gameGetActivePokemon(J10, ActivoWartortle),
    usePokemonAttack(J10, ActivoWartortle, "Burbuja", [], J11),

    printGame(J11, StrJ11),
    write(StrJ11),

    % roba carta del mazo y ataca con psyduck (aun tiene su energia)
    drawCardFromDeck(J11, CartaRobada, J12),
    gameGetActivePokemon(J12, ActivoPsyduck2),
    usePokemonAttack(J12, ActivoPsyduck2, "Pistola Agua", [], J13),

    printGame(J13, StrJ13),
    write(StrJ13),

    %saca cartas del mazo
    drawCardFromDeck(J13, CartaRobada1, J14),
    drawCardFromDeck(J14, CartaRobada2, J15),
    drawCardFromDeck(J15, CartaRobada3, J16),
    drawCardFromDeck(J16, CartaRobada4, J17),
    drawCardFromDeck(J17, CartaRobada5, J18),% saca pocion y cura a wartortle
    gameGetActivePokemon(J18, ActivoaCurar),
    getCardName(ActivoaCurar, PokeaCurar),
    useTrainerCard(J18, CartaRobada5, [PokeaCurar], J19),

    printGame(J19, StrJ19),
    write(StrJ19),

    gameGetActivePokemon(J19, PokeAtaca), % wartortle luego de curarse, ataca (no tiene energia, falla)
    usePokemonAttack(J19, PokeAtaca, "Burbuja", [], J20),

    printGame(J20, StrJ20),
    write(StrJ20),

    playToBench(J20, Totodile, J21), %totodile a activo, psyduck a banca
    changeActivePokemon(J21, Totodile, J22),

    %energia a totodile
    gameGetActivePokemon(J22, ActivoJ1),
    useEnergyCard( J22, ActivoJ1, EnergiaAgua, J23),
    gameGetActivePokemon(J23, ActivoJ1Energia),

    drawCardFromDeck(J23, CartaRobada6, J24), % wartortle
    drawCardFromDeck(J24, CartaRobada7, J25), % energia incolora

    printGame(J25, StrJ25),
    write(StrJ25),

    gameGetActivePokemon(J25, ActivoJJ1),
    useEnergyCard( J25, ActivoJJ1, EnergiaIncolora, J26), % energia incolora no se, ya se jugo una energia en este turno
    gameGetActivePokemon(J26, ActivoJ1Energia),

    printGame(J26, StrJ26),
    write(StrJ26),

    gameGetActivePokemon(J26, ActTotodile),
    usePokemonAttack(J26, ActTotodile, "Golpe", [], J27),

    printGame(J27, StrJ27),
    write(StrJ27),

    gameGetActivePokemon(J27, ActWartortle2),
    useEnergyCard(J27, ActWartortle2, EnergiaIncolora, J28),
    gameGetActivePokemon(J28, ActWartortleEnergia),

    usePokemonAttack(J28, ActWartortleEnergia, "Golpe", [], J29),

    printGame(J29, StrJ29),
    write(StrJ29),

    gameGetActivePokemon(J29, TotodileActual),
    useEnergyCard( J29, TotodileActual, EnergiaIncolora, J30),
    gameGetActivePokemon(J30, TotodileEnergia),

    useTrainerCard(J30, ProfeOak, [], J31),
    printGame(J31, StrJ31),
    write(StrJ31),

    % jugador 2, wartortle ataca
    gameGetActivePokemon(J31, ActivoWartortleJ2),
    usePokemonAttack(J31, ActivoWartortleJ2, "Golpe", [], J32),
    printGame(J32, StrJ32),
    write(StrJ32),

    % jugador 1 saca a totodile y vuelve a poner a psyduck de activo
    % (psyduck trae pegada su energia de agua desde antes, asi que puede atacar)
    changeActivePokemon(J32, Psyduck, J33),

    gameGetActivePokemon(J33, ActivoPsyduckJ1),
    usePokemonAttack(J33, ActivoPsyduckJ1, "Pistola Agua", [], J34), % wartortle pasa a 40 dano acumulado
    printGame(J34, StrJ34),
    write(StrJ34),

    gameGetActivePokemon(J34, ActivoWartortleJ2b),
    usePokemonAttack(J34, ActivoWartortleJ2b, "Golpe", [], J35), % psyduck recibe 10 dano
    printGame(J35, StrJ35),
    write(StrJ35),

    gameGetActivePokemon(J35, ActivoPsyduckJ1b),
    usePokemonAttack(J35, ActivoPsyduckJ1b, "Pistola Agua", [], J36), % wartortle 60 dano acumulado
    printGame(J36, StrJ36),
    write(StrJ36),

    gameGetActivePokemon(J36, ActivoWartortleJ2c),
    usePokemonAttack(J36, ActivoWartortleJ2c, "Golpe", [], J37), % psyduck recibe + 10 dano
    printGame(J37, StrJ37),
    write(StrJ37),

    % wartortle llega a 80 de dano acumulado y es eliminado
    % (se descarta, j2 se queda sin activo y j1 roba premio)
    gameGetActivePokemon(J37, ActivoPsyduckJ1c),
    usePokemonAttack(J37, ActivoPsyduckJ1c, "Pistola Agua", [], J38),
    printGame(J38, StrJ38),
    write(StrJ38),

    useTrainerCard(J38, Hau, [], J39), 

    getCartaBanca(J39, "Blastoise-EX", BlastoiseEXBanca),
    useEnergyCard(J39, BlastoiseEXBanca, EnergiaAgua, J40), % se le pega una energia de agua a blastoise

    usePokemonAttack(J40, null, null, [ ], J41), % PASA TURNO
    printGame(J41, StrJ41),
    write(StrJ41),

    gameGetActivePokemon(J41, ActivoPsyduckJ1D),

    getCartaMano(J41, "Pocion", PocionMano),
    getCardName(ActivoPsyduckJ1D, PsyduckCurar), % se cura psyduck
    useTrainerCard(J41, PocionMano, [PsyduckCurar], J42),
    printGame(J42, StrJ42),
    write(StrJ42),
    gameGetActivePokemon(J42, PsyduckCurado),
    useEnergyCard(J42, PsyduckCurado, EnergiaAgua, J43), % se le pega una energia de agua a psyduck

    gameGetActivePokemon(J43, ActPsyduckEnergia),
    usePokemonAttack(J43, ActPsyduckEnergia, "Pistola Agua", [], J44), % psyduck ataca
    printGame(J44, StrJ44),
    write(StrJ44),

    changeActivePokemon(J44, BlastoiseEXBanca, J45), %blastoise pasa de la banca a activo

    gameGetActivePokemon(J45, BlastoiseActivo),
    usePokemonAbility(J45, BlastoiseActivo, [], J45b), % habilidad de blastoise: roba 1 carta + sin gastar el turno
    printGame(J45b, StrJ45b),
    write(StrJ45b),
    gameGetActivePokemon(J45b, BlastoiseActivoHab),
    useEnergyCard(J45b, BlastoiseActivoHab, EnergiaAgua, J46), %se le anade una energia de agua a blastoise

    gameGetActivePokemon(J46, BlastoiseActivoEnergia),
    usePokemonAttack(J46, BlastoiseActivoEnergia, "Hidrobomba", [], J47), % le faltan energias, pasa turno
    printGame(J47, StrJ47),
    write(StrJ47),

    gameGetActivePokemon(J47, ActPsyduck1),
    usePokemonAttack(J47, ActPsyduck1, "Pistola Agua", [], J48),
    printGame(J48, StrJ48),
    write(StrJ48),

    useTrainerCard(J48, Hau, [], J49),
    gameGetActivePokemon(J49, BlastoiseActivo1),
    useEnergyCard(J49, BlastoiseActivo1, EnergiaAgua, J50), %se le pone energia de agua a blastoise

    gameGetActivePokemon(J50, BlastoiseActivoEnergia1),
    usePokemonAttack(J50, BlastoiseActivoEnergia1, "Hidrobomba", [], J51), 

    printGame(J51, StrJ51),
    write(StrJ51),

    getCartaBanca(J51, "Totodile", TotodileBanca1),
    changeActivePokemon(J51, TotodileBanca1, J52),
    usePokemonAttack(J52, TotodileBanca1, "Golpe", [], J53), %totodile ataca
    printGame(J53, StrJ53),
    write(StrJ53),

    gameGetActivePokemon(J53, BlastoiseFINAL), %eliminan a totodile, jugador 1 se queda sin pokemon en banca y activo
    usePokemonAttack(J53, BlastoiseFINAL, "Hidrobomba", [], J55),
    imprimirResultado(J55).