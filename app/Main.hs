module Main where
import           Data.Aeson                     ( decode
                                                , Value
                                                )
import           Data.Aeson.Yaml                ( encode )
import qualified Data.ByteString.Lazy          as BL
import           Data.Maybe
import           Data.Either
import           Control.Monad                  ( join )
import           System.Environment
import           Safe

maybeEither str Nothing  = Left str
maybeEither str (Just a) = Right a

main :: IO ()
main = do
  args <- getArgs
  let input  = maybeEither "missing input argument" $ args `atMay` 0
      output = maybeEither "missing output argument" $ args `atMay` 1
  case (input, output) of
    (Left err, _       ) -> putStrLn err
    (_       , Left err) -> putStrLn err
    (Right inp, Right out) -> do
      content <- BL.readFile inp
      case decode content of
        Nothing -> putStrLn $ inp ++ " is not a valid json!"
        Just json -> BL.writeFile out $ encode (json :: Value)
