(library (testdata)
         (export gen-testdata/left)
         (import (yuni scheme))

         
(define (gen-one idx)
  (js-obj "ident" (string-append "i" (number->string idx))
          "author" "TestPerson"
          "message" (string-append 
                      (number->string idx)
                      ": " "Testteststest\n\ntesttesttesttesttest\n")))

(define (gen-testdata/left)
  (reverse 
    (map (lambda (idx) (gen-one idx))
         (iota 100 1234 3))))
         
)
