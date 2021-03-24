%include "io.mac"

section .text
    global otp
    extern printf

otp:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

    xor eax, eax

string_not_ending:
	cmp eax, ecx								;; daca nu am ajuns la finalul stringului repetam operatiile.
	je exit										;; dam am ajuns la finualul sirului returnam.
    movzx ebx, BYTE[esi + eax]					;; mutam in ebx un octet din sirul plaintext.
    xor bl, BYTE[edi + eax]						;; facem xor intre 2 octeti si salvam reultatul in bl.
    mov BYTE[edx + eax], bl						;; punem in ciphertext octetul din bl.
    inc eax										;; incrementam eax-ul.
    jmp string_not_ending						;; repetam

exit:
    popa
    leave
    ret

