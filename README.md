# cepl.fond

A simple library for working with cl-fond with CEPL.

## Example

To run the example:

```
CL-USER> (ql:quickload :cepl.fond.example)
CL-USER> (in-package :cepl.fond.example)
EXAMPLE> (cepl:repl)
EXAMPLE> (setup)

;; now each time you run (test-draw-text) it will
;; draw the text to the screen.

;; To try changing the text run (test-change-text)
;; and then run (test-draw-text) again
```

The example uses `cepl.sdl2` and `rtg-math` but neither are required to use `cepl.fond`

## Expected Usage

Whilst `#'make-fond-font`, `#'make-fond-text` and `#'update-fond-text` are intended to be used as-is, it is impossible to pick an approach to rendering the text that will be perfect for all projects. Therefore it is recommended that as soon as `#'fond-draw-simple` does not meet your needs that you copy that function and the pipeline into your own project and modify it to your own desires there.
