numIncreasing' :: [Int] -> Int
numIncreasing' (x:xs) = length $ filter (\(a,b) -> a > b) (zip xs (x:xs))
numIncreasing' _ = 0;

windows :: [Int] -> [Int]
windows (x:y:zs) = (\(a,b,c) -> a + b + c) <$> zip3 (x:y:zs) (y:zs) (zs)
windows _ = []

parseInput :: String -> [Int]
parseInput = (fmap read) . lines

main :: IO ()
main = do
  a <- parseInput <$> (readFile "day1a.txt")
  b <- parseInput <$> (readFile "day1b.txt")
  print $ numIncreasing' a
  print $ numIncreasing' b
  print $ numIncreasing' . windows $ a
  print $ numIncreasing' . windows $ b
