numIncreasing :: [Int] -> Int
numIncreasing xs = length . filter (uncurry (>)) $ zip xs (drop 1 xs)

slidingWindows :: [Int] -> [Int]
slidingWindows xs = (\(a, b, c) -> a + b + c) <$> zip3 xs (drop 1 xs) (drop 2 xs)

parseInput :: String -> [Int]
parseInput = fmap read . lines

main :: IO ()
main = do
  a <- parseInput <$> readFile "day1a.txt"
  b <- parseInput <$> readFile "day1b.txt"
  print $ numIncreasing a
  print $ numIncreasing b
  print $ numIncreasing . slidingWindows $ a
  print $ numIncreasing . slidingWindows $ b
