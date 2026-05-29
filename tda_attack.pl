:- module(tda_attack, [createAttack/6, isAttack/1, getAttackCosto/2, getAttackNombre/2, getAttackDesc/2, getAttackDano/2, getAttackPredicado/2]).

:- use_module('funciones_complementarias.pl').

createAttack(Costo, Nombre, Descripcion, Dano, Predicado, ["Ataque", Costo, Nombre, Descripcion, Dano, Predicado]).

isAttack(["Ataque", _, _, _, _, _]).


getAttackCosto(Ataque, Costo) :- 
    obtenerposde(1, Ataque, Costo).


getAttackNombre(Ataque, Nombre) :- 
    obtenerposde(2, Ataque, Nombre).


getAttackDesc(Ataque, Descripcion) :- 
    obtenerposde(3, Ataque, Descripcion).


getAttackDano(Ataque, Dano) :- 
    obtenerposde(4, Ataque, Dano).


getAttackPredicado(Ataque, Predicado) :- 
    obtenerposde(5, Ataque, Predicado).

