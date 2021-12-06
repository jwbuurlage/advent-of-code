import Text.Parsec
import Text.Parsec.Combinator
import Text.Parsec.Token

solveA numbers boards = go numbers state tests
  where go x y z = z

parseBalls = sepBy (read <$> many1 digit) (char ',')
parseRow = sepBy (read <$> many1 digit) (many1 (char ' '))
parseBoard = count 5 (many (many1 (oneOf "\n ")) *> parseRow)
parseBoards = many $ skipMany (char '\n') *> parseBoard <* char '\n'

input = do
  numbers <- parseBalls
  boards <- parseBoards
  return (numbers, boards)

parseInput :: String -> ([Int], [[[Int]]])
parseInput it = case parse input "" it of
    Left _ -> undefined
    Right x -> x

main :: IO ()
main = do
  (numbers, boards) <- parseInput <$> readFile "day4a.txt"
  print $ solveA numbers boards
