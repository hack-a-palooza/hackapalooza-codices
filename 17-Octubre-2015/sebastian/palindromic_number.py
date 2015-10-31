n1 = 900
n2 = 900
pn = 0
d1 = 0
d2 = 0
d3 = 0
d4 = 0
d5 = 0
d6 = 0

while pn != 998001:
	if n1 == 999:
		n1 = 900
		if n2 < 1000:		
			n2 += 1
	pn = n1 * n2
	d1 = pn // 100000
	d2 = (pn % 100000) // 10000
	d3 = ((pn % 100000) % 10000) // 1000
	d4 = (((pn % 100000) % 10000) % 1000) // 100
	d5 = ((((pn % 100000) % 10000) % 1000) % 100) // 10
	d6 = ((((pn % 100000) % 10000) % 1000) % 100) % 10
		
	if d1 == d6 and d2 == d5 and d3 == d4:
		print "the first factor is: ", n1
		print "the second factor is: ", n2
		print "the palindromic number is: ", pn

	n1 += 1
	
		
