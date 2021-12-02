followCourse :: [(String, Int)] -> (Int, Int)
followCourse moves = go moves (0, 0)
  where
    go ((d, l) : rest) (x, y)
      | d == "up" = go rest (x, y - l)
      | d == "down" = go rest (x, y + l)
      | d == "forward" = go rest (x + l, y)
      | otherwise = undefined
    go _ p = p

followAim :: [(String, Int)] -> (Int, Int)
followAim moves = go moves (0, 0) 0
  where
    go ((d, l) : rest) (x, y) aim
      | d == "up" = go rest (x, y) (aim - l)
      | d == "down" = go rest (x, y) (aim + l)
      | d == "forward" = go rest (x + l, y + l * aim) aim
      | otherwise = undefined
    go _ p _ = p

parseInput :: String -> [(String, Int)]
parseInput = fmap (fmap read . pairify . words) . lines
  where
    pairify (x : y : _) = (x, y)
    pairify _ = undefined

main :: IO ()
main = do
  a <- parseInput <$> readFile "day2a.txt"
  b <- parseInput <$> readFile "day2b.txt"
  print $ uncurry (*) $ followCourse a
  print $ uncurry (*) $ followCourse b
  print $ uncurry (*) $ followAim a
  print $ uncurry (*) $ followAim b
