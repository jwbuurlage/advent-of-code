import           Text.Parsec
import           Text.Parsec.Combinator
import           Text.Parsec.Token

parseNums = sepBy (read <$> many1 digit) (char ',')

fuel xs y = sum $ (\x -> abs (y - x)) <$> xs

triNum :: Int -> Int
triNum n = ((n + 1) * n) `div` 2
fuel' xs y = sum $ (\x -> triNum $ abs (y - x)) <$> xs

solve fueler xs = minimum $ fmap (fueler xs) [0..m + 1]
  where m = maximum xs
solveA = solve fuel
solveB = solve fuel'

parseInput :: String -> [Int]
parseInput it = case parse parseNums "" it of
    Left _  -> undefined
    Right x -> x

main :: IO ()
main = do
  nums <- parseInput <$> readFile "day7a.txt"
  numsB <- parseInput <$> readFile "day7b.txt"
  print $ solveA nums
  print $ solveA numsB
  print $ solveB nums
  print $ solveB numsB
