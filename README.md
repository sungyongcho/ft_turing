# ft_turing

> Turing machine interpreter in OCaml with tape visualization and complexity analysis.

## Overview

A single-headed, single-tape Turing machine simulator written in OCaml. The program reads a machine description from a JSON file, executes it on a given input string, and displays each transition step with a visual representation of the tape and head position. Includes infinite loop/run detection and time complexity analysis as a bonus.

This project was built as part of the 42 school curriculum with a partner (Woolim Park) · Score: 125/100.

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| Language | OCaml |
| JSON Parsing | Yojson |
| Build System | Dune (>= 3.17) |
| Package Manager | OPAM |

## Key Features

- Parses JSON machine descriptions with full validation (alphabet, states, transitions, blanks)
- Executes Turing machine step-by-step with tape visualization and head position highlighting
- Infinite loop detection via configuration history (state + tape + head tracking)
- Infinite run detection for blank-producing loops
- Five machine descriptions: unary addition, palindrome checker, 0^n1^n recognizer, 0^2n recognizer, and a Universal Turing Machine
- Bonus: time complexity analysis tracking state visit counts and total steps

## Architecture

```
ft_turing/
├── bin/
│   ├── main.ml            # Entry point, CLI argument parsing
│   ├── types.ml           # Type definitions (machine, transition)
│   ├── parser.ml          # JSON parsing and validation
│   ├── executer.ml        # Turing machine execution loop
│   ├── print_machine.ml   # Machine description and tape display
│   └── dune               # Build configuration
├── res/
│   ├── 0.unary_sub.json   # Unary subtraction (provided example)
│   ├── 1.unary_add.json   # Unary addition
│   ├── 2.palindrome.json  # Palindrome checker
│   ├── 3.zero_n_one_n.json # 0^n1^n language recognizer
│   ├── 4.zero_2n.json     # 0^2n language recognizer
│   └── 5.utm*.json        # Universal Turing Machine
├── ft_turing.opam          # OCaml package metadata
├── dune-project            # Dune project configuration
├── install_opam.sh         # OPAM setup script
└── Makefile
```

## Getting Started

### Prerequisites

```bash
# OCaml and OPAM
# Dune >= 3.17
opam install yojson dune
```

### Installation

```bash
git clone https://github.com/sungyongcho/ft_turing.git
cd ft_turing
make
```

### Usage

```bash
# Run with a machine description and input
./ft_turing res/0.unary_sub.json "111-11="

# Unary addition
./ft_turing res/1.unary_add.json "11+111="

# Palindrome check
./ft_turing res/2.palindrome.json "abcba"

# 0^n1^n language
./ft_turing res/3.zero_n_one_n.json "000111"

# 0^2n language
./ft_turing res/4.zero_2n.json "0000"

# Help
./ft_turing --help
```

## What This Demonstrates

- **Formal Computation**: Implemented a Turing machine simulator with proper state management, tape manipulation, and transition execution — the foundational model of computation.
- **Functional Programming**: Written in OCaml using algebraic data types, pattern matching, recursive execution, and immutable data structures.
- **Complexity Analysis**: Tracks state visit frequencies and total computation steps to analyze the time complexity of executed algorithms.

## License

This project was built as part of the 42 school curriculum.

---

*Part of [sungyongcho](https://github.com/sungyongcho)'s project portfolio.*
