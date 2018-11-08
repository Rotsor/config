import qualified Data.ByteString.Lazy as BS
import Text.Printf as Printf
import GHC.Word
import GHC.Int
import Data.Binary.Get
import Data.Binary.Put
import Data.Bits

data B = B BS.ByteString

instance Show B where
  show (B b) =
    show (concat $ map (Printf.printf "%02x") (BS.unpack b) :: String)

instance Read B where
  readsPrec d r = map (\(v,r) -> (f v, r)) (readsPrec d r) where
    f = B . BS.pack . map readWord . split where
    split (x : y : rest) = [x, y] : split rest
    split [] = []

    readDigit x | x >= '0' && x <= '9' = fromIntegral $ fromEnum x - fromEnum '0'
    readDigit x | x >= 'a' && x <= 'z' = fromIntegral $ fromEnum x - fromEnum 'a' + 10
    readDigit x | x >= 'A' && x <= 'Z' = fromIntegral $ fromEnum x - fromEnum 'A' + 10
    
    readWord [x, y] = readDigit x * 16 + readDigit y
    

data Der =
  Sequence [Der]
  | Integer Integer
  | OctetString B
  | Other (Word8, B)
  deriving (Show, Read)

data Tag =
  SequenceTag
  | IntegerTag
  | PrimitiveOctetStringTag
  | OtherTag Word8

getTag :: Get Tag
getTag = do
  tag <- getWord8
  if tag .&. 31 == 31
  then error "[getTag]: big tags are not supported"
  else
    case tag of
     48 -> return SequenceTag
     2 -> return IntegerTag
     4 -> return PrimitiveOctetStringTag
     tag -> return (OtherTag tag)

putTag :: Tag -> Put
putTag SequenceTag = putWord8 48
putTag IntegerTag = putWord8 2
putTag PrimitiveOctetStringTag = putWord8 4
putTag (OtherTag tag) = putWord8 tag

putLength :: Int64 -> Put
putLength n | n < 128 = putWord8 (fromIntegral n)

integerToBytes = reverse . go
 where
  go integer =
   let (rest, here) = integer `divMod` 256 in
   if (rest == -1 && here >= 128 || rest == 0 && here < 128)
   then [ fromInteger here ]
   else fromInteger here : go integer

putDer' (Sequence ders) = (SequenceTag, mapM_ putDer ders)
putDer' (Integer int) = (IntegerTag, mapM_ putWord8 (integerToBytes int))
putDer' (OctetString (B contents)) = (PrimitiveOctetStringTag, putLazyByteString contents)
putDer' (Other (tag, (B contents))) = (OtherTag tag, putLazyByteString contents)

putDer :: Der -> Put
putDer der = do
  let (tag, payload) = putDer' der
  putTag tag
  payload <- return $ runPut payload
  putLength (BS.length payload)
  putLazyByteString payload
  

getLength :: Get Integer
getLength = do
  byte1 <- getWord8
  if byte1 <= 127
  then
    return (fromIntegral byte1)
  else
    if byte1 == 128
    then error "[getLength]: indefinite length"
    else
      if byte1 == 255
      then error "[getLength]: reserved value of length (255)"
      else error "[getLength]: multibyte length not supported"

getSequence :: Get a -> Get [a]
getSequence f = do
  isEmpty <- isEmpty
  if isEmpty
  then return []
  else do
    x <- f
    xs <- getSequence f
    return (x : xs)

getKnownDer :: Tag -> Get Der
getKnownDer SequenceTag = Sequence <$> getSequence getDer
getKnownDer IntegerTag = do
  s <- getRemainingLazyByteString
  let res = foldl (\a x -> a * 256 + fromIntegral x) (0 :: Integer) (BS.unpack s)
  return $ Integer $ if BS.index s 0 >= 128
    then
      res - 2 ^ (BS.length s * 8 - 1)
    else
      res
getKnownDer PrimitiveOctetStringTag = OctetString . B <$> getRemainingLazyByteString
getKnownDer (OtherTag tag) = (\x -> Other (tag, B x)) <$> getRemainingLazyByteString

getDer :: Get Der
getDer = do
  tag <- getTag
  length <- getLength
  isolate (fromInteger length :: Int) (getKnownDer tag) 

parseSequence :: ([a] -> (b, [a])) -> [a] -> [b]
parseSequence f [] = []
parseSequence f rest =
  case f rest of
    (b, rest) -> b : parseSequence f rest


splitAt' len list = case Prelude.splitAt len list of
  (first, rest)
   | length first == len -> (first, rest)
   | otherwise -> error "splitAt' failed"

parseKnownType 48 bytes = (Sequence (parseSequence parseDer bytes))
parseKnownType typ rest = error $ "unknown Der type: " ++ show typ

parseDer :: [Word8] -> (Der, [Word8])
parseDer (typ : len : rest) =
  case splitAt' (fromIntegral len) rest of
    (this, rest) ->
      (parseKnownType typ this, rest)

main' = do
  BS.getContents >>= print . runGet getDer

prettyToDer = do
  der <- getLine
  BS.putStr (runPut (putDer (read der)))

of_hex s = read ("\"" ++ s ++ "\"")

pkToDer = do
  pk <- getLine
  let
   der = 
    Sequence [
     Integer 1,OctetString $ of_hex pk,Other (160,of_hex "06052b8104000a")]
  BS.putStr (runPut (putDer der))

main = pkToDer
