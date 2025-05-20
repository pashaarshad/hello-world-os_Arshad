section .data
    ; Welcome message
    welcome_message db 'Welcome to ARSHAD OS', 0

    ; Prompts
    username_prompt db 'Enter Username: ', 0
    password_prompt db 'Enter Password: ', 0

    ; Calculator prompt
    calc_message db 'ARSHAD OS Calculator', 0

    ; Colors
    black db 0x00
    white db 0x07
    red db 0x04
    green db 0x02

section .bss
    username resb 32
    password resb 32
    result resb 32

section .text
    global _start

_start:
    ; Clear screen
    mov eax, 0x0
    int 0x80

    ; Display welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_message
    mov edx, 18
    int 0x80

    ; Wait for key press
    mov eax, 0
    int 0x16

    ; Jump to username and password input
    call display_login_screen

display_login_screen:
    ; Clear screen
    mov eax, 0x0
    int 0x80

    ; Display username prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, username_prompt
    mov edx, 15
    int 0x80

    ; Display input box for username
    call draw_input_box

    ; Capture username input
    call capture_input
    mov [username], eax

    ; Display password prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, password_prompt
    mov edx, 15
    int 0x80

    ; Display input box for password
    call draw_input_box

    ; Capture password input
    call capture_input
    mov [password], eax

    ; Proceed to the calculator
    call display_calculator
    ret

draw_input_box:
    ; Simulate drawing a border for input box
    ; For simplicity, this is just a placeholder
    ret

capture_input:
    ; Placeholder for capturing input
    ; Real input capture will depend on your environment
    ; In practice, you'd store the input in a register or memory
    ret

display_calculator:
    ; Clear screen
    mov eax, 0x0
    int 0x80

    ; Display calculator title
    mov eax, 4
    mov ebx, 1
    mov ecx, calc_message
    mov edx, 21
    int 0x80

    ; Draw calculator UI
    call draw_calculator_ui

    ; Implement calculator logic
    call calculator_logic

    ; Return to main loop or exit
    ret

draw_calculator_ui:
    ; Simulate drawing calculator UI with colors
    ; Border, background, number buttons, etc.
    ret

calculator_logic:
    ; Simulate calculator operations: addition, subtraction, etc.
    ; Display result in red color
    ; For simplicity, this is a placeholder
    ret