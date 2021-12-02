followCourse :: [(String, Int)] -> (Int, Int)
followCourse moves = go moves (0, 0)
  where
    go ((d, l) : moves) (x, y)
      | d == "up" = go moves (x, y - l)
      | d == "down" = go moves (x, y + l)
      | d == "forward" = go moves (x + l, y)
      | otherwise = undefined
    go _ p = p

followAim :: [(String, Int)] -> (Int, Int)
followAim moves = go moves (0, 0) 0
  where
    go ((d, l) : moves) (x, y) aim
      | d == "up" = go moves (x, y) (aim - l)
      | d == "down" = go moves (x, y) (aim + l)
      | d == "forward" = go moves (x + l, y + l * aim) aim
      | otherwise = undefined
    go _ p _ = p

parseInput :: String -> [(String, Int)]
parseInput = fmap (mapRight read . pairify . words) . lines
  where
    pairify (x : y : xs) = (x, y)
    pairify _ = undefined
    mapRight f (x, y) = (x, f y)

main :: IO ()
main = do
  a <- parseInput <$> readFile "day2a.txt"
  b <- parseInput <$> readFile "day2b.txt"
  print $ uncurry (*) $ followCourse a
  print $ uncurry (*) $ followCourse b
  print $ uncurry (*) $ followAim a
  print $ uncurry (*) $ followAim b
