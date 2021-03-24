%include "io.mac"

;; COD C ATASAT IN README


section .data
	i: dd 0								;; stocam iteratorul care parcurge plaintext-ul.

section .text
    global vigenere
    extern printf

vigenere:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len

    xor eax, eax						;; iteram prin plaintext.
    xor ecx, ecx						;; iteram prin key.
    xor ebx, ebx
    mov [i], eax

while:
    cmp eax, [ebp + 16]					;; cat timp contorul e mai mic decat dim. plaintextului,
    jae exit
    cmp ecx, [ebp + 24]					;; cat timp contorul e mai mic decat dim. key ului.
    jae key_len_over					;; daca ecx >= cu dim lui key, ecx devine 0.
    xor ebx, ebx
    movzx ebx, BYTE[esi + eax]			;; retinem in ebx caracterul curent.
    cmp bl, 97							;; daca poate fi litera mica.
    jae lowercase						
    cmp bl, 65							;; daca poate fi litera mare.
    jae uppercase

not_letter:
	mov BYTE[edx + eax], bl				;; adaugam caracterul in rezultat.
    inc eax								;; incrementam doar iteratorul prin plaintext.
    jmp while							;; repetam operatiile.

key_len_over:
	xor ecx, ecx						;; daca ecx a depasit dimensiunea key-ului, il reinitializam cu 0.
	jmp while							;; repetam operatiile.

lowercase:
	cmp bl, 122							;; daca > 122, atunci nu e litera.
	ja not_letter						
	mov [i], eax						;; salvam in 'i', contorul care itereaza prin plaintext.
	xor eax, eax						;; eax devine 0.
	movzx eax, BYTE[edi + ecx]			;; punem in eax caracterul curent din key.
	add bl, al							;; adaugam la caracterul din bl, caracterul din eax.
	sub bl, 65							;; scadem 65 (A), pentru a determina pozitia in alfabet
	xor eax, eax						;;	a caracterului din key.
	mov eax, [i]						;; il reinitializam pe eax cu contorul salvat in 'i'.
	cmp bl, 122							;; daca acel caracter stocat in bl > 122
	ja modify_lower						;; il modificam, ca sa apartina intervalului [97, 122]
	mov BYTE[edx + eax], bl				;; altfel il adaugam la rezultat
	inc eax								;; incrementam contorul prin plaintext
	inc ecx								;; incrementam contorul prin key
	jmp while							;; repetam operatiile


modify_lower:
	sub bl, 122							;; scadem 'z' din caracter
	add bl, 97							;; il adunam pe 'a'
	sub bl, 1							;; scadem 1
	mov BYTE[edx + eax], bl				;; adaugam caracterul in rezultat
	inc eax								;; incrementam contorul prin plaintext
	inc ecx								;; incrementam contorul prin key
	jmp while							;; repetam operatiile

uppercase:								;; analog cu lowercase, doar ca scadem/ comparam cu 'Z' nu 'z'
	cmp bl, 90
	ja not_letter
	mov [i], eax
	xor eax, eax
	movzx eax, BYTE[edi + ecx]
	add bl, al
	sub bl, 65
	xor eax, eax
	mov eax, [i]
	cmp bl, 90
	ja modify_upper
	mov BYTE[edx + eax], bl
	inc eax
	inc ecx
	jmp while

modify_upper:							;; analog cu modify_lower, doar ca scadem 'Z' nu 'z'
	sub bl, 90
	add bl, 65
	sub bl, 1
	mov BYTE[edx + eax], bl
	inc eax
	inc ecx
	jmp while

exit:
    popa
    leave
    ret