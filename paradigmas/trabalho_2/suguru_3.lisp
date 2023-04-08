
(defstruct puzzle
    ; Números iguais representam uma mesma região
    region
    ; Entrada do programa contendo os números presentes no tabuleiro
    ; Espaços vazios são representados por zeros
    tabuleiro
)

(setq puzzle_7
    (make-puzzle
        :region (list '(0 0 0 0 1 1 1) 
                      '(0 2 2 2 3 1 1) 
                      '(4 2 2 3 3 3 5) 
                      '(4 4 4 6 3 5 5)
                      '(4 8 6 6 6 5 5)
                      '(7 8 8 6 9 9 9)
                      '(7 8 8 9 9 10 10))
        :tabuleiro (list '(3 0 2 0 0 1 2) 
                       '(0 0 0 0 0 0 0) 
                       '(0 0 0 0 0 0 5)
                       '(0 0 0 0 0 0 1)
                       '(0 0 0 0 1 0 0)
                       '(0 0 0 0 0 0 4)
                       '(0 4 0 0 0 0 0))
    )
)

; FUNÇÕES DE ACESSO A MATRIZ

; Obtem os elementos de uma linha, seja ela uma matriz de valor ou regiao
(defun getElementFromLine(lista y)
    (nth y lista)
)

; Obtem os elementos de uma matriz, seja ela uma matriz de valor ou regiao
(defun getElementFromMatrix(matrix_value x y)
    (nth y (getElementFromLine matrix_value x))
)

; Altera um valor numa posição de uma linha
(defun setValueInLine(lista value y at)
    (if (null lista)
            (list '())
        (if (= at y)
                (cons value (cdr lista))
            (cons (car lista) (setValueInLine (cdr lista) value y (+ at 1)))
        )
    )
)

; Altera um valor numa coordanada da matriz
(defun setValueInMatrix(matrix_value value x y at)
    (if (null matrix_value)
            (list '())
        (if (= x at)
                (cons (setValueInLine (car matrix_value) value y 0) (cdr matrix_value))
            (cons (car matrix_value) (setValueInMatrix (cdr matrix_value) value x y (+ at 1)))
        )
    )
)

; Obtem o maior valor encontrado na matrix + 1, visto que
; na matriz os valores começam em 0
(defun getRegionAmount(matrix_value)
    (if (null matrix_value)
            0
        (+ 1 (getMatrixMax matrix_value 0))
    )
)

; Obtem o maior número encontrado na linha
(defun getLineMax(lista maximo)
    (if (null lista)
            maximo
        (if (> (car lista) maximo)
                (getLineMax (cdr lista) (car lista))
            (getLineMax (cdr lista) maximo)
        )
    )
)

; Obtem o maior valor encontrado nas linhas da matriz
(defun getMatrixMax(matrix_value maximo)
    (if (null matrix_value)
            maximo
        (if (> (getLineMax (car matrix_value) 0) maximo)
                (getMatrixMax (cdr matrix_value) (getLineMax (car matrix_value) 0))
            (getMatrixMax (cdr matrix_value) maximo)
        )
    )
)

; Percorre a linha a fim de determinar o tamanho da linha que se encontra
(defun getLineSize(lista)
    (if (null lista)
            0
        (+ 1 (getLineSize (cdr lista)))
    )
)
; Utiliza da função anterior , para determinar o tamanho da matriz
(defun getMatrixSize(matrix_value)
    (if (null matrix_value)
            0
        (getLineSize (car matrix_value))
    )
)

; Utiliza o elemento em certa posição da matriz para acessar um vetor
(defun searchVectorWithMatrixValue(matrix_value weight_vector x y)
    (if (null matrix_value)
            -1
        (if (null weight_vector)
                -1
            (getElementFromLine weight_vector (getElementFromMatrix matrix_value x y))
        )
    )
)



; Retorna a quantidade de repetições em uma linha
(defun getLineOccurrences(lista value)
    (if (null lista)
            0
        (if (= value (car lista))
                (+ 1 (getLineOccurrences (cdr lista) value))
            (getLineOccurrences (cdr lista) value)
        )
    )
)

; Retorna a quantidade de repetições em uma matriz
(defun getMatrixOccurrences(matrix_value value)
    (if (null matrix_value)
            0
        (+ (getLineOccurrences (car matrix_value) value) (getMatrixOccurrences (cdr matrix_value) value))
    )
)

; Construtor do vetor com pesos
(defun makeSizeVector(matrix_value region_value qnt_regions)
    (if (= qnt_regions region_value)
            ()
        (cons (getMatrixOccurrences matrix_value region_value) (makeSizeVector matrix_value (+ 1 region_value) qnt_regions))
    )
)

; Obtem um vetor com o tamanho das regiões. Exemplo: 
; vetor[0] = 2, o tamanho da região 1 é 2
(defun getSizeVector(matrix_value)
    (if (null matrix_value)
            ()
        (makeSizeVector matrix_value 0 (getRegionAmount matrix_value))
    )
)

; FUNÇÕES DE VERIFICAÇÃO

; Verifica a validade de um elemento, se for válido, fará a comparaçao com dois elementos. Por fim,
; retorna um booleano
(defun inBounds(matrix_value value x y)
    (if (< x 0)
            ()
        (if (< y 0)
                ()
            (if (= x (getMatrixSize matrix_value))
                    ()
                (if (= y (getMatrixSize matrix_value))
                        ()
                    (if (= value (getElementFromMatrix matrix_value x y))
                            T
                        ()
                    )
                )
            )
        )
    )
)

; Verifica os 8 elementos adjacentes
(defun validateNeighbors(matrix_value value x y)
    (or (inBounds matrix_value value x (- y 1))
        (inBounds matrix_value value x (+ y 1))
        (inBounds matrix_value value (- x 1) y)
        (inBounds matrix_value value (+ x 1) y)
        (inBounds matrix_value value (- x 1) (- y 1))
        (inBounds matrix_value value (- x 1) (+ y 1))
        (inBounds matrix_value value (+ x 1) (- y 1))
        (inBounds matrix_value value (+ x 1) (+ y 1))
    )
)

; Verifica se um elemento se repete numa linha
(defun alreadyInRegionLine(list1 list2 region_value data_value)
    (if (and (null list1) (null list2))
            ()
        (if (and (= (car list2) region_value) (= (car list1) data_Value))
            T
            (alreadyInRegionLine (cdr list1) (cdr list2) region_value data_value)
        )
    )
)

; Verifica se um elemento se repete na matriz da região
(defun alreadyInRegionMatrix(matriz1 matriz2 region_value data_value)
    (if (and (null matriz1) (null matriz2))
            ()
        (if (alreadyInRegionLine (car matriz1) (car matriz2) region_value data_value)
                T
            (alreadyInRegionMatrix (cdr matriz1) (cdr matriz2) region_value data_value)
        )
    )
)

; Verifica se as linhas são iguais
(defun equalLines(list1 list2)
    (cond
        ((and (null list1) (null list2)) T)
        ((= (car list1) (car list2))
            (equalLines (cdr list1) (cdr list2))
        )
        (T ())
    )
)

;Compara se as Matrizes são iguais atraves da chamada da função equalLines
(defun equalMatrix(matriz1 matriz2)
    (cond 
        ((and (null matriz1) (null matriz2)) T)
        ((and (not (null matriz1)) (null matriz2)) ())
        ((and (null matriz1) (not (null matriz2))) ())
        ((equalLines (car matriz1) (car matriz2))
            (equalMatrix (cdr matriz1) (cdr matriz2))
        )
        (t ())
    )
)

; Soluciona o problema por backtracking
(defun backtrackingCaller(matrix_value region_value)
    (backtrackingMain matrix_value region_value (getSizeVector region_value) 0 0 1)
)

; Função principal responsável pelo backtracking, encaminhando
; as verificações e setando valores
; 1. Testa se o valor sendo testado é maior que o tamanho da região em que a coordenada se encontra
;    1.1 Se sim, retorna o tabuleiro
; 2. Testa se o elemento na coordenada se encaixa como solução no tabuleiro
;   2.1 Se sim, busca a linha em que a coordenada se encontra e substitui pelo número sendo testado
; 3. Testa se o elemento na coordenada é 0, ou seja, pode ser testado
;   3.1 Se sim, testa o sucessor do número que já foi testado
; 4. Caso todos esses testes falhem, avança para a próxima posição do tabuleiro
;  a critério da função backtrackingTestNewNumber
(defun backtrackingMain (inputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((> testNumber (searchVectorWithMatrixValue regionMatrix regionVector i j)) inputMatrix)
        ((backtrackingCheck inputMatrix regionMatrix i j testNumber) 
            (backtrackingFindNextPos inputMatrix (setValueInMatrix inputMatrix testNumber i j 0) regionMatrix regionVector i j testNumber)
        )
        ((= (getElementFromMatrix inputMatrix i j) 0) (backtrackingMain inputMatrix regionMatrix regionVector i j (+ testNumber 1)))
        (t (backtrackingTestNewNumber inputMatrix regionMatrix regionVector i j testNumber))
    )
)

; Checa o elemento em certa posição da matriz.
; Se for 0: elemento pode ser testado e:
; Realiza a validação dos vizinhos e checa se já existe na região especificada.
(defun backtrackingCheck(input_matriz region_matriz x y current_value)
    (if (= (getElementFromMatrix input_matriz x y) 0)
            (if (or (validateNeighbors input_matriz current_value x y) (alreadyInRegionMatrix input_matriz region_matriz (getElementFromMatrix region_matriz x y) current_value))
                ()
            T
            )
        ()
    )
)

; 1. Se está na última linha e última coluna, retorna a matriz modificada
; 2. Se está na ultima linha, volta para a primeira e passa para a próxima coluna
; 3, Caso não estiver na última linha, incrementa a coluna
; No fim desses três casos, executa a função backtrackingMain para tentar um novo número
(defun backtrackingTestNewNumber(inputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((and (= (+ i 1) (getMatrixSize inputMatrix)) (= (+ j 1) (getMatrixSize inputMatrix)))
            inputMatrix
        )
        ((= (+ i 1) (getMatrixSize inputMatrix))
            (backtrackingMain inputMatrix regionMatrix regionVector 0 (+ j 1) 1)
        )
        (t (backtrackingMain inputMatrix regionMatrix regionVector (+ i 1) j 1))
    )
)

; Testa o próximo número na coordenada especificada se as matrizes foram iguais.
; Se não, retorna a matriz modificada.
(defun backtrackingValidate (matrix inputMatrix newInputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((equalMatrix newInputMatrix matrix)
            (backtrackingMain inputMatrix regionMatrix regionVector i j (+ testNumber 1))
        )
        (t matrix)
    )
)

; Verifica se chegou no final da matriz e retorna a matriz em questão,
; caso contrário continua as verificações indo em outras direções
; 1. Se está na última linha e na última coluna, retorna a matriz modificada
; 2. Se está na última linha mas não na última coluna, testa a próxima coluna da mesma linha
; 3. Caso contrário, testa a próxima linha na mesma coluna
(defun backtrackingFindNextPos(inputMatrix newInputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((and ( = (+ i 1) (getMatrixSize inputMatrix)) (= (+ j 1) (getMAtrixSize inputMatrix)))
            newInputMatrix
        )
        ((= (+ i 1) (getMatrixSize inputMatrix))
            (backtrackingValidate (backtrackingMain newInputMatrix regionMatrix regionVector 0 (+ j 1) 1)
                                    inputMatrix
                                    newInputMatrix
                                    regionMatrix
                                    regionVector
                                    i
                                    j
                                    testNumber
            )
        )
        (t (backtrackingValidate (backtrackingMain newInputMatrix regionMatrix regionVector (+ i 1) j 1)
                                inputMatrix
                                newInputMatrix
                                regionMatrix
                                regionVector
                                i
                                j
                                testNumber
            )
        )
    )
)


; Imprime as linhas da matriz de forma mais legível
(defun printMatrix (matriz)
    (if (null matriz)
        '()
        (progn 
            (write-line (write-to-string (car matriz)))
            (printMatrix(cdr matriz))
        )
    )
)

(defun main()
    (printMatrix (backtrackingCaller (puzzle-tabuleiro puzzle_7) (puzzle-region puzzle_7)))
)

(main)
