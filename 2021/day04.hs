import           Data.List
import           Text.Parsec
import           Text.Parsec.Combinator
import           Text.Parsec.Token

data BoardState = BoardState {
  getCols     :: [[Int]],
  getRows     :: [[Int]],
  getColCount :: [Int],
  getRowCount :: [Int]
} deriving (Show)

constructState :: [[Int]] -> BoardState
constructState board = BoardState {
  getCols = transpose board,
  getRows = board,
  getColCount = 0 <$ board,
  getRowCount = 0 <$ board
}

finished :: BoardState -> Bool
finished state = (any (>= 5) $ getColCount state)
          || (any (>= 5) $ getRowCount state)

anyFinished :: [BoardState] -> Maybe Int
anyFinished = findIndex finished

maybeIncrement :: Int -> [Int] -> (Int -> Int)
maybeIncrement x xs = if x `elem` xs then (+1) else id

applyZip = uncurry ($)

update :: Int -> BoardState -> BoardState
update x state = BoardState {
  getCols = getCols state,
  getRows = getRows state,
  getColCount = applyZip <$> zip ((maybeIncrement x) <$> (getCols state)) (getColCount state),
  getRowCount = applyZip <$> zip ((maybeIncrement x) <$> (getRows state)) (getRowCount state)
}

solveA numbers boards = go numbers (fmap constructState boards) []
  where
    go (x:xs) states seen = case anyFinished states of
      Just y  -> head seen * (sum $ sum <$> (filter (\z -> not (z `elem` seen)) <$> boards !! y))
      Nothing -> go xs (update x <$> states) (x:seen)
    go _ _ _ = undefined

solveB numbers boards = go numbers (fmap constructState boards) [] Nothing
  where
    go (x:xs) states seen lastFinished = case anyFinished states of
      Just y ->
        if length states == 1 then
          head seen * (sum $ sum <$> (filter (\z -> not (z `elem` seen))) <$> (getCols $ head states))
        else
           go xs (update x <$> (filter (not . finished) states)) (x:seen) (Just (boards !! y))
      Nothing -> go xs (update x <$> states) (x:seen) lastFinished
    go _ _ _ _ = undefined

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
    Left _  -> undefined
    Right x -> x

main :: IO ()
main = do
  (numbersA, boardsA) <- parseInput <$> readFile "day4a.txt"
  (numbersB, boardsB) <- parseInput <$> readFile "day4b.txt"
  print $ solveA numbersA boardsA
  print $ solveA numbersB boardsB
  print $ solveB numbersA boardsA
  print $ solveB numbersB boardsB
