 :- use_module(library(clpfd)).

% Filtra os elementos de um vetor mapeado,
% os valores são numeros naturais e o valor -1, que significa que uam verificação
% encontrou um elemento invalido que deve ser corrigido

%Retorna true se o elemento atual for diferente de -1.

filtro(Retorno) :- (number(Retorno) -> Retorno =\= -1; true).

% Verifica se um elemento já está presente numa região, utilizando Ids para fazer a verificação
% Se o elemento da matriz de região for igual
% ao ID da região retorna o elemento da matriz de entrada
% caso contrario retorna -1.
checkIfInRegion(RegionID,InputValue,RegionID,InputValue).
checkIfInRegion(RegionID,InputValue,RegionValue,-1).

% Transforma as entradas em um vetor correspondente a região por meio de
% restrições e verifica se todos os elementos do vetor resultante são diferntes
getValuesFromRegion(InputVector,RegionVector,RegionID) :-
    maplist(checkIfInRegion(RegionID),InputVector,RegionVector, MapReturn),
    include(filtro, MapReturn, FilterReturn),
    all_distinct(FilterReturn).

% Restringe os valores dos elementos do suguru de acordo com a matriz de limites
maxValueTuple(InputValue, LimitValue) :-
    InputValue in 1..LimitValue.

%Recebe a matriz de entrada como input, percorre duplas de linhas
%e chama a função alreadyInRegionLine para cada dupla de linhas.
%Como exemplo, formam blocos de linhas:
%[A,B], [B,C], [C,D]... A segunda linha da dupla é a primeira linha
%da proxima dupla.

alreadyInRegionMatrix([]).
alreadyInRegionMatrix([_]).
alreadyInRegionMatrix([N1,N2|Na]) :- alreadyInRegionLine(N1, N2), alreadyInRegionMatrix([N2|Na]).

%Recebe duas linhas sequenciais da matriz de entrada como input.
%Define que os 2 primeiros elementos de cada linha tenham valores diferentes.
%Como exemplo, sejam as linhas P = [A,B,C] e Q = [D,E,F]:
%Os blocos [A,B,D,E], [B,C,E,F] terão valores diferentes.

alreadyInRegionLine([],[]).
alreadyInRegionLine([N1,N2], [N3,N4]) :- all_distinct([N1,N2,N3,N4]).
alreadyInRegionLine([N1,N2|Na], [N3,N4|Nb]) :- all_distinct([N1,N2,N3,N4]), alreadyInRegionLine([N2|Na], [N4|Nb]).


% Imprime a matriz
printMatrix([]).
printMatrix([H|T]) :- write(H), nl, printMatrix(T).

% Resolve o problema utilizando uma notação de três matrizes para o tabuleiro do Suguru.
% Usando restrições, ele obtem os possiveis valores para solucionar o puzzle.

% A matriz de região delimita os tectons(ou regiões) do puzzle, onde os valores precisam ser diferentes
% A matriz de limites é utilizada para definir o maior valor possível
%A matriz de entrada são os valores iniciais do puzzle

solucao(InputMatrix, RegionMatrix, LimitMatrix) :-
    %Transforma as matrizes em uma listas comuns
    append(InputMatrix, InputVector),
    append(RegionMatrix, RegionVector),
    Regiao = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21],
    maplist(getValuesFromRegion(InputVector,RegionVector), Regiao),
    maplist(maplist(maxValueTuple), InputMatrix, LimitMatrix),
    alreadyInRegionMatrix(InputMatrix),

    printMatrix(InputMatrix), !.


% Exemplo de um suguru 8x8
entrada8([[_,_,_,3,_,_,2,_],
         [4,_,_,_,_,_,_,_],
         [_,2,_,_,_,_,_,_],
         [_,1,5,_,_,1,5,_],
         [_,2,_,_,_,_,_,_],
         [_,_,_,_,4,_,_,4],
         [_,_,_,_,_,3,_,_],
         [_,5,_,_,_,5,_,_]]).


regiao8([[0,0,0,3,4,4,5,5],
         [0,2,2,3,4,4,5,5],
         [2,2,3,3,4,6,6,5],
         [2,7,7,3,8,8,6,6],
         [10,10,7,7,8,9,9,6],
         [11,10,10,7,8,13,9,9],
         [11,11,10,12,8,13,13,9],
         [11,11,12,12,12,12,13,13]]).

limites8([[4,4,4,5,5,5,5,5],
    [4,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5],
    [5,5,5,5,5,5,5,5]]).
