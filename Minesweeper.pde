import de.bezier.guido.*;

private static final int NUM_ROWS = 10;
private static final int NUM_COLS = 10;
private static final int NUM_MINES = 15;

private MSButton[][] buttons;
private ArrayList <MSButton> mines = new ArrayList <MSButton> ();

void setup () {
	size(400, 400);
	textAlign(CENTER, CENTER);

	Interactive.make( this );

	buttons = new MSButton[NUM_ROWS][NUM_COLS];
	for (int i = 0; i < buttons.length; i++) {
		for (int j = 0; j < buttons[i].length; j++) {
			buttons[i][j] = new MSButton(i, j);
		}
	}

	for (int k = 0; k < NUM_MINES; k++) {
		setMines();
	}
}

public void setMines() {
	int r = (int)(Math.random() * NUM_ROWS);
	int c = (int)(Math.random() * NUM_COLS);

	if (!mines.contains(buttons[r][c])) {
		mines.add(buttons[r][c]);
	} else {
		setMines();
	}
}

public void draw () {
	background( 0 );

	if (isWon()) {
		displayWinningMessage();
		return;
	}
}

public boolean isWon() {
	for (int i = 0; i < buttons.length; i++) {
		for (int j = 0; j < buttons[i].length; j++) {
			if (mines.contains(buttons[i][j]) && !buttons[i][j].isFlagged()) {
				return false;
			}
		if (!mines.contains(buttons[i][j]) && !buttons[i][j].clicked) {
				return false;
			}
		}
	}

	return true;
}

public void displayLosingMessage() {
	String arr = {"Y", "o", "u", " ", "L", "o", "s", "t", "!"};

	for (int i = 0; i < mines.size(); i++) {
		mines.get(i).revealMine();
	}
	
	noLoop();
}

public void displayWinningMessage() {
	String arr = {"Y", "o", "u", " ", "W", "o", "n", "!"};

	buttons = new MSButton[NUM_ROWS][NUM_COLS];
	for (int i = 0; i < mines.size(); i++) {
		mines.get(i).revealMine();
	}

	noLoop();
}

public boolean isValid(int r, int c) {
	return !(r >= NUM_ROWS || c >= NUM_COLS || r < 0 || c < 0);
}

public int countMines(int row, int col) {
	int count = 0;
	for (int i = -1; i < 2; i++) {
		for (int j = -1; j < 2; j++) {
			if (i == 0 && j == 0) {
				continue;
			}

			if (isValid(row + i, col + j)) {
				if (mines.contains(buttons[row + i][col + j])) {
					count++;
				}
			}
		}
	}

	return count;
}

public class MSButton {
	private int myRow, myCol;
	private float x, y, width, height;
	private boolean clicked, flagged;
	private String myLabel;

	public MSButton ( int row, int col ) {
		width = 400 / NUM_COLS;
		height = 400 / NUM_ROWS;
		myRow = row;
		myCol = col; 
		x = myCol * width;
		y = myRow * height;
		myLabel = "";
		flagged = clicked = false;
		Interactive.add( this );
	}

	public void mousePressed () {
		clicked = true;

		if (mouseButton == RIGHT) {
			flagged = !flagged;
			clicked = false;
		} else if (mines.contains(this)) {
			displayLosingMessage();
		} else if (countMines(myRow, myCol) > 0) {
			setLabel(str(countMines(myRow, myCol)));
		} else {
			for (int i = -1; i <= 1; i++) {
				for (int j = -1; j <= 1; j++) {
					if (i == 0 && j == 0) {
						continue;
					}

					if (isValid(myRow + i, myCol + j)) {
						if (!buttons[myRow + i][myCol + j].flagged && !buttons[myRow + i][myCol + j].clicked) {
							buttons[myRow + i][myCol + j].mousePressed();
						}
					}
				}
			}
		}
	}

	public void draw () {    
		if (flagged) {
			fill(0);
		} else if (clicked && mines.contains(this)) {
			fill(255, 0, 0);
		} else if (clicked) {
			fill(200);
		} else {
			fill(100);
		}

		rect(x, y, width, height);
		fill(0);
		text(myLabel, x+width/2, y+height/2);
	}

	public void revealMine() {
		fill(255, 0, 0);
		rect(x, y, width, height);
		fill(0);
		text(myLabel, x+width/2, y+height/2);
	}

	public void setLabel(String newLabel) {
		myLabel = newLabel;
	}

	public void setLabel(int newLabel) {
		myLabel = "" + newLabel;
	}

	public boolean isFlagged() {
		return flagged;
	}
}
