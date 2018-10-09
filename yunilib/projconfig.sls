(library (projconfig)
         (export 
           PROJHEAD?
           BASEURL)
         (import (yuni scheme))

;; API Config
(define (BASEURL) "http://127.0.0.1:9999")

;; Project Config

; <List> of target branches
(define projmainhead "refs/heads/master")
(define projheads*
  (cons projmainhead 
        '("refs/tags/0.8")))

; Library
(define (PROJHEAD? x) 
  (member x projheads*))
(define (PROJMAINHEAD? x) (equal? x projmainhead))
         
)
