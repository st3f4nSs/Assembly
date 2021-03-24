%include "io.mac"

section .data
    reminder: dd 0 									;; pentru a stoca restul impartirii length la 4.
    save_cnt: dd 0  								;; pentru a salva iteratorul prin sir.
    save_sum: dd 0                                  ;; salvam suma pentru o secventa de 4 biti.
    save_result_dim: dd 0 							;; daca reminder != 0 atunci save_result_dim este 1(sirul incepe de la 1),
    												;;  altfel save_result_dim este 0. Pentru a cunoaste dimensiunea hexa_value.

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length

    xor ecx, ecx
    xor ebx, ebx
    xor edi, edi
    xor eax, eax
    xor edx, edx
    mov [reminder], eax
    mov [save_cnt], eax
    mov [save_sum], eax
    mov [save_result_dim], eax

	mov eax, [ebp + 16]   				;; dividend
	mov ecx, 4    						;; divisor
	div ecx
	mov [reminder], edx 				;; calculam catul si restul impartirii lui length la 4.
	xor eax, eax
	xor edx, edx

	mov edi, [reminder] 				
	cmp edi, 0 							;; daca exista reminder (un nr. impar de biti, cei mai din stanga) il calculez.
	jne reminder_exist
	mov edx, [ebp + 8]
	jmp	continue                       

reminder_exist:
	cmp eax, edi						
	je put_reminder
	xor ebx, ebx   						;; luam pe rand fiecare bit, daca e bit de 1 il adaugam la sum altfel repetam.
	movzx ebx, BYTE[esi + eax]			;; prin sum ne referim la valoarea in hexa pentru o secventa de biti( 4 sau <4 pt reminder).
	cmp bl, 49
	je add_to_sum
	inc eax
	jmp reminder_exist 

add_to_sum:
	xor ebx, ebx
	mov ebx, 1
	mov ecx, edi
	sub ecx, eax                       ;; pentru a calcula 2 ^ n shiftam de un numar de n ori
	sub ecx, 1                         ;; adaugam la suma
	shl ebx, cl
	add edx, ebx
	inc eax
	jmp reminder_exist

put_reminder:
	xor eax, eax
	mov eax, edx
	xor edx, edx
	mov edx, [ebp + 8]
	add eax, 48                        ;; cum numarul de biti <= 3 vom avea doar cifre
	mov BYTE[edx + 0], al              ;; adaugam caracterul in rezultatul final
	xor eax, eax
	mov eax, 1
	mov [save_result_dim], eax
	jmp continue

continue:
	xor edi, edi
	mov edi, [reminder]
while2:
	cmp edi, [ebp + 16]					;; un loop care parcurge secvente de cate 4 biti(creste din 4 in 4)
	jae exit
	mov [save_cnt], edi                 ;; stocam edi ul.
	xor edi, edi						;; edi devine suma
	xor eax, eax          				;; eax ul merge de la 0 la 3 ( parcurge de fiecare data 4 biti)

while:
	cmp eax, 4
	jae put_result						;; verificam daca e <=9 sau >9 si punem in sir caracterul
	xor ebx, ebx
	mov ebx, eax
	mov [save_sum], edi   				;; salvam suma stocata in edi in [save_sum]
	xor edi, edi
	mov edi, [save_cnt]                 ;; mutam itaratorul ce itereaza prin bin_seq in save_cnt
	add ebx, edi
	xor edi, edi
	mov edi, [save_sum]					;; refacem edi la cnt_save
	movzx ecx, BYTE[esi + ebx]
	cmp cl, 49
	je add
	inc eax
	jmp while

add:
	xor ecx, ecx
	xor ebx, ebx
	mov ebx, 1
	mov ecx, 4
	sub ecx, eax                        ;; pentru a calcula 2 ^ n shiftam de un numar de n ori   								
	sub ecx, 1							;; vom adaugam la suma.			
	shl ebx, cl
	add edi, ebx
	inc eax
	jmp while

put_result:								
	xor eax, eax
	xor ecx, ecx
	mov ecx, [save_result_dim]
	mov eax, edi
	xor edi, edi
	mov edi, [save_cnt]                ;; analog cu put_reminder, doar ca tinem cont daca suma < 10
	cmp eax, 9                         ;; daca suma e > 9 atunci trebuie sa adaugam o litera in sirul rezultat
	ja hexa_letter
	add eax, 48
	mov BYTE[edx + ecx], al
	inc ecx
	mov [save_result_dim], ecx
	add edi, 4
	jmp while2

hexa_letter:
	add eax, 55
	mov BYTE[edx + ecx], al
	inc ecx                          	;; daca acel caracter e litera
	mov [save_result_dim], ecx
	add edi, 4
	jmp while2

exit:
	xor eax, eax
	mov eax, [save_result_dim]
	mov BYTE[edx + eax], 10
	inc eax
	mov BYTE[edx + eax], 0
    popa
    leave
    ret