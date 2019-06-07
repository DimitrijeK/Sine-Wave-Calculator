#include <curses.h>
#include <unistd.h>
#include <math.h>

char * levels = " .:-=+*#%@";

int main()
{
	initscr();
	double tpi = 3.14159265359 * 2;
	double phase = 0;
	double theta = 0;
	double increment = tpi / (double) COLS;
	int l;
	int c;

top:	
    erase();
	phase += increment;
	l = 0;

sinner:	
    if (l >= LINES) goto bottom;
	theta = 0;
	c = 0;
	
tinner:	
    if (c >= COLS) goto binner;
	int intensity = (int) ((sin(phase + theta) + 1.0) / 2.0 * 10);
	mvaddch(l, c, levels[intensity]);
	theta += increment;
	c++;
	goto tinner;

binner:	
    l++;
	goto sinner;

bottom:	
    box(stdscr, 0, 0);
	refresh();
	goto top;

	endwin();
	return 0;
}