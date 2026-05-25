:- use_module("funciones_complementarias.pl").

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


createEnergyCard(Expansion, Numero, Nombre, Ec) :-
    tipo(Nombre),
    Ec = ["Energia", Expansion, Numero, Nombre].

createPokemonCard(Expansion, Numero, Nombre, HP, TipoPoke, Etapa, Evolucion, ListaAtaques, ["Pokemon", Expansion, Numero, Nombre, HP, TipoPoke, Etapa, Evolucion, ListaAtaques]) :-
    tipo(TipoPoke).

% --------------- PERTENENCIA ----------------

isEnergyCard(["Energia", _, _, Nombre]) :-
    tipo(Nombre).

isPokemonCard(["Pokemon", _, _, _, _, TipoPoke, _, _, _]):-
    tipo(TipoPoke).

isCard(Carta) :-
    isEnergyCard(Carta).
isCard(Carta) :-
    isPokemonCard(Carta).

% ----------------- SELECTORES --------------

getCardType(Carta, Tipo) :- 
    obtenerposde(0, Carta, Tipo).

getCardExpansion(Carta, Expansion) :- 
    obtenerposde(1, Carta, Expansion).

getCardNumber(Carta, Numero) :- 
    obtenerposde(2, Carta, Numero).

getCardName(Carta, Nombre) :- 
    obtenerposde(3, Carta, Nombre).



 getPokemonHP(Carta, HP) :-
    obtenerposde(4, Carta, HP).


getPokemonTipo(Carta, TipoPoke) :-
    obtenerposde(5, Carta, TipoPoke).


getPokemonEtapa(Carta, Etapa) :-
    obtenerposde(6, Carta, Etapa).


getPokemonEvolucion(Carta, Evolucion) :-
    obtenerposde(7, Carta, Evolucion).

getPokemonAtaques(Carta, ListaAtaques) :-
    obtenerposde(8, Carta, ListaAtaques).