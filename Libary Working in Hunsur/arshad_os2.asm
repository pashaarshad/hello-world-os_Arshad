; Boot sector code (512 bytes max)
org 0x7C00             ; BIOS loads the boot sector at 0x7C00
bits 16

start:
    ; Clear screen
    mov ax, 0x0003     ; BIOS interrupt to clear screen
    int 0x10

    ; Display welcome message
    mov si, welcome_msg
    call print_string

    ; Display "Press any key to continue"
    mov si, any_key_msg
    call print_string

    ; Wait for key press
    call wait_key

    ; Display Username and Password prompt
    mov si, username_prompt
    call print_string
    call get_string

    mov si, password_prompt
    call print_string
    call get_string

    ; Assuming a simple check for now, normally you would compare inputs

    ; Open Chrome browser and load website (This part would need OS and application-level code)
    ; For the sake of this example, we’ll just print a success message

    mov si, success_msg
    call print_string

    ; Halt the system
    cli
    hlt

print_string:
    ; Print string at DS:SI
    mov ah, 0x0E
.next_char:
    lodsb              ; Load the next byte from [SI] into AL
    cmp al, 0          ; Check for null terminator
    je .done
    int 0x10           ; BIOS interrupt to print character
    jmp .next_char
.done:
    ret

wait_key:
    ; Wait for key press and return
    xor ah, ah
    int 0x16           ; BIOS interrupt to wait for key press
    ret

get_string:
    ; Simplified input routine for getting a string (without validation)
    mov ah, 0x0A
    int 0x16           ; BIOS interrupt to get string input
    ret

welcome_msg db 'Welcome to Azure OS', 0
any_key_msg db 'Press any key to continue...', 0
username_prompt db 'Enter Username: ', 0
password_prompt db 'Enter Password: ', 0
success_msg db 'Login successful! Loading your website...', 0

times 510-($-$$) db 0   ; Fill the rest of the boot sector with zeros
dw 0xAA55               ; Boot sector signature