import Data.Array
import Data.List
import Text.Parsec
import Text.Parsec.Combinator
import Text.Parsec.Token

type Grid = Array (Int, Int) Int

createGrid :: [[Int]] -> Grid
createGrid lines =
  listArray
    ((0, 0), (length (head lines) - 1, length lines - 1))
    (concat (transpose lines))

neighbors :: (Int, Int) -> (Int, Int) -> [(Int, Int)]
neighbors (mx, my) (x, y) =
  filter
    (\(a, b) -> a >= 0 && a <= mx && b >= 0 && b <= my)
    [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]

lowPoints grid = filter
  (\(x, y) -> all (\z -> (grid ! z) > (grid ! (x, y)))
    (neighbors (snd $ bounds grid) (x, y))) (indices grid)
solveA grid = sum $ (+1) . (grid !) <$> lowPoints grid

basinSize grid (x, y) = go [(x, y)] [(x, y)] 0
  where
    go [] _ size = size
    go (x:rest) seen size = go (rest ++ push seen x) (seen ++ [x] ++ push seen x) (size + 1)
    push seen x = filter (\x -> x `notElem` seen && grid ! x < 9) $ neighbors (snd $ bounds grid) x
solveB grid = product . take 3 . reverse . sort $ basinSize grid <$> lowPoints grid

parseInt = read . pure <$> digit
parseLine = many1 parseInt
input = many1 $ parseLine <* char '\n'

parseInput :: String -> Grid
parseInput it = case parse input "" it of
  Left _ -> undefined
  Right x -> createGrid x

main :: IO ()
main = do
  gridA <- parseInput <$> readFile "day9a.txt"
  gridB <- parseInput <$> readFile "day9b.txt"
  print $ solveA gridA
  print $ solveA gridB
  print $ solveB gridA
  print $ solveB gridB
