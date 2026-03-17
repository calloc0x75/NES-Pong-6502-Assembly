.segment "HEADER"
    .byte "NES", $1A
    .byte 2
    .byte 1
    .byte $03
    .byte $00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
.segment "VECTORS"
    .word nmi_handler, reset_handler, irq_handler
.segment "STARTUP"
.zeropage
ball_x:          .res 1
ball_y:          .res 1
ball_dx:         .res 1
ball_dy:         .res 1
paddle1_y:       .res 1
paddle2_y:       .res 1
controller1:     .res 1
controller2:     .res 1
score1_lo:       .res 1
score2_lo:       .res 1
frame_count:     .res 1
temp:            .res 1
temp2:           .res 1
temp3:           .res 1
ball_spd:        .res 1
ball_spd_fast:   .res 1
paddle_height:   .res 1
ai_mask:         .res 1
trail_head:      .res 1
score1_mid           = $0400
score1_hi            = $0401
score2_mid           = $0402
score2_hi            = $0403
controller1_old      = $0404
controller2_old      = $0405
ball_hit_count       = $0406
score_dirty          = $0407
game_state           = $0408
flash_timer          = $0409
paddle_segs          = $040A
menu_cursor          = $040C
menu_mode            = $040D
menu_speed           = $040E
menu_paddle          = $040F
menu_ai              = $0410
game_mode            = $0411
game_speed           = $0412
game_paddle          = $0413
game_ai              = $0414
menu_paddle_spd      = $0415
game_paddle_spd      = $0416
paddle_spd           = $0417
winner               = $0418
victory_timer        = $0419
trail_x0             = $041A
trail_x1             = $041B
trail_x2             = $041C
trail_x3             = $041D
trail_x4             = $041E
trail_x5             = $041F
trail_y0             = $0420
trail_y1             = $0421
trail_y2             = $0422
trail_y3             = $0423
trail_y4             = $0424
trail_y5             = $0425
wrk_lo               = $0426
wrk_mid              = $0427
wrk_hi               = $0428
dig0                 = $0429
dig1                 = $042A
dig2                 = $042B
dig3                 = $042C
dig4                 = $042D
dig5                 = $042E
dig6                 = $042F
score1_tiles         = $0430
score2_tiles         = $0437
rng_state            = $043E
sfx_request          = $043F
sfx_timer            = $0440
menu_spawn           = $0441
game_spawn           = $0442
LEFT_WALL          = 16
RIGHT_WALL         = 240
TOP_WALL           = 16
BOTTOM_WALL        = 224
SCORE_WIN          = 10
BUTTON_A      = %10000000
BUTTON_B      = %01000000
BUTTON_SELECT = %00100000
BUTTON_START  = %00010000
BUTTON_UP     = %00001000
BUTTON_DOWN   = %00000100
BUTTON_LEFT   = %00000010
BUTTON_RIGHT  = %00000001
STATE_TITLE   = 0
STATE_PLAYING = 1
STATE_2P      = 2
STATE_VICTORY = 3
MODE_CLASSIC  = 0
MODE_INFINITE = 1
SRAM_MAGIC    = $6000
SRAM_HI_LO    = $6001
SRAM_HI_MID   = $6002
SRAM_HI_HI    = $6003
SRAM_MAGIC_V  = $A5
TILE_BLANK  = $00
TILE_SOLID  = $01
TILE_BALL   = $02
TILE_LINE   = $03
TILE_DIGIT0 = $04
TILE_COLON  = $28
TILE_RARROW = $29
TILE_LARROW = $2A
SCORE1_HI_B = $20
SCORE1_LO_B = $25
SCORE2_HI_B = $20
SCORE2_LO_B = $31
.segment "CODE"
reset_handler:
    sei
    cld
    ldx #$40
    stx $4017
    ldx #$FF
    txs
    inx
    stx $2000
    stx $2001
    stx $4010
    lda #$0F
    sta $4015
    lda #$73
    sta rng_state
vblank1:
    bit $2002
    bpl vblank1
clrmem:
    lda #$00
    sta $0000,x
    sta $0100,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #$FE
    sta $0200,x
    inx
    bne clrmem
vblank2:
    bit $2002
    bpl vblank2
    lda SRAM_MAGIC
    cmp #SRAM_MAGIC_V
    beq sram_ok
    lda #SRAM_MAGIC_V
    sta SRAM_MAGIC
    lda #$00
    sta SRAM_HI_LO
    sta SRAM_HI_MID
    sta SRAM_HI_HI
sram_ok:
    lda #$00
    sta score1_lo
    sta score1_mid
    sta score1_hi
    sta score2_lo
    sta score2_mid
    sta score2_hi
    sta frame_count
    sta controller1
    sta controller1_old
    sta controller2
    sta controller2_old
    sta ball_hit_count
    sta score_dirty
    sta flash_timer
    sta menu_cursor
    sta menu_mode
    sta trail_head
    sta trail_x0
    sta trail_x1
    sta trail_x2
    sta trail_x3
    sta trail_x4
    sta trail_x5
    sta trail_y0
    sta trail_y1
    sta trail_y2
    sta trail_y3
    sta trail_y4
    sta trail_y5
    lda #1
    sta menu_speed
    lda #1
    sta menu_paddle
    lda #1
    sta menu_paddle_spd
    lda #1
    sta menu_ai
    lda #0
    sta menu_spawn
    lda #STATE_TITLE
    sta game_state
    lda #$3F
    sta $2006
    lda #$00
    sta $2006
    lda #$0F
    sta $2007
    lda #$30
    sta $2007
    lda #$30
    sta $2007
    lda #$30
    sta $2007
    ldx #12
bg_fill:
    lda #$0F
    sta $2007
    dex
    bne bg_fill
    lda #$0F
    sta $2007
    lda #$30
    sta $2007
    lda #$30
    sta $2007
    lda #$30
    sta $2007
    lda #$0F
    sta $2007
    lda #$2D
    sta $2007
    lda #$2D
    sta $2007
    lda #$2D
    sta $2007
    lda #$0F
    sta $2007
    lda #$1D
    sta $2007
    lda #$1D
    sta $2007
    lda #$1D
    sta $2007
    lda #$0F
    sta $2007
    lda #$0D
    sta $2007
    lda #$0D
    sta $2007
    lda #$0D
    sta $2007
    lda #%10000000
    sta $2000
    jsr draw_title_screen
main_loop:
    jsr prepare_score_tiles
    jmp main_loop
read_controllers:
    lda controller1
    sta controller1_old
    lda controller2
    sta controller2_old
    lda #$00
    sta controller1
    sta controller2
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    ldy #8
rc_loop:
    lda $4016
    and #$01
    asl controller1
    ora controller1
    sta controller1
    lda $4017
    and #$01
    asl controller2
    ora controller2
    sta controller2
    dey
    bne rc_loop
    rts
apply_game_settings:
    lda game_speed
    cmp #2
    bne ags_not_fast
    lda #3
    sta ball_spd
    lda #4
    sta ball_spd_fast
    jmp ags_paddle
ags_not_fast:
    cmp #0
    bne ags_normal
    lda #1
    sta ball_spd
    lda #2
    sta ball_spd_fast
    jmp ags_paddle
ags_normal:
    lda #2
    sta ball_spd
    lda #3
    sta ball_spd_fast
ags_paddle:
    lda game_paddle
    cmp #2
    bne ags_not_small
    lda #2
    sta paddle_segs
    lda #16
    sta paddle_height
    jmp ags_ai
ags_not_small:
    cmp #0
    bne ags_med_pad
    lda #6
    sta paddle_segs
    lda #48
    sta paddle_height
    jmp ags_ai
ags_med_pad:
    lda #4
    sta paddle_segs
    lda #32
    sta paddle_height
ags_ai:
    lda game_ai
    cmp #2
    bne ags_not_hard
    lda #$01
    sta ai_mask
    jmp ags_paddle_spd
ags_not_hard:
    cmp #0
    bne ags_med_ai
    lda #$07
    sta ai_mask
    jmp ags_paddle_spd
ags_med_ai:
    lda #$03
    sta ai_mask
ags_paddle_spd:
    lda game_paddle_spd
    cmp #2
    bne aps_not_fast
    lda #3
    sta paddle_spd
    jmp ags_done
aps_not_fast:
    cmp #0
    bne aps_normal
    lda #1
    sta paddle_spd
    jmp ags_done
aps_normal:
    lda #2
    sta paddle_spd
ags_done:
    rts
update_paddles:
    lda controller1
    sta temp
    and #BUTTON_UP
    beq p1_ck_dn
    lda paddle1_y
    sec
    sbc paddle_spd
    bcc p1_top
    cmp #TOP_WALL
    bcc p1_top
    sta paddle1_y
    jmp p1_done
p1_top:
    lda #TOP_WALL
    sta paddle1_y
    jmp p1_done
p1_ck_dn:
    lda temp
    and #BUTTON_DOWN
    beq p1_done
    lda #BOTTOM_WALL
    sec
    sbc paddle_height
    sta temp2
    lda paddle1_y
    clc
    adc paddle_spd
    cmp temp2
    bcs p1_bot
    sta paddle1_y
    jmp p1_done
p1_bot:
    lda temp2
    sta paddle1_y
p1_done:
    lda game_state
    cmp #STATE_2P
    beq p2_human
    lda frame_count
    and ai_mask
    bne ai_done
    lda ball_y
    sec
    sbc paddle2_y
    bmi ai_up
    cmp #16
    bcc ai_done
    lda #BOTTOM_WALL
    sec
    sbc paddle_height
    sta temp
    lda paddle2_y
    clc
    adc paddle_spd
    cmp temp
    bcs ai_done
    sta paddle2_y
    jmp ai_done
ai_up:
    lda paddle2_y
    sec
    sbc paddle_spd
    cmp #TOP_WALL
    bcc ai_done
    sta paddle2_y
    jmp ai_done
p2_human:
    lda controller2
    sta temp
    and #BUTTON_UP
    beq p2_ck_dn
    lda paddle2_y
    sec
    sbc paddle_spd
    bcc p2_top
    cmp #TOP_WALL
    bcc p2_top
    sta paddle2_y
    jmp ai_done
p2_top:
    lda #TOP_WALL
    sta paddle2_y
    jmp ai_done
p2_ck_dn:
    lda temp
    and #BUTTON_DOWN
    beq ai_done
    lda #BOTTOM_WALL
    sec
    sbc paddle_height
    sta temp2
    lda paddle2_y
    clc
    adc paddle_spd
    cmp temp2
    bcs p2_bot
    sta paddle2_y
    jmp ai_done
p2_bot:
    lda temp2
    sta paddle2_y
ai_done:
    rts
push_trail:
    ldx trail_head
    lda ball_x
    sta trail_x0,x
    lda ball_y
    sta trail_y0,x
    inx
    cpx #6
    bne pt_done
    ldx #0
pt_done:
    stx trail_head
    rts
rng_tick:
    lda rng_state
    lsr a
    bcc rng_no_xor
    eor #$B8
rng_no_xor:
    sta rng_state
    rts
rng_sample:
    lda rng_state
    eor frame_count
    sta rng_state
    jmp rng_tick
update_ball:
    jsr push_trail
    lda ball_x
    clc
    adc ball_dx
    sta ball_x
    lda ball_y
    clc
    adc ball_dy
    sta ball_y
    lda ball_y
    cmp #TOP_WALL
    bcc bnc_top
    cmp #BOTTOM_WALL-8
    bcs bnc_bot
    jmp chk_pad
bnc_top:
    lda #TOP_WALL
    sta ball_y
    lda ball_dy
    eor #$FF
    clc
    adc #1
    sta ball_dy
    lda #2
    sta sfx_request
    jmp chk_pad
bnc_bot:
    lda #BOTTOM_WALL-8
    sta ball_y
    lda ball_dy
    eor #$FF
    clc
    adc #1
    sta ball_dy
    lda #2
    sta sfx_request
chk_pad:
    lda ball_dx
    bmi chk_pad_ok
    jmp chk_rpad
chk_pad_ok:
    lda ball_x
    cmp #LEFT_WALL
    bcc chk_rpad
    cmp #LEFT_WALL+8
    bcs chk_rpad
    lda ball_y
    clc
    adc #4
    sec
    sbc paddle1_y
    bmi chk_rpad
    cmp paddle_height
    bcs chk_rpad
    sta temp3
    inc ball_hit_count
    lda paddle_height
    lsr a
    lsr a
    sta temp2
    lda temp3
    cmp temp2
    bcs pad1_not_top
    lda ball_dy
    sec
    sbc #1
    cmp #$FE
    bcs pad1_dy_top_ok
    lda #$FE
pad1_dy_top_ok:
    sta ball_dy
    jmp pad1_dx
pad1_not_top:
    lda paddle_height
    sec
    sbc temp2
    cmp temp3
    bcs pad1_dx
    lda ball_dy
    clc
    adc #1
    cmp #3
    bcc pad1_dy_bot_ok
    lda #2
pad1_dy_bot_ok:
    sta ball_dy
pad1_dx:
    lda game_spawn
    cmp #2
    bne pad1_normal_spd
    lda ball_dx
    bpl pad1_done
    eor #$FF
    clc
    adc #1
    sta ball_dx
    jmp pad1_done
pad1_normal_spd:
    lda ball_spd_fast
    sta ball_dx
pad1_done:
    lda #LEFT_WALL+8
    sta ball_x
    lda #1
    sta sfx_request
    jmp ball_done
chk_rpad:
    lda ball_dx
    bpl chk_rpad_ok
    jmp chk_goals
chk_rpad_ok:
    lda ball_x
    cmp #RIGHT_WALL-8
    bcs chk_rpad_x_ok
    jmp chk_goals
chk_rpad_x_ok:
    cmp #RIGHT_WALL
    bcs chk_goals
    lda ball_y
    clc
    adc #4
    sec
    sbc paddle2_y
    bmi chk_goals
    cmp paddle_height
    bcs chk_goals
    sta temp3
    inc ball_hit_count
    lda paddle_height
    lsr a
    lsr a
    sta temp2
    lda temp3
    cmp temp2
    bcs pad2_not_top
    lda ball_dy
    sec
    sbc #1
    cmp #$FE
    bcs pad2_dy_top_ok
    lda #$FE
pad2_dy_top_ok:
    sta ball_dy
    jmp pad2_dx
pad2_not_top:
    lda paddle_height
    sec
    sbc temp2
    cmp temp3
    bcs pad2_dx
    lda ball_dy
    clc
    adc #1
    cmp #3
    bcc pad2_dy_bot_ok
    lda #2
pad2_dy_bot_ok:
    sta ball_dy
pad2_dx:
    lda game_spawn
    cmp #2
    bne pad2_normal_spd
    lda ball_dx
    bmi pad2_done
    eor #$FF
    clc
    adc #1
    sta ball_dx
    jmp pad2_done
pad2_normal_spd:
    lda #$00
    sec
    sbc ball_spd_fast
    sta ball_dx
pad2_done:
    lda #RIGHT_WALL-9
    sta ball_x
    lda #1
    sta sfx_request
    jmp ball_done
chk_goals:
    lda ball_x
    cmp #LEFT_WALL
    bcc p2_scored
    cmp #RIGHT_WALL
    bcs p1_scored
    jmp ball_done
p1_scored:
    inc score1_lo
    bne p1s_no_carry1
    inc score1_mid
    bne p1s_no_carry1
    inc score1_hi
p1s_no_carry1:
    lda #1
    sta score_dirty
    lda #3
    sta sfx_request
    lda #24
    sta sfx_timer
    lda game_mode
    cmp #MODE_INFINITE
    bne p1s_no_hi
    jsr check_update_hiscore
p1s_no_hi:
    lda game_mode
    cmp #MODE_CLASSIC
    beq p1s_is_classic
    jmp rst_p1
p1s_is_classic:
    lda score1_lo
    cmp #SCORE_WIN
    bcc p1s_no_win
    lda score1_mid
    bne p1s_no_win
    lda #0
    sta winner
    jsr go_to_victory
    jmp ball_done
p1s_no_win:
    jmp rst_p1
p2_scored:
    inc score2_lo
    bne p2s_no_carry1
    inc score2_mid
    bne p2s_no_carry1
    inc score2_hi
p2s_no_carry1:
    lda #1
    sta score_dirty
    lda #3
    sta sfx_request
    lda #24
    sta sfx_timer
    lda game_mode
    cmp #MODE_CLASSIC
    bne rst_p2
    lda score2_lo
    cmp #SCORE_WIN
    bcc rst_p2
    lda score2_mid
    bne rst_p2
    lda #1
    sta winner
    jsr go_to_victory
    jmp ball_done
rst_p2:
    lda #120
    sta ball_x
    lda game_spawn
    cmp #2
    beq rp2_crazy
    cmp #1
    beq rp2_medium
    lda #112
    sta ball_y
    jmp rp2_dx
rp2_medium:
    jsr rng_sample
    lda rng_state
    and #$01
    beq rp2_med_low
    lda #102
    sta ball_y
    jmp rp2_dx
rp2_med_low:
    lda #122
    sta ball_y
    jmp rp2_dx
rp2_crazy:
    jsr rng_sample
    lda rng_state
    and #$7F
    clc
    adc #48
    sta ball_y
rp2_dx:
    lda game_spawn
    cmp #2
    beq rp2_crazy_dx
    lda #$00
    sec
    sbc ball_spd_fast
    sta ball_dx
    jsr rng_sample
    lda rng_state
    and #$01
    beq rp2_dy_pos
    lda #$FF
    sta ball_dy
    lda #0
    sta ball_hit_count
    jmp ball_done
rp2_dy_pos:
    lda #1
    sta ball_dy
    lda #0
    sta ball_hit_count
    jmp ball_done
rp2_crazy_dx:
    jsr rng_sample
    lda rng_state
    and #$01
    clc
    adc #2
    eor #$FF
    clc
    adc #1
    sta ball_dx
    jsr rng_sample
    lda rng_state
    and #$01
    beq rp2_crazy_dy_pos
    lda #$FF
    sta ball_dy
    lda #0
    sta ball_hit_count
    jmp ball_done
rp2_crazy_dy_pos:
    lda #1
    sta ball_dy
    lda #0
    sta ball_hit_count
    jmp ball_done
rst_p1:
    lda #120
    sta ball_x
    lda game_spawn
    cmp #2
    beq rp1_crazy
    cmp #1
    beq rp1_medium
    lda #112
    sta ball_y
    jmp rp1_dx
rp1_medium:
    jsr rng_sample
    lda rng_state
    and #$01
    beq rp1_med_low
    lda #102
    sta ball_y
    jmp rp1_dx
rp1_med_low:
    lda #122
    sta ball_y
    jmp rp1_dx
rp1_crazy:
    jsr rng_sample
    lda rng_state
    and #$7F
    clc
    adc #48
    sta ball_y
rp1_dx:
    lda game_spawn
    cmp #2
    beq rp1_crazy_dx
    lda ball_spd_fast
    sta ball_dx
    jsr rng_sample
    lda rng_state
    and #$01
    beq rp1_dy_pos
    lda #$FF
    sta ball_dy
    lda #0
    sta ball_hit_count
    jmp ball_done
rp1_dy_pos:
    lda #1
    sta ball_dy
    lda #0
    sta ball_hit_count
    jmp ball_done
rp1_crazy_dx:
    jsr rng_sample
    lda rng_state
    and #$01
    clc
    adc #2
    sta ball_dx
    jsr rng_sample
    lda rng_state
    and #$01
    beq rp1_crazy_dy_pos
    lda #$FF
    sta ball_dy
    lda #0
    sta ball_hit_count
    jmp ball_done
rp1_crazy_dy_pos:
    lda #1
    sta ball_dy
    lda #0
    sta ball_hit_count
ball_done:
    rts
check_update_hiscore:
    lda score1_hi
    cmp SRAM_HI_HI
    bcc cuh_no
    bne cuh_update
    lda score1_mid
    cmp SRAM_HI_MID
    bcc cuh_no
    bne cuh_update
    lda score1_lo
    cmp SRAM_HI_LO
    bcc cuh_no
cuh_update:
    lda score1_lo
    sta SRAM_HI_LO
    lda score1_mid
    sta SRAM_HI_MID
    lda score1_hi
    sta SRAM_HI_HI
cuh_no:
    rts
go_to_victory:
    lda game_state
    sta temp3
    lda #STATE_VICTORY
    sta game_state
    lda #0
    sta victory_timer
    ldx #$00
    lda #$FE
hide_vic_spr:
    sta $0200,x
    inx
    inx
    inx
    inx
    bne hide_vic_spr
    jsr draw_victory_screen
    rts
go_to_title:
    lda #STATE_TITLE
    sta game_state
    lda #0
    sta score_dirty
    ldx #$00
    lda #$FE
hide_spr:
    sta $0200,x
    inx
    inx
    inx
    inx
    bne hide_spr
    jsr draw_title_screen
    rts
init_game:
    lda menu_mode
    sta game_mode
    lda menu_speed
    sta game_speed
    lda menu_paddle
    sta game_paddle
    lda menu_paddle_spd
    sta game_paddle_spd
    lda menu_ai
    sta game_ai
    lda menu_spawn
    sta game_spawn
    jsr apply_game_settings
    lda #100
    sta paddle1_y
    sta paddle2_y
    lda #0
    sta score1_lo
    sta score1_mid
    sta score1_hi
    sta score2_lo
    sta score2_mid
    sta score2_hi
    sta ball_hit_count
    sta trail_head
    sta trail_x0
    sta trail_x1
    sta trail_x2
    sta trail_x3
    sta trail_x4
    sta trail_x5
    sta trail_y0
    sta trail_y1
    sta trail_y2
    sta trail_y3
    sta trail_y4
    sta trail_y5
    lda #1
    sta score_dirty
    jsr draw_game_nametable
    jmp rst_p1
draw_game_nametable:
    lda #$00
    sta $2001
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    ldy #4
    ldx #0
dgn_clr:
    lda #TILE_BLANK
    sta $2007
    inx
    bne dgn_clr
    dey
    bne dgn_clr
    ldy #0
dgn_line:
    tya
    asl a
    asl a
    asl a
    asl a
    asl a
    clc
    adc #15
    sta temp
    tya
    lsr a
    lsr a
    lsr a
    and #$03
    clc
    adc #$20
    sta $2006
    lda temp
    sta $2006
    lda #TILE_LINE
    sta $2007
    iny
    cpy #30
    bne dgn_line
    lda #$00
    sta $2005
    sta $2005
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    rts
pow10_lo:  .byte $40,$A0,$10,$E8,$64,$0A,$01
pow10_mid: .byte $42,$86,$27,$03,$00,$00,$00
pow10_hi:  .byte $0F,$01,$00,$00,$00,$00,$00
extract_digits_clean:
    lda wrk_hi
    cmp #$09
    bcc edc_no_clamp
    bne edc_clamp
    lda wrk_mid
    cmp #$89
    bcc edc_no_clamp
    bne edc_clamp
    lda wrk_lo
    cmp #$68
    bcc edc_no_clamp
edc_clamp:
    lda #$7F
    sta wrk_lo
    lda #$96
    sta wrk_mid
    lda #$98
    sta wrk_hi
edc_no_clamp:
    ldx #0
edc_outer:
    lda #0
    sta dig0,x
edc_inner:
    sec
    lda wrk_lo
    sbc pow10_lo,x
    sta temp
    lda wrk_mid
    sbc pow10_mid,x
    sta temp2
    lda wrk_hi
    sbc pow10_hi,x
    bcc edc_next
    sta wrk_hi
    lda temp2
    sta wrk_mid
    lda temp
    sta wrk_lo
    inc dig0,x
    jmp edc_inner
edc_next:
    inx
    cpx #7
    bne edc_outer
    rts
write_7digits:
    lda #0
    sta temp
    ldx #0
w7d_loop:
    lda dig0,x
    bne w7d_nonzero
    lda temp
    bne w7d_show_zero
    cpx #6
    bne w7d_blank
    lda #TILE_DIGIT0
    sta $2007
    inx
    cpx #7
    bne w7d_loop
    rts
w7d_blank:
    lda #TILE_BLANK
    sta $2007
    inx
    cpx #7
    bne w7d_loop
    rts
w7d_show_zero:
    lda #TILE_DIGIT0
    sta $2007
    inx
    cpx #7
    bne w7d_loop
    rts
w7d_nonzero:
    lda #1
    sta temp
    lda dig0,x
    clc
    adc #TILE_DIGIT0
    sta $2007
    inx
    cpx #7
    bne w7d_loop
    rts
prepare_score_tiles:
    lda score_dirty
    cmp #1
    bne pst_skip
    jmp pst_check_state
pst_skip:
    rts
pst_check_state:
    lda game_state
    cmp #STATE_PLAYING
    beq pst_go
    cmp #STATE_2P
    beq pst_go
    rts
pst_go:
    ldx #6
pst_clear:
    lda #TILE_BLANK
    sta score1_tiles,x
    sta score2_tiles,x
    dex
    bpl pst_clear
    lda score1_lo
    sta wrk_lo
    lda score1_mid
    sta wrk_mid
    lda score1_hi
    sta wrk_hi
    jsr extract_digits_clean
    lda #0
    sta temp
    ldx #0
pst_s1:
    lda dig0,x
    bne pst_s1_nz
    lda temp
    bne pst_s1_zero
    cpx #6
    bne pst_s1_blank
    lda #TILE_DIGIT0
    jmp pst_s1_store
pst_s1_blank:
    lda #TILE_BLANK
    jmp pst_s1_store
pst_s1_zero:
    lda #TILE_DIGIT0
    jmp pst_s1_store
pst_s1_nz:
    lda #1
    sta temp
    lda dig0,x
    clc
    adc #TILE_DIGIT0
pst_s1_store:
    sta score1_tiles,x
    inx
    cpx #7
    bne pst_s1
    lda score2_lo
    sta wrk_lo
    lda score2_mid
    sta wrk_mid
    lda score2_hi
    sta wrk_hi
    jsr extract_digits_clean
    lda #0
    sta temp
    ldx #0
pst_s2:
    lda dig0,x
    bne pst_s2_nz
    lda temp
    bne pst_s2_zero
    cpx #6
    bne pst_s2_blank
    lda #TILE_DIGIT0
    jmp pst_s2_store
pst_s2_blank:
    lda #TILE_BLANK
    jmp pst_s2_store
pst_s2_zero:
    lda #TILE_DIGIT0
    jmp pst_s2_store
pst_s2_nz:
    lda #1
    sta temp
    lda dig0,x
    clc
    adc #TILE_DIGIT0
pst_s2_store:
    sta score2_tiles,x
    inx
    cpx #7
    bne pst_s2
    lda #2
    sta score_dirty
    rts
update_score_display:
    lda score_dirty
    cmp #2
    bne usd_done
    lda #SCORE1_HI_B
    sta $2006
    lda #SCORE1_LO_B
    sta $2006
    ldx #0
usd_s1:
    lda score1_tiles,x
    sta $2007
    inx
    cpx #7
    bne usd_s1
    lda #SCORE2_HI_B
    sta $2006
    lda #SCORE2_LO_B
    sta $2006
    ldx #0
usd_s2:
    lda score2_tiles,x
    sta $2007
    inx
    cpx #7
    bne usd_s2
    lda #$00
    sta score_dirty
usd_done:
    rts
draw_title_screen:
    lda #$00
    sta $2001
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    ldy #4
    ldx #0
dts_clr:
    lda #TILE_BLANK
    sta $2007
    inx
    bne dts_clr
    dey
    bne dts_clr
    lda #$20
    sta $2006
    lda #$8E
    sta $2006
    lda #$1D
    sta $2007
    lda #$1C
    sta $2007
    lda #$1B
    sta $2007
    lda #$14
    sta $2007
    lda #$20
    sta $2006
    lda #$C7
    sta $2006
    lda #$15
    sta $2007
    lda #$16
    sta $2007
    lda #$14
    sta $2007
    lda #$15
    sta $2007
    lda #$20
    sta $2007
    lda #$10
    sta $2007
    lda #$1C
    sta $2007
    lda #$1F
    sta $2007
    lda #$12
    sta $2007
    lda #TILE_COLON
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda SRAM_HI_LO
    sta wrk_lo
    lda SRAM_HI_MID
    sta wrk_mid
    lda SRAM_HI_HI
    sta wrk_hi
    jsr extract_digits_clean
    jsr write_7digits
    lda #$21
    sta $2006
    lda #$2C
    sta $2006
    lda #TILE_DIGIT0+1
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1D
    sta $2007
    lda #$19
    sta $2007
    lda #$0E
    sta $2007
    lda #$26
    sta $2007
    lda #$12
    sta $2007
    lda #$1F
    sta $2007
    lda #$21
    sta $2006
    lda #$6C
    sta $2006
    lda #TILE_DIGIT0+2
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1D
    sta $2007
    lda #$19
    sta $2007
    lda #$0E
    sta $2007
    lda #$26
    sta $2007
    lda #$12
    sta $2007
    lda #$1F
    sta $2007
    lda #$20
    sta $2007
    lda #$21
    sta $2006
    lda #$B7
    sta $2006
    lda #$1A
    sta $2007
    lda #$1C
    sta $2007
    lda #$11
    sta $2007
    lda #$12
    sta $2007
    lda #$21
    sta $2006
    lda #$F7
    sta $2006
    lda #$20
    sta $2007
    lda #$1D
    sta $2007
    lda #$12
    sta $2007
    lda #$12
    sta $2007
    lda #$11
    sta $2007
    lda #$22
    sta $2006
    lda #$37
    sta $2006
    lda #$20
    sta $2007
    lda #$16
    sta $2007
    lda #$27
    sta $2007
    lda #$12
    sta $2007
    lda #$22
    sta $2006
    lda #$77
    sta $2006
    lda #$1D
    sta $2007
    lda #$20
    sta $2007
    lda #$1D
    sta $2007
    lda #$11
    sta $2007
    lda #$22
    sta $2006
    lda #$B7
    sta $2006
    lda #$0E
    sta $2007
    lda #$16
    sta $2007
    lda #$22
    sta $2006
    lda #$F7
    sta $2006
    lda #$20
    sta $2007
    lda #$1D
    sta $2007
    lda #$0E
    sta $2007
    lda #$24
    sta $2007
    lda #$1B
    sta $2007
    jsr draw_menu_cursor
    jsr draw_all_sliders
    lda #$00
    sta $2005
    sta $2005
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    rts
draw_menu_cursor:
    lda #$21
    sta $2006
    lda #$2A
    sta $2006
    lda #TILE_BLANK
    sta $2007
    lda #$21
    sta $2006
    lda #$6A
    sta $2006
    lda #TILE_BLANK
    sta $2007
    lda #$21
    sta $2006
    lda #$AA
    sta $2006
    lda #TILE_BLANK
    sta $2007
    lda #$21
    sta $2006
    lda #$EA
    sta $2006
    lda #TILE_BLANK
    sta $2007
    lda #$22
    sta $2006
    lda #$2A
    sta $2006
    lda #TILE_BLANK
    sta $2007
    lda #$22
    sta $2006
    lda #$6A
    sta $2006
    lda #TILE_BLANK
    sta $2007
    lda #$22
    sta $2006
    lda #$AA
    sta $2006
    lda #TILE_BLANK
    sta $2007
    lda #$22
    sta $2006
    lda #$EA
    sta $2006
    lda #TILE_BLANK
    sta $2007
    ldx menu_cursor
    lda cursor_hi,x
    sta $2006
    lda cursor_lo,x
    sta $2006
    lda #TILE_RARROW
    sta $2007
    rts
cursor_hi: .byte $21,$21,$21,$21,$22,$22,$22,$22
cursor_lo: .byte $2A,$6A,$AA,$EA,$2A,$6A,$AA,$EA
draw_all_sliders:
    lda #$21
    sta $2006
    lda #$A9
    sta $2006
    lda menu_mode
    jsr draw_slider_mode
    lda #$21
    sta $2006
    lda #$E9
    sta $2006
    lda menu_speed
    jsr draw_slider_speed
    lda #$22
    sta $2006
    lda #$29
    sta $2006
    lda menu_paddle
    jsr draw_slider_paddle
    lda #$22
    sta $2006
    lda #$69
    sta $2006
    lda menu_paddle_spd
    jsr draw_slider_paddle_spd
    lda #$22
    sta $2006
    lda #$A9
    sta $2006
    lda menu_ai
    jsr draw_slider_ai
    lda #$22
    sta $2006
    lda #$E9
    sta $2006
    lda menu_spawn
    jsr draw_slider_spawn
    rts
draw_slider_mode:
    cmp #1
    beq dsm_infinite
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$10
    sta $2007
    lda #$19
    sta $2007
    lda #$0E
    sta $2007
    lda #$20
    sta $2007
    lda #$20
    sta $2007
    lda #$16
    sta $2007
    lda #$10
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dsm_infinite:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$16
    sta $2007
    lda #$1B
    sta $2007
    lda #$13
    sta $2007
    lda #$16
    sta $2007
    lda #$1B
    sta $2007
    lda #$16
    sta $2007
    lda #$21
    sta $2007
    lda #$12
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
draw_slider_speed:
    cmp #0
    beq dss_slow
    cmp #2
    bne dss_normal
    jmp dss_fast
dss_normal:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1B
    sta $2007
    lda #$1C
    sta $2007
    lda #$1F
    sta $2007
    lda #$1A
    sta $2007
    lda #$0E
    sta $2007
    lda #$19
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dss_slow:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$20
    sta $2007
    lda #$19
    sta $2007
    lda #$1C
    sta $2007
    lda #$24
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dss_fast:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$13
    sta $2007
    lda #$0E
    sta $2007
    lda #$20
    sta $2007
    lda #$21
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
draw_slider_paddle:
    cmp #0
    beq dsp_big
    cmp #2
    bne dsp_medium
    jmp dsp_small
dsp_medium:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1A
    sta $2007
    lda #$12
    sta $2007
    lda #$11
    sta $2007
    lda #$16
    sta $2007
    lda #$22
    sta $2007
    lda #$1A
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dsp_big:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$0F
    sta $2007
    lda #$16
    sta $2007
    lda #$14
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dsp_small:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$20
    sta $2007
    lda #$1A
    sta $2007
    lda #$0E
    sta $2007
    lda #$19
    sta $2007
    lda #$19
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
draw_slider_paddle_spd:
    cmp #0
    beq dpsp_slow
    cmp #2
    bne dpsp_normal
    jmp dpsp_fast
dpsp_normal:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1B
    sta $2007
    lda #$1C
    sta $2007
    lda #$1F
    sta $2007
    lda #$1A
    sta $2007
    lda #$0E
    sta $2007
    lda #$19
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dpsp_slow:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$20
    sta $2007
    lda #$19
    sta $2007
    lda #$1C
    sta $2007
    lda #$24
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dpsp_fast:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$13
    sta $2007
    lda #$0E
    sta $2007
    lda #$20
    sta $2007
    lda #$21
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
draw_slider_ai:
    cmp #0
    beq dsai_easy
    cmp #2
    bne dsai_med
    jmp dsai_hard
dsai_med:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1A
    sta $2007
    lda #$12
    sta $2007
    lda #$11
    sta $2007
    lda #$16
    sta $2007
    lda #$22
    sta $2007
    lda #$1A
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dsai_easy:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$12
    sta $2007
    lda #$0E
    sta $2007
    lda #$20
    sta $2007
    lda #$26
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dsai_hard:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$15
    sta $2007
    lda #$0E
    sta $2007
    lda #$1F
    sta $2007
    lda #$11
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
draw_slider_spawn:
    cmp #0
    beq dss2_none
    cmp #2
    bne dss2_medium
    jmp dss2_crazy
dss2_none:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1B
    sta $2007
    lda #$1C
    sta $2007
    lda #$1B
    sta $2007
    lda #$12
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dss2_medium:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$1A
    sta $2007
    lda #$12
    sta $2007
    lda #$11
    sta $2007
    lda #$16
    sta $2007
    lda #$22
    sta $2007
    lda #$1A
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
dss2_crazy:
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$10
    sta $2007
    lda #$1F
    sta $2007
    lda #$0E
    sta $2007
    lda #$27
    sta $2007
    lda #$26
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_BLANK
    sta $2007
    rts
draw_victory_screen:
    lda #$00
    sta $2001
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    ldy #4
    ldx #0
dvs_clr:
    lda #TILE_BLANK
    sta $2007
    inx
    bne dvs_clr
    dey
    bne dvs_clr
    lda winner
    bne dvs_p2_wins
    lda #$21
    sta $2006
    lda #$49
    sta $2006
    lda #$1D
    sta $2007
    lda #$19
    sta $2007
    lda #$0E
    sta $2007
    lda #$26
    sta $2007
    lda #$12
    sta $2007
    lda #$1F
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_DIGIT0+1
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$24
    sta $2007
    lda #$16
    sta $2007
    lda #$1B
    sta $2007
    lda #$20
    sta $2007
    jmp dvs_show
dvs_p2_wins:
    lda temp3
    cmp #STATE_2P
    bne dvs_you_lose
    lda #$21
    sta $2006
    lda #$49
    sta $2006
    lda #$1D
    sta $2007
    lda #$19
    sta $2007
    lda #$0E
    sta $2007
    lda #$26
    sta $2007
    lda #$12
    sta $2007
    lda #$1F
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #TILE_DIGIT0+2
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$24
    sta $2007
    lda #$16
    sta $2007
    lda #$1B
    sta $2007
    lda #$20
    sta $2007
    jmp dvs_show
dvs_you_lose:
    lda #$21
    sta $2006
    lda #$4C
    sta $2006
    lda #$26
    sta $2007
    lda #$1C
    sta $2007
    lda #$22
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$19
    sta $2007
    lda #$1C
    sta $2007
    lda #$20
    sta $2007
    lda #$12
    sta $2007
dvs_show:
    lda #$00
    sta $2005
    sta $2005
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    rts
flash_press_start:
    inc flash_timer
    lda flash_timer
    and #$20
    beq fps_hide
    lda #$23
    sta $2006
    lda #$2A
    sta $2006
    lda #$1D
    sta $2007
    lda #$1F
    sta $2007
    lda #$12
    sta $2007
    lda #$20
    sta $2007
    lda #$20
    sta $2007
    lda #TILE_BLANK
    sta $2007
    lda #$20
    sta $2007
    lda #$21
    sta $2007
    lda #$0E
    sta $2007
    lda #$1F
    sta $2007
    lda #$21
    sta $2007
    jmp fps_done
fps_hide:
    lda #$23
    sta $2006
    lda #$2A
    sta $2006
    ldx #11
fps_blank:
    lda #TILE_BLANK
    sta $2007
    dex
    bne fps_blank
fps_done:
    lda #$00
    sta $2005
    sta $2005
    rts
update_sprites:
    lda ball_y
    sta $0200
    lda #TILE_BALL
    sta $0201
    lda #$20
    sta $0202
    lda ball_x
    sta $0203
    lda #0
    cmp paddle_height
    bcs p1s0_hide
    lda paddle1_y
    jmp p1s0_write
p1s0_hide: lda #$FE
p1s0_write:
    sta $0204
    lda #TILE_SOLID
    sta $0205
    lda #$00
    sta $0206
    lda #LEFT_WALL
    sta $0207
    lda #8
    cmp paddle_height
    bcs p1s1_hide
    clc
    adc paddle1_y
    jmp p1s1_write
p1s1_hide: lda #$FE
p1s1_write:
    sta $0208
    lda #TILE_SOLID
    sta $0209
    lda #$00
    sta $020A
    lda #LEFT_WALL
    sta $020B
    lda #16
    cmp paddle_height
    bcs p1s2_hide
    clc
    adc paddle1_y
    jmp p1s2_write
p1s2_hide: lda #$FE
p1s2_write:
    sta $020C
    lda #TILE_SOLID
    sta $020D
    lda #$00
    sta $020E
    lda #LEFT_WALL
    sta $020F
    lda #24
    cmp paddle_height
    bcs p1s3_hide
    clc
    adc paddle1_y
    jmp p1s3_write
p1s3_hide: lda #$FE
p1s3_write:
    sta $0210
    lda #TILE_SOLID
    sta $0211
    lda #$00
    sta $0212
    lda #LEFT_WALL
    sta $0213
    lda #32
    cmp paddle_height
    bcs p1s4_hide
    clc
    adc paddle1_y
    jmp p1s4_write
p1s4_hide: lda #$FE
p1s4_write:
    sta $0214
    lda #TILE_SOLID
    sta $0215
    lda #$00
    sta $0216
    lda #LEFT_WALL
    sta $0217
    lda #40
    cmp paddle_height
    bcs p1s5_hide
    clc
    adc paddle1_y
    jmp p1s5_write
p1s5_hide: lda #$FE
p1s5_write:
    sta $0218
    lda #TILE_SOLID
    sta $0219
    lda #$00
    sta $021A
    lda #LEFT_WALL
    sta $021B
    lda #0
    cmp paddle_height
    bcs p2s0_hide
    lda paddle2_y
    jmp p2s0_write
p2s0_hide: lda #$FE
p2s0_write:
    sta $021C
    lda #TILE_SOLID
    sta $021D
    lda #$00
    sta $021E
    lda #RIGHT_WALL
    sta $021F
    lda #8
    cmp paddle_height
    bcs p2s1_hide
    clc
    adc paddle2_y
    jmp p2s1_write
p2s1_hide: lda #$FE
p2s1_write:
    sta $0220
    lda #TILE_SOLID
    sta $0221
    lda #$00
    sta $0222
    lda #RIGHT_WALL
    sta $0223
    lda #16
    cmp paddle_height
    bcs p2s2_hide
    clc
    adc paddle2_y
    jmp p2s2_write
p2s2_hide: lda #$FE
p2s2_write:
    sta $0224
    lda #TILE_SOLID
    sta $0225
    lda #$00
    sta $0226
    lda #RIGHT_WALL
    sta $0227
    lda #24
    cmp paddle_height
    bcs p2s3_hide
    clc
    adc paddle2_y
    jmp p2s3_write
p2s3_hide: lda #$FE
p2s3_write:
    sta $0228
    lda #TILE_SOLID
    sta $0229
    lda #$00
    sta $022A
    lda #RIGHT_WALL
    sta $022B
    lda #32
    cmp paddle_height
    bcs p2s4_hide
    clc
    adc paddle2_y
    jmp p2s4_write
p2s4_hide: lda #$FE
p2s4_write:
    sta $022C
    lda #TILE_SOLID
    sta $022D
    lda #$00
    sta $022E
    lda #RIGHT_WALL
    sta $022F
    lda #40
    cmp paddle_height
    bcs p2s5_hide
    clc
    adc paddle2_y
    jmp p2s5_write
p2s5_hide: lda #$FE
p2s5_write:
    sta $0230
    lda #TILE_SOLID
    sta $0231
    lda #$00
    sta $0232
    lda #RIGHT_WALL
    sta $0233
    lda trail_head
    clc
    adc #5
    cmp #6
    bcc tr_ok0
    sbc #6
tr_ok0:
    tax
    lda trail_y0,x
    sta $0234
    lda #TILE_BALL
    sta $0235
    lda #$21
    sta $0236
    lda trail_x0,x
    sta $0237
    txa
    clc
    adc #5
    cmp #6
    bcc tr_ok1
    sbc #6
tr_ok1:
    tax
    lda trail_y0,x
    sta $0238
    lda #TILE_BALL
    sta $0239
    lda #$21
    sta $023A
    lda trail_x0,x
    sta $023B
    txa
    clc
    adc #5
    cmp #6
    bcc tr_ok2
    sbc #6
tr_ok2:
    tax
    lda trail_y0,x
    sta $023C
    lda #TILE_BALL
    sta $023D
    lda #$22
    sta $023E
    lda trail_x0,x
    sta $023F
    txa
    clc
    adc #5
    cmp #6
    bcc tr_ok3
    sbc #6
tr_ok3:
    tax
    lda trail_y0,x
    sta $0240
    lda #TILE_BALL
    sta $0241
    lda #$22
    sta $0242
    lda trail_x0,x
    sta $0243
    txa
    clc
    adc #5
    cmp #6
    bcc tr_ok4
    sbc #6
tr_ok4:
    tax
    lda trail_y0,x
    sta $0244
    lda #TILE_BALL
    sta $0245
    lda #$23
    sta $0246
    lda trail_x0,x
    sta $0247
    txa
    clc
    adc #5
    cmp #6
    bcc tr_ok5
    sbc #6
tr_ok5:
    tax
    lda trail_y0,x
    sta $0248
    lda #TILE_BALL
    sta $0249
    lda #$23
    sta $024A
    lda trail_x0,x
    sta $024B
    rts
sfx_update:
    lda sfx_request
    bne sfx_not_idle
    rts
sfx_not_idle:
    cmp #1
    bne sfx_ck_wall
    lda #%10011111
    sta $4000
    lda #$00
    sta $4001
    lda #$DE
    sta $4002
    lda #%00101000
    sta $4003
    lda #0
    sta sfx_request
    rts
sfx_ck_wall:
    cmp #2
    bne sfx_ck_score
    lda #%10001111
    sta $4004
    lda #$00
    sta $4005
    lda #$D1
    sta $4006
    lda #%00101001
    sta $4007
    lda #0
    sta sfx_request
    rts
sfx_ck_score:
    cmp #3
    bne sfx_ck_menu
    lda sfx_timer
    beq sfx_score_done
    lda #$FF
    sta $4008
    lda sfx_timer
    cmp #19
    bcc sfx_s_note3
    lda #$69
    jmp sfx_s_write
sfx_s_note3:
    cmp #13
    bcc sfx_s_note2
    lda #$8D
    jmp sfx_s_write
sfx_s_note2:
    cmp #7
    bcc sfx_s_note1
    lda #$A8
    jmp sfx_s_write
sfx_s_note1:
    lda #$D4
sfx_s_write:
    sta $400A
    lda #%00000001
    sta $400B
    dec sfx_timer
    bne sfx_score_keep
    lda #0
    sta sfx_request
    lda #$00
    sta $4008
    sta $400B
    rts
sfx_score_keep:
    rts
sfx_score_done:
    lda #0
    sta sfx_request
    rts
sfx_ck_menu:
    lda #%00110000
    sta $400C
    lda #$00
    sta $400D
    lda #$06
    sta $400E
    lda #%00001000
    sta $400F
    lda #0
    sta sfx_request
    rts
nmi_handler:
    pha
    txa
    pha
    tya
    pha
    inc frame_count
    jsr rng_tick
    jsr sfx_update
    lda game_state
    cmp #STATE_TITLE
    beq nmi_title
    cmp #STATE_VICTORY
    beq nmi_victory
    lda frame_count
    and #$01
    bne skip_logic
    jsr read_controllers
    jsr update_paddles
    jsr update_ball
skip_logic:
    lda game_state
    cmp #STATE_TITLE
    bne skip_not_title
    jmp nmi_exit
skip_not_title:
    cmp #STATE_VICTORY
    beq nmi_victory_dma
    jsr update_sprites
    jsr update_score_display
    lda #$00
    sta $2003
    lda #$02
    sta $4014
    jmp nmi_exit
nmi_victory_dma:
    lda #$00
    sta $2003
    lda #$02
    sta $4014
    jmp nmi_exit
nmi_victory:
    lda #$00
    sta $2003
    lda #$02
    sta $4014
    inc victory_timer
    lda victory_timer
    cmp #180
    bcs victory_expired
    jmp nmi_exit
victory_expired:
    jsr go_to_title
    jmp nmi_exit
nmi_title:
    jsr flash_press_start
    jsr read_controllers
    lda controller1
    and #BUTTON_UP
    bne do_up
    lda controller2
    and #BUTTON_UP
    beq title_ck_dn
do_up:
    lda controller1_old
    and #BUTTON_UP
    bne title_ck_dn
    lda controller2_old
    and #BUTTON_UP
    bne title_ck_dn
    lda menu_cursor
    beq title_ck_lr
    dec menu_cursor
    lda #4
    sta sfx_request
    jsr draw_menu_cursor
    jmp title_ck_lr
title_ck_dn:
    lda controller1
    and #BUTTON_DOWN
    bne do_dn
    lda controller2
    and #BUTTON_DOWN
    beq title_ck_lr
do_dn:
    lda controller1_old
    and #BUTTON_DOWN
    bne title_ck_lr
    lda controller2_old
    and #BUTTON_DOWN
    bne title_ck_lr
    lda menu_cursor
    cmp #7
    beq title_ck_lr
    inc menu_cursor
    lda #4
    sta sfx_request
    jsr draw_menu_cursor
title_ck_lr:
    lda menu_cursor
    cmp #2
    bcc title_ck_start
    lda controller1
    and #BUTTON_LEFT
    bne do_left
    lda controller2
    and #BUTTON_LEFT
    beq title_ck_right
do_left:
    lda controller1_old
    and #BUTTON_LEFT
    bne title_ck_right
    lda controller2_old
    and #BUTTON_LEFT
    bne title_ck_right
    jsr slider_dec
    jsr draw_all_sliders
    jsr draw_menu_cursor
    jmp title_ck_start
title_ck_right:
    lda controller1
    and #BUTTON_RIGHT
    bne do_right
    lda controller2
    and #BUTTON_RIGHT
    beq title_ck_start
do_right:
    lda controller1_old
    and #BUTTON_RIGHT
    bne title_ck_start
    lda controller2_old
    and #BUTTON_RIGHT
    bne title_ck_start
    jsr slider_inc
    jsr draw_all_sliders
    jsr draw_menu_cursor
title_ck_start:
    lda menu_cursor
    cmp #2
    bcs no_start
    lda controller1
    and #(BUTTON_START | BUTTON_A)
    bne chk_start_new
    lda controller2
    and #(BUTTON_START | BUTTON_A)
    beq no_start
chk_start_new:
    lda controller1_old
    and #(BUTTON_START | BUTTON_A)
    bne no_start
    lda controller2_old
    and #(BUTTON_START | BUTTON_A)
    bne no_start
    lda menu_cursor
    bne launch_2p
    lda #STATE_PLAYING
    sta game_state
    jsr init_game
    jmp no_start
launch_2p:
    lda #STATE_2P
    sta game_state
    jsr init_game
no_start:
    lda #$00
    sta $2003
    lda #$02
    sta $4014
nmi_exit:
    lda #$00
    sta $2005
    sta $2005
    lda #%10000000
    sta $2000
    pla
    tay
    pla
    tax
    pla
    rti
slider_dec:
    lda menu_cursor
    cmp #2
    bne sd_not_mode
    lda menu_mode
    beq sd_done
    dec menu_mode
    jmp sd_done
sd_not_mode:
    cmp #3
    bne sd_not_speed
    lda menu_speed
    beq sd_done
    dec menu_speed
    jmp sd_done
sd_not_speed:
    cmp #4
    bne sd_not_paddle
    lda menu_paddle
    beq sd_done
    dec menu_paddle
    jmp sd_done
sd_not_paddle:
    cmp #5
    bne sd_not_pspd
    lda menu_paddle_spd
    beq sd_done
    dec menu_paddle_spd
    jmp sd_done
sd_not_pspd:
    cmp #6
    bne sd_not_ai
    lda menu_ai
    beq sd_done
    dec menu_ai
    jmp sd_done
sd_not_ai:
    lda menu_spawn
    beq sd_done
    dec menu_spawn
sd_done:
    rts
slider_inc:
    lda menu_cursor
    cmp #2
    bne si_not_mode
    lda menu_mode
    cmp #1
    beq si_done
    inc menu_mode
    jmp si_done
si_not_mode:
    cmp #3
    bne si_not_speed
    lda menu_speed
    cmp #2
    beq si_done
    inc menu_speed
    jmp si_done
si_not_speed:
    cmp #4
    bne si_not_paddle
    lda menu_paddle
    cmp #2
    beq si_done
    inc menu_paddle
    jmp si_done
si_not_paddle:
    cmp #5
    bne si_not_pspd
    lda menu_paddle_spd
    cmp #2
    beq si_done
    inc menu_paddle_spd
    jmp si_done
si_not_pspd:
    cmp #6
    bne si_not_ai
    lda menu_ai
    cmp #2
    beq si_done
    inc menu_ai
    jmp si_done
si_not_ai:
    lda menu_spawn
    cmp #2
    beq si_done
    inc menu_spawn
si_done:
    rts
irq_handler:
    rti
.segment "CHARS"
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$7E,$FF,$FF,$FF,$FF,$7E,$3C
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $18,$18,$18,$18,$18,$18,$18,$18
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$6E,$76,$66,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $18,$38,$18,$18,$18,$18,$7E,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$06,$0C,$18,$30,$7E,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$06,$1C,$06,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $0C,$1C,$3C,$6C,$7E,$0C,$0C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7E,$60,$7C,$06,$06,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$60,$7C,$66,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7E,$06,$06,$0C,$18,$30,$30,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$66,$3C,$66,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$66,$3E,$06,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $18,$3C,$66,$7E,$66,$66,$66,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7C,$66,$66,$7C,$66,$66,$7C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$60,$60,$60,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $78,$6C,$66,$66,$66,$6C,$78,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7E,$60,$60,$7C,$60,$60,$7E,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7E,$60,$60,$7C,$60,$60,$60,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$60,$6E,$66,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $66,$66,$66,$7E,$66,$66,$66,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7E,$18,$18,$18,$18,$18,$7E,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $1E,$06,$06,$06,$66,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $66,$6C,$78,$70,$78,$6C,$66,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $60,$60,$60,$60,$60,$60,$7E,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $63,$77,$7F,$6B,$63,$63,$63,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $66,$76,$7E,$7E,$6E,$66,$66,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$66,$66,$66,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7C,$66,$66,$7C,$60,$60,$60,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$66,$66,$6E,$3C,$06,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7C,$66,$66,$7C,$6C,$66,$66,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $3C,$66,$60,$3C,$06,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7E,$18,$18,$18,$18,$18,$18,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $66,$66,$66,$66,$66,$66,$3C,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $66,$66,$66,$66,$3C,$3C,$18,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $63,$63,$63,$6B,$7F,$77,$63,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $66,$66,$3C,$18,$3C,$66,$66,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $66,$66,$66,$3C,$18,$18,$18,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $7E,$06,$0C,$18,$30,$60,$7E,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$18,$18,$00,$18,$18,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $80,$C0,$E0,$F0,$F0,$E0,$C0,$80
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $01,$03,$07,$0F,$0F,$07,$03,$01
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .res 7504, $00
