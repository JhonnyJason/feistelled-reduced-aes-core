# AES Experiments
AES uses a strong pseudorandom permutation at it's core.
We have the usecase that we have a secret seed - and out of this seed we want to generate a sequence of unique tokens which cannot be guessed by an adversary who might know all generated tokens.

For the sake of a unique token sequence this experiment investigated:
- Using AES-CTR such that digestCTR(counter) provides a unique token for "counter"
- Various optimizations that it runs as fast as possible
- How a minimal Feistel Network of 3 rounds of 2 transformation rounds + one final substitution round compares feistelDigest(counter)
- How using AES-CTR nativly (for 2 blocks) compares

# Problems
- When using AES-CTR directly the output is just 1 block per operation (that's why in native we use 2 blocks) - we want 32 bytes for a token
- The self-created Feistel Network is not prooven to be any save (in the worst case someone could directly calculate the key from a small squence)

# Results
- The implementation in Javascript is not as fast as hoped 
- fastest digestCTR(counter ) is just 10x faster than sha256
- Interestingly the Native implementation is even slower just 3.33x faster than sha256
- The minimal Feistel Network is just 15x faster than sha256

Maybe the expectations on 100x where a bit off - it is a quite a few operations indeed which just cannot be speed up much more...


---

# License
All the sophisticated AES primitives are directly based [ricmoos' aes-js](https://github.com/ricmoo/aes-js)
Everything else consider as simply unlicensed ;-)

[Unlicense JhonnyJason style](https://hackmd.io/nCpLO3gxRlSmKVG3Zxy2hA?view)
