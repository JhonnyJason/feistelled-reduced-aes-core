# Feistelled Reduced AES Core
This is an implementation of a 3 rounds of Feistel Network around an AES 2-transformation step finishing with an AES substitution step.
For every AES-step we use the next of the pre-generated AES-Keys.

# Background

Request Based Authentication using a valid 256bit token.
Using a randomly generated 256bit token for a session is usually fine.

But we want to also satisfy the next level risk which is a timely leaked token.

Therefore we constructed an "adequate" pseudorandom permutation.
The pseudorandom permutation is based on a commonly known seed.
For this we need:
- infeasibility on recovering the seed
- infeasibility to correctly guess the next 

At the same time we want to be much faster than a hash-function like sha256. From which we know we can get this properties as well, when applied correctly.

For this reason we took the [AES Core](https://github.com/ricmoo/aes-js) as a basis, where we know that in the full implementation these conditions are met. Then reduced it to a minimal version which should satisfy these conditions when being [feistelled 3 times over](https://en.wikipedia.org/wiki/Feistel_cipher#Theoretical_work).

Note: If we want the next level - which also includes message integrity checks- then we use SHA256-HMACs. 


# :warning:
**There is no proof (yet) for any of these security properties we imply.**

If you have an idea on how to analyse this implementation for these security properties - don't hesitate to throw a message! :-)


# Usage
```coffee
import { FRAESC } from "feistelled-reduced-aes-core"

seedBytes = # ... a shared seed

fraesc = new FRAESC(seedBytes)

console.log(freasc.generate())

counter = 0
console.log(freasc.generate(counter++))
console.log(freasc.generate(counter++))
console.log(freasc.generate(Date.now()))

console.log(freasc.generate())

```

Construct a new FRAESC instance with your seed as bytes (Uint8 Array of length 64).

The `fraesc.generate()` function generates the pseudorandom bytes (Uint8 Array of length 32). 

- Notice: `fraesc.generate()` returns always the same preallocated Uint8 Array and overwrites the previous one when generating the new pseudorandom bytes.
- Notice: that the FRAESC is **stateful**. As every generation alters the internal left/right vectors.
- Notice: You may provide additional entropy by passing a number value to the `fraesc.generate(num)` function.


---

# License
All the sophisticated AES primitives are directly based [ricmoos' aes-js](https://github.com/ricmoo/aes-js)
Everything else consider as simply unlicensed ;-)

[Unlicense JhonnyJason style](https://hackmd.io/nCpLO3gxRlSmKVG3Zxy2hA?view)
