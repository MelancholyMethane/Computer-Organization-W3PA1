.data
arr:
	.asciiz "zero", "First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth",		# 48 - 57
		"*", "*", "*", "*", "*", "*", "*", "Alpha", "Bravo", "China",						# 58 - 67
		"Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mary",			# 68 - 77
		"November", "Oscar", "Paper", "Quebec", "Research", "Sierra", "Tango", "Uniform", "Victor", "Whisky",	# 78 - 87
		"X-ray", "Yankee", "Zulu", "*", "*", "*", "*", "*", "*", "alpha",					# 88 - 97
		"bravo", "china", "delta", "echo", "foxtrot", "golf", "hotel", "india", "juliet", "kilo",		# 98 - 107
		"lima", "mary", "november", "oscar", "paper", "quebec", "research", "sierra", "tango", "uniform", 	# 108 - 117
		"victor", "whisky", "x-ray", "yankee", "zulu"								# 118 - 122
offset:
	.word	0, 5, 11, 18, 24, 31, 37, 43, 51, 58, 64, 66, 68, 70, 72, 74, 76, 78, 84, 90, 96, 102, 107, 115, 120,
		126, 132, 139, 144, 149, 154, 163, 169, 175, 182, 191, 198, 204, 212, 219, 226, 232, 239, 244, 246,
		248, 250, 252, 254, 256, 262, 268, 274, 280, 285, 293, 298, 304, 310, 317, 322, 327, 332, 341, 347,
		353, 360, 369, 376, 382, 390, 397, 404, 410, 417, 422
line:
	.asciiz	"\n"
nan:
	.asciiz	"\n*\n"

.text
main:
	li	$v0, 12			# read char
	syscall				# implement
	beq 	$v0, '?', exit
	
	sub	$t0, $v0, 122		# t0 = v0 - 122
	bgt	$t0, $zero, outofrange	# t0 > 0 (v0 > 122)
	
	sub	$t0, $v0, 48		# t0 = v0 - 48
	blt	$t0, $zero, outofrange	# t0 < 0 (v0 < 48)
	
	# \n before printing the response
	la	$a0, line
	li	$v0, 4
	syscall
	
	# char in $v0 must be within 48 - 122 now
	la	$a0, arr		# let a0 the start addr. of arr
	la	$s0, offset		# let s0 the start addr. of offset
	sll 	$t0, $t0, 2		# 4 bytes per word
	add	$s1, $s0, $t0		# s1 = &s0[t0] 
	lw	$s2, ($s1)		# s2 = *s1
	add	$a0, $a0, $s2		# a0 += offset
	li	$v0, 4			# print string
	syscall
	la	$a0, line		# \n at the end
	syscall
	j	main

outofrange:
	la	$a0, nan
	li	$v0, 4
	syscall
	j	main
	
exit:
	la	$a0, line
	li	$v0, 4
	syscall
	
