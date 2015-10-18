;;; -*- coding: utf-8; mode: scheme -*-
;;; 2015 Eduardo Acuña Yeomans
;;;
;;; scanner
;;; =======
;;;
;;; primitives
;;; ----------

(define (make-scanner port)
  ;; make-scanner : textual-input-port -> scanner
  (let first-char ((char (read-char port)))
    (if (eof-object? char)
	(delay (cons char '()))
	(delay (cons char (first-char (read-char port)))))))

(define (scanner-read scanner)
  ;; scanner-read : scanner -> character
  (car (force scanner)))

(define (scanner-next scanner)
  ;; scanner-next : scanner -> scanner
  (cdr (force scanner)))
