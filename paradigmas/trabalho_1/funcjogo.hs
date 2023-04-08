module Funcjogo where

import Funcmatrizes
import Tabuleiros

{-
    backtrackingCaller
    Começa a resolução do suguru chamando as funções apropriadas
    Parametros:
        Tabuleiro
    Retorno:
        Tabuleiro resolvido
-}
backtrackingCaller::[[Int]] -> [[Int]]
backtrackingCaller matrix = do
    let regionMatrix = region (getMatrixSize matrix)
    let sizeVector = getSizeVector regionMatrix
    backtrackingMain matrix regionMatrix sizeVector 0 0 1

{-
    backtrackingMain
    1. Testa se o valor sendo testado é maior que o tamanho da região em que a coordenada se encontra
        1.1 Se sim, retorna o tabuleiro
    2. Testa se o elemento na coordenada se encaixa como solução no tabuleiro
        2.1 Se sim, busca a linha em que a coordenada se encontra e substitui pelo número sendo testado
    3. Testa se o elemento na coordenada é 0, ou seja, pode ser testado
        3.1 Se sim, testa o sucessor do número que já foi testado
    4. Caso todos esses testes falhem, avança para a próxima posição do tabuleiro
        a critério da função backtrackingTestNewNumber
    Parametros:
        Tabuleiro
        Matriz de regiões
        Vetor de tamanhos
        i = linha
        j = coluna
        testNumber = número a ser testado
-}
backtrackingMain::[[Int]] -> [[Int]] -> [Int] -> Int -> Int -> Int-> [[Int]]
backtrackingMain inputMatrix regionMatrix regionVector i j testNumber 
    | (testNumber > ((searchVectorWithMatrixValue regionMatrix regionVector i j))) = 
        inputMatrix                                                                
    | (backtrackingCheck inputMatrix regionMatrix i j testNumber) = do
        let newInputMatrix = 
                            replaceLine inputMatrix 
                                        testNumber 
                                        i
                                        j
                                        0
        backtrackingFindNextPos inputMatrix 
                                newInputMatrix 
                                regionMatrix 
                                regionVector 
                                i 
                                j 
                                testNumber
    | ((getValue inputMatrix i j) == 0) = 
        backtrackingMain    inputMatrix 
                            regionMatrix 
                            regionVector 
                            i 
                            j 
                            (testNumber+1) 
    | otherwise = 
        backtrackingTestNewNumber   inputMatrix 
                                    regionMatrix 
                                    regionVector 
                                    i 
                                    j 
                                    testNumber
                                    
{-
    backtrackingCheck
    Checa o elemento em certa posição da matriz.
    Se for 0: elemento pode ser testado e:
    Realiza a validação dos vizinhos e checa se já existe na região especificada.
    Parametros:
        Tabuleiro
        Matriz de regiões
        i = linha
        j = coluna
        testNumber = número sendo testado
-}
backtrackingCheck::[[Int]] -> [[Int]] -> Int -> Int -> Int -> Bool
backtrackingCheck inputMatrix regionMatrix i j testNumber 
    | ((getValue inputMatrix  i j) == 0) = do
        if  (validateNeighbors inputMatrix testNumber i j) 
            || (alreadyinRegionMatrix inputMatrix regionMatrix 
                (getValue regionMatrix i j) testNumber) 
        then
            False
        else
            True
    | otherwise = False

{-
    backtrackingTestNewNumber
    1. Se está na última linha e última coluna, retorna a matriz modificada
    2. Se está na ultima linha, volta para a primeira e passa para a próxima coluna
    3, Caso não estiver na última linha, incrementa a coluna
    No fim desses três casos, executa a função backtrackingMain para tentar um novo número
    Parametros:
        Tabuleiro
        Matriz de regiões
        Vetor de tamanhos
        i = linha
        j = coluna
        testNumber = numero sendo testado
-}
backtrackingTestNewNumber::[[Int]] -> [[Int]] -> [Int] -> Int -> Int -> Int-> [[Int]]
backtrackingTestNewNumber inputMatrix regionMatrix regionVector i j testNumber    
    | ((i+1) == getMatrixSize inputMatrix) && ((j+1) == getMatrixSize inputMatrix) = 
        inputMatrix
    | ((i+1) == getMatrixSize inputMatrix) = 
        backtrackingMain    inputMatrix 
                            regionMatrix 
                            regionVector 
                            0 
                            (j+1) 
                            1
    | otherwise = 
        backtrackingMain    inputMatrix 
                            regionMatrix 
                            regionVector 
                            (i+1) 
                            j 
                            1

{-
    backtrackingValidate
    Testa o próximo número na coordenada especificada se as matrizes foram iguais.
    Se não, retorna a matriz modificada.
    Parametros:
        Tabuleiro proposto
        Tabuleiro original
        Tabuleiro modificado
        Matriz de regiões
        Vetor de tamanhos
        i = linha
        j = coluna
        testNumber = número sendo testado
    Retorno = Matriz Modificada
-}
backtrackingValidate::[[Int]] -> [[Int]] -> [[Int]] -> [[Int]] -> [Int] -> Int -> Int -> Int-> [[Int]]
backtrackingValidate matrix inputMatrix newInputMatrix regionMatrix regionVector i j testNumber   
    | (equalMatrix newInputMatrix matrix) = 
        backtrackingMain    inputMatrix 
                            regionMatrix 
                            regionVector 
                            i 
                            j 
                            (testNumber+1) 
    | otherwise = 
        matrix

{-
    backtrackingFindNextPos
    1. Se está na última linha e na última coluna, retorna a matriz modificada
    2. Se está na última linha mas não na última coluna, testa a próxima coluna da mesma linha
    3. Caso contrário, testa a próxima linha na mesma coluna
    Parametros:
        Tabuleiro
        Tabuleiro modificado
        Matriz de regiões
        Vetor de tamanhos
        i = linha
        j = coluna
        testNumber = número sendo testado
-}
backtrackingFindNextPos::[[Int]] -> [[Int]] -> [[Int]] -> [Int] -> Int -> Int -> Int-> [[Int]]
backtrackingFindNextPos inputMatrix newInputMatrix regionMatrix regionVector i j testNumber 
    | ((i+1) == getMatrixSize inputMatrix) && ((j+1) == getMatrixSize inputMatrix) = 
        newInputMatrix
    | ((i+1) == getMatrixSize inputMatrix) = 
        backtrackingValidate    (backtrackingMain newInputMatrix regionMatrix regionVector 0 (j+1) 1)
                                inputMatrix 
                                newInputMatrix 
                                regionMatrix 
                                regionVector 
                                i 
                                j 
                                testNumber
    | otherwise = 
        backtrackingValidate    (backtrackingMain newInputMatrix regionMatrix regionVector (i+1) j 1)
                                inputMatrix 
                                newInputMatrix 
                                regionMatrix 
                                regionVector 
                                i 
                                j 
                                testNumber