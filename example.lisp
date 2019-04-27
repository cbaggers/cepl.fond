
;;------------------------------------------------------------

(defvar *font* nil)
(defvar *some-text* nil)

(defun setup ()
  (setf *font*
        (make-fond-font #p"/home/baggers/Downloads/Roboto-Regular(2).ttf"
                        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ .!?"))
  (setf *some-text*
        (make-fond-text *font* "Here it is!")))


(defun test-draw-text (text-obj)
  (let ((res (viewport-resolution (current-viewport)))
        (extent (v! 0f0 0f0 (x res) (y res))))
    (clear)
    (fond-draw-simple *some-text* extent)
    (swap)
    text-obj))
