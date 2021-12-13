import           Data.List
import           Data.Tuple
import           Text.Parsec
import           Text.Parsec.Combinator
import           Text.Parsec.Token

import           Data.Array             as A

foldX xs b = nub $ ys ++ ((\(x, y) -> (b - (x - b), y)) <$> zs)
  where
    (ys, zs) = splitAt splitIndex sorted
    splitIndex = case findIndex (\(x, _) -> x >= b) sorted of
      Just x  -> x
      Nothing -> length sorted + 1
    sorted = sort xs

step xs (a, b) = case a of
  'x' -> foldX xs b
  'y' -> swap <$> foldX (swap <$> xs) b
  _   -> undefined

solveA coords folds = length $ step coords (head folds)
solveB = foldl step

parseInt = read <$> many1 digit
parseLine = do
  x <- parseInt
  char ','
  y <- parseInt
  return (x, y)
parseCoords = many1 $ parseLine <* char '\n'

parseFold = do
 string "fold along "
 a <- alphaNum
 char '='
 b <- parseInt
 return (a, b)
parseFolds = many1 $ parseFold <* char '\n'

input = do
  coords <- parseCoords
  char '\n'
  folds <- parseFolds
  return (coords, folds)

parseInput :: String -> ([(Int, Int)], [(Char, Int)])
parseInput it = case parse input "" it of
  Left _  -> undefined
  Right x -> x

toArray coords = transpose $ group (my+1) $ elems $ zeros // [((i, j), '#') | (i, j) <- coords]
        where mx = maximum (fst <$> coords)
              my = maximum (snd <$> coords)
              zeros = A.array ((0,0), (mx, my)) [((i, j), ' ') | i <- [0..mx], j <- [0..my]]
              group _ [] = []
              group n l
                | n > 0 = take n l : group n (drop n l)
                | otherwise = undefined

main :: IO ()
main = do
  (coords, folds) <- parseInput <$> readFile "day13a.txt"
  (coordsB, foldsB) <- parseInput <$> readFile "day13b.txt"
  print $ solveA coords folds
  print $ solveA coordsB foldsB
  print $ solveB coords folds
  putStr . concat $ (++"\n") <$> toArray (solveB coordsB foldsB)
