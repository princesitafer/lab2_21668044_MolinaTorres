:- module(funciones_complementarias, [obtenerposde/3, contar_ataques/2]).

primero([Primero|_], Primero).
noprimero([_|Resto], Resto).

obtenerposde(0, U, Retorno) :-     
    primero(U, Retorno).  

obtenerposde(Pos, U, Retorno) :- 
    Pos > 0, 
    PosAux is Pos - 1, 
    noprimero(U, Resto), 
    obtenerposde(PosAux, Resto, Retorno).


contar_ataques([], 0).
contar_ataques([_|Resto], Cantidad) :-
    contar_ataques(Resto, CantResto),
    Cantidad is CantResto + 1.