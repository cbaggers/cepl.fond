# cepl.fond

A simple library for working with cl-fond with CEPL.

To run the example:

```
CL-USER> (ql:quickload :cepl.fond.example)
CL-USER> (in-package :cepl.fond.example)
EXAMPLE> (cepl:repl)
EXAMPLE> (setup)

;; now each time you run (test-draw-text) it will
;; draw the text to the screen.

;; To try changing the text run (test-change-text)
```

The example uses `cepl.sdl2` and `rtg-math` but neither are required to use `cepl.fond`
