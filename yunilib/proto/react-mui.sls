(library (proto react-mui)
         (export 
           CssBaseline
           Avatar
           AppBar
           Toolbar
           Typography
           Button
           Checkbox
           Chip
           Card
           CardActions
           CardContent
           CardHeader
           CardMedia
           Collapse
           Paper
           withStyles
           ;; Base react-dom components
           ReactDiv
           ReactPre
           ReactFragment
           )
         (import (yuni scheme)
                 (proto jsutil)
                 (proto reactutil))


;;
(define %material-ui/react-mui (delay-load "materialui"))

(define (%MUI str)
  (let ((base (js-ref %material-ui/react-mui str)))
   (make-react-element base)))

(define CssBaseline (%MUI "CssBaseline"))
(define Avatar (%MUI "Avatar"))
(define AppBar (%MUI "AppBar"))
(define Toolbar (%MUI "Toolbar"))
(define Typography (%MUI "Typography"))
(define Button (%MUI "Button"))
(define Checkbox (%MUI "Checkbox"))
(define Chip (%MUI "Chip"))
(define Card (%MUI "Card"))
(define CardActions (%MUI "CardActions"))
(define CardContent (%MUI "CardContent"))
(define CardHeader (%MUI "CardHeader"))
(define CardMedia (%MUI "CardMedia"))
(define Paper (%MUI "Paper"))
(define Collapse (%MUI "Collapse"))

;; Should be at react-dom
(define ReactFragment (make-react-element (yuni/js-import "ReactFragment")))
(define ReactDiv (make-react-element "div"))
(define ReactPre (make-react-element "pre"))

(define %withStyles/MUI
  (js-ref %material-ui/react-mui "withStyles"))

(define (withStyles style)
  (let ((js-proc (js-call %withStyles/MUI style)))
   (lambda (component)
     (js-call js-proc component))))
         
)
