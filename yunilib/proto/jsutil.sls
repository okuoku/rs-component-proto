(library (proto jsutil)
         (export wrap-this
                 delay-load
                 )
         (import (yuni scheme))

;;

(define %thiswrap/wrap-this (yuni/js-import "thiswrap"))
(define %js-load-async/delay-load (yuni/js-import "js-load-async"))
(define (delay-load libname)
  (vector-ref
    (yuni/js-invoke/async1 %js-load-async/delay-load libname)
    0))
(define-syntax wrap-this
  (syntax-rules ()
    ((_ this form ...)
     (js-call %thiswrap/wrap-this (js-closure (lambda (this) form ...))))))
         
)
