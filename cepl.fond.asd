;;;; cepl.fond.asd

(asdf:defsystem #:cepl.fond
  :description "A smaller helper library for working with cl-fond using CEPL"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "BSD 2 Clause"
  :serial t
  :depends-on (#:cl-fond #:cepl)
  :components ((:file "package")
               (:file "base")))
