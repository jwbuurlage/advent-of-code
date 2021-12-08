import Data.List
import Data.Array
import Text.Parsec
import Text.Parsec.Combinator
import Text.Parsec.Token
import Data.Maybe (fromJust)

fromDigits :: [Int] -> Int
fromDigits = foldl addDigit 0 where addDigit num d = 10*num + d

s = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
si = fmap (\x -> fromJust $ elemIndex x ['a'..'g']) <$> s
t mapping = sort <$> fmap (mapping !!) <$> si

-- Mapping from original to scrambled
testValidity signals mapping = length (filter (`elem` signals) (t mapping)) == length signals
getMapping signals = fromJust $ find (testValidity signals) (permutations ['a'..'g'])

value :: ([String], [String]) -> Int
value (signals, output) = fromDigits $ (\x -> fromJust $ elemIndex x (t mapping)) <$> output
  where mapping = getMapping signals

solveB lines = sum $ value <$> lines

parseWord = many1 $ oneOf ['a'..'z']
parseLine = do
  signals <- count 10 (parseWord <* many (char ' '))
  string "| "
  output <- count 4 (parseWord <* many (char ' '))
  return (sort <$> signals, sort <$> output)

input = many1 (parseLine <* char '\n')

countEasy (_, output) = length $ filter (\x -> length x `elem` [2,3,4,7]) output

solveA lines = sum $ countEasy <$> lines

parseInput :: String -> [([String], [String])]
parseInput it = case parse input "" it of
   Left _  -> undefined
   Right x -> x

main :: IO ()
main = do
  linesA <- parseInput <$> readFile "day8a.txt"
  linesB <- parseInput <$> readFile "day8b.txt"
  example <- parseInput <$> readFile "day8c.txt"
  -- print $ solveB example
  print $ solveB linesA
  print $ solveB linesB
