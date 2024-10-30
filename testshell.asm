
user/_testshell:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:

// Purpose: Reading a line from user
// Output: 0 for success, -1 for unsuccessful
// Modified from source 1

int getcmd(char* buf, int nbuf){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
	
	write(2, ">>> ", 4);
  10:	4611                	li	a2,4
  12:	00001597          	auipc	a1,0x1
  16:	c5e58593          	addi	a1,a1,-930 # c70 <malloc+0xfa>
  1a:	4509                	li	a0,2
  1c:	6ae000ef          	jal	6ca <write>
	memset(buf, 0, nbuf);
  20:	864a                	mv	a2,s2
  22:	4581                	li	a1,0
  24:	8526                	mv	a0,s1
  26:	49e000ef          	jal	4c4 <memset>
	gets(buf, nbuf);
  2a:	85ca                	mv	a1,s2
  2c:	8526                	mv	a0,s1
  2e:	4dc000ef          	jal	50a <gets>

	if (buf[0] == 0){
  32:	0004c503          	lbu	a0,0(s1)
  36:	00153513          	seqz	a0,a0
		return -1;
	}
	return 0;
}
  3a:	40a00533          	neg	a0,a0
  3e:	60e2                	ld	ra,24(sp)
  40:	6442                	ld	s0,16(sp)
  42:	64a2                	ld	s1,8(sp)
  44:	6902                	ld	s2,0(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret

000000000000004a <run_command>:

// Purpose: Recursive function to parse command character by character at *buf and execute it

__attribute__((noreturn))
void run_command(char* buf, int nbuf, int* pcp){
  4a:	716d                	addi	sp,sp,-272
  4c:	e606                	sd	ra,264(sp)
  4e:	e222                	sd	s0,256(sp)
  50:	fda6                	sd	s1,248(sp)
  52:	f9ca                	sd	s2,240(sp)
  54:	f5ce                	sd	s3,232(sp)
  56:	f1d2                	sd	s4,224(sp)
  58:	edd6                	sd	s5,216(sp)
  5a:	e9da                	sd	s6,208(sp)
  5c:	e5de                	sd	s7,200(sp)
  5e:	e1e2                	sd	s8,192(sp)
  60:	fd66                	sd	s9,184(sp)
  62:	f96a                	sd	s10,176(sp)
  64:	f56e                	sd	s11,168(sp)
  66:	0a00                	addi	s0,sp,272
  68:	eea43c23          	sd	a0,-264(s0)
  6c:	8b2e                	mv	s6,a1
  6e:	f0c43023          	sd	a2,-256(s0)
	int pipe_cmd = 0; // stores the location where | operator occurs

	int sequence_cmd = 0; // stores the location where ; operator occurs

	// Parsing character by character
	for (int i = 0; i < nbuf; i++){
  72:	26b05c63          	blez	a1,2ea <run_command+0x2a0>
  76:	84aa                	mv	s1,a0
  78:	4901                	li	s2,0
	char* file_name_r = 0; // Buffer to store name of file on the right
  7a:	f0043c23          	sd	zero,-232(s0)
	char* file_name_l = 0; // Buffer to store name of file on the left
  7e:	f0043823          	sd	zero,-240(s0)
	int redirection_right = 0; // >
  82:	4a01                	li	s4,0
	int redirection_left = 0; // <
  84:	4a81                	li	s5,0
	int ws = 1; // word start flag
  86:	4785                	li	a5,1
  88:	f2f43023          	sd	a5,-224(s0)
	int numargs = 0; // number of arguments
  8c:	f0043423          	sd	zero,-248(s0)
		
		// Sets flag and null terminate for a valid string
		// Apparently \0 in integer is 0
		if (buf[i] == '<'){
  90:	03c00b93          	li	s7,60

			redirection_left = 1;
			buf[i] = 0; // Null terminate a word
			continue;
		}
		if (buf[i] == '>'){
  94:	03e00c13          	li	s8,62

			redirection_right = 1;
			buf[i] = 0;
			continue;
		}
		if (buf[i] == '|'){
  98:	07c00c93          	li	s9,124

			pipe_cmd = i + 1; // 1 positon offset
			buf[i] = 0;
			break; // Handling recursively
		}
		if (buf[i] == ';'){
  9c:	03b00d13          	li	s10,59
  a0:	00800db7          	lui	s11,0x800
  a4:	0dcd                	addi	s11,s11,19 # 800013 <base+0x7fdf9b>
  a6:	0da6                	slli	s11,s11,0x9
  a8:	a0e9                	j	172 <run_command+0x128>
			fprintf(2, "REDIR_L FLAG SET\n");
  aa:	00001597          	auipc	a1,0x1
  ae:	bd658593          	addi	a1,a1,-1066 # c80 <malloc+0x10a>
  b2:	4509                	li	a0,2
  b4:	1e5000ef          	jal	a98 <fprintf>
			buf[i] = 0; // Null terminate a word
  b8:	00048023          	sb	zero,0(s1)
			redirection_left = 1;
  bc:	4a85                	li	s5,1
			continue;
  be:	a075                	j	16a <run_command+0x120>
			fprintf(2, "REDIR_R FLAG SET\n");
  c0:	00001597          	auipc	a1,0x1
  c4:	bd858593          	addi	a1,a1,-1064 # c98 <malloc+0x122>
  c8:	4509                	li	a0,2
  ca:	1cf000ef          	jal	a98 <fprintf>
			buf[i] = 0;
  ce:	f2843783          	ld	a5,-216(s0)
  d2:	00078023          	sb	zero,0(a5)
			redirection_right = 1;
  d6:	4a05                	li	s4,1
			continue;
  d8:	a849                	j	16a <run_command+0x120>
			fprintf(2, "PIPE_CMD SET TO: %d\n", i+1);
  da:	2905                	addiw	s2,s2,1
  dc:	864a                	mv	a2,s2
  de:	00001597          	auipc	a1,0x1
  e2:	bd258593          	addi	a1,a1,-1070 # cb0 <malloc+0x13a>
  e6:	4509                	li	a0,2
  e8:	1b1000ef          	jal	a98 <fprintf>
			buf[i] = 0;
  ec:	f2843783          	ld	a5,-216(s0)
  f0:	00078023          	sb	zero,0(a5)
		}
	}

	
	// Dealing with sequence command ;
	if (sequence_cmd){
  f4:	aa91                	j	248 <run_command+0x1fe>
			fprintf(2, "SEQUENCE_CMD SET TO: %d\n", i+1);
  f6:	2905                	addiw	s2,s2,1
  f8:	864a                	mv	a2,s2
  fa:	00001597          	auipc	a1,0x1
  fe:	bce58593          	addi	a1,a1,-1074 # cc8 <malloc+0x152>
 102:	4509                	li	a0,2
 104:	195000ef          	jal	a98 <fprintf>
			buf[i] = 0;
 108:	f2843783          	ld	a5,-216(s0)
 10c:	00078023          	sb	zero,0(a5)
	if (sequence_cmd){
 110:	12090c63          	beqz	s2,248 <run_command+0x1fe>
		sequence_cmd = 0; // Reset flag

		// Parent Process
		if (fork() != 0){
 114:	58e000ef          	jal	6a2 <fork>
 118:	892a                	mv	s2,a0
 11a:	12050763          	beqz	a0,248 <run_command+0x1fe>
			wait(0);
 11e:	4501                	li	a0,0
 120:	592000ef          	jal	6b2 <wait>
			
			// Recursively call run_command to handle everything after ;
			run_command(&buf[sequence_cmd], nbuf - sequence_cmd, pcp);
 124:	f0043603          	ld	a2,-256(s0)
 128:	85da                	mv	a1,s6
 12a:	ef843503          	ld	a0,-264(s0)
 12e:	f1dff0ef          	jal	4a <run_command>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 132:	f2043783          	ld	a5,-224(s0)
 136:	10078463          	beqz	a5,23e <run_command+0x1f4>
				numargs++; // Increment number of arguments
 13a:	f0843783          	ld	a5,-248(s0)
 13e:	2785                	addiw	a5,a5,1
 140:	f0f43423          	sd	a5,-248(s0)
				arguments[numargs] = &buf[i]; // Save word string to arguments
 144:	078e                	slli	a5,a5,0x3
 146:	f9078793          	addi	a5,a5,-112
 14a:	97a2                	add	a5,a5,s0
 14c:	f2843703          	ld	a4,-216(s0)
 150:	fae7b823          	sd	a4,-80(a5)
 154:	8a4e                	mv	s4,s3
 156:	8ace                	mv	s5,s3
				ws = 0; // reset flag
 158:	f3343023          	sd	s3,-224(s0)
 15c:	a039                	j	16a <run_command+0x120>
			if (!file_name_l && redirection_left){ // if left redirection
 15e:	f1043703          	ld	a4,-240(s0)
 162:	cf31                	beqz	a4,1be <run_command+0x174>
			if (!file_name_r && redirection_right){
 164:	f1843783          	ld	a5,-232(s0)
 168:	c7d9                	beqz	a5,1f6 <run_command+0x1ac>
	for (int i = 0; i < nbuf; i++){
 16a:	2905                	addiw	s2,s2,1
 16c:	0485                	addi	s1,s1,1
 16e:	0d2b0c63          	beq	s6,s2,246 <run_command+0x1fc>
		if (buf[i] == '<'){
 172:	f2943423          	sd	s1,-216(s0)
 176:	0004c783          	lbu	a5,0(s1)
 17a:	f37788e3          	beq	a5,s7,aa <run_command+0x60>
		if (buf[i] == '>'){
 17e:	f58781e3          	beq	a5,s8,c0 <run_command+0x76>
		if (buf[i] == '|'){
 182:	f5978ce3          	beq	a5,s9,da <run_command+0x90>
		if (buf[i] == ';'){
 186:	f7a788e3          	beq	a5,s10,f6 <run_command+0xac>
		if (!(redirection_left || redirection_right)){
 18a:	014ae9b3          	or	s3,s5,s4
 18e:	2981                	sext.w	s3,s3
 190:	fc0997e3          	bnez	s3,15e <run_command+0x114>
			if ((buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\n' || buf[i] == 13)){
 194:	02000713          	li	a4,32
 198:	f8f76de3          	bltu	a4,a5,132 <run_command+0xe8>
 19c:	00fdd7b3          	srl	a5,s11,a5
 1a0:	8b85                	andi	a5,a5,1
 1a2:	dbc1                	beqz	a5,132 <run_command+0xe8>
				if (ws){ // If a whitespace is a start of a word, skip this iteration
 1a4:	f2043783          	ld	a5,-224(s0)
 1a8:	ebc1                	bnez	a5,238 <run_command+0x1ee>
					buf[i] = 0; // null terminate
 1aa:	f2843703          	ld	a4,-216(s0)
 1ae:	00070023          	sb	zero,0(a4)
 1b2:	8a3e                	mv	s4,a5
 1b4:	8abe                	mv	s5,a5
				ws = 1; // start a new word
 1b6:	4785                	li	a5,1
 1b8:	f2f43023          	sd	a5,-224(s0)
 1bc:	b77d                	j	16a <run_command+0x120>
			if (!file_name_l && redirection_left){ // if left redirection
 1be:	1e0a8163          	beqz	s5,3a0 <run_command+0x356>
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 1c2:	02000713          	li	a4,32
 1c6:	00f76a63          	bltu	a4,a5,1da <run_command+0x190>
 1ca:	00800737          	lui	a4,0x800
 1ce:	074d                	addi	a4,a4,19 # 800013 <base+0x7fdf9b>
 1d0:	0726                	slli	a4,a4,0x9
 1d2:	00f75733          	srl	a4,a4,a5
 1d6:	8b05                	andi	a4,a4,1
 1d8:	f751                	bnez	a4,164 <run_command+0x11a>
					fprintf(2, "file_name_l: %s\n", file_name_l);
 1da:	f2843603          	ld	a2,-216(s0)
 1de:	00001597          	auipc	a1,0x1
 1e2:	b0a58593          	addi	a1,a1,-1270 # ce8 <malloc+0x172>
 1e6:	4509                	li	a0,2
 1e8:	0b1000ef          	jal	a98 <fprintf>
					file_name_l = &buf[i]; // capture string
 1ec:	f2843783          	ld	a5,-216(s0)
 1f0:	f0f43823          	sd	a5,-240(s0)
 1f4:	bf85                	j	164 <run_command+0x11a>
			if (!file_name_r && redirection_right){
 1f6:	f60a0ae3          	beqz	s4,16a <run_command+0x120>
				if (buf[i] == ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 1fa:	f2843783          	ld	a5,-216(s0)
 1fe:	0007c703          	lbu	a4,0(a5)
 202:	02000793          	li	a5,32
 206:	00f70b63          	beq	a4,a5,21c <run_command+0x1d2>
 20a:	8a4e                	mv	s4,s3
 20c:	f0043c23          	sd	zero,-232(s0)
 210:	bfa9                	j	16a <run_command+0x120>
			if (!file_name_r && redirection_right){
 212:	f1843783          	ld	a5,-232(s0)
 216:	f0f43823          	sd	a5,-240(s0)
 21a:	b7c5                	j	1fa <run_command+0x1b0>
					fprintf(2, "file_name_r: %s\n", file_name_r);
 21c:	f2843a03          	ld	s4,-216(s0)
 220:	8652                	mv	a2,s4
 222:	00001597          	auipc	a1,0x1
 226:	ade58593          	addi	a1,a1,-1314 # d00 <malloc+0x18a>
 22a:	4509                	li	a0,2
 22c:	06d000ef          	jal	a98 <fprintf>
					file_name_r = &buf[i];
 230:	f1443c23          	sd	s4,-232(s0)
					fprintf(2, "file_name_r: %s\n", file_name_r);
 234:	8a4e                	mv	s4,s3
 236:	bf15                	j	16a <run_command+0x120>
 238:	8a4e                	mv	s4,s3
 23a:	8ace                	mv	s5,s3
 23c:	b73d                	j	16a <run_command+0x120>
 23e:	f2043a83          	ld	s5,-224(s0)
 242:	8a56                	mv	s4,s5
 244:	b71d                	j	16a <run_command+0x120>
 246:	4901                	li	s2,0
		}
	}

	// Dealing with redirection command < and >

	if (redirection_left){
 248:	060a9b63          	bnez	s5,2be <run_command+0x274>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
			fprintf(2, "Failed to open file: %s", file_name_l);
			exit(1); // quit
		}
	}
	if (redirection_right){
 24c:	0a0a1663          	bnez	s4,2f8 <run_command+0x2ae>
			exit(1); // quit
		}
	}

	// Handle cd special case
	if (numargs > 0 && strcmp(arguments[0], "cd") == 0){
 250:	f0843783          	ld	a5,-248(s0)
 254:	00f05c63          	blez	a5,26c <run_command+0x222>
 258:	00001597          	auipc	a1,0x1
 25c:	ad858593          	addi	a1,a1,-1320 # d30 <malloc+0x1ba>
 260:	f4043503          	ld	a0,-192(s0)
 264:	20a000ef          	jal	46e <strcmp>
 268:	0a050f63          	beqz	a0,326 <run_command+0x2dc>
		// Exit with 2 to let main know there is cd command
		exit(2);

	}else{ // We know it is not a cd command
		// Technique from source 2
		if (pipe_cmd){
 26c:	10090a63          	beqz	s2,380 <run_command+0x336>
			
			pipe(p); // New pipe
 270:	f3840513          	addi	a0,s0,-200
 274:	446000ef          	jal	6ba <pipe>
			
			if (fork() == 0){
 278:	42a000ef          	jal	6a2 <fork>
 27c:	0c051763          	bnez	a0,34a <run_command+0x300>
				close(1); // close stdout
 280:	4505                	li	a0,1
 282:	450000ef          	jal	6d2 <close>
				dup(p[1]); // Make "in" part of pipe to be stdout
 286:	f3c42503          	lw	a0,-196(s0)
 28a:	498000ef          	jal	722 <dup>
				
				close(p[0]);
 28e:	f3842503          	lw	a0,-200(s0)
 292:	440000ef          	jal	6d2 <close>
				close(p[1]);
 296:	f3c42503          	lw	a0,-196(s0)
 29a:	438000ef          	jal	6d2 <close>

				exec(arguments[0], arguments); // Execute command on the left
 29e:	f4040593          	addi	a1,s0,-192
 2a2:	f4043503          	ld	a0,-192(s0)
 2a6:	43c000ef          	jal	6e2 <exec>
				
				// If we reach this part that means something went wrong
				fprintf(2, "Execution of the command failed\n");
 2aa:	00001597          	auipc	a1,0x1
 2ae:	a8e58593          	addi	a1,a1,-1394 # d38 <malloc+0x1c2>
 2b2:	4509                	li	a0,2
 2b4:	7e4000ef          	jal	a98 <fprintf>
				exit(1);
 2b8:	4505                	li	a0,1
 2ba:	3f0000ef          	jal	6aa <exit>
		close(0); // close stdin
 2be:	4501                	li	a0,0
 2c0:	412000ef          	jal	6d2 <close>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
 2c4:	4581                	li	a1,0
 2c6:	f1043503          	ld	a0,-240(s0)
 2ca:	420000ef          	jal	6ea <open>
 2ce:	f6055fe3          	bgez	a0,24c <run_command+0x202>
			fprintf(2, "Failed to open file: %s", file_name_l);
 2d2:	f1043603          	ld	a2,-240(s0)
 2d6:	00001597          	auipc	a1,0x1
 2da:	a4258593          	addi	a1,a1,-1470 # d18 <malloc+0x1a2>
 2de:	4509                	li	a0,2
 2e0:	7b8000ef          	jal	a98 <fprintf>
			exit(1); // quit
 2e4:	4505                	li	a0,1
 2e6:	3c4000ef          	jal	6aa <exit>
	char* file_name_r = 0; // Buffer to store name of file on the right
 2ea:	f0043c23          	sd	zero,-232(s0)
	int redirection_right = 0; // >
 2ee:	4a01                	li	s4,0
	int numargs = 0; // number of arguments
 2f0:	f0043423          	sd	zero,-248(s0)
	for (int i = 0; i < nbuf; i++){
 2f4:	4901                	li	s2,0
 2f6:	bf99                	j	24c <run_command+0x202>
		close(1); // close stdout
 2f8:	4505                	li	a0,1
 2fa:	3d8000ef          	jal	6d2 <close>
		if (open(file_name_r, O_WRONLY|O_CREATE|O_TRUNC) < 0){ // open our file with fd of 1
 2fe:	60100593          	li	a1,1537
 302:	f1843503          	ld	a0,-232(s0)
 306:	3e4000ef          	jal	6ea <open>
 30a:	f40553e3          	bgez	a0,250 <run_command+0x206>
			fprintf(2, "Failed to open file: %s", file_name_r);
 30e:	f1843603          	ld	a2,-232(s0)
 312:	00001597          	auipc	a1,0x1
 316:	a0658593          	addi	a1,a1,-1530 # d18 <malloc+0x1a2>
 31a:	4509                	li	a0,2
 31c:	77c000ef          	jal	a98 <fprintf>
			exit(1); // quit
 320:	4505                	li	a0,1
 322:	388000ef          	jal	6aa <exit>
		write(pcp[1], arguments[1], strlen(arguments[1]));
 326:	f0043783          	ld	a5,-256(s0)
 32a:	0047a903          	lw	s2,4(a5)
 32e:	f4843483          	ld	s1,-184(s0)
 332:	8526                	mv	a0,s1
 334:	166000ef          	jal	49a <strlen>
 338:	0005061b          	sext.w	a2,a0
 33c:	85a6                	mv	a1,s1
 33e:	854a                	mv	a0,s2
 340:	38a000ef          	jal	6ca <write>
		exit(2);
 344:	4509                	li	a0,2
 346:	364000ef          	jal	6aa <exit>
			}
			if (fork() == 0){ // Handle right side recursively
 34a:	358000ef          	jal	6a2 <fork>
 34e:	e531                	bnez	a0,39a <run_command+0x350>
				close(0); // close stdin
 350:	382000ef          	jal	6d2 <close>
				dup(p[0]); // Make "out" part of pipe to be stdin
 354:	f3842503          	lw	a0,-200(s0)
 358:	3ca000ef          	jal	722 <dup>

				close(p[1]);
 35c:	f3c42503          	lw	a0,-196(s0)
 360:	372000ef          	jal	6d2 <close>
				close(p[0]);
 364:	f3842503          	lw	a0,-200(s0)
 368:	36a000ef          	jal	6d2 <close>

				run_command(&buf[pipe_cmd], nbuf - pipe_cmd, pcp);
 36c:	f0043603          	ld	a2,-256(s0)
 370:	412b05bb          	subw	a1,s6,s2
 374:	ef843783          	ld	a5,-264(s0)
 378:	01278533          	add	a0,a5,s2
 37c:	ccfff0ef          	jal	4a <run_command>
			}
		}else{ // No pipes as well, just a plain command
			exec(arguments[0], arguments);
 380:	f4040593          	addi	a1,s0,-192
 384:	f4043503          	ld	a0,-192(s0)
 388:	35a000ef          	jal	6e2 <exec>

			// Something went wrong if this part is reached
			fprintf(2, "Execution of the command failed\n"); 
 38c:	00001597          	auipc	a1,0x1
 390:	9ac58593          	addi	a1,a1,-1620 # d38 <malloc+0x1c2>
 394:	4509                	li	a0,2
 396:	702000ef          	jal	a98 <fprintf>
		}
	}
	exit(0);
 39a:	4501                	li	a0,0
 39c:	30e000ef          	jal	6aa <exit>
			if (!file_name_r && redirection_right){
 3a0:	f1843783          	ld	a5,-232(s0)
 3a4:	e60787e3          	beqz	a5,212 <run_command+0x1c8>
 3a8:	8a4e                	mv	s4,s3
 3aa:	b3c1                	j	16a <run_command+0x120>

00000000000003ac <main>:


// Purpose: Repeatedly prompt user for input, forks process to run commands,
// and handle the chdir special case.

int main(void){
 3ac:	7135                	addi	sp,sp,-160
 3ae:	ed06                	sd	ra,152(sp)
 3b0:	e922                	sd	s0,144(sp)
 3b2:	e526                	sd	s1,136(sp)
 3b4:	e14a                	sd	s2,128(sp)
 3b6:	1100                	addi	s0,sp,160
	
	static char buf[100];
	
	// Setup a pipe
	int pcp[2];
	pipe(pcp);
 3b8:	fd840513          	addi	a0,s0,-40
 3bc:	2fe000ef          	jal	6ba <pipe>

	int fd;

	// Make sure file descriptors are open
	while((fd = open("console", O_RDWR)) >= 0){
 3c0:	00001497          	auipc	s1,0x1
 3c4:	9a048493          	addi	s1,s1,-1632 # d60 <malloc+0x1ea>
 3c8:	4589                	li	a1,2
 3ca:	8526                	mv	a0,s1
 3cc:	31e000ef          	jal	6ea <open>
 3d0:	00054763          	bltz	a0,3de <main+0x32>
		if(fd >= 3){
 3d4:	4789                	li	a5,2
 3d6:	fea7d9e3          	bge	a5,a0,3c8 <main+0x1c>
			close(fd); // close 0, 1 and 2 and it will reopen itself
 3da:	2f8000ef          	jal	6d2 <close>
			break;
		}
	}
	
	// Main Loop
	while(getcmd(buf, sizeof(buf)) >= 0){
 3de:	00002497          	auipc	s1,0x2
 3e2:	c3248493          	addi	s1,s1,-974 # 2010 <buf.0>
		
		int child_status;

		wait(&child_status);

		if (child_status == 2){ // CD command is detected, must execute in parent
 3e6:	4909                	li	s2,2
	while(getcmd(buf, sizeof(buf)) >= 0){
 3e8:	06400593          	li	a1,100
 3ec:	8526                	mv	a0,s1
 3ee:	c13ff0ef          	jal	0 <getcmd>
 3f2:	04054463          	bltz	a0,43a <main+0x8e>
		if (fork() == 0){
 3f6:	2ac000ef          	jal	6a2 <fork>
 3fa:	c515                	beqz	a0,426 <main+0x7a>
		wait(&child_status);
 3fc:	f6c40513          	addi	a0,s0,-148
 400:	2b2000ef          	jal	6b2 <wait>
		if (child_status == 2){ // CD command is detected, must execute in parent
 404:	f6c42783          	lw	a5,-148(s0)
 408:	ff2790e3          	bne	a5,s2,3e8 <main+0x3c>
			char buffer_cd_arg[100];
			// Read from pipe the pathname to cd
			read(pcp[0], buffer_cd_arg, sizeof(buffer_cd_arg));
 40c:	06400613          	li	a2,100
 410:	f7040593          	addi	a1,s0,-144
 414:	fd842503          	lw	a0,-40(s0)
 418:	2aa000ef          	jal	6c2 <read>
			chdir(buffer_cd_arg); // use chdir system call	
 41c:	f7040513          	addi	a0,s0,-144
 420:	2fa000ef          	jal	71a <chdir>
 424:	b7d1                	j	3e8 <main+0x3c>
			run_command(buf, 100, pcp);
 426:	fd840613          	addi	a2,s0,-40
 42a:	06400593          	li	a1,100
 42e:	00002517          	auipc	a0,0x2
 432:	be250513          	addi	a0,a0,-1054 # 2010 <buf.0>
 436:	c15ff0ef          	jal	4a <run_command>
		}
	}
	exit(0);
 43a:	4501                	li	a0,0
 43c:	26e000ef          	jal	6aa <exit>

0000000000000440 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 440:	1141                	addi	sp,sp,-16
 442:	e406                	sd	ra,8(sp)
 444:	e022                	sd	s0,0(sp)
 446:	0800                	addi	s0,sp,16
  extern int main();
  main();
 448:	f65ff0ef          	jal	3ac <main>
  exit(0);
 44c:	4501                	li	a0,0
 44e:	25c000ef          	jal	6aa <exit>

0000000000000452 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 452:	1141                	addi	sp,sp,-16
 454:	e422                	sd	s0,8(sp)
 456:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 458:	87aa                	mv	a5,a0
 45a:	0585                	addi	a1,a1,1
 45c:	0785                	addi	a5,a5,1
 45e:	fff5c703          	lbu	a4,-1(a1)
 462:	fee78fa3          	sb	a4,-1(a5)
 466:	fb75                	bnez	a4,45a <strcpy+0x8>
    ;
  return os;
}
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret

000000000000046e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 46e:	1141                	addi	sp,sp,-16
 470:	e422                	sd	s0,8(sp)
 472:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 474:	00054783          	lbu	a5,0(a0)
 478:	cb91                	beqz	a5,48c <strcmp+0x1e>
 47a:	0005c703          	lbu	a4,0(a1)
 47e:	00f71763          	bne	a4,a5,48c <strcmp+0x1e>
    p++, q++;
 482:	0505                	addi	a0,a0,1
 484:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 486:	00054783          	lbu	a5,0(a0)
 48a:	fbe5                	bnez	a5,47a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 48c:	0005c503          	lbu	a0,0(a1)
}
 490:	40a7853b          	subw	a0,a5,a0
 494:	6422                	ld	s0,8(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret

000000000000049a <strlen>:

uint
strlen(const char *s)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e422                	sd	s0,8(sp)
 49e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4a0:	00054783          	lbu	a5,0(a0)
 4a4:	cf91                	beqz	a5,4c0 <strlen+0x26>
 4a6:	0505                	addi	a0,a0,1
 4a8:	87aa                	mv	a5,a0
 4aa:	86be                	mv	a3,a5
 4ac:	0785                	addi	a5,a5,1
 4ae:	fff7c703          	lbu	a4,-1(a5)
 4b2:	ff65                	bnez	a4,4aa <strlen+0x10>
 4b4:	40a6853b          	subw	a0,a3,a0
 4b8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4ba:	6422                	ld	s0,8(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
  for(n = 0; s[n]; n++)
 4c0:	4501                	li	a0,0
 4c2:	bfe5                	j	4ba <strlen+0x20>

00000000000004c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4ca:	ca19                	beqz	a2,4e0 <memset+0x1c>
 4cc:	87aa                	mv	a5,a0
 4ce:	1602                	slli	a2,a2,0x20
 4d0:	9201                	srli	a2,a2,0x20
 4d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4da:	0785                	addi	a5,a5,1
 4dc:	fee79de3          	bne	a5,a4,4d6 <memset+0x12>
  }
  return dst;
}
 4e0:	6422                	ld	s0,8(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <strchr>:

char*
strchr(const char *s, char c)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e422                	sd	s0,8(sp)
 4ea:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4ec:	00054783          	lbu	a5,0(a0)
 4f0:	cb99                	beqz	a5,506 <strchr+0x20>
    if(*s == c)
 4f2:	00f58763          	beq	a1,a5,500 <strchr+0x1a>
  for(; *s; s++)
 4f6:	0505                	addi	a0,a0,1
 4f8:	00054783          	lbu	a5,0(a0)
 4fc:	fbfd                	bnez	a5,4f2 <strchr+0xc>
      return (char*)s;
  return 0;
 4fe:	4501                	li	a0,0
}
 500:	6422                	ld	s0,8(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret
  return 0;
 506:	4501                	li	a0,0
 508:	bfe5                	j	500 <strchr+0x1a>

000000000000050a <gets>:

char*
gets(char *buf, int max)
{
 50a:	711d                	addi	sp,sp,-96
 50c:	ec86                	sd	ra,88(sp)
 50e:	e8a2                	sd	s0,80(sp)
 510:	e4a6                	sd	s1,72(sp)
 512:	e0ca                	sd	s2,64(sp)
 514:	fc4e                	sd	s3,56(sp)
 516:	f852                	sd	s4,48(sp)
 518:	f456                	sd	s5,40(sp)
 51a:	f05a                	sd	s6,32(sp)
 51c:	ec5e                	sd	s7,24(sp)
 51e:	1080                	addi	s0,sp,96
 520:	8baa                	mv	s7,a0
 522:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 524:	892a                	mv	s2,a0
 526:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 528:	4aa9                	li	s5,10
 52a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 52c:	89a6                	mv	s3,s1
 52e:	2485                	addiw	s1,s1,1
 530:	0344d663          	bge	s1,s4,55c <gets+0x52>
    cc = read(0, &c, 1);
 534:	4605                	li	a2,1
 536:	faf40593          	addi	a1,s0,-81
 53a:	4501                	li	a0,0
 53c:	186000ef          	jal	6c2 <read>
    if(cc < 1)
 540:	00a05e63          	blez	a0,55c <gets+0x52>
    buf[i++] = c;
 544:	faf44783          	lbu	a5,-81(s0)
 548:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 54c:	01578763          	beq	a5,s5,55a <gets+0x50>
 550:	0905                	addi	s2,s2,1
 552:	fd679de3          	bne	a5,s6,52c <gets+0x22>
    buf[i++] = c;
 556:	89a6                	mv	s3,s1
 558:	a011                	j	55c <gets+0x52>
 55a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 55c:	99de                	add	s3,s3,s7
 55e:	00098023          	sb	zero,0(s3)
  return buf;
}
 562:	855e                	mv	a0,s7
 564:	60e6                	ld	ra,88(sp)
 566:	6446                	ld	s0,80(sp)
 568:	64a6                	ld	s1,72(sp)
 56a:	6906                	ld	s2,64(sp)
 56c:	79e2                	ld	s3,56(sp)
 56e:	7a42                	ld	s4,48(sp)
 570:	7aa2                	ld	s5,40(sp)
 572:	7b02                	ld	s6,32(sp)
 574:	6be2                	ld	s7,24(sp)
 576:	6125                	addi	sp,sp,96
 578:	8082                	ret

000000000000057a <stat>:

int
stat(const char *n, struct stat *st)
{
 57a:	1101                	addi	sp,sp,-32
 57c:	ec06                	sd	ra,24(sp)
 57e:	e822                	sd	s0,16(sp)
 580:	e04a                	sd	s2,0(sp)
 582:	1000                	addi	s0,sp,32
 584:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 586:	4581                	li	a1,0
 588:	162000ef          	jal	6ea <open>
  if(fd < 0)
 58c:	02054263          	bltz	a0,5b0 <stat+0x36>
 590:	e426                	sd	s1,8(sp)
 592:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 594:	85ca                	mv	a1,s2
 596:	16c000ef          	jal	702 <fstat>
 59a:	892a                	mv	s2,a0
  close(fd);
 59c:	8526                	mv	a0,s1
 59e:	134000ef          	jal	6d2 <close>
  return r;
 5a2:	64a2                	ld	s1,8(sp)
}
 5a4:	854a                	mv	a0,s2
 5a6:	60e2                	ld	ra,24(sp)
 5a8:	6442                	ld	s0,16(sp)
 5aa:	6902                	ld	s2,0(sp)
 5ac:	6105                	addi	sp,sp,32
 5ae:	8082                	ret
    return -1;
 5b0:	597d                	li	s2,-1
 5b2:	bfcd                	j	5a4 <stat+0x2a>

00000000000005b4 <atoi>:

int
atoi(const char *s)
{
 5b4:	1141                	addi	sp,sp,-16
 5b6:	e422                	sd	s0,8(sp)
 5b8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5ba:	00054683          	lbu	a3,0(a0)
 5be:	fd06879b          	addiw	a5,a3,-48
 5c2:	0ff7f793          	zext.b	a5,a5
 5c6:	4625                	li	a2,9
 5c8:	02f66863          	bltu	a2,a5,5f8 <atoi+0x44>
 5cc:	872a                	mv	a4,a0
  n = 0;
 5ce:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5d0:	0705                	addi	a4,a4,1
 5d2:	0025179b          	slliw	a5,a0,0x2
 5d6:	9fa9                	addw	a5,a5,a0
 5d8:	0017979b          	slliw	a5,a5,0x1
 5dc:	9fb5                	addw	a5,a5,a3
 5de:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5e2:	00074683          	lbu	a3,0(a4)
 5e6:	fd06879b          	addiw	a5,a3,-48
 5ea:	0ff7f793          	zext.b	a5,a5
 5ee:	fef671e3          	bgeu	a2,a5,5d0 <atoi+0x1c>
  return n;
}
 5f2:	6422                	ld	s0,8(sp)
 5f4:	0141                	addi	sp,sp,16
 5f6:	8082                	ret
  n = 0;
 5f8:	4501                	li	a0,0
 5fa:	bfe5                	j	5f2 <atoi+0x3e>

00000000000005fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5fc:	1141                	addi	sp,sp,-16
 5fe:	e422                	sd	s0,8(sp)
 600:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 602:	02b57463          	bgeu	a0,a1,62a <memmove+0x2e>
    while(n-- > 0)
 606:	00c05f63          	blez	a2,624 <memmove+0x28>
 60a:	1602                	slli	a2,a2,0x20
 60c:	9201                	srli	a2,a2,0x20
 60e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 612:	872a                	mv	a4,a0
      *dst++ = *src++;
 614:	0585                	addi	a1,a1,1
 616:	0705                	addi	a4,a4,1
 618:	fff5c683          	lbu	a3,-1(a1)
 61c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 620:	fef71ae3          	bne	a4,a5,614 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 624:	6422                	ld	s0,8(sp)
 626:	0141                	addi	sp,sp,16
 628:	8082                	ret
    dst += n;
 62a:	00c50733          	add	a4,a0,a2
    src += n;
 62e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 630:	fec05ae3          	blez	a2,624 <memmove+0x28>
 634:	fff6079b          	addiw	a5,a2,-1
 638:	1782                	slli	a5,a5,0x20
 63a:	9381                	srli	a5,a5,0x20
 63c:	fff7c793          	not	a5,a5
 640:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 642:	15fd                	addi	a1,a1,-1
 644:	177d                	addi	a4,a4,-1
 646:	0005c683          	lbu	a3,0(a1)
 64a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 64e:	fee79ae3          	bne	a5,a4,642 <memmove+0x46>
 652:	bfc9                	j	624 <memmove+0x28>

0000000000000654 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 654:	1141                	addi	sp,sp,-16
 656:	e422                	sd	s0,8(sp)
 658:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 65a:	ca05                	beqz	a2,68a <memcmp+0x36>
 65c:	fff6069b          	addiw	a3,a2,-1
 660:	1682                	slli	a3,a3,0x20
 662:	9281                	srli	a3,a3,0x20
 664:	0685                	addi	a3,a3,1
 666:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 668:	00054783          	lbu	a5,0(a0)
 66c:	0005c703          	lbu	a4,0(a1)
 670:	00e79863          	bne	a5,a4,680 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 674:	0505                	addi	a0,a0,1
    p2++;
 676:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 678:	fed518e3          	bne	a0,a3,668 <memcmp+0x14>
  }
  return 0;
 67c:	4501                	li	a0,0
 67e:	a019                	j	684 <memcmp+0x30>
      return *p1 - *p2;
 680:	40e7853b          	subw	a0,a5,a4
}
 684:	6422                	ld	s0,8(sp)
 686:	0141                	addi	sp,sp,16
 688:	8082                	ret
  return 0;
 68a:	4501                	li	a0,0
 68c:	bfe5                	j	684 <memcmp+0x30>

000000000000068e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 68e:	1141                	addi	sp,sp,-16
 690:	e406                	sd	ra,8(sp)
 692:	e022                	sd	s0,0(sp)
 694:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 696:	f67ff0ef          	jal	5fc <memmove>
}
 69a:	60a2                	ld	ra,8(sp)
 69c:	6402                	ld	s0,0(sp)
 69e:	0141                	addi	sp,sp,16
 6a0:	8082                	ret

00000000000006a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6a2:	4885                	li	a7,1
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 6aa:	4889                	li	a7,2
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6b2:	488d                	li	a7,3
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6ba:	4891                	li	a7,4
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <read>:
.global read
read:
 li a7, SYS_read
 6c2:	4895                	li	a7,5
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <write>:
.global write
write:
 li a7, SYS_write
 6ca:	48c1                	li	a7,16
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <close>:
.global close
close:
 li a7, SYS_close
 6d2:	48d5                	li	a7,21
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <kill>:
.global kill
kill:
 li a7, SYS_kill
 6da:	4899                	li	a7,6
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6e2:	489d                	li	a7,7
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <open>:
.global open
open:
 li a7, SYS_open
 6ea:	48bd                	li	a7,15
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6f2:	48c5                	li	a7,17
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6fa:	48c9                	li	a7,18
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 702:	48a1                	li	a7,8
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <link>:
.global link
link:
 li a7, SYS_link
 70a:	48cd                	li	a7,19
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 712:	48d1                	li	a7,20
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 71a:	48a5                	li	a7,9
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <dup>:
.global dup
dup:
 li a7, SYS_dup
 722:	48a9                	li	a7,10
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 72a:	48ad                	li	a7,11
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 732:	48b1                	li	a7,12
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 73a:	48b5                	li	a7,13
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 742:	48b9                	li	a7,14
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 74a:	1101                	addi	sp,sp,-32
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 756:	4605                	li	a2,1
 758:	fef40593          	addi	a1,s0,-17
 75c:	f6fff0ef          	jal	6ca <write>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6105                	addi	sp,sp,32
 766:	8082                	ret

0000000000000768 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 768:	7139                	addi	sp,sp,-64
 76a:	fc06                	sd	ra,56(sp)
 76c:	f822                	sd	s0,48(sp)
 76e:	f426                	sd	s1,40(sp)
 770:	0080                	addi	s0,sp,64
 772:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 774:	c299                	beqz	a3,77a <printint+0x12>
 776:	0805c963          	bltz	a1,808 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 77a:	2581                	sext.w	a1,a1
  neg = 0;
 77c:	4881                	li	a7,0
 77e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 782:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 784:	2601                	sext.w	a2,a2
 786:	00000517          	auipc	a0,0x0
 78a:	5ea50513          	addi	a0,a0,1514 # d70 <digits>
 78e:	883a                	mv	a6,a4
 790:	2705                	addiw	a4,a4,1
 792:	02c5f7bb          	remuw	a5,a1,a2
 796:	1782                	slli	a5,a5,0x20
 798:	9381                	srli	a5,a5,0x20
 79a:	97aa                	add	a5,a5,a0
 79c:	0007c783          	lbu	a5,0(a5)
 7a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7a4:	0005879b          	sext.w	a5,a1
 7a8:	02c5d5bb          	divuw	a1,a1,a2
 7ac:	0685                	addi	a3,a3,1
 7ae:	fec7f0e3          	bgeu	a5,a2,78e <printint+0x26>
  if(neg)
 7b2:	00088c63          	beqz	a7,7ca <printint+0x62>
    buf[i++] = '-';
 7b6:	fd070793          	addi	a5,a4,-48
 7ba:	00878733          	add	a4,a5,s0
 7be:	02d00793          	li	a5,45
 7c2:	fef70823          	sb	a5,-16(a4)
 7c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7ca:	02e05a63          	blez	a4,7fe <printint+0x96>
 7ce:	f04a                	sd	s2,32(sp)
 7d0:	ec4e                	sd	s3,24(sp)
 7d2:	fc040793          	addi	a5,s0,-64
 7d6:	00e78933          	add	s2,a5,a4
 7da:	fff78993          	addi	s3,a5,-1
 7de:	99ba                	add	s3,s3,a4
 7e0:	377d                	addiw	a4,a4,-1
 7e2:	1702                	slli	a4,a4,0x20
 7e4:	9301                	srli	a4,a4,0x20
 7e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7ea:	fff94583          	lbu	a1,-1(s2)
 7ee:	8526                	mv	a0,s1
 7f0:	f5bff0ef          	jal	74a <putc>
  while(--i >= 0)
 7f4:	197d                	addi	s2,s2,-1
 7f6:	ff391ae3          	bne	s2,s3,7ea <printint+0x82>
 7fa:	7902                	ld	s2,32(sp)
 7fc:	69e2                	ld	s3,24(sp)
}
 7fe:	70e2                	ld	ra,56(sp)
 800:	7442                	ld	s0,48(sp)
 802:	74a2                	ld	s1,40(sp)
 804:	6121                	addi	sp,sp,64
 806:	8082                	ret
    x = -xx;
 808:	40b005bb          	negw	a1,a1
    neg = 1;
 80c:	4885                	li	a7,1
    x = -xx;
 80e:	bf85                	j	77e <printint+0x16>

0000000000000810 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 810:	711d                	addi	sp,sp,-96
 812:	ec86                	sd	ra,88(sp)
 814:	e8a2                	sd	s0,80(sp)
 816:	e0ca                	sd	s2,64(sp)
 818:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 81a:	0005c903          	lbu	s2,0(a1)
 81e:	26090863          	beqz	s2,a8e <vprintf+0x27e>
 822:	e4a6                	sd	s1,72(sp)
 824:	fc4e                	sd	s3,56(sp)
 826:	f852                	sd	s4,48(sp)
 828:	f456                	sd	s5,40(sp)
 82a:	f05a                	sd	s6,32(sp)
 82c:	ec5e                	sd	s7,24(sp)
 82e:	e862                	sd	s8,16(sp)
 830:	e466                	sd	s9,8(sp)
 832:	8b2a                	mv	s6,a0
 834:	8a2e                	mv	s4,a1
 836:	8bb2                	mv	s7,a2
  state = 0;
 838:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 83a:	4481                	li	s1,0
 83c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 83e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 842:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 846:	06c00c93          	li	s9,108
 84a:	a005                	j	86a <vprintf+0x5a>
        putc(fd, c0);
 84c:	85ca                	mv	a1,s2
 84e:	855a                	mv	a0,s6
 850:	efbff0ef          	jal	74a <putc>
 854:	a019                	j	85a <vprintf+0x4a>
    } else if(state == '%'){
 856:	03598263          	beq	s3,s5,87a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 85a:	2485                	addiw	s1,s1,1
 85c:	8726                	mv	a4,s1
 85e:	009a07b3          	add	a5,s4,s1
 862:	0007c903          	lbu	s2,0(a5)
 866:	20090c63          	beqz	s2,a7e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 86a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 86e:	fe0994e3          	bnez	s3,856 <vprintf+0x46>
      if(c0 == '%'){
 872:	fd579de3          	bne	a5,s5,84c <vprintf+0x3c>
        state = '%';
 876:	89be                	mv	s3,a5
 878:	b7cd                	j	85a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 87a:	00ea06b3          	add	a3,s4,a4
 87e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 882:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 884:	c681                	beqz	a3,88c <vprintf+0x7c>
 886:	9752                	add	a4,a4,s4
 888:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 88c:	03878f63          	beq	a5,s8,8ca <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 890:	05978963          	beq	a5,s9,8e2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 894:	07500713          	li	a4,117
 898:	0ee78363          	beq	a5,a4,97e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 89c:	07800713          	li	a4,120
 8a0:	12e78563          	beq	a5,a4,9ca <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 8a4:	07000713          	li	a4,112
 8a8:	14e78a63          	beq	a5,a4,9fc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 8ac:	07300713          	li	a4,115
 8b0:	18e78a63          	beq	a5,a4,a44 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 8b4:	02500713          	li	a4,37
 8b8:	04e79563          	bne	a5,a4,902 <vprintf+0xf2>
        putc(fd, '%');
 8bc:	02500593          	li	a1,37
 8c0:	855a                	mv	a0,s6
 8c2:	e89ff0ef          	jal	74a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	bf49                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 8ca:	008b8913          	addi	s2,s7,8
 8ce:	4685                	li	a3,1
 8d0:	4629                	li	a2,10
 8d2:	000ba583          	lw	a1,0(s7)
 8d6:	855a                	mv	a0,s6
 8d8:	e91ff0ef          	jal	768 <printint>
 8dc:	8bca                	mv	s7,s2
      state = 0;
 8de:	4981                	li	s3,0
 8e0:	bfad                	j	85a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 8e2:	06400793          	li	a5,100
 8e6:	02f68963          	beq	a3,a5,918 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8ea:	06c00793          	li	a5,108
 8ee:	04f68263          	beq	a3,a5,932 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 8f2:	07500793          	li	a5,117
 8f6:	0af68063          	beq	a3,a5,996 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 8fa:	07800793          	li	a5,120
 8fe:	0ef68263          	beq	a3,a5,9e2 <vprintf+0x1d2>
        putc(fd, '%');
 902:	02500593          	li	a1,37
 906:	855a                	mv	a0,s6
 908:	e43ff0ef          	jal	74a <putc>
        putc(fd, c0);
 90c:	85ca                	mv	a1,s2
 90e:	855a                	mv	a0,s6
 910:	e3bff0ef          	jal	74a <putc>
      state = 0;
 914:	4981                	li	s3,0
 916:	b791                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 918:	008b8913          	addi	s2,s7,8
 91c:	4685                	li	a3,1
 91e:	4629                	li	a2,10
 920:	000ba583          	lw	a1,0(s7)
 924:	855a                	mv	a0,s6
 926:	e43ff0ef          	jal	768 <printint>
        i += 1;
 92a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 92c:	8bca                	mv	s7,s2
      state = 0;
 92e:	4981                	li	s3,0
        i += 1;
 930:	b72d                	j	85a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 932:	06400793          	li	a5,100
 936:	02f60763          	beq	a2,a5,964 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 93a:	07500793          	li	a5,117
 93e:	06f60963          	beq	a2,a5,9b0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 942:	07800793          	li	a5,120
 946:	faf61ee3          	bne	a2,a5,902 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 94a:	008b8913          	addi	s2,s7,8
 94e:	4681                	li	a3,0
 950:	4641                	li	a2,16
 952:	000ba583          	lw	a1,0(s7)
 956:	855a                	mv	a0,s6
 958:	e11ff0ef          	jal	768 <printint>
        i += 2;
 95c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 95e:	8bca                	mv	s7,s2
      state = 0;
 960:	4981                	li	s3,0
        i += 2;
 962:	bde5                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 964:	008b8913          	addi	s2,s7,8
 968:	4685                	li	a3,1
 96a:	4629                	li	a2,10
 96c:	000ba583          	lw	a1,0(s7)
 970:	855a                	mv	a0,s6
 972:	df7ff0ef          	jal	768 <printint>
        i += 2;
 976:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 978:	8bca                	mv	s7,s2
      state = 0;
 97a:	4981                	li	s3,0
        i += 2;
 97c:	bdf9                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 97e:	008b8913          	addi	s2,s7,8
 982:	4681                	li	a3,0
 984:	4629                	li	a2,10
 986:	000ba583          	lw	a1,0(s7)
 98a:	855a                	mv	a0,s6
 98c:	dddff0ef          	jal	768 <printint>
 990:	8bca                	mv	s7,s2
      state = 0;
 992:	4981                	li	s3,0
 994:	b5d9                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 996:	008b8913          	addi	s2,s7,8
 99a:	4681                	li	a3,0
 99c:	4629                	li	a2,10
 99e:	000ba583          	lw	a1,0(s7)
 9a2:	855a                	mv	a0,s6
 9a4:	dc5ff0ef          	jal	768 <printint>
        i += 1;
 9a8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9aa:	8bca                	mv	s7,s2
      state = 0;
 9ac:	4981                	li	s3,0
        i += 1;
 9ae:	b575                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9b0:	008b8913          	addi	s2,s7,8
 9b4:	4681                	li	a3,0
 9b6:	4629                	li	a2,10
 9b8:	000ba583          	lw	a1,0(s7)
 9bc:	855a                	mv	a0,s6
 9be:	dabff0ef          	jal	768 <printint>
        i += 2;
 9c2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 9c4:	8bca                	mv	s7,s2
      state = 0;
 9c6:	4981                	li	s3,0
        i += 2;
 9c8:	bd49                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 9ca:	008b8913          	addi	s2,s7,8
 9ce:	4681                	li	a3,0
 9d0:	4641                	li	a2,16
 9d2:	000ba583          	lw	a1,0(s7)
 9d6:	855a                	mv	a0,s6
 9d8:	d91ff0ef          	jal	768 <printint>
 9dc:	8bca                	mv	s7,s2
      state = 0;
 9de:	4981                	li	s3,0
 9e0:	bdad                	j	85a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9e2:	008b8913          	addi	s2,s7,8
 9e6:	4681                	li	a3,0
 9e8:	4641                	li	a2,16
 9ea:	000ba583          	lw	a1,0(s7)
 9ee:	855a                	mv	a0,s6
 9f0:	d79ff0ef          	jal	768 <printint>
        i += 1;
 9f4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9f6:	8bca                	mv	s7,s2
      state = 0;
 9f8:	4981                	li	s3,0
        i += 1;
 9fa:	b585                	j	85a <vprintf+0x4a>
 9fc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9fe:	008b8d13          	addi	s10,s7,8
 a02:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a06:	03000593          	li	a1,48
 a0a:	855a                	mv	a0,s6
 a0c:	d3fff0ef          	jal	74a <putc>
  putc(fd, 'x');
 a10:	07800593          	li	a1,120
 a14:	855a                	mv	a0,s6
 a16:	d35ff0ef          	jal	74a <putc>
 a1a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a1c:	00000b97          	auipc	s7,0x0
 a20:	354b8b93          	addi	s7,s7,852 # d70 <digits>
 a24:	03c9d793          	srli	a5,s3,0x3c
 a28:	97de                	add	a5,a5,s7
 a2a:	0007c583          	lbu	a1,0(a5)
 a2e:	855a                	mv	a0,s6
 a30:	d1bff0ef          	jal	74a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a34:	0992                	slli	s3,s3,0x4
 a36:	397d                	addiw	s2,s2,-1
 a38:	fe0916e3          	bnez	s2,a24 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 a3c:	8bea                	mv	s7,s10
      state = 0;
 a3e:	4981                	li	s3,0
 a40:	6d02                	ld	s10,0(sp)
 a42:	bd21                	j	85a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 a44:	008b8993          	addi	s3,s7,8
 a48:	000bb903          	ld	s2,0(s7)
 a4c:	00090f63          	beqz	s2,a6a <vprintf+0x25a>
        for(; *s; s++)
 a50:	00094583          	lbu	a1,0(s2)
 a54:	c195                	beqz	a1,a78 <vprintf+0x268>
          putc(fd, *s);
 a56:	855a                	mv	a0,s6
 a58:	cf3ff0ef          	jal	74a <putc>
        for(; *s; s++)
 a5c:	0905                	addi	s2,s2,1
 a5e:	00094583          	lbu	a1,0(s2)
 a62:	f9f5                	bnez	a1,a56 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a64:	8bce                	mv	s7,s3
      state = 0;
 a66:	4981                	li	s3,0
 a68:	bbcd                	j	85a <vprintf+0x4a>
          s = "(null)";
 a6a:	00000917          	auipc	s2,0x0
 a6e:	2fe90913          	addi	s2,s2,766 # d68 <malloc+0x1f2>
        for(; *s; s++)
 a72:	02800593          	li	a1,40
 a76:	b7c5                	j	a56 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a78:	8bce                	mv	s7,s3
      state = 0;
 a7a:	4981                	li	s3,0
 a7c:	bbf9                	j	85a <vprintf+0x4a>
 a7e:	64a6                	ld	s1,72(sp)
 a80:	79e2                	ld	s3,56(sp)
 a82:	7a42                	ld	s4,48(sp)
 a84:	7aa2                	ld	s5,40(sp)
 a86:	7b02                	ld	s6,32(sp)
 a88:	6be2                	ld	s7,24(sp)
 a8a:	6c42                	ld	s8,16(sp)
 a8c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a8e:	60e6                	ld	ra,88(sp)
 a90:	6446                	ld	s0,80(sp)
 a92:	6906                	ld	s2,64(sp)
 a94:	6125                	addi	sp,sp,96
 a96:	8082                	ret

0000000000000a98 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a98:	715d                	addi	sp,sp,-80
 a9a:	ec06                	sd	ra,24(sp)
 a9c:	e822                	sd	s0,16(sp)
 a9e:	1000                	addi	s0,sp,32
 aa0:	e010                	sd	a2,0(s0)
 aa2:	e414                	sd	a3,8(s0)
 aa4:	e818                	sd	a4,16(s0)
 aa6:	ec1c                	sd	a5,24(s0)
 aa8:	03043023          	sd	a6,32(s0)
 aac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ab0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ab4:	8622                	mv	a2,s0
 ab6:	d5bff0ef          	jal	810 <vprintf>
}
 aba:	60e2                	ld	ra,24(sp)
 abc:	6442                	ld	s0,16(sp)
 abe:	6161                	addi	sp,sp,80
 ac0:	8082                	ret

0000000000000ac2 <printf>:

void
printf(const char *fmt, ...)
{
 ac2:	711d                	addi	sp,sp,-96
 ac4:	ec06                	sd	ra,24(sp)
 ac6:	e822                	sd	s0,16(sp)
 ac8:	1000                	addi	s0,sp,32
 aca:	e40c                	sd	a1,8(s0)
 acc:	e810                	sd	a2,16(s0)
 ace:	ec14                	sd	a3,24(s0)
 ad0:	f018                	sd	a4,32(s0)
 ad2:	f41c                	sd	a5,40(s0)
 ad4:	03043823          	sd	a6,48(s0)
 ad8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 adc:	00840613          	addi	a2,s0,8
 ae0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ae4:	85aa                	mv	a1,a0
 ae6:	4505                	li	a0,1
 ae8:	d29ff0ef          	jal	810 <vprintf>
}
 aec:	60e2                	ld	ra,24(sp)
 aee:	6442                	ld	s0,16(sp)
 af0:	6125                	addi	sp,sp,96
 af2:	8082                	ret

0000000000000af4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 af4:	1141                	addi	sp,sp,-16
 af6:	e422                	sd	s0,8(sp)
 af8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 afa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afe:	00001797          	auipc	a5,0x1
 b02:	5027b783          	ld	a5,1282(a5) # 2000 <freep>
 b06:	a02d                	j	b30 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b08:	4618                	lw	a4,8(a2)
 b0a:	9f2d                	addw	a4,a4,a1
 b0c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b10:	6398                	ld	a4,0(a5)
 b12:	6310                	ld	a2,0(a4)
 b14:	a83d                	j	b52 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b16:	ff852703          	lw	a4,-8(a0)
 b1a:	9f31                	addw	a4,a4,a2
 b1c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b1e:	ff053683          	ld	a3,-16(a0)
 b22:	a091                	j	b66 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b24:	6398                	ld	a4,0(a5)
 b26:	00e7e463          	bltu	a5,a4,b2e <free+0x3a>
 b2a:	00e6ea63          	bltu	a3,a4,b3e <free+0x4a>
{
 b2e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b30:	fed7fae3          	bgeu	a5,a3,b24 <free+0x30>
 b34:	6398                	ld	a4,0(a5)
 b36:	00e6e463          	bltu	a3,a4,b3e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b3a:	fee7eae3          	bltu	a5,a4,b2e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 b3e:	ff852583          	lw	a1,-8(a0)
 b42:	6390                	ld	a2,0(a5)
 b44:	02059813          	slli	a6,a1,0x20
 b48:	01c85713          	srli	a4,a6,0x1c
 b4c:	9736                	add	a4,a4,a3
 b4e:	fae60de3          	beq	a2,a4,b08 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b52:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b56:	4790                	lw	a2,8(a5)
 b58:	02061593          	slli	a1,a2,0x20
 b5c:	01c5d713          	srli	a4,a1,0x1c
 b60:	973e                	add	a4,a4,a5
 b62:	fae68ae3          	beq	a3,a4,b16 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b66:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b68:	00001717          	auipc	a4,0x1
 b6c:	48f73c23          	sd	a5,1176(a4) # 2000 <freep>
}
 b70:	6422                	ld	s0,8(sp)
 b72:	0141                	addi	sp,sp,16
 b74:	8082                	ret

0000000000000b76 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b76:	7139                	addi	sp,sp,-64
 b78:	fc06                	sd	ra,56(sp)
 b7a:	f822                	sd	s0,48(sp)
 b7c:	f426                	sd	s1,40(sp)
 b7e:	ec4e                	sd	s3,24(sp)
 b80:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b82:	02051493          	slli	s1,a0,0x20
 b86:	9081                	srli	s1,s1,0x20
 b88:	04bd                	addi	s1,s1,15
 b8a:	8091                	srli	s1,s1,0x4
 b8c:	0014899b          	addiw	s3,s1,1
 b90:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b92:	00001517          	auipc	a0,0x1
 b96:	46e53503          	ld	a0,1134(a0) # 2000 <freep>
 b9a:	c915                	beqz	a0,bce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b9e:	4798                	lw	a4,8(a5)
 ba0:	08977a63          	bgeu	a4,s1,c34 <malloc+0xbe>
 ba4:	f04a                	sd	s2,32(sp)
 ba6:	e852                	sd	s4,16(sp)
 ba8:	e456                	sd	s5,8(sp)
 baa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 bac:	8a4e                	mv	s4,s3
 bae:	0009871b          	sext.w	a4,s3
 bb2:	6685                	lui	a3,0x1
 bb4:	00d77363          	bgeu	a4,a3,bba <malloc+0x44>
 bb8:	6a05                	lui	s4,0x1
 bba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bbe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bc2:	00001917          	auipc	s2,0x1
 bc6:	43e90913          	addi	s2,s2,1086 # 2000 <freep>
  if(p == (char*)-1)
 bca:	5afd                	li	s5,-1
 bcc:	a081                	j	c0c <malloc+0x96>
 bce:	f04a                	sd	s2,32(sp)
 bd0:	e852                	sd	s4,16(sp)
 bd2:	e456                	sd	s5,8(sp)
 bd4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bd6:	00001797          	auipc	a5,0x1
 bda:	4a278793          	addi	a5,a5,1186 # 2078 <base>
 bde:	00001717          	auipc	a4,0x1
 be2:	42f73123          	sd	a5,1058(a4) # 2000 <freep>
 be6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 be8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 bec:	b7c1                	j	bac <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 bee:	6398                	ld	a4,0(a5)
 bf0:	e118                	sd	a4,0(a0)
 bf2:	a8a9                	j	c4c <malloc+0xd6>
  hp->s.size = nu;
 bf4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bf8:	0541                	addi	a0,a0,16
 bfa:	efbff0ef          	jal	af4 <free>
  return freep;
 bfe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c02:	c12d                	beqz	a0,c64 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c06:	4798                	lw	a4,8(a5)
 c08:	02977263          	bgeu	a4,s1,c2c <malloc+0xb6>
    if(p == freep)
 c0c:	00093703          	ld	a4,0(s2)
 c10:	853e                	mv	a0,a5
 c12:	fef719e3          	bne	a4,a5,c04 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c16:	8552                	mv	a0,s4
 c18:	b1bff0ef          	jal	732 <sbrk>
  if(p == (char*)-1)
 c1c:	fd551ce3          	bne	a0,s5,bf4 <malloc+0x7e>
        return 0;
 c20:	4501                	li	a0,0
 c22:	7902                	ld	s2,32(sp)
 c24:	6a42                	ld	s4,16(sp)
 c26:	6aa2                	ld	s5,8(sp)
 c28:	6b02                	ld	s6,0(sp)
 c2a:	a03d                	j	c58 <malloc+0xe2>
 c2c:	7902                	ld	s2,32(sp)
 c2e:	6a42                	ld	s4,16(sp)
 c30:	6aa2                	ld	s5,8(sp)
 c32:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c34:	fae48de3          	beq	s1,a4,bee <malloc+0x78>
        p->s.size -= nunits;
 c38:	4137073b          	subw	a4,a4,s3
 c3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c3e:	02071693          	slli	a3,a4,0x20
 c42:	01c6d713          	srli	a4,a3,0x1c
 c46:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c48:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c4c:	00001717          	auipc	a4,0x1
 c50:	3aa73a23          	sd	a0,948(a4) # 2000 <freep>
      return (void*)(p + 1);
 c54:	01078513          	addi	a0,a5,16
  }
}
 c58:	70e2                	ld	ra,56(sp)
 c5a:	7442                	ld	s0,48(sp)
 c5c:	74a2                	ld	s1,40(sp)
 c5e:	69e2                	ld	s3,24(sp)
 c60:	6121                	addi	sp,sp,64
 c62:	8082                	ret
 c64:	7902                	ld	s2,32(sp)
 c66:	6a42                	ld	s4,16(sp)
 c68:	6aa2                	ld	s5,8(sp)
 c6a:	6b02                	ld	s6,0(sp)
 c6c:	b7f5                	j	c58 <malloc+0xe2>
