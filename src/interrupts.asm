.include "io.inc65"
; ---------------------------------------------------------------------------
; interrupt.s
; ---------------------------------------------------------------------------
;
; Interrupt handler.
;
; Checks for a BRK instruction and returns from all valid interrupts.

;.import   _stop
.import   _acia_putc, _str_a_to_x
.export   _irq_int, _nmi_int
.export   lastirq
.zeropage
lastirq:      .res 1

.segment  "CODE"

.PC02                             ; Force 65C02 assembly mode

; ---------------------------------------------------------------------------
; Non-maskable interrupt (NMI) service routine

_nmi_int:
            RTI                    ; Return from all NMI interrupts

; ---------------------------------------------------------------------------
; Maskable interrupt (IRQ) service routine
_irq_int:   SEI
            PHA
            LDA IRQ_DATA
            LDX VIA_T1C_L
            ROR
            ;LDA #'H'
            ;STA ACIA_DATA
            CMP lastirq
            BEQ @end
            STA lastirq
            JSR _str_a_to_x
            STA ACIA_DATA
            STX ACIA_DATA
@end:       PLA
            CLI
            RTI

;_irq_int1:  PHX                    ; Save X register contents to stack
;           TSX                    ; Transfer stack pointer to X
;           PHA                    ; Save accumulator contents to stack
;           INX                    ; Increment X so it points to the status
;           INX                    ;   register value saved on the stack
;           LDA $100,X             ; Load status register contents
;           AND #$10               ; Isolate B status bit
;           BNE break              ; If B = 1, BRK detected


; ---------------------------------------------------------------------------
; BRK detected, stop

;break:     JMP _stop              ; If BRK is detected, something very bad
                                  ;   has happened, so stop running
