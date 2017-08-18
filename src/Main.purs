
module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Maybe(Maybe(..), fromJust)
import Data.Foldable (for_)
import Graphics.Canvas as C
import Partial.Unsafe (unsafePartial)
import Data.Tuple
import Math as M

-- Sierspinki Triangle

numIterations :: Int
numIterations = 3

sideLength :: Number
sideLength = 500.0

xOffset :: Number
xOffset = 50.0

yOffset :: Number
yOffset = 100.0

rootThreeByTwo :: Number
rootThreeByTwo = (M.sqrt 3.0)/ 2.0

type Point = {
  x :: Number,
  y :: Number
}

type Triangle = {
  l :: Point,
  r :: Point,
  t :: Point
}

drawTriangle :: String -> Triangle -> C.Context2D -> Eff _ C.Context2D
drawTriangle color trg ctx = do
  _ <- C.beginPath ctx
  _ <- C.moveTo ctx trg.l.x trg.l.y
  _ <- C.lineTo ctx trg.r.x trg.r.y
  _ <- C.lineTo ctx trg.t.x trg.t.y
  _ <- C.setFillStyle color ctx
  _ <- C.fill ctx
  C.closePath ctx

drawSierspinki :: Int -> Triangle -> C.Context2D -> Eff _ C.Context2D
drawSierspinki 0 trg ctx = pure ctx
drawSierspinki num trg ctx = do
  _ <- drawTriangle "white" downTriangle ctx
  _ <- drawSierspinki (num - 1) topTriangle ctx
  _ <- drawSierspinki (num - 1) leftTriangle ctx
  drawSierspinki (num - 1) rightTriangle ctx
  where
    currSideLength :: Number
    currSideLength = (trg.r.x - trg.l.x)
    pointLeft :: Point
    pointLeft = { x: trg.l.x + currSideLength / 4.0, y: trg.t.y + (rootThreeByTwo * currSideLength) / 2.0 }
    pointRight :: Point
    pointRight = { x: trg.t.x + currSideLength / 4.0, y: trg.t.y + (rootThreeByTwo * currSideLength) / 2.0 }
    pointBottom :: Point
    pointBottom = { x: trg.l.x + currSideLength / 2.0, y: trg.l.y }
    downTriangle :: Triangle
    downTriangle = { t: pointBottom, l: pointLeft, r: pointRight }
    topTriangle :: Triangle
    topTriangle = { t: trg.t, l: pointLeft, r: pointRight }
    leftTriangle :: Triangle
    leftTriangle = { t: pointLeft, l: trg.l, r: pointBottom }
    rightTriangle :: Triangle
    rightTriangle = { t: pointRight, l: pointBottom, r: trg.r }

main :: forall e. Eff _ C.Context2D
main = unsafePartial $ do 
  canvas <- C.getCanvasElementById "canvas"
  ctx    <- C.getContext2D (fromJust canvas)
  _      <- drawTriangle "black" triangleMain ctx
  drawSierspinki numIterations triangleMain ctx
  where
    pointA :: Point
    pointA = { x: xOffset + (sideLength / 2.0), y: yOffset }
    pointB :: Point
    pointB = { x: xOffset, y: yOffset + (rootThreeByTwo * sideLength) }
    pointC :: Point
    pointC = { x: xOffset + sideLength, y: yOffset + (rootThreeByTwo * sideLength) }
    triangleMain :: Triangle
    triangleMain = { t: pointA, l: pointB, r: pointC }