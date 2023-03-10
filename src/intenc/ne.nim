## Byte precision int/number encoding
    
import std/[math, strutils, sequtils, parseutils, sugar]
import utils

proc convert(s: openArray[int], mlength: int): seq[byte] =
    var tmp: byte
    for x in s:
        let b = x.toBin(mlength * 8)
        for i in countup(0, b.len-1, 8):
            if i+7 < b.len:
                discard b[i..i+7].parseBin(tmp)
            else:
                discard b[i..^1].parseBin(tmp)
            result.add tmp

# Temporary removal
# proc encode*(s: openArray[int]): seq[byte] = 
    # Encode an array of integers into an seq of bytes.
    # The byte length is stored as the first byte in the seq.
    # var mlength = findMaxLen(s, true)
    # mlength = ceil(mlength.binLen / 8).int
    # result.add mlength.byte
    # result.add s.convert(mlength)



proc encode*(us: openArray[uint], lo: var int): seq[byte] = 
    ## Encode an array of integers into an seq of bytes.
    ## The byte length is stored into `lo`.
    let s = us.map(a => a.int) # For math it does not except uint
    
    var mlength = findMaxLen(s, true)
    mlength = ceil(mlength.binLen / 8).int
    lo = mlength
    result.add s.convert(mlength)

proc decode*(i: openArray[byte], l = 0): seq[uint] = 
    ## Decode an encoded int seq from an array of bytes.
   
    var ri = i.toSeq
    var rl: int
    # if l == 0:
        # rl = ri[0].int
        # ri.delete(0)
    # else:
    rl = l
    var tmp: int
    for index in countup(0, ri.len-1, rl):
        var rstr = ""
        for x in ri[index..index+rl-1]:
            rstr &= x.int.toBin(8)
        discard rstr.parseBin(tmp)
        result.add tmp.uint