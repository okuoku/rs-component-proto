(library (components tlstream)
         (export tlstream)
         (import (yuni scheme)
                 (proto react-mui)
                 (proto reactutil)
                 (proto jsutil)
                 (components tlcards))

(define tlstream
  (make-react-element
    ((withStyles
       (js-obj "tlstream" (js-obj "maxHeight" "100%"
                                  "overflow" "scroll"
                                  "flexDirection" "column"
                                  "width" "700px"))
       (js-obj "streamlist" (js-obj "disablePadding" "true"
                                    "dense" "true")))
     (make-react-class/raw
       "render"
       (wrap-this 
         this
         (let* ((props (js-ref this "props"))
                (classes (js-ref props "classes")))
           (let ((entries* (vector->list (js-ref props "entries"))))
            (ReactDiv
              (js-obj "className" (js-ref classes "tlstream"))
              (apply MuiList
                     (js-obj "className" (js-ref classes "streamlist"))
                     (map (lambda (prop)
                            (tlcard/large prop))
                          entries*))))))))))
         
)
