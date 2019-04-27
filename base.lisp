(in-package :cepl.fond)

;;------------------------------------------------------------

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
    (update-fond-text obj text)
    obj))

(defun update-fond-text (text-obj text-str)
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
    (unbind-hack)
    text-obj))

(defun unbind-hack ()
  ;; as we call out to a lib that effects gl state we need to invalidate
  ;; CEPL's context cache. However what sucks is that CEPL doesnt have a
  ;; proper way to do that so we have this ugliness
  ;;
  ;; we dont need GL_TEXTURE_2D as we only track binding of samplers
  (with-cepl-context (ctx)
    (cepl.context::%with-cepl-context-slots
        (vao-binding-id array-of-bound-gpu-buffers)
        ctx
      (setf vao-binding-id 0)
      (setf (aref array-of-bound-gpu-buffers #.(cepl.context::buffer-kind->cache-index :array-buffer)) nil)
      (setf (aref array-of-bound-gpu-buffers #.(cepl.context::buffer-kind->cache-index :element-array-buffer)) nil)))
  (values))

;;------------------------------------------------------------
