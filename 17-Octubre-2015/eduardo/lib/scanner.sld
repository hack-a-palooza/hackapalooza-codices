(define-library (scanner)
  (import (scheme base)
	  (scheme lazy)
	  (scheme file))
  (export
   make-scanner
   scanner-open-from-file
   scanner-open-from-string
   scanner-open-from-port

   scanner-read
   scanner-next)
  (include "./scanner/primitives.scm")
  (include "./scanner/io.scm"))
