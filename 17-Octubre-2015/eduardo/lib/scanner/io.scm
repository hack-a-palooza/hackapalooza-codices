;;; -*- coding: utf-8; mode: scheme -*-
;;; 2015 Eduardo Acuña Yeomans
;;;
;;; scanner
;;; =======
;;;
;;; input/output
;;; ------------

(define (scanner-open-from-port port)
  ;; scanner-open-from-port : port -> scanner
  (if (input-port? port)
      (make-scanner port)
      (error "scanner-open-from-port: not an input port" port)))

(define (scanner-open-from-file filename)
  ;; scanner-open-from-file : string -> scanner
  (define port (open-input-file filename))
  (scanner-open-from-port port))

(define (scanner-open-from-string string)
  ;; scanner-open-from-string : string -> port
  (define port (open-input-string string))
  (scanner-open-from-port port))
