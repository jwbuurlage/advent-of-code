{-# LANGUAGE TupleSections #-}

import           Text.Parsec
import           Text.Parsec.Combinator
import           Text.Parsec.Token
import qualified Data.Map as M
import Data.List
import Data.Tuple

type Rules = M.Map (Char, Char) Char

reduceCounts list = M.toList $ M.fromListWith (+) list

freq :: Ord a => [a] -> [(a, Int)]
freq s = reduceCounts [(x, 1) | x <- s]

maybeInsert :: Rules -> (Char, Char) -> [(Char, Char)]
maybeInsert ruleMap (x, y) = if (x, y) `M.member` ruleMap then [(x, z), (z, y)] else []
  where z = ruleMap M.! (x, y)


step :: Rules -> [((Char, Char), Int)] -> [((Char, Char), Int)]
step ruleMap pairs = reduceCounts fullList
  where
    apply ((x, y), n) = (,n) <$> maybeInsert ruleMap (x, y)
    fullList = concat (apply <$> pairs)

solve t steps init rules = last sorted - head sorted
  where
    ruleMap = M.fromList rules
    freqs = reduceCounts $ (swap . fmap fst . swap <$> iterate (step ruleMap) init !! steps) ++ [(t, 1)]
    sorted = sort $ snd <$> freqs

toFreqPairs s@(_:xs) = freq $ zip s xs
toFreqPairs _ = []

solveA t = solve t 10
solveB t = solve t 40

parseInit = many1 alphaNum <* char '\n'
parseRule = do
 a <- alphaNum
 b <- alphaNum
 string " -> "
 c <- alphaNum
 return ((a, b), c)
parseRules = many1 $ parseRule <* char '\n'
input = do
  init <- parseInit
  char '\n'
  rules <- parseRules
  return (init, rules)
parseInput :: String -> (String, [((Char, Char), Char)])
parseInput it = case parse input "" it of
  Left _  -> undefined
  Right x -> x

main :: IO ()
main = do
  (init, rules) <- parseInput <$> readFile "day14a.txt"
  (initB, rulesB) <- parseInput <$> readFile "day14b.txt"
  print $ solveA (last init) (toFreqPairs init) rules
  print $ solveA (last initB) (toFreqPairs initB) rulesB
  print $ solveB (last init) (toFreqPairs init) rules
  print $ solveB (last initB) (toFreqPairs initB) rulesB
