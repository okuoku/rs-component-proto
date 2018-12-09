(library (components tlcards)
         (export
           tlcard/large)
         (import (yuni scheme)
                 (proto react-mui)
                 (proto reactutil)
                 (proto jsutil))

         
;;

(define %tlcard/logdata
  (make-react-element
    ((withStyles
       (js-obj "logcontent" (js-obj "whiteSpace" "pre-wrap")))
     (make-react-class/raw
       "render" 
       (wrap-this this
                  (let* ((props (js-ref this "props"))
                         (classes (js-ref props "classes")))
                    (Collapse (js-obj "collapsedHeight" "10px"
                                      "in" (js-ref props "expand"))
                              (ReactPre (js-obj "className" 
                                                (js-ref classes "logcontent"))
                                        (js-ref props "value")))))))))

(define (checkbox/action initial act) 
  (Checkbox 
    (js-obj "onChange" (js-closure (lambda (event checked) (act checked)))
            "checked" initial)))

(define tlcard/revid
  (make-react-element
    ((withStyles
       (js-obj 
         "revid" (js-obj "padding" "2px"
                         "font-size" "60%")
         "revnumber" (js-obj "font-weight" "bold")))
     (make-react-class/raw
       "render"
       (wrap-this
         this
         (let* ((classes (js-ref (js-ref this "props") "classes")))
          (Typography
            (js-obj "className" (js-ref classes "revid"))
            (ReactSpan
              (js-obj "className" (js-ref classes "revnumber"))
              "r12345")
            " - "
            "Anonymous"
            " "
            "00:00:00+0900")))))))

(define tlcard/large
  (make-react-element
    ((withStyles 
       (js-obj "tlitem" (js-obj "flexDirection" "column")))
     (make-react-class/raw
       "getInitialState" (wrap-this this (js-obj "logexpand" #t))
       "render" 
       (wrap-this 
         this
         (let* ((props (js-ref this "props"))
                (state (js-ref this "state"))
                (logexpand (js-ref state "logexpand"))
                (classes (js-ref props "classes"))
                (logdata (%tlcard/logdata
                           (js-obj 
                             "expand" logexpand
                             "value" (js-ref props "message")))))
           (define (change b)
             (js-invoke this "setState" (js-obj "logexpand" b)))
           (ListItem
             (js-obj "className" (js-ref classes "tlitem")
                     "alignItems" "flex-start"
                     "button" #t
                     "dense" #t
                     ;"selected" "true"
                     "divider" #t)
             (ListItemSecondaryAction
               #f
               (checkbox/action logexpand change))
             (ReactDiv #f logdata) 
             ;; FIXME: Pass props.ident
             (tlcard/revid #f))))))))

)
