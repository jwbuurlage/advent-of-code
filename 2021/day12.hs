import qualified Data.Set as S
import qualified Data.Map as M
import Data.Tuple (swap)
import Data.Char (isLower)
import Text.Parsec
import Text.Parsec.Combinator
import Text.Parsec.Token

solveA :: M.Map String [String] -> Int
solveA adj = go [("start", S.fromList ["start"])] 0
  where
    go ((node, seen):rest) num
      | node == "end" = go rest (num+1)
      | otherwise =
        let
          unseen = filter (not . flip S.member seen) (adj M.! node)
          newSeen = if isLower $ head node then S.insert node seen else seen
        in go (((\x -> (x, newSeen)) <$> unseen) ++ rest) num
    go [] num = num

solveB :: M.Map String [String] -> Int
solveB adj = go [("start", False, S.fromList ["start"])] 0
  where
    go ((node, doubled, seen):rest) num
      | node == "end" = go rest (num+1)
      | otherwise =
        let
          unseen = filter (not . flip S.member seen) (adj M.! node)
          newSeen = if isLower $ head node then S.insert node seen else seen
          toPush = ((\x -> (x, doubled, newSeen)) <$> unseen)
          seenButDoubled = if doubled then [] else
            (\x -> (x, True, newSeen)) <$>
            filter (\x -> (x /= "start") && (S.member x seen)) (adj M.! node)
        in go (toPush ++ seenButDoubled ++ rest) num
    go [] num = num

edgesToAdj :: [(String, String)] -> M.Map String [String]
edgesToAdj edges = M.fromListWith (++) (fmap (:[]) <$> (edges ++ (swap <$> edges)))

parseNode = many1 alphaNum
parseLine = do
  from <- parseNode
  char '-'
  to <- parseNode
  return (from, to)
input = many1 $ parseLine <* char '\n'

parseInput :: String -> [(String, String)]
parseInput it = case parse input "" it of
  Left _ -> undefined
  Right x -> x

main :: IO ()
main = do
  edges <- parseInput <$> readFile "day12a.txt"
  edgesB <- parseInput <$> readFile "day12b.txt"
  print $ solveA $ edgesToAdj edges
  print $ solveA $ edgesToAdj edgesB
  print $ solveB $ edgesToAdj edges
  print $ solveB $ edgesToAdj edgesB
