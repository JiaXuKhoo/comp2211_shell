#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

// Coursework description mentioned allowed use of xv6 shell source code as reference and externel resources so,
// Reference List
// Source 1: https://github.com/mit-pdos/xv6-riscv/blob/riscv/user/sh.c - xv6 by MIT
// Source 2: xv6: a simple, Unix-like teaching operating system by Russ Cox, Frans Kaashoek and Robert Morris (31/08/2024)

// Purpose: Reading a line from user
// Output: 0 for success, -1 for unsuccessful
// Modified from source 1
int getcmd(char* buf, int nbuf){
	
	write(2, ">>> ", 4);
	memset(buf, 0, nbuf);
	gets(buf, nbuf);

	if (buf[0] == 0){
		return -1;
	}
	return 0;
}

// Purpose: Recursive function to parse command character by character at *buf and execute it

__attribute__((noreturn))
void run_command(char* buf, int nbuf, int* pcp){

	// Useful data structures and flags
	
	char* arguments[10] = {0}; // Initialize everything to NULL
	int numargs = 0; // number of arguments

	int ws = 1; // word start flag
	int we = 0; // word end flag
	
	int redirection_left = 0; // <
	int redirection_right = 0; // >
	char* file_name_l = 0; // Buffer to store name of file on the left
	char* file_name_r = 0; // Buffer to store name of file on the right

	int p[2];
	int pipe_cmd = 0; // stores the location where | operator occurs

	int sequence_cmd = 0; // stores the location where ; operator occurs

	// Parsing character by character
	for (int i = 0; i < nbuf; i++){
		
		// Sets flag and null terminate for a valid string
		// Apparently \0 in integer is 0
		if (buf[i] == '<'){
			redirection_left = 1;
			buf[i] = 0; // Null terminate a word
			continue;
		}
		if (buf[i] == '>'){
			redirection_right = 1;
			buf[i] = 0;
			continue;
		}
		if (buf[i] == '|'){
			pipe_cmd = i + 1; // 1 positon offset
			buf[i] = 0;
			break; // Handling recursively
		}
		if (buf[i] == ';'){
			sequence_cmd = i + 1; // 1 position offset
			buf[i] = 0;
			break; // Handling recursively
		}
		
		// hello012304560
		// If redirection is not present
		if (!(redirection_left || redirection_right)){
			
			// Check for whitespaces, ' ', '\t' and '\n' AND CARRIAGE RETURN
			if ((buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\n' || buf[i] == 13)){
				if (ws) continue; // skip this iteration if it's a start of word is whitespace

				buf[i] = 0; // null terminate
				we = 1; // whitespace so word ended

			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
				if (strcmp(&buf[i], "") != 0){
					arguments[numargs++] = &buf[i]; // Save word string to arguments
				}
				ws = 0; // reset flag

			}
			if (we){ // At the end of a word
				ws = 1; // start a new word
				we = 0; // no longer at the end of a word

			}

		}else{ // Redirection is detected, capture filenames

			// We are only expected to do 2 element redirections
			
			if (!file_name_l && redirection_left){ // if left redirection
				// If it's a whitespace we process at next iteration, skipping whitespaces
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
					
					file_name_l = &buf[i]; // capture string
					file_name_l[strlen(file_name_l) - 1] = 0; // Remove trailing newline
				}
			}

			if (!file_name_r && redirection_right){
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
					
					file_name_r = &buf[i];
					file_name_r[strlen(file_name_r) - 1] = 0; // Remove trailing newline
				}
			}
		}
	}
	
	
	arguments[numargs] = 0; // NULL terminate for exec() to work

	// Dealing with sequence command ;
	if (sequence_cmd){

		// Parent Process
		if (fork() != 0){
			wait(0);
			
			fprintf(2, "Sequenced: <S>%s<E>\n", &buf[sequence_cmd]);

			// Recursively call run_command to handle everything after ;
			run_command(&buf[sequence_cmd], nbuf - sequence_cmd, pcp);
			exit(0); // Exits even if run_command is not working
		}
		wait(0);
	}

	// Dealing with redirection command < and >

	if (redirection_left){
		close(0); // close stdin
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_l);
			exit(1); // quit
		}
	}
	if (redirection_right){
		close(1); // close stdout
		if (open(file_name_r, O_WRONLY|O_CREATE|O_TRUNC) < 0){ // open our file with fd of 1
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_r);
			exit(1); // quit
		}
	}

	// Handle cd special case
	if (numargs > 0 && strcmp(arguments[0], "cd") == 0){
		// Write argument to pcp pipeline
		write(pcp[1], arguments[1], strlen(arguments[1]));

		// Exit with 2 to let main know there is cd command
		exit(2);

	}else{ // We know it is not a cd command
		// Technique from source 2
		if (pipe_cmd){
			
			pipe(p); // New pipe
			
			if (fork() == 0){
				close(1); // close stdout
				dup(p[1]); // Make "in" part of pipe to be stdout
				
				close(p[0]);
				close(p[1]);

				exec(arguments[0], arguments); // Execute command on the left
				
				// If we reach this part that means something went wrong
				fprintf(2, "Execution of the command failed: %s\n", arguments[0]);

				exit(1);
			}
			if (fork() == 0){ // Handle right side recursively
				close(0); // close stdin
				dup(p[0]); // Make "out" part of pipe to be stdin

				close(p[1]);
				close(p[0]);

				run_command(&buf[pipe_cmd], nbuf - pipe_cmd, pcp);
				exit(0);
			}
			
			close(p[0]);
			close(p[1]);
			wait(0);
			wait(0);

		}else{ // No pipes as well, just a plain command
			exec(arguments[0], arguments);

			// Something went wrong if this part is reached
			fprintf(2, "Execution of the command failed: %s\n", arguments[0]);
			exit(1);	
		}
	}
	exit(0);
}


// Purpose: Repeatedly prompt user for input, forks process to run commands,
// and handle the chdir special case.

int main(void){
	
	static char buf[100];

	// Setup a pipe
	int pcp[2];
	pipe(pcp);

	int fd;

	// Make sure file descriptors are open
	// Taken from source 1
	while((fd = open("console", O_RDWR)) >= 0){
		if(fd >= 3){
			close(fd); // close 0, 1 and 2 and it will reopen itself
			break;
		}
	}
	
	// Main Loop
	while(getcmd(buf, sizeof(buf)) >= 0){
		
		if (fork() == 0){
			run_command(buf, 100, pcp);
		}
		
		int child_status;

		wait(&child_status);

		if (child_status == 2){ // CD command is detected, must execute in parent

			char buffer_cd_arg[100];
			memset(buffer_cd_arg, 0, sizeof(buffer_cd_arg));

			// Read from pipe the pathname to cd
			read(pcp[0], buffer_cd_arg, sizeof(buffer_cd_arg));
			
			// Attempt to use chdir system call
			if (chdir(buffer_cd_arg) < 0){
				fprintf(2, "Failed to change directory to : %s\n", buffer_cd_arg);
			}	
		}
	}
	exit(0);
}
