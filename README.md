# MiniLisp Compiler - Final Project

This project implements a basic MiniLisp compiler with the following features:
1. Syntax Validation
2. Print Statements
3. Numerical Operations
4. Logical Operations
5. `if` Expressions
6. Variable Definitions

The compiler is built using **lex** (for lexical analysis) and **yacc** (for parsing).

## Features

### 1. Syntax Validation
- The compiler will check if the syntax of the MiniLisp code is correct.

### 2. Print
- Print functionality will output values to the console.

### 3. Numerical Operations
- Basic numerical operations such as addition, subtraction, multiplication, and division are supported.

### 4. Logical Operations
- Logical operations like AND, OR, and NOT are supported.

### 5. `if` Expression
- The compiler supports `if` expressions for conditional evaluation.

### 6. Variable Definition
- You can define and use variables within the MiniLisp environment.

## How to Run

To compile and run the MiniLisp compiler, follow these steps:

### Step 1: Install Required Tools
Ensure that you have `bison`, `flex`, and `gcc` installed. These tools are used to generate the parser and lexer.

- **Bison** (GNU parser generator)
- **Flex** (fast lexical analyzer generator)
- **GCC** (GNU Compiler Collection)

### Step 2: Generate the Parser and Lexer

#### Generate the Parser using Bison (Yacc)
```bash
bison -d -o minilisp.tab.c minilisp.y
```

#### Compile the Parser Code
```bash
gcc -c -std=c99 -g -I.. minilisp.tab.c
```

#### Generate the Lexer using Flex
```bash
flex -o minilisp.yy.c minilisp.l
```

#### Compile the Lexer Code
```bash
gcc -c -std=c99 -g -I.. minilisp.yy.c
```

#### Link the Object Files
```bash
gcc -o minilisp minilisp.tab.o minilisp.yy.o -ll
```

#### Run the Compiler((put ur testcase in this testcase.txt file))
```bash
./minilisp < testcase.txt
```

