algorithm-d
===========

Algorithm D from the paper "Pattern Matching in Trees" from Hoffmann and O'Donnell. Contains both the counter and bit string versions and supports matching multiple patterns on a single trie.

To build, clone the repository and run:

```
mllex lexer.lex
mlyacc parser.grm
smlpkg sync
mlton algorithmd.mlb
```

The executable will be `./algorithmd` in the project directory.