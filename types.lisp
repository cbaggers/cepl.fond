(in-package :cepl.fond)

;;------------------------------------------------------------

(defstruct (fond-font (:constructor %make-font))
  (font (error "missing font") :type cl-fond:font)
  (sampler (error "missing sampler") :type sampler))

(defstruct (fond-text (:constructor %make-text))
  (varr (error "missing varr") :type gpu-array)
  (iarr (error "missing iarr") :type gpu-array)
  (stream (error "missing stream") :type buffer-stream)
  (font (error "missing font") :type fond-font))

;;------------------------------------------------------------
