		.data
return:				.word	0

@ Print String
p_string:			.asciz	"%s"
p_char:				.asciz	"%c"
p_2char:			.asciz	"%c%c"
p_num_s:			.asciz	"%u "
p_num_s1:			.asciz	"> %u\n"
p_num_s2:			.asciz	">> %u\n"
p_newline:			.asciz	"\n"

@ Game String
s_title:			.asciz  "\n             /`·.¸\n            /¸...¸`:·\n        ¸.·´  ¸   `·.¸.·´)\n       : © ):´;      ¸  {\n       `·.¸ `·  ¸.·´\\`·¸)\n           `\\\\´´\\¸.·´\n   _____         ______ _     _\n  / ____|       |  ____(_)   | |\n | |  __  ___   | |__   _ ___| |__\n | | |_ |/ _ \\  |  __| | / __| '_ \\\n | |__| | (_) | | |    | \\__ \\ | | |\n  \\_____|\\___/  |_|    |_|___/_| |_|\n\nDeveloped by Natchapon Santiphiboon 60010285\nThis Project is for Computer Organization and Assembly Language Subject at KMITL\n"

s_name_player1:		.asciz	"YOU "
s_name_player2:		.asciz	"COM1"
s_name_player3:		.asciz	"COM2"
s_name_player4:		.asciz	"COM3"

s_game_info1:		.asciz	"\n--------------Game Info--------------\nCard(s) left in pool: %d\n     Book(s)         Hand\n%s %-15s "
s_game_info2:		.asciz	"\n%s %-15s %-2d Card(s)"

s_game_over1:		.asciz	"\n\nNo card in pool. GAME OVER!\n=====================================\n"
s_game_over2_1:		.asciz	"              %s wins!"
s_game_over2_2:		.asciz	"         %s and %s win!"
s_game_over2_3:		.asciz	"       %s, %s and %s win!"
s_game_over2_4:		.asciz	"            Nobody wins :("
s_game_over3:		.asciz	"\n=====================================\n"

s_game_turn:		.asciz	"\n\n|== %s turn ==|"

s_game_start:		.asciz	"\nStarting Game..."

s_turn_start:		.asciz	"\n\nRandomize starting player...\n>%s goes first!"

s_card_call:		.asciz	"\n%s call %s for %cs."
s_card_get:			.asciz	"\nGets %d %cs from %s."
s_card_nope:		.asciz	"\n%s has no %cs. Go fish!"
s_card_catch:		.asciz	"\n%s Catches %c from the pool. Lucky!"
s_card_draw:		.asciz	"\n%s Fishes a card from the pool."
s_card_draws:		.asciz	"\n%s Fishes %c from the pool."
s_card_nodraw:		.asciz	"\nNo cards left in the pool to draw!"
s_card_noleft:		.asciz	"\n%s has no cards left. Draws %d card(s) from the pool."
s_card_nodeck:		.asciz	"\n%s has no cards left. No cards left in the pool to draw!"

s_book_get:			.asciz	"\n%s Gets a book of four %cs."

s_input_card:		.asciz	"\nSelect face to call (2,3,4,5,6,7,8,9,T,J,Q,K,A) (0 for random) : "
s_input_player3:	.asciz	"\nSelect player to call (1,2) (0 for random) : "
s_input_player4:	.asciz	"\nSelect player to call (1,2,3) (0 for random) : "

s_invalid_input:		.asciz	"\nInvalid Input!"
s_invalid_cardh:	.asciz	" No face in hand!"

s_player_set:		.asciz	"\nSet amount of player (2-4) : "

@ Game Data
d_player_count:		.word	4

d_card_face:		.asciz	"23456789TJQKA"
d_card_deck:		.asciz	"22223333444455556666777788889999TTTTJJJJQQQQKKKKAAAA"
d_card_deck_count:	.word	51

d_player_hand:		.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"
					.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"
					.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"
					.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"
d_player_book:		.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"
					.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"
					.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"
					.asciz	"\0\0\0\0\0\0\0\0\0\0\0\0\0"

@ Scanf Buffer
b_scanf_w1:			.word	0
b_scanf_w2:			.word	0

		.text
		.global main
		.global printf
		.global scanf
		.global srand
		.global time
		.global rand
main:
		@ Start Program
		ldr	r1, =return
		str	lr, [r1]
		
		@ Set up rand
		mov r0, #0
		bl  time
		bl  srand

		@ Game =============================================
		
		@ Print title
		ldr r0, =s_title
		bl  printf
		
		@ Set player count
m_sp_loop:
		ldr r0, =s_player_set
		bl  printf
		
		ldr	r0, =p_2char
		ldr	r1, =b_scanf_w1
		ldr r2, =b_scanf_w2
		bl	scanf
		
		@ Input Char
		ldr r1, =b_scanf_w1
		ldrb r1, [r1]
		
		@ Check Input
		cmp r1, #49
		bls m_sp_no
		
		cmp r1, #53
		bhs m_sp_no
		
		@ Set Value
		sub r1, #48
		ldr r0, =d_player_count
		str r1, [r0]
		b   m_sg
m_sp_no:
		ldr r0, =s_invalid_input
		bl	printf
		b   m_sp_loop
m_sg:
		@ Start Game
		ldr r0, =s_game_start
		bl  printf
		
		bl  game_deck_suff
		bl  game_deal_card
		bl  game_print_info
		
		@ Random Start Player
		ldr r10, =d_player_count  @ r10 = Player Count
		ldr r10, [r10]
		sub r1, r10, #1
		bl  util_rand
		mov r4, r0		@ r4 = Player Turn
		
		@ Print who goes first
		ldr r0, =s_turn_start
		mov r1, #5
		mul r2, r4, r1
		ldr r1, =s_name_player1
		add r1, r1, r2
		bl  printf
		
		@ Main Game Loop
gl_loop:
		@ Game end if no card in deck
		ldr r0, =d_card_deck_count
		ldr r0, [r0]
		cmp r0, #-1
		ble gl_end
		
		@ Print Turn
		ldr r0, =s_game_turn
		mov r1, #5
		mul r2, r4, r1
		ldr r1, =s_name_player1
		add r1, r1, r2
		bl  printf
		
		@ Play turn
		mov r1, r4
		bl  game_com_play
		
		@ Next Player Turn
		add r4, r4, #1
		cmp r4, r10
		moveq r4, #0
		
		b   gl_loop
		
gl_end:
		@ Game Over
		bl game_print_info
		
		ldr r0, =s_game_over1
		bl  printf
		
		bl util_print_winner
		
		ldr r0, =s_game_over3
		bl  printf
		
		@ Game =============================================
exit:
		@ Exit
		ldr	lr, =return
		ldr	lr, [lr]
		bx	lr
		
@ == Game Function ==
@ Player play (Player = r1) <<<<<<<<<<
game_com_play:
		push {lr}
		push {r4-r6}
		mov r4, r1
		
		@ (r4 = Player, r5 = Call Face, r6 = Call Player)
		
		@ Start of turn
g_cp_start:
		@ Check for empty hand
		mov r1, r4
		bl  util_card_noleft
		cmp r0, #0
		beq g_cp_exit
		
		@ If player turn, print game info
		cmp r4, #0
		bleq game_print_info
		
		@ Player or COM
		cmp r4, #0
		bne g_cp_rf
		
g_cp_in_fa:
		@ Input face to call
		ldr	r0, =s_input_card
		bl	printf
		
		ldr	r0, =p_2char
		ldr	r1, =b_scanf_w1
		ldr r2, =b_scanf_w2
		bl	scanf
		
		@ Input Char
		ldr r1, =b_scanf_w1
		ldrb r1, [r1]
		
		@ Random?
		cmp r1, #48
		beq g_cp_rf
		
		@ Check for invalid input
		bl util_in_face
		cmp r0, #-1
		ble g_cp_in_fa
		mov r5, r0
		
		b   g_cp_ps
		
		@ Random face to call
g_cp_rf:
		mov r1, r4
		bl util_face_count
		sub r1, r0, #1
		bl util_rand
		mov r1, r4
		mov r2, r0
		bl util_card_pos
		mov r5, r0
		
g_cp_ps:
		@ Player or COM
		cmp r4, #0
		bne g_cp_rp
		
		@ 1v1?
		ldr r0, =d_player_count
		ldr r0, [r0]
		cmp r0, #2
		moveq r6, #1
		beq g_cp_cont
		
g_cp_in_ps:
		@ Input player to call
		ldr r0, =d_player_count
		ldr r0, [r0]
		cmp r0, #3
		ldreq r0, =s_input_player3
		ldrne r0, =s_input_player4
		bl	printf
		
		ldr	r0, =p_2char
		ldr	r1, =b_scanf_w1
		ldr r2, =b_scanf_w2
		bl	scanf
		
		@ Input Char
		ldr	r1, =b_scanf_w1
		ldr	r1, [r1]
		
		@ Random?
		cmp r1, #48
		beq g_cp_rp
		
		@ Check for invalid input
		cmp r1, #48
		bls g_cp_in_ps_no
		
		ldr r0, =d_player_count
		ldr r0, [r0]
		add r0, #47
		
		cmp r1, r0
		bhi g_cp_in_ps_no
		
		sub r1, #48
		mov r6, r1
		b   g_cp_cont
		
g_cp_in_ps_no:
		ldr r0, =s_invalid_input
		bl	printf
		b   g_cp_in_ps
		
		@ Random player to call
g_cp_rp:
		ldr r1, =d_player_count
		ldr r1, [r1]
		sub r1, r1, #2
		bl util_rand
		cmp r0, r4
		addhs r0, r0, #1
		mov r6, r0

g_cp_cont:
		@ Print card call
		mov r0, #5
		mul r2, r4, r0
		ldr r1, =s_name_player1
		add r1, r1, r2
		mul r3, r6, r0
		ldr r2, =s_name_player1
		add r2, r2, r3
		ldr r3, =d_card_face
		ldrb r3, [r3,r5]
		ldr r0, =s_card_call
		bl  printf
		
		@ Call for card
		mov r1, r4
		mov r2, r6
		mov r3, r5
		bl  util_call_face
		
		@ Print result
		cmp r0, #0
		beq g_cp_pr_nope
		
		@ Get card
		mov r3, #5
		mul r1, r6, r3
		ldr r3, =s_name_player1
		add r3, r3, r1
		mov r1, r0
		ldr r2, =d_card_face
		ldrb r2, [r2,r5]
		ldr r0, =s_card_get
		bl  printf
		
		@ Check Book
		mov r1, r4
		bl  util_check_book
		
		@ Extra turn
		b   g_cp_start
		
		@ Dont Get card
g_cp_pr_nope:
		mov r3, #5
		mul r2, r6, r3
		ldr r1, =s_name_player1
		add r1, r1, r2
		ldr r2, =d_card_face
		ldrb r2, [r2,r5]
		ldr r0, =s_card_nope
		bl  printf
		
		@ Draw card
		mov r1, r4
		bl  util_card_draw
		
		@ Check Catch
		cmp r0, r5
		bne g_cp_pr_end
		
		mov r1, #5
		mul r2, r4, r1
		ldr r1, =s_name_player1
		add r1, r1, r2
		ldr r3, =d_card_face
		ldr r2, [r3,r0]
		ldr	r0, =s_card_catch
		bl	printf
		
		@ Check Book
		mov r1, r4
		bl  util_check_book
		
		@ Extra turn
		b   g_cp_start
		
g_cp_pr_end:
		cmp r0,#-1
		bne g_cp_pr_pc
		
		@ No card
		ldr	r0, =s_card_nodraw
		bl	printf
		b   g_cp_exit
		
		@ Print card
g_cp_pr_pc:
		mov r1, #5
		mul r2, r4, r1
		ldr r1, =s_name_player1
		add r1, r1, r2
		cmp r4, #0
		ldrne r0, =s_card_draw
		bne g_cp_pr_pc_p
		mov r2, r0
		ldr r0, =d_card_face
		ldrb r2, [r0,r2]
		ldr r0, =s_card_draws
g_cp_pr_pc_p:
		bl	printf
		
		mov r1, r4
		bl  util_check_book
g_cp_exit:
		pop {r4-r6}
		pop {pc}

@ Print Game Info <<<<<<<<<<
game_print_info:
		push {lr}
		
		@ Debug Print Deck
		@bl  debug_print_deck
		@ldr	r0, =p_newline
		@bl	printf
		
		@ Print Header and Player info
		ldr	r0, =s_game_info1
		ldr r1, =d_card_deck_count
		ldr r1, [r1]
		add r1, r1, #1
		ldr	r2, =s_name_player1
		ldr r3, =d_player_book
		bl	printf
		
		mov r1, #0
		bl util_card_print
		
		@ COM1
		mov r1, #1
		bl	util_card_count
		mov r3, r0
		ldr	r0, =s_game_info2
		ldr	r1, =s_name_player2
		ldr	r2, =d_player_book+14
		bl	printf
		
		@ Debug Print Card
		@mov r1, #1
		@bl util_card_print
		
		@ COM2
		ldr r0, =d_player_count
		ldr r0, [r0]
		cmp r0,#3
		blo g_pi_skip
		
		mov r1, #2
		bl	util_card_count
		mov r3, r0
		ldr	r0, =s_game_info2
		ldr	r1, =s_name_player3
		ldr	r2, =d_player_book+28
		bl	printf
		
		@ Debug Print Card
		@mov r1, #2
		@bl util_card_print
		
		@ COM3
		ldr r0, =d_player_count
		ldr r0, [r0]
		cmp r0,#4
		blo g_pi_skip
		
		mov r1, #3
		bl	util_card_count
		mov r3, r0
		ldr	r0, =s_game_info2
		ldr	r1, =s_name_player4
		ldr	r2, =d_player_book+42
		bl	printf
		
		@ Debug Print Card
		@mov r1, #3
		@bl util_card_print
		
g_pi_skip:
		pop {pc}
		
@ Shuffle Deck <<<<<<<<<<
game_deck_suff:
		push {lr}
		push {r4-r8}
		
		@ (r4 = *d_card_deck,r5 = d_card_deck offset,r6 = card face,r7 = card left,r8 = face left)
		
		@ Clear Deck (14 = No Card)
		mov r0, #14
		ldr r4, =d_card_deck
		mov r5, #0
g_ds_cd_loop:
		strb r0, [r4,r5]
		add r5, r5, #1
		cmp r5, #52
		blo g_ds_cd_loop
		
		@ Shuffle Deck
		mov r0, #0
		mov r5, #0
		mov r7, #51
		mov r6, #0
		
g_ds_sd_loop1:	@ Select Face
		mov r8, #0
		
g_ds_sd_loop2:	@ Place All 4 Card
		mov r1, r7
		bl  util_rand
		mov r1, #-1

g_ds_sd_loop3:	@ Find Pos
		add r1, r1, #1
		ldrb r2, [r4,r1]
		cmp r2, #14
		beq g_ds_sd_l3_else
		
		add r0, r0, #1
		b   g_ds_sd_loop3
		
g_ds_sd_l3_else:
		cmp r1,r0
		blo g_ds_sd_loop3
		
		strb r6, [r4,r0]
		add r8, r8, #1
		sub r7, r7, #1
		cmp r8, #4
		blo g_ds_sd_loop2
		
		add r6, r6, #1
		cmp r6, #13
		blo g_ds_sd_loop1
		
		pop {r4-r8}
		pop {pc}
		
@ Deal cards <<<<<<<<<<
game_deal_card:
		push {lr}
		push {r4-r10}
		
		@ (r4 = *d_player_hand, r5 = d_player_count, r6 = Card count)
		
		@ Clear hand and book
		mov r0, #0
		ldr r4, =d_player_hand
		mov r1, r4
		add r1, r1, #112
g_dc_ch_loop:
		str r0, [r4], #4
		cmp r4, r1
		blo g_dc_ch_loop
		
		@ Player count
		ldr r5, =d_player_count
		ldr r5, [r5]

		@ 7 Cards for 2 Players, 6 for 3, 5 for 4
		mov r6, #7
		mov r2, #37
		cmp r5, #3
		moveq r6, #6
		moveq r2, #33
		cmp r5, #4
		moveq r6, #5
		moveq r2, #31
		
		@ Store card left
		ldr r1, =d_card_deck_count
		str r2, [r1]
			
		@ Init loop
		ldr r4, =d_player_hand
		ldr r0, =d_card_deck
		add r0, r0, #51
		
		@ Loop stop point
		mov r1, #14
		mul r5, r5, r1
		add r5, r5, r4
		
g_dc_gc_loop1: @ Select Player
		mov r3, r6		@ Card Dealt
		
g_dc_gc_loop2: @ Deal Cards
		ldrb r1, [r0] , #-1
		ldrb r2, [r4,r1]
		add r2, r2, #1
		strb r2, [r4,r1]
		sub r3, r3, #1
		cmp r3, #0
		bne g_dc_gc_loop2
		
		add r4, r4, #14
		cmp r4, r5
		bne g_dc_gc_loop1
		
		@ Check for book
		mov r1, #0
		bl  util_check_book
		mov r1, #1
		bl  util_check_book
		mov r1, #2
		cmp r5, #3
		blhs  util_check_book
		mov r1, #3
		cmp r5, #4
		blhs  util_check_book
		
		pop {r4-r10}
		pop {pc}

@ == Utility Function ==
@ Random Number (0-r1) <<<<<<<<<<
util_rand:
		push {lr}
		
		@ Spacial Case
		cmp r1, #0
		moveq r0, #0
		beq u_ra_exit
		
		@ r1 += 1
		add r1, r1, #1
		
		@ Rand
		push {r1}
		bl  rand
		pop {r1}
		
		@ Set Max Random Value For Mod Performance
		mov r2, #255
		cmp r1, #8
		ldrhs r2, =#1023
		cmp r1, #16
		ldrhs r2, =#8191
		cmp r1, #32
		ldrhs r2, =#32767
		
		and r0, r2
		
		@ Mod by r1
u_ra_loop:
		cmp r0, r1
		blo u_ra_exit
		sub r0, r0, r1
		b   u_ra_loop
u_ra_exit:
		pop {pc}
		
@ Count Card (return Card Count = r0; player = r1) <<<<<<<<<<
util_card_count:
		push {lr}
		
		@ Hand Pos
		mov r0, #14
		mul r1, r1, r0
		
		ldr r2, =d_player_hand
		add r2, r2, r1
		add r1, r2, #13
		mov r0, #0
		
u_cc_loop:
		ldrb r3, [r2], #1
		add r0, r0, r3
		cmp r2,r1
		blo u_cc_loop
		
		pop {pc}
		
@ Print Card (player = r1) <<<<<<<<<<
util_card_print:
		push {lr}
		push {r4}
		
		@ Hand Pos
		mov r0, #14
		mul r1, r1, r0
		
		ldr r2, =d_player_hand
		add r2, r2, r1
		mov r1, #0
		ldr r4, =d_card_face
		
u_cp_loop1: @ Loop all card
		ldrb r3, [r2,r1]
		
u_cp_loop2: @ Print card face
		cmp r3, #0
		beq u_cp_skip
		sub r3, r3, #1
		
		@ Printf
		push {r0-r3}
		ldr	r0, =p_char
		ldrb r1, [r4,r1]	@ Card Face Num to Char
		bl	printf
		pop {r0-r3}
		b   u_cp_loop2
		
u_cp_skip:
		add r1, r1, #1
		cmp r1, #13
		blo u_cp_loop1
		
		pop {r4}
		pop {pc}
		
@ Draw Card (return Card drawn = r0 (-1 = Out of card); player = r1) <<<<<<<<<<
util_card_draw:
		push {lr}
		@ Hand Pos
		ldr r3, =d_player_hand
		mov r0, #14
		mul r1, r1, r0
		add r3, r3, r1
		
		@ Deck count
		ldr r1, =d_card_deck_count
		ldr r2, [r1]
		
		@ Check if no card to draw
		cmp r2, #-1
		moveq r0, #-1
		beq u_cd_exit
		
		@ Remove 1 Card from deck count
		sub r0, r2, #1
		str r0, [r1]
		
		@ Put card to player hand
		ldr r1, =d_card_deck
		ldrb r0, [r1,r2]
		ldrb r2, [r3,r0]
		add r2, r2, #1
		strb r2, [r3,r0]

u_cd_exit:		
		pop {pc}
		
@ Check for book (return Book Found = r0; player = r1) <<<<<<<<<<
util_check_book:
		push {lr}
		push {r4}
		mov r4, r1
		
		@ Hand Pos
		mov r0, #14
		mul r1, r1, r0
		
		mov r0, #0
		ldr r2, =d_player_hand
		add r2, r2, r1
		mov r1, #0
		
u_cb_loop:
		ldrb r3, [r2,r1]
		cmp r3,#4
		bne u_cb_skip
		
		@ Push Face to Book
		push {r2-r4}
		add r2, r2, #56	@ Hand + 56 = Book Pos
		
u_cb_pf_loop:	@ Push To last
		ldrb r3, [r2], #1
		cmp r3,#0
		bne u_cb_pf_loop
		
		ldr r4, =d_card_face
		ldrb r3, [r4,r1]
		strb r3, [r2,#-1]
		
		pop {r2-r4}
		
		@ Set card to zero
		mov r3, #0
		strb r3, [r2,r1]
		
		@ Print Book Get
		push {r0-r3}
		mov r0, r1
		mov r1, #5
		mul r2, r4, r1
		ldr r1, =s_name_player1
		add r1, r1, r2
		ldr r3, =d_card_face
		ldr r2, [r3,r0]
		ldr	r0, =s_book_get
		bl	printf
		pop {r0-r3}
		
		@ Set Return to 1
		mov r0, #1
		
u_cb_skip:
		add r1, r1, #1
		cmp r1,#13
		blo u_cb_loop
		
u_cb_exit:
		pop {r4}
		pop {pc}
		
@ Count Book (return Book Count = r0; player = r1) <<<<<<<<<<
util_book_count:
		push {lr}
		
		@ Hand Pos
		mov r0, #14
		mul r1, r1, r0
		
		ldr r2, =d_player_book
		add r2, r2, r1
		add r1, r2, #13
		mov r0, #0
		
u_bc_loop:
		ldrb r3, [r2], #1
		cmp r3, #0
		addne r0, r0, #1
		cmp r2,r1
		blo u_bc_loop
		
		pop {pc}
		
@ Find and Print Winner <<<<<<<<<<
util_print_winner:
		push {lr}
		push {r4-r7}
		
		@ Count Book from all player (= r4-r7)
		mov r1, #0
		bl util_book_count
		mov r4, r0
		
		mov r1, #1
		bl util_book_count
		mov r5, r0
		
		mov r1, #2
		bl util_book_count
		mov r6, r0
		
		mov r1, #3
		bl util_book_count
		mov r7, r0
		
		@ Count player
		ldr r0, =d_player_count
		ldr r0, [r0]
		cmp r0,#3
		blo u_pw_2p
		
		cmp r0,#4
		blo u_pw_3p
		
		@ 4 Player
		
		@ Find max book
		mov r0, r4
		cmp r0, r5
		movlo r0, r5
		cmp r0, r6
		movlo r0, r6
		cmp r0, r7
		movlo r0, r7
		
		@ Cmp max book with all player
		cmp r0, r4
		moveq r4, #-1
		cmp r0, r5
		moveq r5, #-1
		cmp r0, r6
		moveq r6, #-1
		cmp r0, r7
		moveq r7, #-1
		
		@ Count winner
		mov r0, #0
		cmp r4, #-1
		addeq r0, r0, #1
		cmp r5, #-1
		addeq r0, r0, #1
		cmp r6, #-1
		addeq r0, r0, #1
		cmp r7, #-1
		addeq r0, r0, #1
		
		@ b Winner count
		cmp r0, #4
		beq u_pw_draw
		cmp r0, #3
		beq u_pw_4p_3w
		cmp r0, #2
		beq u_pw_4p_2w
		
		@ 1 winner
		cmp r4, #-1
		moveq r1, #0
		beq	u_pw_win_1p
		cmp r5, #-1
		moveq r1, #1
		beq	u_pw_win_1p
		cmp r6, #-1
		moveq r1, #2
		beq	u_pw_win_1p
		mov r1, #3
		b	u_pw_win_1p
		
		@ 2 winners
u_pw_4p_2w:
		cmp r4, #-1
		moveq r1, #0
		beq	u_pw_4p_2w_p1w
		cmp r5, #-1
		moveq r1, #1
		beq	u_pw_4p_2w_p2w
		
		@ Player 1&2 lose
		mov r1, #2
		mov r2, #3
		b   u_pw_win_2p
		
		@ Player 1 wins
u_pw_4p_2w_p1w:
		cmp r5, #-1
		moveq r2, #1
		beq	u_pw_win_2p
		cmp r6, #-1
		moveq r2, #2
		beq	u_pw_win_2p
		mov r2, #3
		b	u_pw_win_2p
		
		@ Player 2 wins
u_pw_4p_2w_p2w:
		cmp r6, #-1
		moveq r2, #2
		beq	u_pw_win_2p
		mov r2, #3
		b	u_pw_win_2p

		@ 3 winners
u_pw_4p_3w:
		cmp r4, #-1
		movne r1, #1
		movne r2, #2
		movne r3, #3
		bne	u_pw_win_3p
		cmp r5, #-1
		movne r1, #0
		movne r2, #2
		movne r3, #3
		bne	u_pw_win_3p
		cmp r6, #-1
		movne r1, #0
		movne r2, #1
		movne r3, #3
		bne	u_pw_win_3p
		mov r1, #0
		mov r2, #1
		mov r3, #2
		b	u_pw_win_3p

		@ 3 Player
u_pw_3p:
		@ Find max book
		mov r0, r4
		cmp r0, r5
		movlo r0, r5
		cmp r0, r6
		movlo r0, r6
		
		@ Cmp max book with all player
		cmp r0, r4
		moveq r4, #-1
		cmp r0, r5
		moveq r5, #-1
		cmp r0, r6
		moveq r6, #-1
		
		@ Count winner
		mov r0, #0
		cmp r4, #-1
		addeq r0, r0, #1
		cmp r5, #-1
		addeq r0, r0, #1
		cmp r6, #-1
		addeq r0, r0, #1
		
		@ b Winner count
		cmp r0, #3
		beq u_pw_draw
		cmp r0, #2
		beq u_pw_3p_2w
		
		@ 1 winner
		cmp r4, #-1
		moveq r1, #0
		beq	u_pw_win_1p
		cmp r5, #-1
		moveq r1, #1
		beq	u_pw_win_1p
		mov r1, #2
		b	u_pw_win_1p
		
		@ 2 winners
u_pw_3p_2w:
		cmp r4, #-1
		movne r1, #1
		movne r2, #2
		bne	u_pw_win_2p
		cmp r5, #-1
		movne r1, #0
		movne r2, #2
		bne	u_pw_win_2p
		mov r1, #0
		mov r2, #1
		b	u_pw_win_2p
		
		@ 2 Player
u_pw_2p:
		mov r1, #0
		cmp r4, r5
		beq u_pw_draw
		movlo r1, #1
		
		@ 1 Player wins (r1)
u_pw_win_1p:
		mov r5, #5
		mul r6, r1, r5
		ldr r1, =s_name_player1
		add r1, r1, r6
		
		ldr r0,=s_game_over2_1
		bl  printf
		b   u_pw_exit
		
		@ 2 Players win (r1-r2)
u_pw_win_2p:
		mov r5, #5
		mul r6, r1, r5
		ldr r1, =s_name_player1
		add r1, r1, r6
		
		mul r6, r2, r5
		ldr r2, =s_name_player1
		add r2, r2, r6
		
		ldr r0,=s_game_over2_2
		bl  printf
		b   u_pw_exit
		
		@ 3 Players win (r1-r3)
u_pw_win_3p:
		mov r5, #5
		mul r6, r1, r5
		ldr r1, =s_name_player1
		add r1, r1, r6
		
		mul r6, r2, r5
		ldr r2, =s_name_player1
		add r2, r2, r6
		
		mul r6, r3, r5
		ldr r3, =s_name_player1
		add r3, r3, r6
		
		ldr r0,=s_game_over2_2
		bl  printf
		b   u_pw_exit
		
		@ Draw
u_pw_draw:
		ldr r0,=s_game_over2_4
		bl  printf
u_pw_exit:
		pop {r4-r7}
		pop {pc}
		
@ Count Face (return Face Count = r0; player = r1) <<<<<<<<<<
util_face_count:
		push {lr}
		
		@ Hand Pos
		mov r0, #14
		mul r1, r1, r0
		
		ldr r2, =d_player_hand
		add r2, r2, r1
		add r1, r2, #13
		mov r0, #0
		
u_fc_loop:
		ldrb r3, [r2], #1
		cmp r3, #0
		addne r0, r0, #1
		cmp r2,r1
		blo u_fc_loop
		
		pop {pc}
		
@ Card Pos to Face (return Face = r0; player = r1, pos = r2) <<<<<<<<<<
util_card_pos:
		push {lr}
		
		@ Hand Pos
		mov r0, #14
		mul r1, r1, r0
		
		ldr r3, =d_player_hand
		add r3, r3, r1
		add r1, r3, r2
		mov r2, r3
		mov r0, #-1
		
u_cp_loop:
		ldrb r3, [r2], #1
		cmp r3, #0
		addeq r1, r1, #1
		add r0, r0, #1
		cmp r2,r1
		bls u_cp_loop
		
		pop {pc}

@ Call Face (return Card Get = r0; caller player = r1, called player = r2, face = r3) <<<<<<<<<<
util_call_face:
		push {lr}
		push {r4-r5}
		mov r4, r1		@ (caller player = r4, face = r5)
		mov r5, r3
		
		@ Called Player Hand Pos (r1)
		mov r0, #14
		mul r2, r2, r0
		ldr r1, =d_player_hand
		add r1, r1, r2
		
		mov r0, #0
		
		@ Check for Face
		ldrb r2, [r1,r5]
		cmp r2, #0
		beq u_cf_exit
		
		@ Remove card
		strb r0, [r1,r5]
		mov r0, r2
		
		@ Caller Player Hand Pos (r1)
		mov r3, #14
		mul r4, r4, r3
		ldr r1, =d_player_hand
		add r1, r1, r4
		
		@ Add Card
		ldrb r3, [r1,r5]
		add r3, r3, r0
		strb r3, [r1,r5]

u_cf_exit:
		pop {r4-r5}
		pop {pc}
		
@ Check out of card (return Can draw = r0; player = r1) <<<<<<<<<<
util_card_noleft:
		push {lr}
		push {r4-r6}
		mov r4, r1
		
		@ Check if player has no card
		bl  util_card_count
		cmp r0, #0
		movne r0, #-1
		bne u_cn_exit
		
		@ Draw card
		mov r5, #7
		ldr r0, =d_player_count
		ldr r0, [r0]
		cmp r0, #3
		moveq r5, #6
		cmp r0, #4
		moveq r5, #5
		mov r6, r5

u_cn_dc_loop:
		mov r1, r4
		bl  util_card_draw
		
		cmp r0,#-1
		beq u_cn_dc_exit
		sub r5, r5, #1
		cmp r5, #0
		bne u_cn_dc_loop
		
u_cn_dc_exit:
		@ Print Result
		mov r3, #5
		mul r3, r4, r3
		ldr r1, =s_name_player1
		add r1, r1, r3
		
		cmp r5, r6
		beq u_cn_pr_nocard
		
		sub r2, r6, r5
		ldr r0, =s_card_noleft
		bl  printf
		
		b   u_cn_pr_cont
		
u_cn_pr_cont:
		mov r1, r4
		bl  util_check_book
		mov r0, #1
		b   u_cn_exit
		
u_cn_pr_nocard:
		ldr r0, =s_card_nodeck
		bl  printf
		mov r0, #0
		
u_cn_exit:
		pop {r4-r6}
		pop {pc}
		
@ Check Input Face Call (return Face = r0 (-1 = Invalid Input,-2 = Not have face);Input char = r1) <<<<<<<<<<
util_in_face:
		push {lr}
		
		@ Char to Face Num
		ldr r2, =d_card_face
		mov r0, #0
u_if_cf_loop:
		cmp r0, #13		@ Not found face
		moveq r0, #-1
		beq u_if_return
		ldrb r3, [r2,r0]
		
		cmp r3, r1
		addne r0, #1
		bne u_if_cf_loop
		
		@ Check if have face
		ldr r1, =d_player_hand
		ldrb r1, [r1,r0]
		cmp r1, #0
		moveq r0, #-2
		beq u_if_return
		
u_if_return:
		@ Print Invalid Input
		cmp r0, #-1
		bgt u_if_exit
		push {r0}
		ldr r0, =s_invalid_input
		bl	printf
		pop {r0}
		cmp r0, #-2
		bgt u_if_exit
		push {r0}
		ldr r0, =s_invalid_cardh
		bl	printf
		pop {r0}
		
u_if_exit:
		pop {pc}

@ == Debug Function ==
debug_print_deck:
		push {lr}
		
		push {r0-r3}
		ldr	r0, =p_newline
		bl	printf
		pop {r0-r3}
		
		mov r2, #0
		ldr r1, =d_card_deck
de_pd_loop:
		ldrb r0, [r1,r2]
		add r2, r2, #1
		
		ldr r3, =d_card_face
		push {r0-r3}
		ldrb r1, [r3,r0]
		ldr	r0, =p_char
		bl	printf
		pop {r0-r3}
		
		ldr r3, =d_card_deck_count
		ldr r3, [r3]
		cmp r2, r3
		ble de_pd_loop
		
		pop {pc}
		
/* Usefull Debug Code
		
		@ Printf
		push {r0-r3}
		ldr	r0, =s
		bl	printf
		pop {r0-r3}
		
		@ Print rX
		push {r0-r3}
		mov	r1,rX
		ldr	r0, =p_num_s1
		bl	printf
		pop {r0-r3}
		
		@ Print Card at rX
		push {r0-r3}
		ldr r0, =d_card_face
		ldrb r1, [r0,rX]
		ldr	r0, =p_char
		bl	printf
		pop {r0-r3}
		
		@ Print n char
		push {r0-r7}
		mov r0, #1
		ldr r1, =s
		mov r2, #n
		mov r7, #4
		svc 0
		pop {r0-r7}
*/
