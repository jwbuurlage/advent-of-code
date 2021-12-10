import Data.List
import Data.Maybe

open = "([{<"
close = ")]}>"
costs = [3, 57, 1197, 25137]

cost x = costs !! fromJust (x `elemIndex` close)
expected x = close !! fromJust (x `elemIndex` open)

corrupt :: String -> Int
corrupt xs = go xs []
  where
    go (y:ys) []
      | y `elem` open = go ys [y]
      | y `elem` close = cost y
    go (y:ys) (s:ss)
      | y `elem` open = go ys (y:s:ss)
      | y `elem` close = if expected s == y then go ys ss else cost y
      | otherwise = undefined
    go [] _ = 0

fix xs = go xs []
  where
    go (y:ys) []
      | y `elem` open = go ys [y]
      | y `elem` close = undefined
    go (y:ys) (s:ss)
      | y `elem` open = go ys (y:s:ss)
      | y `elem` close = if expected s == y then go ys ss else undefined
      | otherwise = undefined
    go [] ss = ss

solveA lines = sum $ corrupt <$> lines

solveB lines = scores !! div (length scores) 2
  where
    valid = filter (\xs -> corrupt xs == 0) lines
    scores = sort $ score . fix <$> valid
    score = \xs -> foldl (\b a -> b * 5 + a) 0 ((+1) . fromJust . (`elemIndex` open) <$> xs)

main :: IO ()
main = do
  a <- lines <$> readFile "day10a.txt"
  b <- lines <$> readFile "day10b.txt"
  print $ solveA a
  print $ solveA b
  print $ solveB a
  print $ solveB b
