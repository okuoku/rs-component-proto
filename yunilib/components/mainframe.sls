(library (components mainframe)
         (export mainframe)
         (import (yuni scheme)
                 (components tlcards)
                 (components cmdbar)
                 (testdata)
                 (proto reactutil)
                 (proto jsutil))

;;

(define dat (gen-testdata/left))

(define mainframe
  (make-react-element
    ((withStyles (js-obj 
                   "screen" (js-obj "height" "100vh"
                                    "overflow" "hidden"
                                    "display" "flex"
                                    "flexDirection" "column")
                   "upper" (js-obj "height" "36px")
                   "lower" (js-obj "overflow" "scroll")))
     (make-react-class/raw
       "render" (wrap-this this
                           (let* ((props (js-ref this "props"))
                                  (classes (js-ref props "classes")))
                             (ReactDiv 
                               (js-obj "className" (js-ref classes "screen"))
                               (ReactDiv (js-obj "className"
                                                 (js-ref classes "upper"))
                                         (cmdbar))
                               (ReactDiv (js-obj "className" 
                                                 (js-ref classes "lower"))
                                         (apply ReactDiv
                                                #f
                                                (map (lambda (prop) 
                                                       (tlcard/large prop))
                                                     dat))))))))))
         
)
