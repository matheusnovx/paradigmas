(defun main()
    (write-line (write-to-string ((lambda(x y z) (if (>= (+ x y z) 18) "Aprovado" "Nao")) 6 6 6)))
)

(main)