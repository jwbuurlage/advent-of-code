import           Text.Parsec
import           Text.Parsec.Combinator
import           Text.Parsec.Token

parseNums = sepBy (read <$> many1 digit) (char ',')

initialize nums = fmap (\x -> length $ filter (==x) nums) [0..8]

addToElem :: Int -> Int -> [Int] -> [Int]
addToElem idx y xs = as ++ [y + x] ++ cs
  where (as, x:cs) = splitAt idx xs

update :: [Int] -> [Int]
update (x:xs) = addToElem 6 x (xs ++ [x])
update _ = undefined

solveA iter x = sum $ iterate update x !! iter

parseInput :: String -> [Int]
parseInput it = case parse parseNums "" it of
    Left _  -> undefined
    Right x -> x

main :: IO ()
main = do
  nums <- parseInput <$> readFile "day6a.txt"
  numsB <- parseInput <$> readFile "day6b.txt"
  print $ solveA 79 $ update $ initialize nums
  print $ solveA 79 $ update $ initialize numsB
  print $ solveA 255 $ update $ initialize nums
  print $ solveA 255 $ update $ initialize numsB
