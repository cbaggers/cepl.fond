;;;; package.lisp

(defpackage #:cepl.fond
  (:use :cl :cepl :vari)
  (:export :fond-vertex
           :fond-pipeline
           :fond-font
           :fond-text
           :make-fond-font
           :make-fond-text
           :update-fond-text
           :fond-draw-simple))
