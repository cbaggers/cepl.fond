;;;; cepl.fond.example.asd

(asdf:defsystem #:cepl.fond.example
  :description "Simple example for how to use cl-fond via cepl.fond"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "BSD 2 Clause"
  :serial t
  :depends-on (#:cepl.sdl2
               #:rtg-math
               #:rtg-math.vari
               #:cepl.fond)
  :components ((:file "example/example")))
