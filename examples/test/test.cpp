#include <atomic>
#include <cassert>

using namespace std;

int g = 0;

int notmain(int& y) {
	++y;
	g = y;
	return g;
}

int main () {
	atomic_int x (0);

	int y = x.fetch_add(1);
	y = notmain(y);
	
	x.compare_exchange_strong(y, 2); 
}
