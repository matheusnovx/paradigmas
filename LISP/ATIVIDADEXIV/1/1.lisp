(defun main()
    (write-line (write-to-string ((lambda(x y) (if (= x y) 0 1)) 1 0)))
)

(main)