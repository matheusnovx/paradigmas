module Funcmatrizes where

{- 
    getValue
    Retorna elemento da matriz, implementando a operação matriz[i][j]
    Parametros:
        Matriz
        i = linha alvo
        j = coluna alvo
    Retorno = elemento desejado
-}
getValue::[[Int]] -> Int -> Int -> Int
getValue matrix i j = (matrix !! i) !! j

{- 
    setValue
    Muda o valor de um elemento de um vetor por outro especificado
    Parametros:
        Vetor
        value = valor a ser inserido
        target = valor a ser substituido
        coord = coordenada atual sendo checada
    Retorno = Vetor modificado
-} 
setValue::[Int] -> Int -> Int -> Int -> [Int]
setValue [] _ _ _= []
setValue (a:b) value target coord 
    | (coord == target) = value:b                                
    | otherwise = a:(setValue b value target (coord+1))

{- 
    replaceLine
    Busca uma linha para fazer mudança de valor utilizando setValue
    Parametros:
        Vetor
        value = valor a ser inserido
        i = linha a ser encontrada
        j = coluna argumento da função setValue
        coord = coordenada atual sendo checada 
    Retorno = Matriz modificada 
-}
replaceLine::[[Int]] -> Int -> Int -> Int -> Int -> [[Int]]
replaceLine [] _ _ _ _ = []
replaceLine (a:b) value i j coord 
    | (i == coord) = (setValue a value j 0):b
    | otherwise = a:(replaceLine b value i j (coord + 1))

{-  
    getRegionAmount
    Soma 1 ao valor máximo para compensar com os valores começarem em 0
    Parametros:
        Matriz
    Retorno = maior valior da matriz + 1
-}
getRegionAmount::[[Int]] -> Int
getRegionAmount [] = 0
getRegionAmount matrix = 1 + (getMatrixMax matrix 0)

{- 
    getLineMax
    Retorna maior valor em um vetor
    Parametros:
        Vetor
        max = Maior valor atual
    Retorno = maior valor do vetor
-}
getLineMax::[Int] -> Int -> Int
getLineMax [] max = max
getLineMax (a:b) max 
    | (a > max) = getLineMax b a
    | otherwise = getLineMax b max

{-  
    getMatrixMax
    Retorna maior valor em uma matriz
    Parametros:
        Matriz
        max = Maior valor atual
    Retorno = maior valor da matriz 
-}
getMatrixMax::[[Int]] -> Int -> Int
getMatrixMax [] max = max
getMatrixMax (a:b) max 
    | (getLineMax a 0 > max) = getMatrixMax b (getLineMax a 0)
    | otherwise = getMatrixMax b max

{-
    getLineSize
    Determina o tamanho do vetor
    Parametros:
        Vetor
    Retorno = Tamanho do vetor
-}
getLineSize::[Int] -> Int
getLineSize [] = 0
getLineSize (a:b) = 1 + getLineSize b

{-
    getMatrixSize
    Determina o tamanho da matriz
    Parametros:
        Matriz
    Retorno = Tamanho da matriz
-}
getMatrixSize::[[Int]] -> Int
getMatrixSize (a:b) = getLineSize a

{- 
    searchVectorWithMatrixValue
    Utiliza o elemento em certa posição da matriz para acessar um vetor
    Parametros:
        Matriz
        Vetor
        i = linha alvo
        j = coluna alvo
    Retorno = elemento na posição alvo
-}
searchVectorWithMatrixValue::[[Int]] -> [Int] -> Int -> Int -> Int
searchVectorWithMatrixValue matrix vector i j = vector !! (getValue matrix i j)

{-  
    getLineOccurrences
    Retorna quantas vezes um valor aparece em um vetor
    Parametros:
        Vetor
        value = valor a ser contado
    Retorno = número de ocorrencias
-}
getLineOccurrences::[Int] -> Int -> Int
getLineOccurrences [] _ = 0
getLineOccurrences (a:b) value 
    | (value == a) = 1 + getLineOccurrences b value
    | otherwise = getLineOccurrences b value

{-  
    getMatrixOccurrences
    Retorna quantas vezes um valor aparece em uma matriz
    Parametros:
        Vetor
        value = valor a ser contado
    Retorno = número de ocorrencias
-}
getMatrixOccurrences::[[Int]] -> Int -> Int
getMatrixOccurrences [] _ = 0
getMatrixOccurrences (a:b) value = (getLineOccurrences a value) + (getMatrixOccurrences b value)

{-
    makeSizeVector
    Inicializa um vetor com o tamanho das regiões
    Parametros:
        Matriz
        regionValue = região atual sendo analizada
        regAmount = quantidade de regiões da matriz
    Retorno = Vetor com os tamanhos das regiões
-}
makeSizeVector::[[Int]] -> Int -> Int -> [Int]
makeSizeVector matrix regionValue regAmount 
    | (regionValue == regAmount) = []
    | otherwise = (getMatrixOccurrences matrix regionValue):[] ++ (makeSizeVector matrix (regionValue+1) regAmount)

{-
    getSizeVector
    Calcula a quantidade de elementos que uma região precisa para ser completa
    Parametro:
         A matriz de regiões
    Retorno = Lista com a quantidade necessária para cada seção
-}
getSizeVector::[[Int]] -> [Int]
getSizeVector [] = []
getSizeVector matrix = do
    let x = getRegionAmount matrix
    makeSizeVector matrix 0 x

{-
    inBounds
    Checa se o valor está dentro dos limites da matriz, e
    se ele se encontra dentro dela
    Parametros:
        Matriz
        value = valor a ser validado
        i = linha alvo
        j = coluna alvo
    Retorno = Booleano resultado do teste
-}
inBounds::[[Int]] -> Int -> Int -> Int -> Bool
inBounds matrix value i j  
    | (i < 0) = False
    | (j < 0) = False
    | (i == getMatrixSize matrix) = False
    | (j == getMatrixSize matrix) = False
    | (value == (getValue matrix i j)) = True
    | otherwise = False

{-
    validateNeighbors
    Checa se há algum elemento repetido nos 8 blocos em torno de uma posição
    Parametros:
        Matriz Tabuleiro
        valor = Valor a ser inserido
        i = Linha alvo
        j = Coluna alvo
    Retorno = Booleano que indica se a posição é válida
-}
validateNeighbors::[[Int]] -> Int -> Int -> Int -> Bool
validateNeighbors matrix value i j = do
    let a = inBounds matrix value i (j-1)
    let b = inBounds matrix value i (j+1)
    let c = inBounds matrix value (i-1) j
    let d = inBounds matrix value (i+1) j
    let e = inBounds matrix value (i-1) (j-1)
    let f = inBounds matrix value (i-1) (j+1)
    let g = inBounds matrix value (i+1) (j-1)
    let h = inBounds matrix value (i+1) (j+1)
    a || b || c || d || e || f || g || h

{- 
    alreadyInRegionLine
    Checa se já existe elemento com certo valor na linha da região especificada
    Parametros:
        Vetor tabuleiro
        Vetor regiao
        regionID = região checada
        value = elemento a ser checado
    Retorno = Booleano que indica se o elemento já existe
-}
alreadyInRegionLine::[Int] -> [Int] -> Int -> Int -> Bool
alreadyInRegionLine [] [] _ _ = False
alreadyInRegionLine (a:b) (c:d) regionID value
    | (c == regionID) && (a == value) = True
    | otherwise = alreadyInRegionLine b d regionID value


{- 
    alreadyInRegionMatrix
    Checa se já existe elemento com certo valor na matriz região especificada
    Parametros:
        Matriz tabuleiro
        Matriz regiao
        regionID = região checada
        value = elemento a ser checado
    Retorno = Booleano que indica se o elemento já existe
-}
alreadyinRegionMatrix::[[Int]] -> [[Int]] -> Int -> Int -> Bool
alreadyinRegionMatrix [] [] _ _ = False
alreadyinRegionMatrix (a:b) (c:d) regionID value 
    | (alreadyInRegionLine a c regionID value ) = True
    | otherwise = alreadyinRegionMatrix b d regionID value

{- 
    equalLines
    Checa se os vetores são iguais
    Parametros:
        Vetor
        Vetor
    Retorno = Resultado do teste
-}
equalLines::[Int] -> [Int] -> Bool
equalLines [] [] = True
equalLines (a:b) (c:d) 
    | (a == c) = equalLines b d
    | otherwise = False

{- 
    equalMatrix
    Checa se as matrizes são iguais
    Parametros:
        Matrizes
        Matrizes
    Retorno = Resultado do teste
-}
equalMatrix::[[Int]] -> [[Int]] -> Bool
equalMatrix [] [] = True
equalMatrix [] _ = False
equalMatrix _ [] = False
equalMatrix (a:b) (c:d) 
    | (equalLines a c) = equalMatrix b d
    | otherwise = False