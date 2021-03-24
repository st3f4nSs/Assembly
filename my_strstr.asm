%include "io.mac"

;; COD C ATASAT IN README


section .data
    i: dd 0                                     ;; vom stoca iteratorul prin haystack.                                                         
    j: dd 0                                     ;; vom stoca iteratorul prin needle.        

section .text
    global my_strstr
    extern printf

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len

    xor eax, eax                                ;; iteratorul prin haystack si prin needle
    xor ecx, ecx
    xor edx, edx                                ;; initializare registre si variabile cu 0.
    mov [i], eax
    mov [j], eax

while:
    cmp eax, [ebp + 20]                         ;; cat timp mai avem caractere de prelucrat.
    jae exit_check                              ;; daca am ajuns la finalul sirului jump pe exit_check. 
    xor edx, edx                                
    xor ecx, ecx
    mov [j], edx                                ;; salvam in j pe edx.
    movzx edx, BYTE[esi + eax]                  ;; caracterul de pe poz eax din haystack.
    movzx ecx, BYTE[ebx + 0]                    ;; primul caracter din ecx.
    cmp dl, cl                                  ;; comparam caracterul curent cu primul caracter din needle.
    je verify_rest                              ;; daca sunt egala => verificam restul sirului needle (daca e subsir din haystack).
    inc eax                                     ;; daca nu sunt egale atunci trecem la urmatorul caracter din haystack.
    jmp while                                   ;; repetam operatiile.

verify_rest:
    mov [i], eax                                ;; mutam in 'i' contorul prin haystack, pentru a elibera registrul eax.
    cmp eax, [ebp + 20]                         ;; cat timp nu am ajuns la finalul sirului haystack.
    jae exit_check                              ;; daca am ajuns la final iesim.
    xor eax, eax                                ;; initializam cu 0 eax-ul.
    mov eax, [j]                                ;; salvam in eax iteratorul prin needle.
    cmp eax, [ebp + 24]                         ;; cat timp nu am ajuns la finalul sirului needle
    jae put_result                              ;; adaugam rezultatul
    xor eax, eax
    mov eax, [i]
    xor edx, edx                                
    xor ecx, ecx                                
    movzx edx, BYTE[esi + eax]                  
    inc eax
    mov [i], eax                                
    xor eax, eax                                ;; stocam in edx caracterul din haystack si in ecx din needle
    mov eax, [j]
    movzx ecx, BYTE[ebx + eax]
    inc eax
    mov [j], eax
    xor eax, eax
    mov eax, [i]
    cmp dl, cl                                  ;; daca cele 2 caractere sunt continuam verificarea
    je verify_rest                              
    jmp while                                   

put_result:
    xor edx, edx                                
    xor ecx, ecx
    mov ecx, [ebp + 24]                         ;; calculam valoarea indexului ca diferenta (index prin haystack si dimensiunea subsirului)
    mov edx, [i]                                   
    sub edx, ecx
    xor ecx, ecx
    mov ecx, [ebp + 8]                          ;; adaugam in substr_index rezultatul
    mov [ecx], edx
    jmp exit

exit_check:
    xor ecx, ecx
    mov ecx, [j]
    cmp ecx, [ebp + 24]
    je put_result
    xor edx, edx                                ;; daca am ajuns la finalul sirului haystack, trebuie sa verificam daca am ajuns si la 
    mov edx, [ebp + 20]                         ;; finalul sirului needle. In caz afirmativ adaugam indicele.
    add edx, 1
    xor ecx, ecx
    mov ecx, [ebp + 8]
    mov [ecx], edx
    jmp exit

exit:
    popa
    leave
    ret
