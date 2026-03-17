# NES Pong — 6502 Assembly

A fully-featured Pong clone for the NES, written from scratch in pure 6502 assembly.

## Features
- 1 Player Mode vs AI
- 2 Player Mode for Local-Multiplayer
- Settings such as Mode, Ball-Speed, Paddle-Size, Paddle-Speed, AI Difficulty, Ball-Spawns
- Classic mode first to 10
- Infinite Mode

## Controls
- Player 1 W/S
- Player 2 Up/Down Arrow's

## Future Improvements

- More responsive game loop (sub-frame logic or variable update rate)
- Paddle edge hit detection refinement
- Angle Customization/Improvements (steeper/shallower returns based on paddle/ball speed)
- 2-player score tracking across multiple rounds
- General Bug Fixes

## Building

Requires [ca65 / ld65](https://cc65.github.io/) from the cc65 toolchain.

```bash
ca65 pong.asm -o pong.o
ld65 -C nes.cfg pong.o -o pong.nes
```
Or use the precompiled version shipped inside this repository :D

Compatible with any NES emulator. Tested on [Mesen](https://www.mesen.ca).

## Technical Notes
- **PPU**: Background and sprite layers used separately — the center line is a background tile, paddles and ball are OAM sprites. Score display is written to the nametable during vblank.
- **RNG**: Galois LFSR (`eor #$B8`) seeded with a fixed value and mixed with `frame_count` each sample for entropy.
- **Sound**: APU programmed directly via memory-mapped registers. No audio engine.
- **Memory**: Hot variables in zero page for fast access. SRAM at `$6000` for high score with magic byte validation.
