#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char** argv){
	if (argc != 2){
		// 2 is stderror
		fprintf(2, "Usage: sleep [time_amount]\n");
		fprintf(2, "Total Arguments: %d", argc);
		exit(1);
	}
	sleep(atoi(argv[1]));
	exit(0);
};
