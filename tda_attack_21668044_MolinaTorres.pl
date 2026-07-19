:- module(tda_attack_21668044_MolinaTorres, [createAttack/6, isAttack/1, getAttackCosto/2, getAttackNombre/2, getAttackDesc/2, getAttackDano/2, getAttackPredicado/2]).

:- use_module('funciones_complementarias_21668044_MolinaTorres.pl').


% createAttack/6
%construye una lista con datos de ataque asociados a un pokemon
%  entrada: Costo, Nombre, Descripcion, Dano, Predicado, LISTA.
% SALIDa: lista con datos del ataque

createAttack(Costo, Nombre, Descripcion, Dano, Predicado, ["Ataque", Costo, Nombre, Descripcion, Dano, Predicado]).



%isAttack/1
% verifica si es un ataque valido
% entrada: lista
% salida: booleano
isAttack(["Ataque", _, _, _, _, _]).


% Predicados: getAttack---/2
% selectores para extraer atributos especificos de un ataque.
%entrada: Ataque, valor_buscado
%salida: valor del atributo buscado

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

