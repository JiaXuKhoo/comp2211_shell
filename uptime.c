#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char** argv){
	if(argc != 1){
		// print to stderror
		fprintf(2, "Uptime does not accept any arguments.\n");
		exit(1);
		
	}else{
		// Use the uptime syscall
		printf("Total uptime: %d ticks.\n", uptime());
	}
	exit(0);
}
