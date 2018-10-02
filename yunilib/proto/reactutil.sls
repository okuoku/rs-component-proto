(library (proto reactutil)
         (export
           make-react-element
           make-react-class/raw
           make-react-class)
         (import (yuni scheme) (proto jsutil))
         
(define %e/make-react-element (yuni/js-import "e"))
(define %createReactClass/make-react-element
  (yuni/js-import "createReactClass"))


(define (make-react-class/raw . args)
  (js-call 
    %createReactClass/make-react-element
    (apply js-obj args)))

(define (make-react-class . args)
  (make-react-element (apply make-react-class/raw args)))

(define (make-react-element ElementBase)
  (lambda args
    (cond
      ((null? args)
       (js-call %e/make-react-element ElementBase #f))
      (else
        (apply js-call %e/make-react-element ElementBase args)))))

)
