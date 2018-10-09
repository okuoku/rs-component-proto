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
       "render" (wrap-this this
                           (let* ((props (js-ref this "props"))
                                  (classes (js-ref props "classes")))
                            (ReactPre (js-obj "className" (js-ref classes
                                                                  "logcontent"))
                                      (js-ref props "value"))))))))

(define tlcard/large
  (make-react-element
    ((withStyles 
       (js-obj "card" (js-obj "maxWidth" "350px")))
     (make-react-class/raw
       "render" (wrap-this this
                           (let* ((props (js-ref this "props"))
                                  (classes (js-ref props "classes")))
                             (Card
                               (js-obj "className" (js-ref classes "card"))
                               (CardHeader
                                 (js-obj "avatar" (Avatar #f "Q")
                                         "action" (Checkbox)
                                         "title" (js-ref props "ident")))
                               (CardContent
                                 #f
                                 (%tlcard/logdata
                                   (js-obj "value"
                                           (js-ref props "message")))))))))))

)
