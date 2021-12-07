import Data.List
import Data.Array
import Text.Parsec
import Text.Parsec.Combinator
import Text.Parsec.Token

type Coord = (Int, Int)
type Vent = (Coord, Coord)
type Grid = Array (Int, Int) Int

gridSize :: [Vent] -> (Int, Int)
gridSize lines = (x, y)
  where x = max (maximum (fst . fst <$> lines)) (maximum (fst . snd <$> lines))
        y = max (maximum (snd . fst <$> lines)) (maximum (snd . snd <$> lines))

trace ((a, b), (c, d))
        | a == c = [(a, y) | y <- [(min b d)..max b d]]
        | b == d = [(x, b) | x <- [(min a c)..max a c]]
        | otherwise = []

trace' ((a, b), (c, d))
        | a == c = [(a, y) | y <- [(min b d)..max b d]]
        | b == d = [(x, b) | x <- [(min a c)..max a c]]
        | a > c = trace' ((c, d), (a, b))
        | d > b = [(a + x, b + x) | x <- [0..c - a]]
        | otherwise = [(a + x, b - x) | x <- [0..c - a]]

update tracer xs l = xs // [((i, j), (xs ! (i, j)) + 1) | (i, j) <- tracer l]

solve tracer lines = length $ filter (>1) (elems lineCounts)
  where (x, y) = gridSize lines
        total = (x + 1) * (y + 1) - 1
        grid = listArray ((0,0), (x, y)) [ 0 | _ <- [0..total] ]
        lineCounts = foldl (update tracer) grid lines

solveA = solve trace
solveB = solve trace'

parseInt = read <$> many1 digit

parseCoord = do
  x <- parseInt
  char ','
  y <- parseInt
  return (x, y)

parseLine = do
  src <- parseCoord
  string " -> "
  tgt <- parseCoord
  return (src, tgt)

input = many1 (parseLine <* char '\n')

parseInput :: String -> [Vent]
parseInput it = case parse input "" it of
    Left _  -> undefined
    Right x -> x

main :: IO ()
main = do
  linesA <- parseInput <$> readFile "day5a.txt"
  linesB <- parseInput <$> readFile "day5b.txt"
  print $ solveA linesA
  print $ solveA linesB
  print $ solveB linesA
  print $ solveB linesB
