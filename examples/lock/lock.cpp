#include <pthread.h>

pthread_mutex_t lock;
int x = 0;

int main (int argc, char** argv) {
	pthread_mutex_init(&lock, NULL);
	if (argc == 0) {
		x = 2;
		return 0;
	}

	pthread_mutex_lock(&lock);

	if (argc < 0) {
		x = -5;
		pthread_mutex_unlock(&lock);
		return 0;
	}

	if (argc > 0) {
		x = 27;
		//pthread_mutex_unlock(&lock);
		return 0;
	}

	pthread_mutex_unlock(&lock);
	return 1;
}

