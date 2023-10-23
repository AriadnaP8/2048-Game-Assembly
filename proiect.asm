.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date

include matrice.inc
include chenar.inc
include sageti.inc
include digits.inc
include letters.inc
include cifre.inc

window_title DB "Exemplu proiect desenare", 0
area_width EQU 700
area_height EQU 580
area DD 0
matrix DD 0 ;declarare matrice

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

xinceput DD 39
yinceput DD 86
button_size DD 350

button_x dd 100
button_y dd 100

stanga_x EQU 491
stanga_y EQU 238
dreapta_x EQU 563
dreapta_y EQU 238
jos_x EQU 527
jos_Y EQU 273
sus_x EQU 527
sus_Y EQU 200
sageti_size EQU 30

button_start_x EQU 510
button_start_y EQU 111
button_start_size EQU 60

symbol_width DD 10
symbol_height DD 20

symbol_width2 DD 40
symbol_height2 DD 40;##################################################SI AICI

symbol_width3 DD 30
symbol_height3 DD 30

cifre_width DD 14
cifre_height DD 27

mat_spate_x dd 0
mat_spate_y dd 0

start_apasat dd 0

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
	
	make_text proc
			push ebp
			mov ebp, esp
			pusha
			
			mov eax, [ebp + arg1] ; citim simbolul de afisat
			cmp eax, 'A'
			jl make_digit
			cmp eax, 'Z'
			jg make_digit
			sub eax, 'A'
			lea esi, letters
			jmp draw_text

		make_digit:
			cmp eax, '0'
			jl make_space
			cmp eax, '9'
			jg make_space
			sub eax, '0'
			lea esi, digits
			jmp draw_text

		make_space:	
			mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
			lea esi, letters
		
		draw_text:
			mov ebx, symbol_width
			mul ebx
			mov ebx, symbol_height
			mul ebx
			add esi, eax
			mov ecx, symbol_height
			
		bucla_simbol_linii:
			mov edi, [ebp + arg2] ; pointer la matricea de pixeli
			mov eax, [ebp + arg4] ; pointer la coord y
			add eax, symbol_height
			sub eax, ecx
			mov ebx, area_width
			mul ebx
			add eax, [ebp + arg3] ; pointer la coord x
			shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
			add edi, eax
			push ecx
			mov ecx, symbol_width
			
		bucla_simbol_coloane:
			cmp byte ptr [esi], 0
			je simbol_pixel_alb
			mov dword ptr [edi], 0
			jmp simbol_pixel_next
			
		simbol_pixel_alb:
			mov dword ptr [edi], 0FFFFFFh
			
		simbol_pixel_next:
			inc esi
			add edi, 4
			loop bucla_simbol_coloane
			pop ecx
			loop bucla_simbol_linii
			popa
			mov esp, ebp
			pop ebp
			ret
	make_text endp
	
	make_chenar proc
			push ebp
			mov ebp, esp
			pusha
			
			mov eax, [ebp + arg1] ; citim simbolul de afisat
			lea esi, chenar		
		draw_text:
			mov ebx, symbol_width2
			mul ebx
			mov ebx, symbol_height2
			mul ebx
			add esi, eax
			mov ecx, symbol_height2
			
		bucla_simbol_linii:
			mov edi, [ebp + arg2] ; pointer la matricea de pixeli
			mov eax, [ebp + arg4] ; pointer la coord y
			add eax, symbol_height2
			sub eax, ecx
			mov ebx, area_width
			mul ebx
			add eax, [ebp + arg3] ; pointer la coord x
			shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
			add edi, eax
			push ecx
			mov ecx, symbol_width2
			
		bucla_simbol_coloane:
			cmp byte ptr [esi], 0
			je simbol_pixel_alb
			mov dword ptr [edi], 0FFFFFFh
			jmp simbol_pixel_next
			
		simbol_pixel_alb:
			mov dword ptr [edi], 0DBCD88h
			
		simbol_pixel_next:
			inc esi
			add edi, 4
			loop bucla_simbol_coloane
			pop ecx
			loop bucla_simbol_linii
			popa
			mov esp, ebp
			pop ebp
			ret
	make_chenar endp
	
	make_text_start proc
			push ebp
			mov ebp, esp
			pusha
			
			mov eax, [ebp + arg1] ; citim simbolul de afisat
			cmp eax, 'A'
			jl make_digit
			cmp eax, 'Z'
			jg make_digit
			sub eax, 'A'
			lea esi, letters
			jmp draw_text

		make_digit:
			cmp eax, '0'
			jl make_space
			cmp eax, '9'
			jg make_space
			sub eax, '0'
			lea esi, digits
			jmp draw_text

		make_space:	
			mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
			lea esi, letters
		
		draw_text:
			mov ebx, symbol_width
			mul ebx
			mov ebx, symbol_height
			mul ebx
			add esi, eax
			mov ecx, symbol_height
			
		bucla_simbol_linii:
			mov edi, [ebp + arg2] ; pointer la matricea de pixeli
			mov eax, [ebp + arg4] ; pointer la coord y
			add eax, symbol_height
			sub eax, ecx
			mov ebx, area_width
			mul ebx
			add eax, [ebp + arg3] ; pointer la coord x
			shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
			add edi, eax
			push ecx
			mov ecx, symbol_width
			
		bucla_simbol_coloane:
			cmp byte ptr [esi], 0
			je simbol_pixel_verde
			mov dword ptr [edi], 0
			jmp simbol_pixel_next
			
		simbol_pixel_verde:
			mov dword ptr [edi], 000FF1Fh
			
		simbol_pixel_next:
			inc esi
			add edi, 4
			loop bucla_simbol_coloane
			pop ecx
			loop bucla_simbol_linii
			
			popa
			mov esp, ebp
			pop ebp
			ret
	make_text_start endp
	
	make_text_nume proc
			push ebp
			mov ebp, esp
			pusha
			
			mov eax, [ebp + arg1] ; citim simbolul de afisat
			cmp eax, 'A'
			jl make_digit
			cmp eax, 'Z'
			jg make_digit
			sub eax, 'A'
			lea esi, letters
			jmp draw_text

		make_digit:
			cmp eax, '0'
			jl make_space
			cmp eax, '9'
			jg make_space
			sub eax, '0'
			lea esi, digits
			jmp draw_text

		make_space:	
			mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
			lea esi, letters
		
		draw_text:
			mov ebx, symbol_width
			mul ebx
			mov ebx, symbol_height
			mul ebx
			add esi, eax
			mov ecx, symbol_height
			
		bucla_simbol_linii:
			mov edi, [ebp + arg2] ; pointer la matricea de pixeli
			mov eax, [ebp + arg4] ; pointer la coord y
			add eax, symbol_height
			sub eax, ecx
			mov ebx, area_width
			mul ebx
			add eax, [ebp + arg3] ; pointer la coord x
			shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
			add edi, eax
			push ecx
			mov ecx, symbol_width
			
		bucla_simbol_coloane:
			cmp byte ptr [esi], 0
			je simbol_pixel_mov
			mov dword ptr [edi], 0
			jmp simbol_pixel_next
			
		simbol_pixel_mov:
			mov dword ptr [edi], 0A400DDh
			
		simbol_pixel_next:
			inc esi
			add edi, 4
			loop bucla_simbol_coloane
			pop ecx
			loop bucla_simbol_linii
			popa
			mov esp, ebp
			pop ebp
			ret
	make_text_nume endp
	
	make_cifre proc
			push ebp
			mov ebp, esp
			pusha
			
			mov eax, [ebp + arg1] ; citim simbolul de afisat
			cmp eax, 'A'
			jl make_digit
			cmp eax, 'Z'
			jg make_digit
			sub eax, 'A'
			lea esi, letters
			jmp draw_text

		make_digit:
			cmp eax, '0'
			jl make_space
			cmp eax, '9'
			jg make_space
			sub eax, '0'
			lea esi, cifre
			jmp draw_text

		make_space:	
			mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
			lea esi, letters
		
		draw_text:
			mov ebx, cifre_width
			mul ebx
			mov ebx, cifre_height
			mul ebx
			add esi, eax
			mov ecx, cifre_height
			
		bucla_simbol_linii:
			mov edi, [ebp + arg2] ; pointer la matricea de pixeli
			mov eax, [ebp + arg4] ; pointer la coord y
			add eax, cifre_height
			sub eax, ecx
			mov ebx, area_width
			mul ebx
			add eax, [ebp + arg3] ; pointer la coord x
			shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
			add edi, eax
			push ecx
			mov ecx, cifre_width
			
		bucla_simbol_coloane:
			cmp byte ptr [esi], 0
			je simbol_pixel_alb
			mov dword ptr [edi], 0
			jmp simbol_pixel_next
			
		simbol_pixel_alb:
			mov dword ptr [edi], 0FFFFFFh
			
		simbol_pixel_next:
			inc esi
			add edi, 4
			loop bucla_simbol_coloane
			pop ecx
			loop bucla_simbol_linii
			popa
			mov esp, ebp
			pop ebp
			ret
	make_cifre endp
	
	make_sageti proc
			push ebp
			mov ebp, esp
			pusha
			
			mov eax, [ebp + arg1] ; citim simbolul de afisat
			mov edx, [ebp + arg3]
			cmp eax, 'a'
			je make_stanga
			cmp eax, 'd'
			je make_dreapta
			cmp eax, 's'
			je make_jos
			cmp eax, 'w'
			je make_sus

		make_stanga:
			 mov eax, 0
			; mov ebx, 30
			; mov symbol_width, ebx
			; mov symbol_height, ebx
			lea esi, sageti
			jmp draw_text
			
		make_dreapta:
			mov eax, 1
			; mov ebx, 30
			; mov symbol_width, ebx
			; mov symbol_height, ebx
			lea esi, sageti
			jmp draw_text
			
		make_jos:
			 mov eax, 2
			; mov ebx, 30
			; mov symbol_width, ebx
			; mov symbol_height, ebx
			lea esi, sageti
			jmp draw_text
			
		make_sus:
			 mov eax, 3
			; mov ebx, 30
			; mov symbol_width, ebx
			; mov symbol_height, ebx
			lea esi, sageti
			jmp draw_text
		
		draw_text:
			mov ebx, symbol_width3
			mul ebx
			mov ebx, symbol_height3
			mul ebx
			add esi, eax
			mov ecx, symbol_height3
			
		bucla_simbol_linii:
			mov edi, [ebp + arg2] ; pointer la matricea de pixeli
			mov eax, [ebp + arg4] ; pointer la coord y
			add eax, symbol_height3
			sub eax, ecx
			mov ebx, area_width
			mul ebx
			add eax, [ebp + arg3] ; pointer la coord x
			shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
			add edi, eax
			push ecx
			mov ecx, symbol_width3
			
		bucla_simbol_coloane:
			cmp byte ptr [esi], 0
			je simbol_pixel_verde
			mov dword ptr [edi], 0
			jmp simbol_pixel_next
			
		simbol_pixel_verde:
			mov dword ptr [edi], 0fa0000h
			
		simbol_pixel_next:
			inc esi
			add edi, 4
			loop bucla_simbol_coloane
			pop ecx
			loop bucla_simbol_linii
			popa
			mov esp, ebp
			pop ebp
			ret
	make_sageti endp
	
	;MACROURI
	; un macro ca sa apelam mai usor desenarea simbolului
	make_text_macro macro symbol, drawArea, x, y
		push y
		push x
		push drawArea
		push symbol
		call make_text
		add esp, 16
	endm
	
	make_text_start_macro macro symbol, drawArea, x, y
		push y
		push x
		push drawArea
		push symbol
		call make_text_start
		add esp, 16
	endm
	
	make_text_nume_macro macro symbol, drawArea, x, y
		push y
		push x
		push drawArea
		push symbol
		call make_text_nume
		add esp, 16
	endm
	
	make_cifre_macro macro symbol, drawArea, x, y
		push y
		push x
		push drawArea
		push symbol
		call make_cifre
		add esp, 16
	endm
	
	make_chenar_macro macro symbol, drawArea, x, y
		push y
		push x
		push drawArea
		push symbol
		call make_chenar
		add esp, 16
	endm
	
	make_sageti_macro macro symbol, drawArea, x, y
		push y
		push x
		push drawArea
		push symbol
		call make_sageti
		add esp, 16
	endm

	linie_orizontala macro x, y, len, color
		local bucla_line
			 mov eax, y ;eax = y
			 mov ebx, area_width
			 mul ebx ; eax = y * area_width + x
			 add eax, x
			 shl eax,2 ; eax=(y*area_width + x) *4
			 add eax, area
			 mov ecx, len
			 bucla_line:
				 mov dword  ptr[eax] ,color
				 add eax, 4
			 loop bucla_line
		 endm
	 
	linie_verticala macro x, y, len, color
		local bucla_line
			mov eax, y ;eax = y
			mov ebx, area_width
			mul ebx ; eax = y*area_width + x
			add eax, x
			shl eax,2 ;eax = (y*area_width + x) *4
			add eax, area
			mov ecx, len
			bucla_line:
				mov dword  ptr[eax], color
				add eax, area_width * 4
			loop bucla_line
		endm

		
		
		
plasare_random_valoare proc
	
	push ebp
	mov ebp, esp
	pusha
	
	generare_alte_valori:
	
		rdtsc 
		mov edx, 0
		mov ebx, 4
		div ebx
		mov ecx, edx ; valoarea random pentru pozitia i 
		
		rdtsc 
		add eax, 3
		mov edx, 0
		mov ebx, 4
		div ebx
		mov ebx, edx ; valoarea random pentru pozitia j 
	
	cmp  matrix[ebx][ecx], 0
	jne generare_alte_valori
		rdtsc
		mov edx, 0
		mov edi, 2
		div edi
		
		cmp edx, 0
		je plasare_val_2
		
			;se plaseaza valoarea 4
			mov matrix[ebx][ecx],4
			jmp final_plasare_random
		
		plasare_val_2:
		
			;se plaseaza valoarea 4
			mov matrix[ebx][ecx],2
		
		final_plasare_random:
	popa
	mov esp, ebp
	pop ebp
	ret
plasare_random_valoare endp		

desenare_numere proc
	push ebp
	mov ebp, esp
	pusha
	
					mov eax, xinceput
					sub eax, 100
					mov edx, 0
					div symbol_width2
					sub eax, 1
					;add eax, 40
					mov mat_spate_x, eax
					
					;int 3
					mov eax, yinceput
					sub eax, 100
					mov edx, 0
					div symbol_height2
					sub eax, 1
					;add eax, 40
					mov edx, eax
					
					mov eax, mat_spate_x
					
					cmp matrix[edx][eax], 2
					jne comparare_cu_4
						make_cifre_macro '2', area, xinceput, yinceput
					comparare_cu_4:
				go_NEXT:
		
	popa
	mov esp, ebp
	pop ebp
	ret

desenare_numere endp


mutare_sus proc

	push ebp
	mov ebp, esp
	pusha
	
	mov ecx, 0
	mov ebx, 0
	
	parcurgere_linii:
		mov ebx, 0
		
		parcurgere_coloane:
			add ebx, ecx
			cmp matrix[ebx], 0
			jb parcurgere_coloane_final
				mov eax, matrix[ebx]
				cmp eax,matrix[ebx+16]
					jne parcurgere_coloane_final
					
						mov eax, matrix[ebx+ecx]
						mov edx, 2
						mul edx
						mov matrix[ebx+ecx], eax
							cmp ecx, 2
							jne next
								mov matrix[ebx+ecx+16], 0
					next:
						
						
							

		parcurgere_coloane_final:

	popa
	mov esp, ebp
	pop ebp
	ret
mutare_sus endp








		
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
	draw proc
	push ebp
	mov ebp, esp
	pusha
	
		;desenam matricea/chenarul si patratele din el
		;int 3
		;mov matrix[16], 
		mov eax, 0
		 mov matrix[eax], 2
		 add eax, 1
		 mov matrix[eax], 2
		 add eax, 1
		 mov matrix[eax], 2
		add eax, 1
		mov matrix[eax], 2
		
		
		lea esi, matrice
		mov yinceput, 100
		mov ecx, 0
		loop1:
			mov xinceput, 100
			mov ebx, 0
			loop2:
				mov edx, 0
				mov dl, [esi + ebx]
				make_chenar_macro edx, area, xinceput, yinceput
				add ebx, 1
				
				cmp dl, 0;pozitie in care va fi afisat un numar
				jne go_NEXT
				
					mov eax, xinceput
					sub eax, 100
					mov edx, 0
					div symbol_width2
					sub eax, 1
					mov mat_spate_x, eax
					
					;int 3
					
					mov eax, yinceput
					sub eax, 100
					mov edx, 0
					div symbol_height2
					sub eax, 1
					mov edx, 4;inmultim cu dimensiunea matricei
					mul edx
					
					mov edx, eax
					
					mov eax, mat_spate_x
					
					cmp matrix[eax][edx], 2
					jne comparare_cu_4
						make_cifre_macro '2', area, xinceput, yinceput
					comparare_cu_4:
					
				go_NEXT:
				add xinceput, 40;################################################################################################MODIFICA DIN 40 IN MAI MARE
				cmp ebx, 4; daca nu ajunge la capatul liniei, se intoarce inapoi in loop pentru a continua sa deseneze
			jb loop2
			add esi, 4 ;pentru a trece la a doua linie pentru ca fara ea afiseaza prima linie de 9 ori
			add yinceput, 40 ;crestem cu 40 de pixeli
			add ecx, 1 ;trecem la linia urm pt a cobori
			cmp ecx, 4 ;daca n am ajuns la capatul coloanei, intra inapoi in loop
		jb loop1
		
		
		mov eax, [ebp + arg1]
		cmp eax, 1
		jz evt_click
		cmp eax, 2
		jz evt_timer ; nu s-a efectuat click pe nimic
		;mai jos e codul care intializeaza fereastra cu pixeli albi
		mov eax, area_width
		mov ebx, area_height
		mul ebx
		shl eax, 2
		push eax
		push 0
		push area
		call memset
		add esp, 12
		jmp afisare_litere
	
evt_click:
; mov eax, [ebp+arg3];
; mov ebx ,area_width
; mul ebx
; add eax , [ebp+arg2]
; shl eax,2	
; add eax,area
; mov dword ptr[eax], 0FF0000h
;linie_orizontala [ebp+arg2], [ebp+arg3], 10 , 0FFh
;	jmp afisare_litere

	cmp start_apasat, 1
	je verificare_sageti
	mov eax, [ebp + arg2]
	cmp eax, button_start_x
	jl fail
	cmp eax, button_start_x + button_start_size
	jg fail
	mov eax, [ebp + arg3]
	cmp eax, button_start_y
	jl fail
	cmp eax, button_start_y + button_start_size
	jg fail
		mov start_apasat, 1
		call plasare_random_valoare
		call plasare_random_valoare
	jmp succes
	;generam numere random care pot fi doar 2 sau 4
	;int 3
	
	
	verificare_sageti:
	
	
	;verificare buton sageata stanga
	mov eax, [ebp + arg2]
	cmp eax, stanga_x
	jl verificare_sageata_dreapta
	cmp eax, stanga_x + 30
	jg verificare_sageata_dreapta
	mov eax, [ebp + arg3]
	cmp eax, stanga_y
	jl verificare_sageata_dreapta
	cmp eax, stanga_y + 30
	jg verificare_sageata_dreapta
		
	jmp succes
	
	verificare_sageata_dreapta:
	;verificare buton sageata dreapta
	mov eax, [ebp + arg2]
	cmp eax, dreapta_x
	jl verificare_sageata_sus
	cmp eax, dreapta_x + 30
	jg verificare_sageata_sus
	mov eax, [ebp + arg3]
	cmp eax, dreapta_y
	jl verificare_sageata_sus
	cmp eax, dreapta_y + 30
	jg verificare_sageata_sus
	jmp succes
	
	verificare_sageata_sus:
	;verificare buton sageata sus
	mov eax, [ebp + arg2]
	cmp eax, sus_x
	jl verificare_sageata_jos
	cmp eax, sus_x + 30
	jg verificare_sageata_jos
	mov eax, [ebp + arg3]
	cmp eax, sus_y
	jl verificare_sageata_jos
	cmp eax, sus_y + 30
	jg verificare_sageata_jos
	jmp succes
	
	verificare_sageata_jos:
	;verificare buton sageata jos
	mov eax, [ebp + arg2]
	cmp eax, jos_x
	jl fail
	cmp eax, jos_x + 30
	jg fail
	mov eax, [ebp + arg3]
	cmp eax, jos_y
	jl fail
	cmp eax, jos_y + 30
	jg fail
	jmp succes
	

fail:
	;nu face nimic
	;e doar pentru a bloca evt_click din a merge in continuare
	
succes:
	
evt_timer:
	; inc counter
	
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	; mov ebx, 10
	; mov eax, counter
	;cifra unitatilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 30, 10
	;cifra zecilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 20, 10
	;cifra sutelor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 10, 10
	
	;scriem un mesaj
	 make_text_macro '2', area, 270, 28
	 make_text_macro '0', area, 284, 28
	 make_text_macro '4', area, 298, 28
	 make_text_macro '8', area, 312, 28
	 
	 
	;creez matricea de 4 x 4
	;linie_orizontala button_x, button_y, button_size, 0FFFFFFh
	;linie_orizontala button_x, button_y + button_size, button_size, 0FFFFFFh
	;linie_verticala button_x, button_y, button_size, 0FFFFFFh
	;linie_verticala	button_x + button_size, button_y, button_size, 0FFFFFFh
	
	;creez fiecare linie si coloana in parte
	;linie_verticala button_x + button_size / 2, button_y, button_size, 0FFFFFFh
	;linie_verticala button_x + button_size / 4, button_y, button_size, 0FFFFFFh
	;linie_verticala button_x + button_size / 2 + button_size / 4, button_y, button_size, 0FFFFFFh
	;linie_orizontala button_x, button_y + button_size / 2, button_size, 0FFFFFFh
	;linie_orizontala button_x, button_y + button_size / 4, button_size, 0FFFFFFh
	;linie_orizontala button_x, button_y + button_size / 2 + button_size / 4, button_size, 0FFFFFFh
	
	;fac butonul de start
	linie_orizontala button_start_x, button_start_y, button_start_size, 0FFFFFFh
	linie_orizontala button_start_x, button_start_y + button_start_size, button_start_size, 0FFFFFFh
	linie_verticala button_start_x, button_start_y, button_start_size, 0FFFFFFh
	linie_verticala	button_start_x + button_start_size, button_start_y, button_start_size, 0FFFFFFh
	
	;scrie textul START in buton
	make_text_start_macro 'S', area, 515, 131
	make_text_start_macro 'T', area, 525, 131
	make_text_start_macro 'A', area, 535, 131
	make_text_start_macro 'R', area, 545, 131
	make_text_start_macro 'T', area, 555, 131
	
	;creez butoanele cu sageti
	make_sageti_macro 'a', area, stanga_x, stanga_y
	make_sageti_macro 'd', area, dreapta_x, dreapta_y
	make_sageti_macro 's', area, jos_x, jos_y
	make_sageti_macro 'w', area, sus_x, sus_y
	
	;scrie numele in partea de jos
	make_text_nume_macro 'P', area, 189, 511
	make_text_nume_macro 'O', area, 199, 511
	make_text_nume_macro 'P', area, 209, 511
	make_text_nume_macro 'E', area, 219, 511
	make_text_nume_macro 'S', area, 229, 511
	make_text_nume_macro 'C', area, 239, 511
	make_text_nume_macro 'A', area, 259, 511
	make_text_nume_macro 'R', area, 269, 511
	make_text_nume_macro 'I', area, 279, 511
	make_text_nume_macro 'A', area, 289, 511
	make_text_nume_macro 'D', area, 299, 511
	make_text_nume_macro 'N', area, 309, 511
	make_text_nume_macro 'A', area, 319, 511
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	;creez matricea "din spate" a tabloului
	mov eax, 16
	mov ebx, 16
	mul ebx
	push eax
	call malloc
	add esp, 4
	
	mov matrix, eax
	
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start