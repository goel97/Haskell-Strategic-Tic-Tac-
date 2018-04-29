module Rendering where

import Data.Array
import Graphics.Gloss

import Game

playerXColor = makeColorI 255 50 50 255
playerOColor = makeColorI 50 100 255 255
tieColor = makeColorI 0 0 100 255
boardGridColor = makeColorI 255 255 255 255

boardAsRunningPicture game =
    pictures [
                color playerXColor $ xCellsOfBoard board,
                color playerOColor $ oCellsOfBoard board,
                color playerXColor $ xbigBoard bBoard,
                color playerOColor $ obigBoard bBoard,
                dieDisplay game,
                boardAsGrid
             ]
    where board = gameBoard game
          bBoard = bigBoard game

outcomeColor (Just PlayerX) = playerXColor
outcomeColor (Just PlayerO) = playerOColor
outcomeColor Nothing = tieColor
outcomeColorA (Just Player_X) = playerXColor
outcomeColorA (Just Player_O) = playerOColor
outcomeColorA (Just Tie) = tieColor

snapPictureToCell picture (row, column) = translate x y picture
    where x = fromIntegral column * 60 + 60 * 0.5
          y = fromIntegral row * 60 + 60 * 0.5

snapBigPictureToCell picture (row, column) = translate x y picture
    where x = fromIntegral column * 180 + 180 * 0.5
          y = fromIntegral row * 180 + 180 * 0.5

xbigBoard :: BBoard -> Picture
xbigBoard bBoard = cellsOfBigBoard bBoard (Just Player_X) bigXCell

obigBoard :: BBoard -> Picture
obigBoard bBoard = cellsOfBigBoard bBoard (Just Player_O) bigOCell

bigXCell :: Picture
bigXCell = pictures
        [ 
          rotate 45.0 $ rectangleSolid 135.0 20.0,
          rotate (-45.0) $ rectangleSolid 135.0 20.0
        ]

bigOCell :: Picture
bigOCell = thickCircle 45.0 20.0

cellsOfBigBoard :: BBoard -> CellA -> Picture -> Picture
cellsOfBigBoard bBoard cell cellPicture =
    pictures
    $ map (snapBigPictureToCell cellPicture . fst)
    $ filter (\(_, e) -> e == cell)
    $ assocs bBoard

xCell :: Picture
xCell = pictures
        [ 
          rotate 45.0 $ rectangleSolid 48.0 8.0,
          rotate (-45.0) $ rectangleSolid 48.0 8.0
        ]

oCell :: Picture
oCell = thickCircle 15.0 7.0

cellsOfBoard :: Board -> Cell -> Picture -> Picture
cellsOfBoard board cell cellPicture =
    pictures
    $ map (snapPictureToCell cellPicture . fst)
    $ filter (\(_, e) -> e == cell)
    $ assocs board

xCellsOfBoard :: Board -> Picture
xCellsOfBoard board = cellsOfBoard board (Just PlayerX) xCell

oCellsOfBoard :: Board -> Picture
oCellsOfBoard board = cellsOfBoard board (Just PlayerO) oCell

horizontalLines :: Picture
horizontalLines =
  pictures
  $ concatMap (\i -> [line [(0,60*i),(540,60*i)]])
    [0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0]

verticalLines :: Picture
verticalLines =
  pictures
  $ concatMap (\i -> [line [(60*i,0),(60*i,540)]])
    [0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0]

intToString :: Int -> String
intToString n = "." ++ show n ++ "."

dieDisplay :: Game -> Picture
dieDisplay game =
    pictures[
              translate 380 460 (color (makeColorI 0 0 0 200) ( scale 0.4 0.4 (text $ intToString (fst (prevMove game) )))),
              translate 455 460 (color (makeColorI 0 0 0 200) ( scale 0.4 0.4 (text $ intToString (snd (prevMove game) ))))
            ]

mainGrid :: Picture
mainGrid =
    pictures
    $ concatMap (\i -> [ line [ (i * 180, 0.0), (i * 180, 540)]
                       , line [ (0.0, i * 180), (540, i * 180)]
                       ])
      [0.0,1.0,2.0]

boardAsGrid :: Picture
boardAsGrid =
    pictures
    [
        color (makeColorI 175 175 175 255) horizontalLines,
        color (makeColorI 175 175 175 255) verticalLines,
        color (makeColorI 0 0 0 255) mainGrid
    ]

boardAsPicture board =
    pictures
    [
        xCellsOfBoard board
      , oCellsOfBoard board
      --, horizontalLines,
      --, verticalLines,
      , mainGrid
    ]

boardAsGameOverPicture winner board = color (outcomeColorA winner) (boardAsPicture board)

gameAsPicture:: Game->Picture
gameAsPicture game = translate (fromIntegral screenWidth * (-0.5))
                           (fromIntegral screenHeight * (-0.5))
                           frame
     where frame = case gameState game of
                    Running -> boardAsRunningPicture (game)
                    GameOver winner -> boardAsGameOverPicture winner (gameBoard game)


