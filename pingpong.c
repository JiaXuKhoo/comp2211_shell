#include "kernel/types.h"
#include "user/user.h"


int main(){
	
	// Establish a pipe
	int p[2];
	pipe(p);

	// Create our message to be pinged
	char ball = 'a';
	int pid = fork();

	if (pid > 0){ // Parent process
		// write to the 'in'-part of the pipe
		write(p[1], &ball, 1);
		
		// wait for child process to finish
		wait((int*) 0);

		// We read the altered byte from the pipe
		int message;
		read(p[0], &message, 1);
		int my_pid = getpid();
		printf("Parent [PID=%d]: Recieved Pong, message: %i\n", my_pid, message);		

	}else{ // Child Process
		int byte_buffer;
		
		// Read in the byte from the 'out'-part of the pipe
		read(p[0], &byte_buffer, 1);
		int my_pid = getpid(); // get this process's pid using getpid() syscall
		printf("Child [PID=%d]: Recieved Ping, message:%i\n", my_pid, byte_buffer);

		// Change the message and send it back
		if (byte_buffer == 'a'){
			byte_buffer = 'b';
			write(p[1], &byte_buffer, 1);
		}
		exit(0);
	}


exit(0);
}
