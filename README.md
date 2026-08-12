# Pong

A classic Pong game made with Lua and LÖVE 2D.

This is my first game development project, created while learning game development with LÖVE 2D and Lua.

## Features

- Player vs AI mode
- Two-player mode
- First to 10 wins
- Ball and paddle collision
- AI opponent
- Sound effects
- Main menu
- Game over screen
- Return to main menu during a game
- Resizable game window

## Controls

### Player 1

- W — Move up
- S — Move down

### Player 2

- Up Arrow — Move up
- Down Arrow — Move down

### General

- Enter — Start game / return to menu
- Esc — Return to main menu

## How to Play

Choose a game mode from the main menu.

### Player vs AI

Player 1 controls the left paddle using W and S.

The AI controls the right paddle automatically.

### Two Players

Player 1 uses W and S.

Player 2 uses the Up and Down arrow keys.

The first player to reach 10 points wins.

## Download

The latest Windows version can be downloaded from the Releases section.

Download the Windows ZIP file, extract it, and run:

`Pong.exe`

## Built With

- Lua
- LÖVE 2D 11.5

## Project Structure

```text
pong/
│
├── main.lua
├── player.lua
├── ball.lua
├── ai.lua
├── sounds.lua
├── table-tennis.png
└── README.md
