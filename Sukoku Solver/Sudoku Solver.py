import sys

size = 9
box_size = 3
digits = set(range(1, 10))

def read_sudoku(Sudoku_problem):
    # Read the Sudoku puzzle from a text file.
    grid = []

    with open(Sudoku_problem, "r", encoding="utf-8") as file:
        for line in file:
            line = line.strip()

            if not line or set(line) <= set("-+| "):
                continue

            values = [
                char for char in line
                if char.isdigit() or char == "."
            ]

            if len(values) != size:
                raise ValueError(
                    "Each Sudoku row must contain exactly 9 cells."
                )

            row = []
            for value in values:
                if value == "." or value == "0":
                    row.append(0)
                elif value in "123456789":
                    row.append(int(value))
                else:
                    raise ValueError("Invalid Sudoku value.")

            grid.append(row)

    if len(grid) != size:
        raise ValueError("The Sudoku must contain exactly 9 rows.")

    if not is_valid_grid(grid):
        raise ValueError(
            "The initial Sudoku contains conflicting numbers."
        )

    return grid

def is_valid_grid(grid):
    # Check whether the initial numbers obey the Sudoku constraints.
    for row in range(size):
        for col in range(size):
            value = grid[row][col]

            if value == 0:
                continue

            grid[row][col] = 0
            valid = is_valid_value(grid, row, col, value)
            grid[row][col] = value

            if not valid:
                return False

    return True

def is_valid_value(grid, row, col, value):
    # Check the row and column constraints.
    for i in range(size):
        if grid[row][i] == value:
            return False

        if grid[i][col] == value:
            return False

    # Check the 3x3 box constraint.
    box_row = (row // box_size) * box_size
    box_col = (col // box_size) * box_size

    for r in range(box_row, box_row + box_size):
        for c in range(box_col, box_col + box_size):
            if grid[r][c] == value:
                return False

    return True

def solve_sudoku(grid):
    # Find the next empty cell in a fixed order.
    for row in range(size):
        for col in range(size):
            if grid[row][col] == 0:

                # Try each digit in the empty cell.
                for value in range(1, 10):
                    if is_valid_value(grid, row, col, value):
                        grid[row][col] = value

                        # Recursively solve the remaining cells.
                        if solve_sudoku(grid):
                            return True

                        # Backtrack if this value fails.
                        grid[row][col] = 0

                # No digit works in this cell.
                return False

    # No empty cells = the puzzle is solved.
    return True


def print_sudoku(grid):
    # Print the Sudoku in a gird.
    for row in range(size):
        if row > 0 and row % box_size == 0:
            print("------+-------+------")

        parts = []
        for col in range(size):
            if col > 0 and col % box_size == 0:
                parts.append("|")
            parts.append(str(grid[row][col]))

        print(" ".join(parts))

def main():
    if len(sys.argv) != 2:
        print("Usage: python sudoku_solver.py <puzzle_file.txt>")
        return

    filename = sys.argv[1]

    try:
        grid = read_sudoku(filename)
    except (OSError, ValueError) as error:
        print(f"Error reading puzzle: {error}")
        return

    print("Original Sudoku:")
    print_sudoku(grid)

    print("\nSolving...")

    if solve_sudoku(grid):
        print("\nSolved the Sudoku:")
        print_sudoku(grid)
    else:
        print("\nNo solution for this Sudoku.")

if __name__ == "__main__":
    main()
