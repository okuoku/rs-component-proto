(library (components tlstream)
         (export make-tlstream)
         (import (yuni scheme)
                 (proto react-mui)
                 (proto reactutil)
                 (proto jsutil)
                 (components tlcards))

;; 
;; TLSTREAM ITEM(TLITEM):
;; 
;;  (rev "ident" . REVDATA*)
;;  (subheader "ident" "subject")
;;  (more "ident" . PARAM) :: "More" button
;;
;;  REVDATA:
;;   (revname "alternative revname")
;;   (author "author string")
;;   (date "date string")
;;   (message "message string")
;;
;; TLSTREAM EVENTS:
;; 
;;  (init)
;;  (more "ident" . PARAM) => ITEM* / (#f . Message)
;;  (action "ident" ACTION)
;;    ACTION = #t (main action) / "action idents"
;;  (link "ident" "revname parameters")
;;  (datetag YYYY MM DD)
;;
         
(define (rev->prop rev)
  (let ((r (js-obj "ident" "INVALID"
                   "author" "???"
                   "message" "???"
                   "date" "???")))
    (js-set! r "ident" (cadr rev))
    (js-set! r "revname" (cadr rev))
    (for-each (lambda (p) 
                (case (car p)
                  ((revname) (js-set! r "revname" (cdr p)))
                  ((author) (js-set! r "author" (cdr p)))
                  ((message) (js-set! r "message" (cdr p)))
                  ((date) (js-set! r "date" (cdr p)))) )
              (cddr rev))
    r))

(define (revdate x)
  (let ((r (assq 'datetag x)))
   (and r (cdr r))))

(define (filter-datetag rev*)
  (define curdate #f)
  (let loop ((cur '())
             (q rev*))
    (if (null? q)
      (reverse cur)
      (let ((a (car q))
            (d (cdr q)))
        (if (eq? 'rev (car a))
          (let ((date (revdate (cddr a))))
           (PCK 'REVDATE a '=> date)
           (cond
             ((and curdate (equal? curdate date))
              (loop (cons a cur) d))
             (else
               (set! curdate date)
               (loop (cons a (cons (cons 'datetag date) cur)) d))))
          (loop (cons a cur) d))))))


(define (make-tlstream cmd)
  (define init-sent? #f)
  (make-react-element
    ((withStyles
       (js-obj "tlstream" (js-obj "maxHeight" "100%"
                                  "overflow" "scroll"
                                  "flexDirection" "column"
                                  "width" "700px"))
       (js-obj "streamlist" (js-obj "disablePadding" "true"
                                    "dense" "true")))
     (make-react-class/raw
       "getInitialState" (wrap-this this (js-obj "theState" #f))
       "componentDidMount"
       (wrap-this
         this
         (let ()
          (define (init-cb entries*)
            (js-invoke this "setState" 
                       (js-obj "theState" entries*)))
          (cmd '(init) init-cb)))
       "render"
       (wrap-this 
         this
         (let* ((props (js-ref this "props"))
                (state (js-ref (js-ref this "state") "theState"))
                (classes (js-ref props "classes")))

           (define (init-cb entries*)
             (js-invoke this "setState" 
                        (js-obj "theState" entries*)))

           (cond
             ((not state)
              "Init...")
             (else
               (let ((entries* (filter-datetag state)))
                (ReactDiv
                  (js-obj "className" (js-ref classes "tlstream"))
                  (apply MuiList
                         (js-obj "className" (js-ref classes "streamlist"))
                         (map (lambda (obj)
                                (case (car obj)
                                  ((rev)
                                   (tlcard/large (rev->prop obj)))
                                  ((more)
                                   (tlmorebutton/action 
                                     (lambda () 
                                       (PCK 'ONL)
                                       (cmd obj init-cb))))
                                  ((datetag)
                                   (ListSubheader
                                     (js-obj "inset" #t
                                             "disableGutters" #t)
                                     (let ((Y (number->string (cadr obj)))
                                           (M (number->string (caddr obj)))
                                           (D (number->string (cadddr obj))))
                                       (string-append Y "/" M "/" D))))
                                  (else "Something wrong")))
                              entries*))))))))))))
)
