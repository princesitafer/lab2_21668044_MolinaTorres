:- module(tda_card_21668044_MolinaTorres, [createEnergyCard/4, createPokemonCard/13, createTrainerCard/7, isEnergyCard/1, isPokemonCard/1, isTrainerCard/1, isCard/1, getCardType/2, getCardExpansion/2, getCardNumber/2, getCardName/2, getPokemonEvolucionaDe/2, getPokemonHP/2, getPokemonTipo/2, getPokemonDebilidad/2, getPokemonResistencia/2, getPokemonCosteRetirada/2, getPokemonEsEX/2, getPokemonHabilidad/2, getPokemonAtaques/2, getTrainerTipo/2, getTrainerTexto/2, getTrainerPredicado/2]).

:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').

% tipo/1
% Hechos que enumeras lo tipos validos que puede tener un pokemon o energias
% base de conocimiento
% Entrada: atomo que representa el nombre del tipo (planta, fuego)
% Recorrido: BOOL, true si es valido, false en otro caso
tipo("Planta").
tipo("Fuego").
tipo("Agua").
tipo("Rayo").
tipo("Psiquico").
tipo("Lucha").
tipo("Oscura").
tipo("Metalica").
tipo("Hada").
tipo("Incolora").
tipo("Dragon").

% tipoTrainer/1
% define el dominio de tipos de cartas de entrenador validos
% Hechos/base de conocimientos
% Dominio: atomo que representa el tipo (objeto/partidario)
% Recorrido: booleano
tipoTrainer("objeto").
tipoTrainer("partidario").


%createEnergyCard/4
% constructorcarta de energia
% valida y construye el tda de carta
% entrada: expansion, Numero, Nombre, id.
% salidaestructura ["Energia", Expansion, Numero, Nombre].
createEnergyCard(Expansion, Numero, Nombre, Ec) :-
    tipo(Nombre),
    Ec = ["Energia", Expansion, Numero, Nombre].


% createPokemonCard/14
% constructor de una carta pokemon
% valida reglas y datos de un pokemon
% entrada: expansion, nombre, HP, tipos, ataques, debilidad, resistencia ..
%salida estructura ["Pokemon", Expansion, ...]
createPokemonCard(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques, ["Pokemon", Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques]) :-
   tipo(Tipo),
    Ps > 0,
    length(Ataques, Cantidad),
    ( 
        (Habilidad == null, Cantidad =< 3) % no tiene habilidades, entonces tiene max 3ataques
        ; 
        (Habilidad \== null, Cantidad =< 2) % tiene habilidad entonces tiene max 2 ataques
    ).


% createTrainerCard/7
% constructor de carta entrenador.
% valida carta de entrenador
% entrada: expansion, Numero, Nombre, Tipo, Texto, predicadoAsociado, resultado.
% salida: Estructura ["Entrenador", Expansion, ...]
createTrainerCard(Expansion, Numero, Nombre, Tipo, Texto, PredicadoAsociado, ["Entrenador", Expansion, Numero, Nombre, Tipo, Texto, PredicadoAsociado]) :-
    tipoTrainer(Tipo).


% --------------- PERTENENCIA ----------------


% isEnergyCard/1, isPokemonCard/1, isTrainerCard/1, isCard/1
% verifican si una lista cumple con la estructura y tipos para ser una carta valida
%entrada: lista
% salida: bool

isEnergyCard(["Energia", _, _, Nombre]) :-
    tipo(Nombre).

isPokemonCard(["Pokemon", _, _, _, _, _, TipoPoke, _, _, _, _, _, _ | _]):-
    tipo(TipoPoke).

isTrainerCard(["Entrenador", _, _, _, Tipo, _, _]) :-
    tipoTrainer(Tipo).

isCard(Carta) :-
    isEnergyCard(Carta); isPokemonCard(Carta) ; isTrainerCard(Carta).


% ----------------- SELECTORES --------------

% getCard/2, getPokemon/2, getTrainer/2
% extraen un atributo especifico de una carta dependiende de su posicion
%entrada: carta, atributo_a_sacar
%salida: valor del atributo a buscar


getCardType(Carta, Tipo) :- 
    obtenerposde(0, Carta, Tipo).

getCardExpansion(Carta, Expansion) :- 
    obtenerposde(1, Carta, Expansion).

getCardNumber(Carta, Numero) :- 
    obtenerposde(2, Carta, Numero).

getCardName(Carta, Nombre) :- 
    obtenerposde(3, Carta, Nombre).


getPokemonEvolucionaDe(Carta, EvolucionaDe) :-
    obtenerposde(4, Carta, EvolucionaDe).

getPokemonHP(Carta, HP) :-
    obtenerposde(5, Carta, HP).

getPokemonTipo(Carta, Tipo) :-
    obtenerposde(6, Carta, Tipo).

getPokemonDebilidad(Carta, Debilidad) :-
    obtenerposde(7, Carta, Debilidad).

getPokemonResistencia(Carta, Resistencia) :-
    obtenerposde(8, Carta, Resistencia).

getPokemonCosteRetirada(Carta, CosteRetirada) :-
    obtenerposde(9, Carta, CosteRetirada).

getPokemonEsEX(Carta, EsEX) :-
    obtenerposde(10, Carta, EsEX).

getPokemonHabilidad(Carta, Habilidad) :-
    obtenerposde(11, Carta, Habilidad).

getPokemonAtaques(Carta, Ataques) :-
    obtenerposde(12, Carta, Ataques).


getTrainerTipo(Carta, Tipo) :-
    obtenerposde(4, Carta, Tipo).

getTrainerTexto(Carta, Texto) :-
    obtenerposde(5, Carta, Texto).

getTrainerPredicado(Carta, Predicado) :-
    obtenerposde(6, Carta, Predicado).