# Strategic Tic-Tac-Toe

2 Player Mega Tic Tac Toe Game


### Running Instructions

* Install Haskell  
* Install Gloss (A Haskell graphics library) 

```
cabal install gloss
```
* Open Terminal  
* Locate to directory  
* Use the command  

```
 ghc -o -l Main.hs
 ```
* And then use the command

 ```
 ./l
 ```
 
### Game Rules 
* The game starts with X playing wherever they want in any of the 81 empty spots.
* This move 'sends' their opponent to its relative location.For example, if X played in the top right square of their local board, then O needs to play next in the local board at the top right of the global board. O can then play in any one of the nine available spots in that local board, each move sending X to a different local board.(Local board is the smaller 3 X 3 board while the global board is the bigger 3 X 3 board)
* If a move is played so that it is to win a local board by the rules of normal tic-tac-toe, then it wins that local board.
* Once the outcome of a local board is decided (win or draw), no more moves may be played in that board. If a player is sent to such a board, then that player may play in any other board.
* Game play ends when either a player wins the global board, or there are no legal moves remaining.

More details can be found here 

```
https://en.wikipedia.org/wiki/Ultimate_tic-tac-toe#Rules
```
