module Main where

import System.Environment ( getArgs )
import Data.List ( delete, elemIndex )
import Data.Maybe ( fromJust )
import qualified Data.Map as Map

data Boy = Boy { name :: String
               , enemy :: String
               , friend :: String
               } deriving (Show, Eq)

type Line = [String]

parseBoy :: String -> Boy
parseBoy line =
  let [n, e, f] = words line
  in Boy n e f

isValidPosition :: Int -> Boy -> Line -> Map.Map String Boy -> Bool
isValidPosition pos boy line boyMap
  | pos == 0 = True
  | otherwise = 
      let enemyPos = findPosition (enemy boy) line
          friendPos = findPosition (friend boy) line
      in case enemyPos of
           Nothing -> True
           Just ep -> 
             if ep > pos
             then case friendPos of
                    Nothing -> False
                    Just fp -> fp < ep && fp < pos
             else True

findPosition :: String -> Line -> Maybe Int
findPosition name line = elemIndex name line

generateValidArrangements :: Map.Map String Boy -> Line -> [String] -> [[String]]
generateValidArrangements boyMap currentLine remainingBoys
  | null remainingBoys = [currentLine]
  | otherwise = 
      let pos = length currentLine
          validNextBoys = filter (\name -> 
                            let boy = fromJust $ Map.lookup name boyMap
                            in isValidPosition pos boy currentLine boyMap) remainingBoys
      in concatMap (\name -> 
                    let newLine = currentLine ++ [name]
                        newRemaining = delete name remainingBoys
                    in generateValidArrangements boyMap newLine newRemaining) validNextBoys

findValidArrangement :: [Boy] -> Maybe Line
findValidArrangement boys =
  let boyMap = Map.fromList [(name boy, boy) | boy <- boys]
      boyNames = map name boys
      arrangements = generateValidArrangements boyMap [] boyNames
  in if null arrangements then Nothing else Just (head arrangements)

main :: IO ()
main = do
  args <- getArgs
  content <- case args of
               (filePath:_) -> readFile filePath
               [] -> getContents
  
  let boys = map parseBoy $ filter (not . null) $ lines content
      result = findValidArrangement boys
  
  case result of
    Just line -> putStrLn $ unwords line
    Nothing -> putStrLn "impossible"
