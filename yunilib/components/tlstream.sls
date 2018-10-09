(library (components tlstream)
         (export tlstream)
         (import (yuni scheme)
                 (proto reactutil)
                 (proto jsutil)
                 (components tlcards))

(define tlstream
  (make-react-element
    ((withStyles
       (js-obj "tlstream" (js-obj "maxHeight" "100%"
                                  "overflow" "scroll"
                                  "flexDirection" "column"
                                  "width" "350px")))
     (make-react-class/raw
       "render"
       (wrap-this 
         this
         (let* ((props (js-ref this "props"))
                (classes (js-ref props "classes")))
           (let ((entries* (vector->list (js-ref props "entries"))))
            (ReactDiv
              (js-obj "className" (js-ref classes "tlstream"))
              (apply ReactDiv
                     #f
                     (map (lambda (prop)
                            (tlcard/large prop))
                          entries*))))))))))
         
)
