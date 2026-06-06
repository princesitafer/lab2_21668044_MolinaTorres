:- module(tda_card_21668044_MolinaTorres, [createEnergyCard/4, createPokemonCard/13, createTrainerCard/7, isEnergyCard/1, isPokemonCard/1, isTrainerCard/1, isCard/1, getCardType/2, getCardExpansion/2, getCardNumber/2, getCardName/2, getPokemonEvolucionaDe/2, getPokemonHP/2, getPokemonTipo/2, getPokemonDebilidad/2, getPokemonResistencia/2, getPokemonCosteRetirada/2, getPokemonEsEX/2, getPokemonHabilidad/2, getPokemonAtaques/2, getTrainerTipo/2, getTrainerTexto/2, getTrainerPredicado/2]).

:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').

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


tipoTrainer("objeto").
tipoTrainer("partidario").


createEnergyCard(Expansion, Numero, Nombre, Ec) :-
    tipo(Nombre),
    Ec = ["Energia", Expansion, Numero, Nombre].

createPokemonCard(Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques, ["Pokemon", Expansion, Numero, Nombre, EvolucionaDe, Ps, Tipo, Debilidad, Resistencia, CosteRetirada, EsEX, Habilidad, Ataques]) :-
   tipo(Tipo),
    Ps > 0,
    length(Ataques, Cantidad),
    ( 
        (Habilidad == null, Cantidad =< 3) % no tiene habilidades, entonces tiene max 3ataques
        ; 
        (Habilidad \== null, Cantidad =< 2) % tiene habilidad entonces tiene max 2 ataques
    ).

createTrainerCard(Expansion, Numero, Nombre, Tipo, Texto, PredicadoAsociado, ["Entrenador", Expansion, Numero, Nombre, Tipo, Texto, PredicadoAsociado]) :-
    tipoTrainer(Tipo).


% --------------- PERTENENCIA ----------------

isEnergyCard(["Energia", _, _, Nombre]) :-
    tipo(Nombre).

isPokemonCard(["Pokemon", _, _, _, _, _, TipoPoke, _, _, _, _, _, _]):-
    tipo(TipoPoke).

isTrainerCard(["Entrenador", _, _, _, Tipo, _, _]) :-
    tipoTrainer(Tipo).

isCard(Carta) :-
    isEnergyCard(Carta); isPokemonCard(Carta) ; isTrainerCard(Carta).

% ----------------- SELECTORES --------------

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