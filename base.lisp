(in-package :cepl.fond)

;;------------------------------------------------------------

(defstruct-g fond-vertex
  (position :vec2)
  (in-tex-coord :vec2))

(defun-g calc-text-uvs ((position :vec2)
                        (in-tex-coord :vec2)
                        (extent :vec4))
  (vec4 (* 2 (/ (+ (x position) (x extent))
                (- (z extent) 1.0)))
        (* 2 (/ (- (y position) (y extent))
                (+ (w extent) 1.0)))
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
  (let ((intensity (x (texture tex-image tex-coord))))
    (* (vec4 intensity) text-color)))

(defpipeline-g fond-pipeline ()
  (tvert fond-vertex)
  (tfrag :vec2))

;;------------------------------------------------------------

(defstruct (fond-font (:constructor %make-font))
  (font (error "missing font") :type texture)
  (sampler (error "missing sampler") :type sampler))

(defstruct (fond-text (:constructor %make-text))
  (varr (error "missing varr") :type gpu-array)
  (iarr (error "missing iarr") :type gpu-array)
  (stream (error "missing stream") :type buffer-stream)
  (font (error "missing font") :type fond-font))

(defun make-fond-font (file charset)
  (let* ((font (cl-fond:make-font file charset))
         (sampler (sample
                   (make-texture-from-id (cl-fond:texture font)
                                         :base-dimensions '(? ?)
                                         :element-type :rgba8))))
    (%make-font :font font :sampler sampler)))

(defun make-fond-text (font &optional (text ""))
  (check-type text string)
  (check-type font fond-font)
  (let* ((varr (make-gpu-array nil :dimensions 1 :element-type 'fond-vertex))
         (iarr (make-gpu-array nil :dimensions 1 :element-type :uint))
         (stream (make-buffer-stream varr :index-array iarr))
         (obj (%make-text :varr varr :iarr iarr :stream stream :font font)))
    (if text
        (update-text obj text))
    obj))

(defun update-text (text-obj text-str)
  (let* ((font (fond-font-font (fond-text-font text-obj)))
         (vbuff (gpu-array-buffer (fond-text-varr text-obj)))
         (ibuff (gpu-array-buffer (fond-text-iarr text-obj)))
         (new-len (cl-fond:update-text
                   font
                   text-str
                   (gpu-buffer-id vbuff)
                   (gpu-buffer-id ibuff))))
    (setf (buffer-stream-length (fond-text-stream text-obj))
          new-len)
    text-obj))

(defun unbind-hack ()
  ;; as we call out to a lib that effects gl state we need to invalidate
  ;; CEPL's context cache. However what sucks is that CEPL doesnt have a
  ;; proper way to do that so we have this ugliness
  ;;
  ;; we dont need GL_TEXTURE_2D as we only track binding of samplers
  (with-cepl-context (ctx)
    (cepl.context::%with-cepl-context-slots (vao-binding-id) ctx
      ))
  GL_ARRAY_BUFFER
  GL_ELEMENT_ARRAY_BUFFER
  vao
  GL_FRAMEBUFFER
  )

(defun fond-draw-simple (text-obj extent-v4 &optional (color (v! 1 1 1 1)))
  (check-type text-obj fond-text)
  (check-type extent-v4 (simple-array single-float (4)))
  (let ((sampler (fond-font-sampler (fond-text-font text-obj))))
    (map-g #'fond-pipeline (fond-text-stream text-obj)
           :extent extent-v4
           :tex-image sampler
           :text-color color)))
