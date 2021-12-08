import Data.Array
import Data.List
import Data.Maybe (fromJust)
import Text.Parsec
import Text.Parsec.Combinator
import Text.Parsec.Token

mapped mapping = sort . fmap (mapping !!) <$> segmentsByIndex
  where
    segmentsByIndex =
      fmap (\x -> fromJust $ elemIndex x ['a' .. 'g'])
        <$> ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
test signals mapping = length (filter (`elem` signals) (mapped mapping)) == length signals
bruteForce signals = fromJust $ find (test signals) (permutations ['a' .. 'g'])
value (signals, output) = numberify $ (\x -> fromJust $ elemIndex x (mapped mapping)) <$> output
  where
    mapping = bruteForce signals
    numberify = foldl (\x y -> 10 * y + x) 0
solveB lines = sum $ value <$> lines

countEasy (_, output) = length $ filter (\x -> length x `elem` [2, 3, 4, 7]) output
solveA lines = sum $ countEasy <$> lines

input = many1 (parseLine <* char '\n')
parseInput :: String -> [([String], [String])]
parseInput it = case parse input "" it of
  Left _ -> undefined
  Right x -> x

parseWord = many1 $ oneOf ['a' .. 'z']
parseLine = do
  signals <- count 10 (parseWord <* many (char ' '))
  string "| "
  output <- count 4 (parseWord <* many (char ' '))
  return (sort <$> signals, sort <$> output)

main :: IO ()
main = do
  linesA <- parseInput <$> readFile "day8a.txt"
  linesB <- parseInput <$> readFile "day8b.txt"
  print $ solveB linesA
  print $ solveB linesB
