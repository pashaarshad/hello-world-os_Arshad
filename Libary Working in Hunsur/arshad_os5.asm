[bits 16]           ; tell assembler that working in real mode (16-bit mode)
[org 0x7c00]        ; organize from 0x7C00 memory location where BIOS will load us

start:              ; start label from where our code starts

    xor ax, ax           ; set ax register to 0
    mov ds, ax           ; set data segment(ds) to 0
    mov es, ax           ; set extra segment(es) to 0
    mov bx, 0x8000

    mov ax, 0x13         ; set video mode to 320x200 256 colors
    int 0x10            ; call BIOS video interrupt

    mov ah, 0x02         ; set cursor position
    mov bh, 0x00         ; page number
    mov dh, 0x06         ; y coordinate/row
    mov dl, 0x09         ; x coordinate/col
    int 0x10

    mov si, start_os_intro         ; point start_os_intro string to source index
    call _print_DiffColor_String   ; call print different color string function

    ; set cursor to specific position on screen
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x10
    mov dl, 0x06
    int 0x10

    mov si, press_key             ; point press_key string to source index
    call _print_GreenColor_String ; call print green color string function

    mov ax, 0x00         ; get keyboard input
    int 0x16            ; interrupt for hold & read input

    ;/////////////////////////////////////////////////////////////
    ; load second sector into memory

    mov ah, 0x02                    ; load second stage to memory
    mov al, 1                       ; number of sectors to read into memory
    mov dl, 0x80                    ; sector read from fixed/USB disk
    mov ch, 0                       ; cylinder number
    mov dh, 0                       ; head number
    mov cl, 2                       ; sector number
    mov bx, _OS_Stage_2             ; load into es:bx segment:offset of buffer
    int 0x13                        ; disk I/O interrupt

    jmp _OS_Stage_2                 ; jump to second stage

    ;/////////////////////////////////////////////////////////////
    ; declaring string data here
start_os_intro db '    Welcome to ARSHAD_OS!', 0
press_key db '>>>> Press any key to start <<<<', 0
login_username db 'Username : ', 0
login_password db 'Password : ', 0
display_text db '      ##Welcome To ARSHAD OS##', 0
os_info db 10, 'OS: ARSHAD_OS Bits: 16-Bit ver: version=1.0', 13, 0
press_key_2 db 10, 'Press any key to go to GUI view...', 0
window_text db 10, 'GUI', 0
hello_world_text db 10, 10, '    I CAN AND I WILL', 0
login_label db '#] Login....(ESC to skip login)', 0

    ;/////////////////////////////////////////////////////////////
    ; defining printing string functions here

    ;****** print string without color
print_string:
    mov ah, 0x0E            ; value to tell interrupt handler to print character from al
.repeat_next_char:
    lodsb                ; get character from string
    cmp al, 0            ; compare al with end of string
    je .done_print       ; if char is zero, end of string
    int 0x10             ; otherwise, print it
    jmp .repeat_next_char; jump to .repeat_next_char if not 0
.done_print:
    ret

    ;****** print string with different colors
_print_DiffColor_String:
    mov bl, 1             ; color value
    mov ah, 0x0E
.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    add bl, 6            ; increase color value by 6
    int 0x10
    jmp .repeat_next_char
.done_print:
    ret

    ;****** print string with green color
_print_GreenColor_String:
    mov bl, 10
    mov ah, 0x0E
.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    int 0x10
    jmp .repeat_next_char
.done_print:
    ret

    ;****** print string with white color
_print_WhiteColor_String:
    mov bl, 15
    mov ah, 0x0E
.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    int 0x10
    jmp .repeat_next_char
.done_print:
    ret

    ;****** print string with yellow color
_print_YellowColor_String:
    mov bl, 14
    mov ah, 0x0E
.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    int 0x10
    jmp .repeat_next_char
.done_print:
    ret

    ;///////////////////////////////////////////
    ; boot loader magic number
    times ((0x200 - 2) - ($ - $$)) db 0x00 ; set 512 bytes for boot sector
    dw 0xAA55                           ; boot signature 0xAA & 0x55

;////////////////////////////////////////////////////////////////////////////////////////

_OS_Stage_2:
    mov al, 2                    ; set font to normal mode
    mov ah, 0                    ; clear the screen
    int 0x10                    ; call video interrupt

    mov cx, 0                    ; initialize counter(cx) to get input

    ;***** print login_label on screen
    ; set cursor to specific position on screen
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x00
    mov dl, 0x00
    int 0x10

    mov si, login_label         ; point si to login_label
    call print_string           ; display it on screen

    ;****** read username
    ; set cursor to specific position on screen
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x02
    mov dl, 0x00
    int 0x10

    mov si, login_username      ; point si to login_username
    call print_string           ; display it on screen

_getUsernameinput:
    mov ax, 0x00               ; get keyboard input
    int 0x16                  ; hold for input

    cmp ah, 0x1C               ; compare input with Enter key
    je .exitinput             ; if Enter, jump to exitinput

    cmp ah, 0x01               ; compare input with Escape key
    je _skipLogin             ; if Escape, jump to _skipLogin

    mov ah, 0x0E               ; display input char
    int 0x10

    inc cx                     ; increase counter
    cmp cx, 5                  ; compare counter with 5
    jbe _getUsernameinput      ; if less or equal, jump to _getUsernameinput
    jmp .inputdone            ; else, jump to inputdone

.inputdone:
    mov cx, 0                  ; set counter to 0
    jmp _getUsernameinput     ; jump to _getUsernameinput
    ret                       ; return

.exitinput:
    jmp _startBrowser         ; jump to _startBrowser

_skipLogin:
    jmp _startBrowser         ; jump to _startBrowser

    ;****** read password
    ; set cursor position for text
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x03
    mov dl, 0x00
    int 0x10

    mov si, login_password      ; point si to login_password
    call print_string           ; display it on screen

_getPasswordinput:
    mov ax, 0x00               ; get keyboard input
    int 0x16                  ; hold for input

    cmp ah, 0x1C               ; compare input with Enter key
    je .exitinput             ; if Enter, jump to exitinput

    cmp ah, 0x01               ; compare input with Escape key
    je _skipLogin             ; if Escape, jump to _skipLogin

    inc cx                     ; increase counter
    cmp cx, 5                  ; compare counter with 5
    jbe _getPasswordinput      ; if less or equal, jump to _getPasswordinput
    jmp .inputdone            ; else, jump to inputdone

.inputdone:
    mov cx, 0                  ; set counter to 0
    jmp _getPasswordinput     ; jump to _getPasswordinput
    ret                       ; return

.exitinput:
    jmp _startBrowser         ; jump to _startBrowser

    ;****** display display_text on screen
    ; set cursor position for text
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x0A
    mov dl, 0x0A
    int 0x10

    mov si, display_text       ; point si to display_text
    call print_string          ; display it on screen

    ;****** display window_text on screen
    ; set cursor position for text
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x10
    mov dl, 0x10
    int 0x10

    mov si, window_text        ; point si to window_text
    call print_string          ; display it on screen

    ;****** draw window frame
    mov ah, 0x0C              ; set color to white
    mov al, 0x00              ; set color to black
    mov cx, 0xA0              ; set width of window
    mov dx, 0xB0              ; set height of window
    int 0x10                 ; call video interrupt

    ;****** draw lines on window
    mov ah, 0x0C              ; set color to red
    mov al, 0x04              ; draw horizontal lines
    mov cx, 0x80              ; line length
    mov dx, 0xB0              ; starting position
    int 0x10                 ; call video interrupt

    ;****** show hello_world_text on screen
    ; set cursor position for text
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x10
    mov dl, 0x12
    int 0x10

    mov si, hello_world_text   ; point si to hello_world_text
    call print_string         ; display it on screen

    ;****** end program
    hlt

_startBrowser:
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x0C
    mov dl, 0x00
    int 0x10

    mov si, os_info           ; point to os_info
    call print_string         ; display it on screen

    ;**** jump to URL
    mov ax, 0x00             ; set a URL address to open
    int 0x13                ; open URL
    hlt
