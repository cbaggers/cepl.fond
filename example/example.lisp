(defpackage #:cepl.fond.example
  (:use :cl :cepl :cepl.fond :rtg-math))
(in-package :cepl.fond.example)

;;------------------------------------------------------------

(defvar *font* nil)
(defvar *some-text* nil)

(defun setup ()
  (setf *font*
        (make-fond-font
         (asdf:system-relative-pathname :cepl.fond.example
                                        "./example/Roboto-Regular.ttf")
         "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ .!?"))
  (setf *some-text*
        (make-fond-text *font* "Here it is!")))

(defun test-change-text ()
  (update-text *some-text* "Woooooo!"))

(defun test-draw-text ()
  (let* ((res (viewport-resolution (current-viewport)))
         (extent (v! 0f0 0f0 (x res) (y res))))
    (clear)
    (fond-draw-simple *some-text* extent)
    (swap)
    *some-text*))
