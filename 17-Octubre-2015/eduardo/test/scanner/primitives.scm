(define snr (make-scanner (open-input-string "HAL")))

(and (or (equal? (scanner-read snr)
		 #\H)
	 (error "test failed at scanner-read #\H !="
		(scanner-read snr)))
     (or (equal? (scanner-read (scanner-next snr))
		 #\A)
	 (error "test failed at scanner-read #\A !="
		(scanner-read (scanner-next snr))))
     (or (equal? (scanner-read (scanner-next (scanner-next snr)))
		 #\L)
	 (error "test failed at scanner-read #\L !="
		(scanner-read (scanner-next (scanner-next snr)))))
