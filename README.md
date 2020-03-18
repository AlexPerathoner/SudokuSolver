
<img align="right" width="20%" src="https://raw.githubusercontent.com/AlexPerathoner/SudokuSolver/master/Screens/icon.png"></img>
# SudokuSolver

Command line tool in Swift to solve sudokus using recursion and multiple cores.


## How it works
SudokuSolver has one simple function: solve(). This function is called recoursively and what it does is check what numbers could be added to the table. If there are none, SudokuSolver tries another combination.


## Performance
The results of some tests are shown below.
The times indicated are compared to the first version of *SudokuSolver*, which used only recursion, and to the second version, which also uses multiple threads.

<a name="table"></a>

| Level<sup>[1](#note1)</sup>   | Time with recursion<sup>[2](#note2)</sup> | Time with recursion & GCD<sup>[2](#note2)</sup> |
| ------------- | ------------- | ---------- |
| Easy  | 0.09  | 0.12 |
| Medium| 0.13  | 0.21 |
| Hard| 2.11  | 0.8 |
| Expert| 10.647 | 4.16 |
| Plus<sup>[3](#note3)</sup>| 164.353 | 80.06|

<a name="note1"></a><sup>1</sup>: Level according to [sudoku.com](https://sudoku.com)</mark>

<a name="note2"></a><sup>2</sup>: Times are in seconds</mark>

<a name="note3"></a><sup>3</sup>: Arto Inkala's "[World's Hardest Sudoku](https://gizmodo.com/can-you-solve-the-10-hardest-logic-puzzles-ever-created-1064112665)".</mark>

As you can see the only-recursion is effectively only with sudokus which have fewer combinations. However, with difficult sudoku it starts to be worth creating more threads, up to the "[World's Hardest Sudoku](https://gizmodo.com/can-you-solve-the-10-hardest-logic-puzzles-ever-created-1064112665)", which is solved in 51% in less time.

## How to use
*SudokuSolver* takes an input file that could look like this:

```-6---7---
1---8---4
---91----
---------
---3---26
47---68--
6-5--247-
-----81--
--9----3-
```
The file should be saved on the disk in the .txt format.

Once started, *SudokuSolver* will ask you to enter the path to that file.
Press enter and the solving algorithm will begin.

Output will look like this:

><img margin="10px" width="45%" src="https://raw.githubusercontent.com/AlexPerathoner/SudokuSolver/master/Screens/solved.png">

  
**Important:** more complex sudokus can take quite a long time to be solved (see  the [table](#table)) and as there is **no** limit to the cpu used by *SudokuSolver* it's likely that the performance of your computer will drop.

><img align="left" margin="30px" width="48%" src="https://raw.githubusercontent.com/AlexPerathoner/SudokuSolver/master/Screens/cpuUsage.png">

<br>
<br>
<br>
## Credits
Thanks to [amiantos](https://gist.github.com/amiantos) for creating his [Toroidal Matrix](https://gist.github.com/amiantos/bb0f313da1ee686f4f69b8b44f3cd184) and inspiring me to create this project.
<div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

---
Donations are welcome!

[![Donate-Paypal](https://img.shields.io/badge/donate-paypal-yellow.svg?style=flat)](https://paypal.me/AlexanderPerathoner)
