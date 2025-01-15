#!/bin/zsh

mkdir -p ~/bin
cp opam ~/bin/opam
chmod +x ~/bin/opam

export PATH=$HOME/bin:$PATH

opam init --root=$HOME/.opam

#opam switch create 5.2.0
#eval $(opam env --switch=5.2.0)
