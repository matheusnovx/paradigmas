 :- use_module(library(clpfd)).

tabuleiro([[_,_,_,3,_,_,2,_],
         [4,_,_,_,_,_,_,_],
         [_,2,_,_,_,_,_,_],
         [_,1,5,_,_,1,5,_],
         [_,2,_,_,_,_,_,_],
         [_,_,_,_,4,_,_,4],
         [_,_,_,_,_,3,_,_],
         [_,5,_,_,_,5,_,_]]).


regiao([[0,0,0,3,4,4,5,5],
         [0,2,2,3,4,4,5,5],
         [2,2,3,3,4,6,6,5],
         [2,7,7,3,8,8,6,6],
         [10,10,7,7,8,9,9,6],
         [11,10,10,7,8,13,9,9],
         [11,11,10,12,8,13,13,9],
         [11,11,12,12,12,12,13,13]]).

limites([[4,4,4,5,5,5,5,5],
    [4,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5]]).

%FUNÇÕES AUXILIARES
add(X,[],[X]).
add(X,[H|T],[H|T2]) :- X > H, add(X,T,T2).
add(X,[H|T],[X,H|T]) :- X =< H.

ordenacao([],[]).
ordenacao([H|T],LResultado) :- ordenacao(T,LResultadoCauda), add(H,LResultadoCauda,LResultado).

ultimo([X], X).
ultimo([H,H2|T], X) :- ultimo([H2|T],X).

maior([],0).
maior(L, X) :- ordenacao(L, R), ultimo(R,X).

% Filtra os elementos de um vetor mapeado,
% os valores são numeros naturais e o valor -1, que significa que uam verificação
% encontrou um elemento invalido que deve ser corrigido

%Retorna true se o elemento atual for diferente de -1.

validateNumber(Retorno) :- (number(Retorno) -> Retorno =\= -1; true).

% Verifica se um elemento já está presente numa região, utilizando Ids para fazer a verificação
% Se o elemento da matriz de região for igual
% ao ID da região retorna o elemento da matriz de entrada
% caso contrario retorna -1.
checkIfInRegion(RegionID,InputValue,RegionID,InputValue).
checkIfInRegion(RegionID,InputValue,RegionValue,-1).

% Transforma as entradas em um vetor correspondente a região por meio de
% restrições e verifica se todos os elementos do vetor resultante são diferntes
getValuesFromRegion(InputVector,RegionVector,RegionID) :-
    maplist(checkIfInRegion(RegionID),InputVector,RegionVector, FoundElement),
    include(validateNumber, FoundElement, ValidResult),
    all_distinct(ValidResult).

% Restringe os valores dos elementos do suguru de acordo com a matriz de limites
checkIfInDomain(InputValue, LimitValue) :-
    InputValue in 1..LimitValue.

%Chama a função checkIfDifferentLine duas linhas de cada vez.

checkIfDifferentMatrix([]).
checkIfDifferentMatrix([_]).
checkIfDifferentMatrix([A,B|T]) :- checkIfDifferentLine(A, B), checkIfDifferentMatrix([B|T]).

%Checa se os elementos de blocos 2x2 são diferentes para determinar
%se a matriz foi preenchida corretamente.
%Acaba funcionado como uma checagem 3x3 já que tem overlap de linhas.

checkIfDifferentLine([],[]).
checkIfDifferentLine([A,B], [C,D]) :- all_distinct([A,B,C,D]).
checkIfDifferentLine([A,B|T1], [C,D|T2]) :- all_distinct([A,B,C,D]), checkIfDifferentLine([B|T1], [D|T2]).


% Imprime a matriz
printMatrix([]).
printMatrix([H|T]) :- write(H), nl, printMatrix(T).

% Resolve o problema utilizando uma notação de três matrizes para o tabuleiro do Suguru.
% Usando restrições, ele obtem os possiveis valores para solucionar o puzzle.

% A matriz de região delimita os tectons(ou regiões) do puzzle, onde os valores precisam ser diferentes
% A matriz de limites é utilizada para definir o maior valor possível
%A matriz de entrada são os valores iniciais do puzzle

solucao(InputMatrix, RegionMatrix, LimitMatrix) :-
    append(InputMatrix, InputVector),
    append(RegionMatrix, RegionVector),

    maior(RegionVector, Maxi),
    numlist(0,Maxi,Regiao),

    maplist(getValuesFromRegion(InputVector,RegionVector), Regiao),
    maplist(maplist(checkIfInDomain), InputMatrix, LimitMatrix),
    checkIfDifferentMatrix(InputMatrix),

    printMatrix(InputMatrix), !.
