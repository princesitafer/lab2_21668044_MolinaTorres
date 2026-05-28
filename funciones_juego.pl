:- module(funciones_juego, [createDeck/2]).
:- use_module("tda_card.pl").


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



createDeck(Cartas, ["baraja", Cartas]) :-
    length(Cartas, 60),                              
    verificar_limite_copias(Cartas, Cartas),         
    tiene_pokemon_basico(Cartas).