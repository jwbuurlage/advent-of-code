import           Data.List (transpose)

common :: [String] -> String
common xs = fmap mostCommon (transpose xs)
  where
  mostCommon ys
    | ones ys >= zeros ys = '1'
    | otherwise = '0'
  ones ys = length $ filter (== '1') ys
  zeros ys = length ys - ones ys

flipBitstring :: String -> String
flipBitstring (x:xs)
  | x == '1' = "0" ++ flipBitstring xs
  | otherwise = "1" ++ flipBitstring xs
flipBitstring [] = []

binaryToNumber :: String -> Int
binaryToNumber xs = go (reverse xs) 0 0
  where
    go (x:xs) level acc = go xs (level+1) (if x == '1' then acc + 2^level else acc)
    go [] level acc = acc

solveA xs =
  binaryToNumber delta * binaryToNumber epsilon
  where
    delta = common xs
    epsilon = flipBitstring delta

findRating xss matcher = go xss 0
  where
    go [] _ = undefined
    go [xs] _ = xs
    go xss l = go (filter (\xs -> (xs !! l) == (ys !! l)) xss) (l + 1)
      where ys = matcher xss

solveB xs = binaryToNumber generator * binaryToNumber scrubber
  where
    generator = findRating xs common
    scrubber = findRating xs (flipBitstring . common)

parseInput :: String -> [String]
parseInput = lines

main :: IO ()
main = do
  a <- parseInput <$> readFile "day3a.txt"
  b <- parseInput <$> readFile "day3b.txt"
  print $ solveA a
  print $ solveA b
  print $ solveB a
  print $ solveB b
