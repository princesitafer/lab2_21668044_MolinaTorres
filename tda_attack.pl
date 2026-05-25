:- use_module("funciones_complementarias.pl").

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