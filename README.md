# Simple SQL Update Statement Parser

Compiler Designing project on `SQL update statement` parsing based on Lex and Yacc.

This parser simply checks the validity of the Update statement of SQL language.

example:

```bash
Enter a SQL update query:
SQL: update table
  -> set name = "val"  
  -> where name IS NULL;
Query is Valid!
```

## Screenshot

![screenshot](https://github.com/yuvrajsab/CD-Project/blob/master/image.PNG)

## Development

This project is built using Flex, Yacc and [GNUMake](https://www.gnu.org/software/make/).
Before you can start development you need to take care of a few prerequisites.

### Installing Prerequisites

#### Using `apt` package manager (Debian/Ubuntu)

```bash
sudo apt install flex yacc 
sudo apt install make #(optional)
```

**Note**: You can get GnuMake for Windows OS from http://gnuwin32.sourceforge.net/packages/make.htm

### Clone Project

You can simply clone the project using git as:

```bash
git clone https://github.com/yuvrajsab/CD-Project.git
```
or you can simply download ZIP and extract it.

### Build

You can build project by just running a command using GNUMake.

```bash
make build
```

Or Manually:

```bash
flex update.l
yacc update.y
gcc lex.yy.c y.tab.c
```

### Run

You can build & run project by simply running just one command using GNUMake.

```bash
make
```

Or Manually (after Build):

```bash
./a.out #(for linux/macos)
./a.exe #(for windows)
```

### Test

We have some tests in `tests.txt` file to check the parser which strings it is accepting. You can also add your own string in `tests.txt` file.

Run test using GnuMake:

```bash
make test
```

Or Manually (after Build):

```bash
./a.out TEST #(for linux/macos)
./a.exe TEST #(for windows)
```
