(in-package :cepl.fond)

;;------------------------------------------------------------

(defstruct-g fond-vertex
  (position :vec2)
  (in-tex-coord :vec2))

;;------------------------------------------------------------

;; custom accessors as at the time of writing varjo didnt
;; have a proper accessor..which is mad, but I guess most
;; folks using varjo have been using rtg-math too.
(v-def-glsl-template-fun v-x (a) "~a.x" (:vec2) :float :pure t)
(v-def-glsl-template-fun v-y (a) "~a.y" (:vec2) :float :pure t)
(v-def-glsl-template-fun v-x (a) "~a.x" (:vec4) :float :pure t)
(v-def-glsl-template-fun v-y (a) "~a.y" (:vec4) :float :pure t)
(v-def-glsl-template-fun v-z (a) "~a.z" (:vec4) :float :pure t)
(v-def-glsl-template-fun v-w (a) "~a.w" (:vec4) :float :pure t)

;;------------------------------------------------------------

(defun-g calc-text-uvs ((position :vec2)
                        (in-tex-coord :vec2)
                        (extent :vec4))
  (vec4 (* 2 (/ (+ (v-x position) (v-x extent))
                (- (v-z extent) 1.0)))
        (* 2 (/ (- (v-y position) (v-y extent))
                (+ (v-w extent) 1.0)))
        0.0
        1.0))

(defun-g tvert ((text-info fond-vertex) &uniform (extent :vec4))
  (with-slots (position in-tex-coord) text-info
    (values
     (calc-text-uvs position in-tex-coord extent)
     in-tex-coord)))

(defun-g tfrag ((tex-coord :vec2)
                &uniform
                (tex-image :sampler-2d)
                (text-color :vec4))
  (let ((intensity (v-x (texture tex-image tex-coord))))
    (* (vec4 intensity) text-color)))

(defpipeline-g fond-pipeline ()
  (tvert fond-vertex)
  (tfrag :vec2))

;;------------------------------------------------------------

(defun fond-draw-simple (text-obj extent-v4
                         &optional (color (make-array 4 :element-type 'single-float :initial-element 1f0)))
  (check-type text-obj fond-text)
  (check-type extent-v4 (simple-array single-float (4)))
  (check-type color (simple-array single-float (4)))
  (let ((sampler (fond-font-sampler (fond-text-font text-obj))))
    (map-g #'fond-pipeline (fond-text-stream text-obj)
           :extent extent-v4
           :tex-image sampler
           :text-color color)))

;;------------------------------------------------------------
