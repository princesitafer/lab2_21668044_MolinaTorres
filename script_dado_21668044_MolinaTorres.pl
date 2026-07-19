:- module(script_dado_21668044_MolinaTorres, [run_prueba/0]).

%IMPORTACIONES 
:- use_module('tda_card_21668044_MolinaTorres.pl').
:- use_module('tda_attack_21668044_MolinaTorres.pl').
:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').
:- use_module('funciones_juego_21668044_MolinaTorres.pl').

:- set_prolog_flag(answer_write_options,[max_depth(0)]).

%PREDICADOS
sinEfecto(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoParalizar(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoGreatBall(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoHau(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoCynthia(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoPokemonFanClub(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoPotion(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoProfessorKukui(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoSwitch(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.
efectoPokemonCatcher(JuegoIn, JuegoOut) :- JuegoOut = JuegoIn.


% TODO UNIDO POR COMAS!!
run_prueba :-

    % -- ENERGIA --
    createEnergyCard("Energia Basica", 4, "Rayo", EnergiaRayo),

    % -- ATAQUES --
    createAttack([[1,"Rayo"]], "Impactrueno", "", 20, sinEfecto, A_Impactrueno),
    createAttack([[2,"Rayo"],[1,"Incolora"]], "Bola Voltio", "", 50, sinEfecto, A_BolaVoltio),
    createAttack([[1,"Incolora"]], "Placaje", "", 10, sinEfecto, A_Placaje),
    createAttack([[2,"Rayo"],[1,"Incolora"]], "Impactrueno", "", 50, sinEfecto, A_Impactrueno50),
    createAttack([[1,"Rayo"]], "Psíquico", "", 20, sinEfecto, A_Psiquico),
    createAttack([[3,"Rayo"]], "Rayo", "", 80, sinEfecto, A_Rayo80),
    createAttack([[1,"Rayo"]], "Bola Relámpago", "", 10, sinEfecto, A_BolaRelampago10),
    createAttack([[1,"Rayo"]], "Bola Relámpago", "", 60, sinEfecto, A_BolaRelampago60),
    createAttack([[1,"Rayo"]], "Puño Trueno", "", 30, sinEfecto, A_PunoTrueno),
    createAttack([[2,"Rayo"]], "Electrocañón", "", 50, sinEfecto, A_Electrocanon),
    createAttack([[4,"Rayo"]], "Voltio Salvaje", "", 120, sinEfecto, A_VoltioSalvaje),
    createAttack([[1,"Incolora"]], "Cornada", "", 10, sinEfecto, A_Cornada),
    createAttack([[2,"Rayo"]], "Patada Salvaje", "", 40, sinEfecto, A_PatadaSalvaje),
    createAttack([[1,"Incolora"]], "Ataque Ala", "", 20, sinEfecto, A_AtaqueAla20),
    createAttack([[2,"Incolora"]], "Ataque Ala", "", 40, sinEfecto, A_AtaqueAla40),
    createAttack([[2,"Rayo"]], "Impacto Trueno", "", 30, sinEfecto, A_ImpactoTrueno),
    createAttack([[3,"Rayo"]], "Colmillo Trueno", "Lanza una moneda. Si sale cara, el Pokémon Activo de tu rival pasa a estar Paralizado.", 60, efectoParalizar, A_ColmilloTrueno),

    % -- POKEMON --
    createPokemonCard("Crimson Invasion", 30, "Pikachu", null, 70, "Rayo", "Lucha", "Metal", 1, false, null, [A_Impactrueno,A_BolaVoltio], Pikachu1),
    createPokemonCard("Shining Legends", 28, "Pikachu", null, 60, "Rayo", "Lucha", "Metal", 1, false, null, [A_Placaje,A_Impactrueno50], Pikachu2),
    createPokemonCard("Crimson Invasion", 31, "Alolan Raichu", "Pikachu", 110, "Rayo", "Lucha", "Metal", 1, false, null, [A_Psiquico,A_Rayo80], Raichu),
    createPokemonCard("Shining Legends", 30, "Voltorb", null, 60, "Rayo", "Lucha", null, 1, false, null, [A_BolaRelampago10], Voltorb),
    createPokemonCard("Shining Legends", 31, "Electrode", "Voltorb", 90, "Rayo", "Lucha", null, 1, false, null, [A_BolaRelampago60], Electrode),
    createPokemonCard("Ultra Prism", 43, "Electabuzz", null, 80, "Rayo", "Lucha", "Metal", 1, false, null, [A_PunoTrueno], Electabuzz),
    createPokemonCard("Burning Shadows", 43, "Electivire", "Electabuzz", 140, "Rayo", "Lucha", "Metal", 3, false, null, [A_Electrocanon,A_VoltioSalvaje], Electivire),
    createPokemonCard("Lost Thunder", 81, "Blitzle", null, 60, "Rayo", "Lucha", "Metal", 1, false, null, [A_Cornada], Blitzle),
    createPokemonCard("Lost Thunder", 82, "Zebstrika", "Blitzle", 110, "Rayo", "Lucha", "Metal", 1, false, null, [A_PatadaSalvaje], Zebstrika),
    createPokemonCard("Team Up", 121, "Pidgey", null, 60, "Incolora", "Rayo", "Lucha", 1, false, null, [A_AtaqueAla20], Pidgey),
    createPokemonCard("Team Up", 123, "Pidgeotto", "Pidgey", 80, "Incolora", "Rayo", "Lucha", 1, false, null, [A_AtaqueAla40], Pidgeotto),
    createPokemonCard("Shining Legends", 32, "Raikou", null, 120, "Rayo", "Lucha", "Metal", 2, false, null, [A_ImpactoTrueno,A_ColmilloTrueno], Raikou),

    % -- ENTRENADORES --
    createTrainerCard("Ultra Prism", 119, "Cynthia", "partidario", "Baraja tu mano en tu mazo. Luego roba 6 cartas.", efectoCynthia, Cynthia),
    createTrainerCard("Sun & Moon", 119, "Gran Ball", "objeto", "Mira las 7 primeras cartas de tu mazo...", efectoGreatBall, GreatBall),
    createTrainerCard("Celestial Storm", 132, "Hau", "partidario", "Roba 3 cartas.", efectoHau, Hau),
    createTrainerCard("Sun & Moon", 126, "Pokémon Catcher", "objeto", "Cambia el Pokémon Activo de tu rival.", efectoPokemonCatcher, PokemonCatcher),
    createTrainerCard("Ultra Prism", 133, "Club de Fans Pokémon", "partidario", "Busca 2 Pokémon Básicos.", efectoPokemonFanClub, PokemonFanClub),
    createTrainerCard("Sun & Moon", 127, "Poción", "objeto", "Cura 30 puntos de daño.", efectoPotion, Potion),
    createTrainerCard("Sun & Moon", 128, "Profesor Kukui", "partidario", "Roba 2 cartas.", efectoProfessorKukui, ProfessorKukui),
    createTrainerCard("Celestial Storm", 147, "Cambio", "objeto", "Cambia tu Pokémon Activo.", efectoSwitch, Switch),

    % -- CREAR MAZO --
    createDeck([
        Pikachu1,Pikachu1, Pikachu2,Pikachu2, Raichu,Raichu, Electrode,Electrode, Voltorb,Voltorb,Voltorb,
        Electivire,Electivire, Electabuzz,Electabuzz,Electabuzz, Zebstrika, Blitzle,Blitzle, Pidgeotto,
        Pidgey,Pidgey, Raikou,Raikou, Cynthia, GreatBall,GreatBall, Hau,Hau,Hau,Hau, PokemonCatcher,
        PokemonFanClub,PokemonFanClub, Potion, ProfessorKukui, Switch,Switch, 
        EnergiaRayo,EnergiaRayo,EnergiaRayo,EnergiaRayo, EnergiaRayo,EnergiaRayo,EnergiaRayo,EnergiaRayo,
        EnergiaRayo,EnergiaRayo,EnergiaRayo,EnergiaRayo, EnergiaRayo,EnergiaRayo,EnergiaRayo,EnergiaRayo,
        EnergiaRayo,EnergiaRayo,EnergiaRayo,EnergiaRayo, EnergiaRayo,EnergiaRayo
    ], Deck1),

    % -- JUEGO DE PRUEBA --
   shuffleDeck(Deck1, 12345, Deck1Barajado),
   
    %mismas cartas pero diferente semilla en el deck2
    shuffleDeck(Deck1, 54321, Deck2Barajado),

initGame(
    Deck1Barajado,
    Deck2Barajado,
    11111,
    JuegoInicial
),
printGame(JuegoInicial, StrJ1),
write(StrJ1),
% Supongamos que el jugador 1 es quien comienza el juego según la moneda lanzada
% Jugador 1 pone su pokémon activo
playToBench( JuegoInicial, Pikachu1, J2),
changeActivePokemon( J2, null, J3),
% Le “pasamos” el turno al otro jugador
usePokemonAttack( J3, null, null, [ ], J4),

% Jugador 2 pone su pokémon activo
playToBench( J4, Voltorb, J5),
changeActivePokemon( J5, null, J6),
usePokemonAttack( J6, null, null, [ ], J7),

% Recién a partir de acá comienzan los turnos normales.

% Jugador 1 roba una carta del mazo, supongamos le sale un Raichu
drawCardFromDeck( J7, RaichuEnLaMano, J8),

% Jugador 1 pone una energía al Pikachu (Debe tener esa energía en la mano)
useEnergyCard( J8, Pikachu1EnJuego, EnergiaRayo, J9),

% Este predicado es un selector del juego, 
% no se pide explicitamente, pero lo requerirán para el script de pruebas
% También van a requerir un selector para obtener los Pokémon de la banca. 
gameGetActivePokemon(J9, Pikachu1EnJuego),

% Si intenta evolucionar, no se puede por ser el primer turno.
not(evolvePokemon( J9, Pikachu1EnJuego, RaichuEnLaMano, J9_2)),

% No se puede usar este ataque porque le faltan energías
not(usePokemonAttack( J9, Pikachu1EnJuego, "Bola Voltio", [ ], J9_3)),

% Jugador 1 ataca y pasa el turno al jugador 2
usePokemonAttack( J9, Pikachu1EnJuego, "Impactrueno", [ ], J10),

printGame(J9, StrJ_9),
write(StrJ_9),


% Le toca al jugador 2
% supongamos que le salió la carta entrenador "Hau"
drawCardFromDeck( J11, HauEnJuego, J12),

% Jugador 2 pone otro Voltorb en su banca.
playToBench( J12, Voltorb, J13),

% Jugador 2 usa "Hau" que le salió al inicio
useTrainerCard( J13, HauEnJuego, [ ], J14),

% jugador 2 pone una energía
useEnergyCard( J15, Voltorb1EnJuego, EnergiaRayo, J16),

% No se puede poner otra energía en el mismo turno
% Acá el voltorb se vuelve a obtener ya que en la variable 
% "Voltorb1EnJuego" está desactualizado 
gameGetActivePokemon(J16, VoltorbEnJuego1),
not(useEnergyCard( J16, VoltorbEnJuego1, EnergiaRayo, J16_2)),

% jugador 2 ataca y pasa el turno
usePokemonAttack( J16, VoltorbEnJuego1, "Bola Relámpago", [ ], J17),

printGame(J17, StrJ_17),
write(StrJ_17),

%%%%% Y acá se sigue turno tras turno...


write("\n===== FIN DEL SCRIPT =====\n").
