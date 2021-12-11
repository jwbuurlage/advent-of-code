import Control.Monad
import Data.Array
import Data.Array.IO
import Data.List (transpose)
import Text.Parsec
import Text.Parsec.Combinator
import Text.Parsec.Token

type Coord = (Int, Int)
type Grid = Array Coord Int
type MGrid = IOArray Coord Int

neighbors :: Coord -> Coord -> [Coord]
neighbors (mx, my) (x, y) =
  filter
    (\(a, b) -> a >= 0 && a <= mx && b >= 0 && b <= my)
    [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1), (x + 1, y + 1), (x - 1, y - 1), (x - 1, y + 1), (x + 1, y - 1)]

updateElem :: MGrid -> Coord -> (Int -> Int) -> IO ()
updateElem grid i f = do
    v <- readArray grid i
    writeArray grid i (f v)

updateNeighbours :: Coord -> MGrid -> Coord -> IO ()
updateNeighbours bnds grid c = do
  forM_ (neighbors bnds c) (\d -> updateElem grid d (\x -> if x == 0 then 0 else x+1 ))

filterNeighbours :: Coord -> MGrid -> Coord -> IO [Coord]
filterNeighbours bnds grid c = do
  filterM (fmap (>9) . readArray grid) (neighbors bnds c)

setNinesToZero :: [Coord] -> MGrid -> IO ()
setNinesToZero coords grid = forM_ coords (\d -> writeArray grid d 0)

flash :: MGrid -> IO Int
flash grid = do
  bnds <- snd <$> getBounds grid
  initial <- freeze grid
  forM_ (indices initial) (\(i, j) -> writeArray grid (i, j) (initial ! (i, j) + 1))
  nines <- filter (\(x, y) -> y > 9) <$> getAssocs grid
  let stack = fst <$> nines
  setNinesToZero stack grid
  go bnds grid stack 0
  where
    go bnds grid ((x, y):rest) num = do
      -- update neighbours with +1, unless they are 0
      updateNeighbours bnds grid (x, y)
      -- if that makes any hit nine, add them to 'rest' -- they should flash
      add <- filterNeighbours bnds grid (x, y)
      -- reset 9s to 0
      setNinesToZero add grid
      -- recurse
      go bnds grid (add ++ rest) (num + 1)
    go _ _ [] num = return num

simulate :: Grid -> IO (Grid, Int)
simulate grid =
  do
    mGrid <-
      (thaw grid :: IO MGrid)
    count <- flash mGrid
    nextGrid <- freeze mGrid
    return (nextGrid, count)

solveA grid = go 100 grid 0
  where
    go 0 grid x = return x
    go iter grid x = do
      (nextGrid, flashes) <- simulate grid
      go (iter-1) nextGrid (x + flashes)

createGrid :: [[Int]] -> Grid
createGrid lines =
  listArray
    ((0, 0), (length (head lines) - 1, length lines - 1))
    (concat (transpose lines))

parseInt = read . pure <$> digit
parseLine = many1 parseInt
input = many1 $ parseLine <* char '\n'

parseInput :: String -> Grid
parseInput it = case parse input "" it of
  Left _ -> undefined
  Right x -> createGrid x

main :: IO ()
main = do
  linesA <- parseInput <$> readFile "day11a.txt"
  linesB <- parseInput <$> readFile "day11b.txt"
  ansA <- solveA linesA
  print ansA
  ansB <- solveA linesB
  print ansB
