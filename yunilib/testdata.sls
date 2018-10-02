(library (testdata)
         (export gen-testdata/left)
         (import (yuni scheme)
                 (datafetch testing))
         
(define (gen-one ref)
  (let* ((x (testdata-ref ref))
         (ident (js-ref x "ident"))
         (author (js-ref x "author"))
         (message (js-ref x "message")))
    (js-obj "ident" (substring ident 0 10)
            "author" author
            "message" message)))

(define (gen-spine)
  (ensure-testdata!)
  ;; Generate spine
  (let loop ((next (testdata-head))
             (cur '()))
    (let ((nn (testdata-refnext next)))
     (if nn
       (loop nn (cons next cur))
       (reverse cur)
       ))))

(define (gen-testdata/left)
  (let ((l (gen-spine)))
   (PCK (list 'LOGLENGTH: (length l)))
   (map gen-one l)))

(define testdata-available #f)
(define (ensure-testdata!)
  (unless testdata-available
    (prepare-testdata)
    (set! testdata-available #t)))
         
)
