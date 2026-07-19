:- module(scriptpropio2_21668044_MolinaTorres, [corre_prueba2/0]).
 
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
 
corre_prueba2 :-
 
    createEnergyCard("Base", 1, "Fuego", EnergiaFuego),
    createEnergyCard("Base", 2, "Rayo", EnergiaRayo),
    createEnergyCard("Base", 3, "Incolora", EnergiaIncolora),

    createAttack([[1,"Fuego"]], "Ascuas", "Daño básico de fuego", 20, sinEfecto, A_Ascuas),
    createAttack([[1,"Incolora"]], "Mordisco", "Mordisco incoloro", 10, sinEfecto, A_Mordisco),
    createAttack([[1,"Fuego"],[1,"Incolora"]], "Lanzallamas", "Fuego intermedio", 60, sinEfecto, A_Lanzallamas),
    createAttack([[2,"Fuego"],[1,"Incolora"]], "Lanzallamas Intenso", "Fuego arrasador", 120, sinEfecto, A_LanzallamasIntenso),
    createAttack([[1,"Fuego"]], "Patada Ignea", "Patada ardiente", 30, sinEfecto, A_PatadaIgnea),

    createAttack([[1,"Rayo"]], "Impactrueno", "Golpe electrico basico", 20, sinEfecto, A_Impactrueno),
    createAttack([[2,"Rayo"],[1,"Incolora"]], "Rayo", "Descarga electrica fuerte", 90, sinEfecto, A_Rayo),
    createAttack([[1,"Incolora"]], "Autodestruccion", "Explosion desesperada", 10, sinEfecto, A_Autodestruccion),
    createAttack([[1,"Rayo"]], "Mordisco Electrico", "Mordisco cargado", 20, sinEfecto, A_MordiscoElectrico),
    createAttack([[1,"Rayo"]], "Chispazo", "Chispa basica", 20, sinEfecto, A_Chispazo),
 
    createPokemonCard("Base", 10, "Charmander", null, 60, "Fuego", "Agua", null, 1, false, null, [A_Ascuas], Charmander),
    createPokemonCard("Base", 11, "Charmeleon", "Charmander", 90, "Fuego", "Agua", null, 2, false, null, [A_Ascuas, A_Lanzallamas], Charmeleon),
    createPokemonCard("Base", 12, "Charizard", "Charmeleon", 150, "Fuego", "Agua", null, 3, false, null, [A_LanzallamasIntenso], Charizard),
    createPokemonCard("Base", 13, "Growlithe", null, 70, "Fuego", "Agua", null, 1, false, null, [A_Mordisco], Growlithe),
    createPokemonCard("Base", 14, "Vulpix", null, 60, "Fuego", "Agua", null, 1, false, null, [A_Ascuas], Vulpix),
    createPokemonCard("Base", 15, "Ponyta", null, 60, "Fuego", "Agua", null, 1, false, null, [A_PatadaIgnea], Ponyta),
 
    createPokemonCard("Base", 20, "Pikachu", null, 60, "Rayo", "Fuego", null, 1, false, null, [A_Impactrueno], Pikachu),
    createPokemonCard("Base", 21, "Raichu", "Pikachu", 110, "Rayo", "Fuego", null, 2, false, null, [A_Impactrueno, A_Rayo], Raichu),
    createPokemonCard("Base", 22, "Voltorb", null, 50, "Rayo", "Fuego", null, 1, false, null, [A_Autodestruccion], Voltorb),
    createPokemonCard("Base", 23, "Electrike", null, 60, "Rayo", "Fuego", null, 1, false, null, [A_MordiscoElectrico], Electrike),
    createPokemonCard("Base", 24, "Magnemite", null, 50, "Rayo", "Fuego", null, 1, false, null, [A_Chispazo], Magnemite),

    createTrainerCard("Base", 30, "Pocion", "objeto", "Cura 30 daño", efectoPotion, Pocion),
    createTrainerCard("Base", 31, "Hau", "partidario", "Roba 3 cartas", efectoHau, Hau),
    createTrainerCard("Base", 32, "Profesor Oak", "partidario", "Descarta mano y roba 7", efectoProfessorOak, ProfeOak),

createDeck([
    Charmander, Charmander, Charmander, Charmander,
    Charmeleon, Charmeleon, Charmeleon, Charmeleon,
    Charizard, Charizard,
    Growlithe, Growlithe, Growlithe, Growlithe,
    Vulpix, Vulpix, Vulpix,
    Ponyta, Ponyta, Ponyta,
 
    Pocion, Pocion, Pocion, Pocion,
    Hau, Hau, Hau, Hau,
    ProfeOak, ProfeOak, ProfeOak, ProfeOak,
 
    EnergiaFuego, EnergiaFuego, EnergiaFuego, EnergiaFuego, EnergiaFuego,
    EnergiaFuego, EnergiaFuego, EnergiaFuego, EnergiaFuego, EnergiaFuego,
    EnergiaFuego, EnergiaFuego, EnergiaFuego, EnergiaFuego,
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora,
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora,
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora,
    EnergiaIncolora, EnergiaIncolora
], DeckFuego),


createDeck([
    Pikachu, Pikachu, Pikachu, Pikachu,
    Raichu, Raichu, Raichu, Raichu,
    Voltorb, Voltorb, Voltorb, Voltorb,
    Electrike, Electrike, Electrike, Electrike,
    Magnemite, Magnemite, Magnemite, Magnemite,
 
    Pocion, Pocion, Pocion, Pocion,
    Hau, Hau, Hau, Hau,
    ProfeOak, ProfeOak, ProfeOak, ProfeOak,
 
    EnergiaRayo, EnergiaRayo, EnergiaRayo, EnergiaRayo, EnergiaRayo,
    EnergiaRayo, EnergiaRayo, EnergiaRayo, EnergiaRayo, EnergiaRayo,
    EnergiaRayo, EnergiaRayo, EnergiaRayo, EnergiaRayo,
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora,
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora,
    EnergiaIncolora, EnergiaIncolora, EnergiaIncolora, EnergiaIncolora,
    EnergiaIncolora, EnergiaIncolora
], DeckRayo),
 
shuffleDeck(DeckFuego, 1111, DeckFuegoBarajado),
shuffleDeck(DeckRayo, 6666, DeckRayoBarajado),
 
initGame(DeckFuegoBarajado, DeckRayoBarajado, 33333, Q0),
printGame(Q0, S0),
write(S0),
 
% Jugador 1 con baraja de fuego activa a Charmander e intenta atacar,
% no tiene energia por lo que falla, pasando turno

playToBench(Q0, Charmander, Q1),
changeActivePokemon(Q1, Charmander, Q2),
gameGetActivePokemon(Q2, ActivoQ2),
usePokemonAttack(Q2, ActivoQ2, "Ascuas", [], Q3),
printGame(Q3, S3),
write(S3),
 

% Jugador 2 de baraja de rayo, mete a banca a magnemite y a pikachu, y luego activa a
% Pikachu. 
%intenta atacar sin energia, falla

playToBench(Q3, Magnemite, Q4),
playToBench(Q4, Pikachu, Q5),
changeActivePokemon(Q5, Pikachu, Q6),
getCartaBanca(Q6, "Magnemite", MagnemiteBanca),
gameGetActivePokemon(Q6, ActivoQ6),
usePokemonAttack(Q6, ActivoQ6, "Impactrueno", [], Q7),
printGame(Q7, S7),
write(S7),
 

% Jugador 1 le pega energiaFuego a charmander y ataca 
%pikachu es debil a Fuego, el dano se duplica

gameGetActivePokemon(Q7, ActivoQ7),
useEnergyCard(Q7, ActivoQ7, EnergiaFuego, Q8),
gameGetActivePokemon(Q8, ActivoQ8),
usePokemonAttack(Q8, ActivoQ8, "Ascuas", [], Q9), % pikachu queda en 40/60ps
printGame(Q9, S9),
write(S9),
 


% Jugador 2 pega energiaRayo a pikachu y ataca a charmander (queda 20/60)

gameGetActivePokemon(Q9, ActivoQ9),
useEnergyCard(Q9, ActivoQ9, EnergiaRayo, Q10),
gameGetActivePokemon(Q10, ActivoQ10),
usePokemonAttack(Q10, ActivoQ10, "Impactrueno", [], Q11), 
printGame(Q11, S11),
write(S11),
 

% Charmander vuelve atacar y pikachu llega a 0ps (jugador 1saca 1 premio por derrotar el pokemon)
gameGetActivePokemon(Q11, ActivoQ11),
usePokemonAttack(Q11, ActivoQ11, "Ascuas", [], Q12), %PRIMER POKEMON DERROTADO
printGame(Q12, S12),
write(S12),
 
% jugador 2, su pokemon activo murio, pasa a Magnemite desde la banca al puesto activo
%intenta atacar, no tiene energia entonces falla
changeActivePokemon(Q12, MagnemiteBanca, Q13),
gameGetActivePokemon(Q13, ActivoQ13),
usePokemonAttack(Q13, ActivoQ13, "Chispazo", [], Q14),
printGame(Q14, S14),
write(S14),
 
% Jugador 1 evoluciona charmander a Charmeleon y ataca.
% magnemite es debil al fuego (queda 40/50)
gameGetActivePokemon(Q14, ActivoQ14),
getCartaMano(Q14, "Charmeleon", CharmeleonMano),
evolvePokemon(Q14, ActivoQ14, CharmeleonMano, Q15),
gameGetActivePokemon(Q15, ActivoQ15),
usePokemonAttack(Q15, ActivoQ15, "Ascuas", [], Q16), 
printGame(Q16, S16),
write(S16),
 

% Jugador 2 usa Hau (roba 3cartas), pega energia de rayo a magnemite y ataca 
getCartaMano(Q16, "Hau", HauMano),
useTrainerCard(Q16, HauMano, [], Q17),
gameGetActivePokemon(Q17, ActivoQ17),
useEnergyCard(Q17, ActivoQ17, EnergiaRayo, Q18),
gameGetActivePokemon(Q18, ActivoQ18),
usePokemonAttack(Q18, ActivoQ18, "Chispazo", [], Q19), %charmeleon queda en 40/90
printGame(Q19, S19),
write(S19),


%jugador 1 roba carta del mazo, se cura con pocion, pega energia incolora y usa la habilidad
% de su Charmeleon (no tiene habilidad, no cambia nada)
drawCardFromDeck(Q19, _CartaRobadaQ19, Q20),
gameGetActivePokemon(Q20, ActivoQ20),
getCardName(ActivoQ20, NombreActivoQ20),
getCartaMano(Q20, "Pocion", PocionMano),
useTrainerCard(Q20, PocionMano, [NombreActivoQ20], Q21), % Charmeleon sana de 40 a 10 de daño
gameGetActivePokemon(Q21, ActivoQ21),
useEnergyCard(Q21, ActivoQ21, EnergiaIncolora, Q22),
gameGetActivePokemon(Q22, ActivoQ22),
usePokemonAbility(Q22, ActivoQ22, [], Q23), % sin habilidad, el juego no cambia
usePokemonAttack(Q23, null, null, [], Q24), % PASA TURNO sin atacar
printGame(Q24, S24),
write(S24),
 
%jugador 2 usa profesor Oak 
% descarta toda su mano y roba 7 cartas, pasa turno

getCartaMano(Q24, "Profesor Oak", ProfeOakMano),
useTrainerCard(Q24, ProfeOakMano, [], Q25),
printGame(Q25, S25),
write(S25),
 

% jugador 1, su charmeleon ya tiene energia fuego y incolora
% ataca con Lanzallamas (60 de daño base, x2 por
% debilidad a Fuego = 120) magnemite queda en 0ps, queda sin pokemon ni en banca ni activos

gameGetActivePokemon(Q25, ActivoQ25),
usePokemonAttack(Q25, ActivoQ25, "Lanzallamas", [], Q26),
 
imprimirResultado(Q26).