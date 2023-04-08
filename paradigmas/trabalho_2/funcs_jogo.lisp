(defun backtrackingCaller (matrix)
    (setq regionMatrix regioes)
    (setq sizeVector (getSizeVector regionMatrix))
    (backtrackingMain matrix regionMatrix sizeVector 0 0 1)
)

(defun backtrackingMain (inputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((> testNumber (searchVectorWithMatrixValue regionMatrix regionVector i j)) inputMatrix)
        ((backtrackingCheck inputMatrix regionMatrix i j testNumber) 
            (progn
                (setq newInputMatrix (replaceline inputMatrix testNumber i j))
                (backtrackingFindNextPos inputMatrix newInputMatrix regionMatrix regionVector i j testNumber)
            )
        ((= (aref inputMatrix i j) 0) backtrackingMain inputMatrix regionMatrix regionVector i j (+ testNumber 1))
        (t backtrackingTestNewNumber inputMatrix regionMatrix regionVector i j testNumber)
    )
)

(defun backtrackingCheck (inputMatrix regionMatrix i j testNumber)
    (cond
        ((= (aref inputMatrix i j) 0)
            (progn
                (if (or (validateNeighbors inputMatrix testNumber i j)
                         (alreadyInRegionMatrix inputMatrix regionMatrix (aref regionMatrix i j) testNumber))
                    NIL
                    t
                )
            )
        )
        (t NIL)
    )
)

(defun backtrackingTestNewNumber(inputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((and (= (+ i 1) (getMatrixSize inputMatrix)) (= (+ j 1) (getMatrixSize inputMatrix)))
            inputMatrix
        )
        ((= (+ i 1) (getMatrixSize inputMatrix))
            (backtrackingMain inputMatrix regionMatrix regionVector 0 (+ j 1) 1)
        )
        (t backtrackingMain inputMatrix regionMatrix regionVector (+ i 1) j 1)
    )
)

(defun backtrackingValidate (matrix inputMatrix newInputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((equalMatrix newInputMatrix matrix)
            (backtrackingMain inputMatrix regionMatrix regionVector i j (+ testNumber 1))
        )
        (t matrix)
    )
)

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
        (t backtrackingValidate (backtrackingMain newInputMatrix regionMatrix regionVector (+ i 1) j 1)
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