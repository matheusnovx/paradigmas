:- use_module(library(clpfd)).
:- initialization(main).

%swipl -q -s sudoku.pl

% Inicia a lista vazia e seta os valores depois que acaba a recursão.
blocks([], [], []).
% Define que ela será iniciada com 3 valores e as caudas terão Ns1, Ns2 e Ns3
% sendo que todos os valores serão distintos.
blocks( [N1,N2,N3|Ns1],
        [N4,N5,N6|Ns2],
        [N7,N8,N9|Ns3]) :-
	all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
	% Chama blocks paras as caudas
	% Define que cada uma das 3 linhas terão 3 colunas.
	blocks(Ns1, Ns2, Ns3).

% Validação dos operadores
validacao([],[]).
validacao([S1,S2,S3|T], [Op1,Op2|TT]) :- 
	% Como o operador ja é uma função por si só, chama-se ele pra verificar se os valores
	% são ou não maiores/menores que os outros
	call(Op1,S1,S2),
	call(Op2,S2,S3),
	% Por fim, é utilizando a mesma lógica do blocks, as caudas são retornadas.
	validacao(T,TT).


main:- 
% % Exemplo 11
% 	% Operadores da matriz normal do puzzle
% 	Operadores = [	[#<, #>, #<, #<, #>, #>],
% 					[#<, #<, #<, #>, #>, #<],
% 					[#<, #<, #<, #>, #>, #<],
% 					[#>, #>, #>, #<, #<, #>],
% 					[#>, #<, #>, #<, #>, #>],
% 					[#<, #>, #<, #>, #>, #<],
% 					[#<, #>, #>, #>, #<, #>],
% 					[#>, #<, #>, #<, #<, #<],
% 					[#<, #>, #<, #<, #<, #>]],
	
% 	% Operadores da matriz transposta
% 	OpTransp = [	[#>, #<, #>, #>, #>, #<],
% 					[#<, #<, #<, #<, #>, #<],
% 					[#<, #<, #<, #<, #>, #>],
% 					[#>, #<, #>, #<, #<, #>],
% 					[#>, #>, #>, #<, #>, #>],
% 					[#>, #>, #>, #>, #>, #<],
% 					[#<, #>, #<, #>, #<, #>],
% 					[#>, #>, #>, #>, #<, #<],
% 					[#<, #>, #<, #>, #<, #>]],


% % Exemplo 100
% 	Operadores = [	[#>, #<, #>, #>, #>, #<],
% 					[#>, #<, #>, #<, #<, #>],
% 					[#<, #<, #<, #>, #<, #<],
% 					[#<, #>, #<, #>, #<, #>],
% 					[#<, #>, #>, #<, #<, #>],
% 					[#<, #<, #>, #>, #>, #>],
% 					[#<, #<, #<, #>, #<, #<],
% 					[#>, #>, #>, #<, #>, #<],
% 					[#>, #>, #<, #>, #>, #<]],

% Exemplo 190
	% Operadores da matriz normal do puzzle
	Operadores = [	[#<, #>, #<, #<, #>, #>],
					[#>, #<, #<, #<, #>, #<],
					[#>, #<, #>, #<, #>, #<],
					[#<, #>, #>, #<, #<, #>],
					[#<, #>, #>, #<, #<, #>],
					[#<, #>, #>, #>, #>, #<],
					[#>, #<, #<, #<, #>, #<],
					[#>, #>, #>, #>, #<, #>],
					[#>, #>, #<, #>, #<, #<]],
	
	% Operadores da matriz transposta
	OpTransp = [	[#<, #>, #>, #<, #<, #>],
					[#>, #<, #<, #>, #>, #>],
					[#>, #<, #<, #>, #>, #<],
					[#>, #<, #>, #<, #<, #>],
					[#<, #>, #>, #<, #<, #<],
					[#<, #>, #>, #>, #>, #<],
					[#>, #<, #<, #>, #<, #<],
					[#<, #<, #>, #>, #<, #<],
					[#<, #<, #<, #<, #>, #<]],

	% Cria uma matriz com tamanho 9 e com listas dentro dela
	length(P, 9), maplist(same_length(P),P),
	append(P, Ns), Ns ins 1..9,
	
	% Valida-se todos os valores de forma recursiva
	maplist(validacao, P, Operadores),


	% Faz-se a transposição da matriz normal do puzzle, armazenando a trasnposta em Q
	transpose(P, Q),

	% Valida-se todos os valores novamente, mas com a transposta dessa vez
	maplist(validacao, Q, OpTransp),

	% Cria as listas com todos os valores diferentes, para garantir que seja 
	% resolvido o sudoku 
	maplist(all_distinct, Q),
	maplist(all_distinct, P),

	% Define os blocos de 3 linhas pra cada bloco
	P = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
	blocks(As, Bs, Cs), 
	blocks(Ds, Es, Fs), 
	blocks(Gs, Hs, Is),

    maplist(label, P),

	% Print da saída 
	maplist(portray_clause, P).