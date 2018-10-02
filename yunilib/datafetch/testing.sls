(library (datafetch testing)
         (export prepare-testdata
                 testdata-head
                 testdata-ref
                 testdata-refnext
                 )
         (import (yuni scheme)
                 (datafetch fetcher))

;;

(define BASEURL "http://localhost:9999")

(define MASTERREF #f)
(define REFCOUNT 0)
(define REPOSITORY-REFS (js-obj))
(define REPOSITORY-LINKS (js-obj))

(define (testdata-head) MASTERREF)
(define (testdata-ref x) (ref-read x))
(define (testdata-refnext x) 
  (let ((r (js-ref REPOSITORY-LINKS x)))
   (if (js-undefined? r) #f r)))

(define (REQ-history ref)
  (let* ((r (do-fetch (string-append BASEURL "/mainhistory")
                      (list (cons 'from ref)
                            (cons 'count 100))))
         (res (js-ref r "result")))
    (let ((l (js-array->list res)))
     l)))

(define (CALC-heads)
  (let* ((r (do-fetch (string-append BASEURL "/heads")))
         (res (js-ref r "result")))
    (let ((l (js-array->list res)))
     (for-each (lambda (e)
                 (let ((name (js-ref e "name"))
                       (ref (js-ref e "ref")))
                   (PCK (list 'NAME: name 'REF: ref))
                   (when (string=? name "refs/heads/master")
                     (set! MASTERREF ref))))
               l))))

(define (ref-register! refname obj)
  (js-set! REPOSITORY-REFS refname obj))

(define (ref-read refname)
  (let ((r (js-ref REPOSITORY-REFS refname)))
   (if (js-undefined? r)
     #f
     r)))

(define (ref-link! from to)
  (let ((r (js-ref REPOSITORY-LINKS from)))
   (if (js-undefined? r)
     (js-set! REPOSITORY-LINKS from to)
     (begin
       (unless (string=? to r)
         (PCK (list 'INVALID-LINK r from '=> to)))
       (js-set! REPOSITORY-LINKS from to)))))

(define (fill-refs/recursive! ref)
  (define need-continue? #f)
  (define hit-known? #f)
  (define branch-queue '())
  (PCK (list 'ENTER: ref))
  (let* ((l (REQ-history ref))
         (len (length l)))
    (PCK (list 'HISTORY-LEN: len))
    (when (<= 100 len)
      (set! need-continue? #t))
    (let loop ((cur (car l))
               (q (cdr l)))
      ;; Process cur
      (let ((ident (js-ref cur "ident")))
       (let ((i (and (not (string=? ident ref)) (ref-read ident))))
        (cond
          (i (set! hit-known? #t))
          (else
            (ref-register! ident cur) 
            (let ((branches (js-array->list (js-ref cur "rest_parents"))))
             (set! branch-queue (append branch-queue branches))))))
       (cond
         ((null? q)
          (when need-continue?
            (PCK (list 'CONTINUE: ident))
            (set! branch-queue (cons ident branch-queue))))
         ((not hit-known?)
          (ref-link! ident (js-ref (car q) "ident"))
          (loop (car q) (cdr q)))
         (else
           (ref-link! ident (js-ref (car q) "ident"))
           (PCK (list 'MERGED: ident))
           'do-nothing))))
    (PCK (list 'NEXT: branch-queue))
    ;; FIXME: Why can't be a for-each?
    (for-each fill-refs/recursive! branch-queue)))

(define (prepare-testdata)
  (CALC-heads)
  (when MASTERREF
    (fill-refs/recursive! MASTERREF)))



)
