%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

    xor eax, eax

while:
    cmp eax, [ebp + 20] 				;; comparam eax cu length
    je exit								;; daca sunt egale iesim
    movzx ebx, BYTE[esi + eax]			;; mutam in ebx primul byte din plaintext( primul caracter)
    cmp bl, 97							;; daca poate fi litera mica
    jae lowercase
    cmp bl, 65							;; daca poate fi litera mare
    jae uppercase

not_letter:
    mov BYTE[edx + eax], bl				;; daca nu e litera adaugam caracterul
    inc eax								;; incrementam iteratorul prin vector
    jmp while							;; repetam

lowercase:								;; pentru litera mica
	cmp bl, 122							;; comparam cu 'z'
	ja not_letter						;; daca e mai mare => nu e litera mica
	xor ecx, ecx
	movzx ecx, bl						;; punem in ecx caracterul retinut in bl
	add ecx, edi						;; adunam cheia la ecx
	cmp ecx, 122						;; verificam daca e mai mare decat 'z'
	ja generate_character_lower			;; daca e mai mare vom face scaderi succesive pt a obtine caracterul
	mov BYTE[edx + eax], cl             ;; adaugam in rezultat caracterul retinu in cl
	inc eax								;; incrementam contorul
	jmp while							;; repetam operatiile

generate_character_lower:
	sub ecx, 122						;; scadem 'z'(122) din caracter.
	add ecx, 96							;; adaugam caracterul 'a' - 1 (96).
	cmp ecx, 122						;; comparam cu 'z'
	ja generate_character_lower			;; daca este mai mare repetam, daca nu adugam caracterul.
	mov BYTE[edx + eax], cl   			;; adaugam caracterul la rezultat
	inc eax								;; incrementam eax-ul
	jmp while							;; luam urmatorul caracter

uppercase:
	cmp bl, 90							;; comparam cu 'Z'
	ja not_letter						;; daca e mai mare => nu e litera mica
	xor ecx, ecx
	movzx ecx, bl						;; punem in ecx caracterul retinut in bl
	add ecx, edi						;; adunam cheia la ecx
	cmp ecx, 90							;; verificam daca e mai mare decat 'Z'		
	ja generate_character_upper			;; daca e mai mare vom face scaderi succesive pt a obtine caracterul
	mov BYTE[edx + eax], cl 			;; adaugam in rezultat caracterul retinu in cl
	inc eax								;; incrementam contorul
	jmp while							;; repetam operatiile

generate_character_upper:
	sub ecx, 90							;; scadem 'Z'(90) din caracter.
	add ecx, 64							;; adaugam caracterul 'A' - 1 (96).
	cmp ecx, 90							;; comparam cu 'Z'
	ja generate_character_upper			;; daca este mai mare repetam, daca nu adugam caracterul.
	mov BYTE[edx + eax], cl 			;; adaugam caracterul la rezultat
	inc eax 							;; incrementam eax-ul
	jmp while							;; luam urmatorul caracter

exit:
	mov BYTE[edx + ecx], 0				;; punem terminatorul de sir
    popa
    leave
    ret
 