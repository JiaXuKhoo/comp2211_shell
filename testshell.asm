
user/_testshell:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
// Source 2: xv6: a simple, Unix-like teaching operating system by Russ Cox, Frans Kaashoek and Robert Morris (31/08/2024)

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
  16:	cee58593          	addi	a1,a1,-786 # d00 <malloc+0xf8>
  1a:	4509                	li	a0,2
  1c:	740000ef          	jal	75c <write>
	memset(buf, 0, nbuf);
  20:	864a                	mv	a2,s2
  22:	4581                	li	a1,0
  24:	8526                	mv	a0,s1
  26:	530000ef          	jal	556 <memset>
	gets(buf, nbuf);
  2a:	85ca                	mv	a1,s2
  2c:	8526                	mv	a0,s1
  2e:	56e000ef          	jal	59c <gets>

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
  6c:	8bae                	mv	s7,a1
  6e:	f0c43023          	sd	a2,-256(s0)

	// Useful data structures and flags
	
	char* arguments[10] = {0}; // Initialize everything to NULL
  72:	f4043023          	sd	zero,-192(s0)
  76:	f4043423          	sd	zero,-184(s0)
  7a:	f4043823          	sd	zero,-176(s0)
  7e:	f4043c23          	sd	zero,-168(s0)
  82:	f6043023          	sd	zero,-160(s0)
  86:	f6043423          	sd	zero,-152(s0)
  8a:	f6043823          	sd	zero,-144(s0)
  8e:	f6043c23          	sd	zero,-136(s0)
  92:	f8043023          	sd	zero,-128(s0)
  96:	f8043423          	sd	zero,-120(s0)
	int pipe_cmd = 0; // stores the location where | operator occurs

	int sequence_cmd = 0; // stores the location where ; operator occurs

	// Parsing character by character
	for (int i = 0; i < nbuf; i++){
  9a:	2cb05463          	blez	a1,362 <run_command+0x318>
  9e:	84aa                	mv	s1,a0
  a0:	4901                	li	s2,0
	char* file_name_r = 0; // Buffer to store name of file on the right
  a2:	f2043023          	sd	zero,-224(s0)
	char* file_name_l = 0; // Buffer to store name of file on the left
  a6:	f0043c23          	sd	zero,-232(s0)
	int redirection_right = 0; // >
  aa:	4a81                	li	s5,0
	int redirection_left = 0; // <
  ac:	4b01                	li	s6,0
	int ws = 1; // word start flag
  ae:	4785                	li	a5,1
  b0:	f2f43423          	sd	a5,-216(s0)
	int numargs = 0; // number of arguments
  b4:	f0043423          	sd	zero,-248(s0)
		
		// Sets flag and null terminate for a valid string
		// Apparently \0 in integer is 0
		if (buf[i] == '<'){
  b8:	03c00c13          	li	s8,60
			redirection_left = 1;
			buf[i] = 0; // Null terminate a word
			continue;
		}
		if (buf[i] == '>'){
  bc:	03e00c93          	li	s9,62
			redirection_right = 1;
			buf[i] = 0;
			continue;
		}
		if (buf[i] == '|'){
  c0:	07c00d13          	li	s10,124
			pipe_cmd = i + 1; // 1 positon offset
			buf[i] = 0;
			break; // Handling recursively
		}
		if (buf[i] == ';'){
  c4:	03b00d93          	li	s11,59
  c8:	008007b7          	lui	a5,0x800
  cc:	07cd                	addi	a5,a5,19 # 800013 <base+0x7fdf9b>
  ce:	07a6                	slli	a5,a5,0x9
  d0:	f0f43823          	sd	a5,-240(s0)
  d4:	a801                	j	e4 <run_command+0x9a>
			buf[i] = 0; // Null terminate a word
  d6:	00048023          	sb	zero,0(s1)
			redirection_left = 1;
  da:	4b05                	li	s6,1
	for (int i = 0; i < nbuf; i++){
  dc:	2905                	addiw	s2,s2,1
  de:	0485                	addi	s1,s1,1
  e0:	2b2b8163          	beq	s7,s2,382 <run_command+0x338>
		if (buf[i] == '<'){
  e4:	8a26                	mv	s4,s1
  e6:	0004c783          	lbu	a5,0(s1)
  ea:	ff8786e3          	beq	a5,s8,d6 <run_command+0x8c>
		if (buf[i] == '>'){
  ee:	05978163          	beq	a5,s9,130 <run_command+0xe6>
		if (buf[i] == '|'){
  f2:	05a78363          	beq	a5,s10,138 <run_command+0xee>
		if (buf[i] == ';'){
  f6:	05b78e63          	beq	a5,s11,152 <run_command+0x108>
			break; // Handling recursively
		}
		
		// hello012304560
		// If redirection is not present
		if (!(redirection_left || redirection_right)){
  fa:	015b69b3          	or	s3,s6,s5
  fe:	2981                	sext.w	s3,s3
 100:	0c099063          	bnez	s3,1c0 <run_command+0x176>
			
			// Check for whitespaces, ' ', '\t' and '\n' AND CARRIAGE RETURN
			if ((buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\n' || buf[i] == 13)){
 104:	02000713          	li	a4,32
 108:	30f76263          	bltu	a4,a5,40c <run_command+0x3c2>
 10c:	f1043703          	ld	a4,-240(s0)
 110:	00f75733          	srl	a4,a4,a5
 114:	8b05                	andi	a4,a4,1
 116:	cf35                	beqz	a4,192 <run_command+0x148>
				if (ws) continue; // skip this iteration if it's a start of word is whitespace
 118:	f2843783          	ld	a5,-216(s0)
 11c:	12079a63          	bnez	a5,250 <run_command+0x206>

				buf[i] = 0; // null terminate
 120:	00048023          	sb	zero,0(s1)
 124:	8abe                	mv	s5,a5
 126:	8b3e                	mv	s6,a5
				}
				ws = 0; // reset flag

			}
			if (we){ // At the end of a word
				ws = 1; // start a new word
 128:	4785                	li	a5,1
 12a:	f2f43423          	sd	a5,-216(s0)
 12e:	b77d                	j	dc <run_command+0x92>
			buf[i] = 0;
 130:	00048023          	sb	zero,0(s1)
			redirection_right = 1;
 134:	4a85                	li	s5,1
			continue;
 136:	b75d                	j	dc <run_command+0x92>
			pipe_cmd = i + 1; // 1 positon offset
 138:	0019049b          	addiw	s1,s2,1
			buf[i] = 0;
 13c:	000a0023          	sb	zero,0(s4)
			}
		}
	}
	
	
	arguments[numargs] = 0; // NULL terminate for exec() to work
 140:	f0843783          	ld	a5,-248(s0)
 144:	078e                	slli	a5,a5,0x3
 146:	f9078793          	addi	a5,a5,-112
 14a:	97a2                	add	a5,a5,s0
 14c:	fa07b823          	sd	zero,-80(a5)

	// Dealing with sequence command ;
	if (sequence_cmd){
 150:	a491                	j	394 <run_command+0x34a>
			sequence_cmd = i + 1; // 1 position offset
 152:	2905                	addiw	s2,s2,1
 154:	0009049b          	sext.w	s1,s2
			buf[i] = 0;
 158:	000a0023          	sb	zero,0(s4)
	arguments[numargs] = 0; // NULL terminate for exec() to work
 15c:	f0843783          	ld	a5,-248(s0)
 160:	078e                	slli	a5,a5,0x3
 162:	f9078793          	addi	a5,a5,-112
 166:	97a2                	add	a5,a5,s0
 168:	fa07b823          	sd	zero,-80(a5)
	if (sequence_cmd){
 16c:	22048463          	beqz	s1,394 <run_command+0x34a>

		// Parent Process
		if (fork() != 0){
 170:	5c4000ef          	jal	734 <fork>
 174:	89aa                	mv	s3,a0
 176:	c565                	beqz	a0,25e <run_command+0x214>
			wait(0);
 178:	4501                	li	a0,0
 17a:	5ca000ef          	jal	744 <wait>
			
			// Recursively call run_command to handle everything after ;
			run_command(&buf[sequence_cmd], nbuf - sequence_cmd, pcp);
 17e:	f0043603          	ld	a2,-256(s0)
 182:	412b85bb          	subw	a1,s7,s2
 186:	ef843783          	ld	a5,-264(s0)
 18a:	00978533          	add	a0,a5,s1
 18e:	ebdff0ef          	jal	4a <run_command>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 192:	f2843703          	ld	a4,-216(s0)
 196:	c361                	beqz	a4,256 <run_command+0x20c>
				if (strcmp(&buf[i], "") != 0){
 198:	e791                	bnez	a5,1a4 <run_command+0x15a>
					file_name_r[strlen(file_name_r) - 1] = 0; // Remove trailing newline
 19a:	8ace                	mv	s5,s3
 19c:	8b4e                	mv	s6,s3
 19e:	f3343423          	sd	s3,-216(s0)
 1a2:	bf2d                	j	dc <run_command+0x92>
					arguments[numargs++] = &buf[i]; // Save word string to arguments
 1a4:	f0843703          	ld	a4,-248(s0)
 1a8:	00371793          	slli	a5,a4,0x3
 1ac:	f9078793          	addi	a5,a5,-112
 1b0:	97a2                	add	a5,a5,s0
 1b2:	fb47b823          	sd	s4,-80(a5)
 1b6:	0017079b          	addiw	a5,a4,1
 1ba:	f0f43423          	sd	a5,-248(s0)
 1be:	bff1                	j	19a <run_command+0x150>
			if (!file_name_l && redirection_left){ // if left redirection
 1c0:	f1843703          	ld	a4,-232(s0)
 1c4:	cb05                	beqz	a4,1f4 <run_command+0x1aa>
			if (!file_name_r && redirection_right){
 1c6:	f2043783          	ld	a5,-224(s0)
 1ca:	fb89                	bnez	a5,dc <run_command+0x92>
 1cc:	f00a88e3          	beqz	s5,dc <run_command+0x92>
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 1d0:	000a4703          	lbu	a4,0(s4)
 1d4:	02000793          	li	a5,32
 1d8:	04e7ee63          	bltu	a5,a4,234 <run_command+0x1ea>
 1dc:	008007b7          	lui	a5,0x800
 1e0:	07cd                	addi	a5,a5,19 # 800013 <base+0x7fdf9b>
 1e2:	07a6                	slli	a5,a5,0x9
 1e4:	00e7d7b3          	srl	a5,a5,a4
 1e8:	8b85                	andi	a5,a5,1
 1ea:	c7a9                	beqz	a5,234 <run_command+0x1ea>
 1ec:	8ace                	mv	s5,s3
 1ee:	f2043023          	sd	zero,-224(s0)
 1f2:	b5ed                	j	dc <run_command+0x92>
			if (!file_name_l && redirection_left){ // if left redirection
 1f4:	180b0163          	beqz	s6,376 <run_command+0x32c>
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 1f8:	02000713          	li	a4,32
 1fc:	00f76a63          	bltu	a4,a5,210 <run_command+0x1c6>
 200:	00800737          	lui	a4,0x800
 204:	074d                	addi	a4,a4,19 # 800013 <base+0x7fdf9b>
 206:	0726                	slli	a4,a4,0x9
 208:	00f75733          	srl	a4,a4,a5
 20c:	8b05                	andi	a4,a4,1
 20e:	ff45                	bnez	a4,1c6 <run_command+0x17c>
					file_name_l[strlen(file_name_l) - 1] = 0; // Remove trailing newline
 210:	8552                	mv	a0,s4
 212:	31a000ef          	jal	52c <strlen>
 216:	fff5079b          	addiw	a5,a0,-1
 21a:	1782                	slli	a5,a5,0x20
 21c:	9381                	srli	a5,a5,0x20
 21e:	97d2                	add	a5,a5,s4
 220:	00078023          	sb	zero,0(a5)
					file_name_l = &buf[i]; // capture string
 224:	f1443c23          	sd	s4,-232(s0)
 228:	bf79                	j	1c6 <run_command+0x17c>
			if (!file_name_r && redirection_right){
 22a:	f2043783          	ld	a5,-224(s0)
 22e:	f0f43c23          	sd	a5,-232(s0)
 232:	bf79                	j	1d0 <run_command+0x186>
					file_name_r[strlen(file_name_r) - 1] = 0; // Remove trailing newline
 234:	8552                	mv	a0,s4
 236:	2f6000ef          	jal	52c <strlen>
 23a:	fff5079b          	addiw	a5,a0,-1
 23e:	1782                	slli	a5,a5,0x20
 240:	9381                	srli	a5,a5,0x20
 242:	97d2                	add	a5,a5,s4
 244:	00078023          	sb	zero,0(a5)
					file_name_r = &buf[i];
 248:	f3443023          	sd	s4,-224(s0)
					file_name_r[strlen(file_name_r) - 1] = 0; // Remove trailing newline
 24c:	8ace                	mv	s5,s3
 24e:	b579                	j	dc <run_command+0x92>
 250:	8ace                	mv	s5,s3
 252:	8b4e                	mv	s6,s3
 254:	b561                	j	dc <run_command+0x92>
 256:	f2843b03          	ld	s6,-216(s0)
 25a:	8ada                	mv	s5,s6
 25c:	b541                	j	dc <run_command+0x92>
			exit(0); // Exits even if run_command is not working
		}
		wait(0);
 25e:	4501                	li	a0,0
 260:	4e4000ef          	jal	744 <wait>
 264:	84ce                	mv	s1,s3
 266:	a23d                	j	394 <run_command+0x34a>
	}

	// Dealing with redirection command < and >

	if (redirection_left){
		close(0); // close stdin
 268:	4501                	li	a0,0
 26a:	4fa000ef          	jal	764 <close>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
 26e:	4581                	li	a1,0
 270:	f1843503          	ld	a0,-232(s0)
 274:	508000ef          	jal	77c <open>
 278:	12055063          	bgez	a0,398 <run_command+0x34e>
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_l);
 27c:	f1843603          	ld	a2,-232(s0)
 280:	00001597          	auipc	a1,0x1
 284:	a9058593          	addi	a1,a1,-1392 # d10 <malloc+0x108>
 288:	4509                	li	a0,2
 28a:	0a1000ef          	jal	b2a <fprintf>
			exit(1); // quit
 28e:	4505                	li	a0,1
 290:	4ac000ef          	jal	73c <exit>
		}
	}
	if (redirection_right){
		close(1); // close stdout
 294:	4505                	li	a0,1
 296:	4ce000ef          	jal	764 <close>
		if (open(file_name_r, O_WRONLY|O_CREATE|O_TRUNC) < 0){ // open our file with fd of 1
 29a:	60100593          	li	a1,1537
 29e:	f2043503          	ld	a0,-224(s0)
 2a2:	4da000ef          	jal	77c <open>
 2a6:	0e055b63          	bgez	a0,39c <run_command+0x352>
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_r);
 2aa:	f2043603          	ld	a2,-224(s0)
 2ae:	00001597          	auipc	a1,0x1
 2b2:	a6258593          	addi	a1,a1,-1438 # d10 <malloc+0x108>
 2b6:	4509                	li	a0,2
 2b8:	073000ef          	jal	b2a <fprintf>
			exit(1); // quit
 2bc:	4505                	li	a0,1
 2be:	47e000ef          	jal	73c <exit>
	}

	// Handle cd special case
	if (numargs > 0 && strcmp(arguments[0], "cd") == 0){
		// Write argument to pcp pipeline
		write(pcp[1], arguments[1], strlen(arguments[1]));
 2c2:	f0043783          	ld	a5,-256(s0)
 2c6:	0047a903          	lw	s2,4(a5)
 2ca:	f4843483          	ld	s1,-184(s0)
 2ce:	8526                	mv	a0,s1
 2d0:	25c000ef          	jal	52c <strlen>
 2d4:	0005061b          	sext.w	a2,a0
 2d8:	85a6                	mv	a1,s1
 2da:	854a                	mv	a0,s2
 2dc:	480000ef          	jal	75c <write>

		// Exit with 2 to let main know there is cd command
		exit(2);
 2e0:	4509                	li	a0,2
 2e2:	45a000ef          	jal	73c <exit>
				// If we reach this part that means something went wrong
				fprintf(2, "Execution of the command failed: %s\n", arguments[0]);

				exit(1);
			}
			if (fork() == 0){ // Handle right side recursively
 2e6:	44e000ef          	jal	734 <fork>
 2ea:	e90d                	bnez	a0,31c <run_command+0x2d2>
				close(0); // close stdin
 2ec:	478000ef          	jal	764 <close>
				dup(p[0]); // Make "out" part of pipe to be stdin
 2f0:	f3842503          	lw	a0,-200(s0)
 2f4:	4c0000ef          	jal	7b4 <dup>

				close(p[1]);
 2f8:	f3c42503          	lw	a0,-196(s0)
 2fc:	468000ef          	jal	764 <close>
				close(p[0]);
 300:	f3842503          	lw	a0,-200(s0)
 304:	460000ef          	jal	764 <close>

				run_command(&buf[pipe_cmd], nbuf - pipe_cmd, pcp);
 308:	f0043603          	ld	a2,-256(s0)
 30c:	409b85bb          	subw	a1,s7,s1
 310:	ef843783          	ld	a5,-264(s0)
 314:	00978533          	add	a0,a5,s1
 318:	d33ff0ef          	jal	4a <run_command>
				exit(0);
			}
			
			close(p[0]);
 31c:	f3842503          	lw	a0,-200(s0)
 320:	444000ef          	jal	764 <close>
			close(p[1]);
 324:	f3c42503          	lw	a0,-196(s0)
 328:	43c000ef          	jal	764 <close>
			wait(0);
 32c:	4501                	li	a0,0
 32e:	416000ef          	jal	744 <wait>
			wait(0);
 332:	4501                	li	a0,0
 334:	410000ef          	jal	744 <wait>
			// Something went wrong if this part is reached
			fprintf(2, "Execution of the command failed: %s\n", arguments[0]);
			exit(1);	
		}
	}
	exit(0);
 338:	4501                	li	a0,0
 33a:	402000ef          	jal	73c <exit>
			exec(arguments[0], arguments);
 33e:	f4040593          	addi	a1,s0,-192
 342:	f4043503          	ld	a0,-192(s0)
 346:	42e000ef          	jal	774 <exec>
			fprintf(2, "Execution of the command failed: %s\n", arguments[0]);
 34a:	f4043603          	ld	a2,-192(s0)
 34e:	00001597          	auipc	a1,0x1
 352:	9f258593          	addi	a1,a1,-1550 # d40 <malloc+0x138>
 356:	4509                	li	a0,2
 358:	7d2000ef          	jal	b2a <fprintf>
			exit(1);	
 35c:	4505                	li	a0,1
 35e:	3de000ef          	jal	73c <exit>
	char* file_name_r = 0; // Buffer to store name of file on the right
 362:	f2043023          	sd	zero,-224(s0)
	char* file_name_l = 0; // Buffer to store name of file on the left
 366:	f0043c23          	sd	zero,-232(s0)
	int redirection_right = 0; // >
 36a:	4a81                	li	s5,0
	int redirection_left = 0; // <
 36c:	4b01                	li	s6,0
	int numargs = 0; // number of arguments
 36e:	f0043423          	sd	zero,-248(s0)
	int pipe_cmd = 0; // stores the location where | operator occurs
 372:	4481                	li	s1,0
 374:	b3f1                	j	140 <run_command+0xf6>
			if (!file_name_r && redirection_right){
 376:	f2043783          	ld	a5,-224(s0)
 37a:	ea0788e3          	beqz	a5,22a <run_command+0x1e0>
 37e:	8ace                	mv	s5,s3
 380:	bbb1                	j	dc <run_command+0x92>
	arguments[numargs] = 0; // NULL terminate for exec() to work
 382:	f0843783          	ld	a5,-248(s0)
 386:	078e                	slli	a5,a5,0x3
 388:	f9078793          	addi	a5,a5,-112
 38c:	97a2                	add	a5,a5,s0
 38e:	fa07b823          	sd	zero,-80(a5)
 392:	4481                	li	s1,0
	if (redirection_left){
 394:	ec0b1ae3          	bnez	s6,268 <run_command+0x21e>
	if (redirection_right){
 398:	ee0a9ee3          	bnez	s5,294 <run_command+0x24a>
	if (numargs > 0 && strcmp(arguments[0], "cd") == 0){
 39c:	f0843783          	ld	a5,-248(s0)
 3a0:	00f05c63          	blez	a5,3b8 <run_command+0x36e>
 3a4:	00001597          	auipc	a1,0x1
 3a8:	99458593          	addi	a1,a1,-1644 # d38 <malloc+0x130>
 3ac:	f4043503          	ld	a0,-192(s0)
 3b0:	150000ef          	jal	500 <strcmp>
 3b4:	f00507e3          	beqz	a0,2c2 <run_command+0x278>
		if (pipe_cmd){
 3b8:	d0d9                	beqz	s1,33e <run_command+0x2f4>
			pipe(p); // New pipe
 3ba:	f3840513          	addi	a0,s0,-200
 3be:	38e000ef          	jal	74c <pipe>
			if (fork() == 0){
 3c2:	372000ef          	jal	734 <fork>
 3c6:	f20510e3          	bnez	a0,2e6 <run_command+0x29c>
				close(1); // close stdout
 3ca:	4505                	li	a0,1
 3cc:	398000ef          	jal	764 <close>
				dup(p[1]); // Make "in" part of pipe to be stdout
 3d0:	f3c42503          	lw	a0,-196(s0)
 3d4:	3e0000ef          	jal	7b4 <dup>
				close(p[0]);
 3d8:	f3842503          	lw	a0,-200(s0)
 3dc:	388000ef          	jal	764 <close>
				close(p[1]);
 3e0:	f3c42503          	lw	a0,-196(s0)
 3e4:	380000ef          	jal	764 <close>
				exec(arguments[0], arguments); // Execute command on the left
 3e8:	f4040593          	addi	a1,s0,-192
 3ec:	f4043503          	ld	a0,-192(s0)
 3f0:	384000ef          	jal	774 <exec>
				fprintf(2, "Execution of the command failed: %s\n", arguments[0]);
 3f4:	f4043603          	ld	a2,-192(s0)
 3f8:	00001597          	auipc	a1,0x1
 3fc:	94858593          	addi	a1,a1,-1720 # d40 <malloc+0x138>
 400:	4509                	li	a0,2
 402:	728000ef          	jal	b2a <fprintf>
				exit(1);
 406:	4505                	li	a0,1
 408:	334000ef          	jal	73c <exit>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 40c:	f2843783          	ld	a5,-216(s0)
 410:	d8079ae3          	bnez	a5,1a4 <run_command+0x15a>
 414:	8abe                	mv	s5,a5
 416:	8b3e                	mv	s6,a5
 418:	b1d1                	j	dc <run_command+0x92>

000000000000041a <main>:


// Purpose: Repeatedly prompt user for input, forks process to run commands,
// and handle the chdir special case.

int main(void){
 41a:	7135                	addi	sp,sp,-160
 41c:	ed06                	sd	ra,152(sp)
 41e:	e922                	sd	s0,144(sp)
 420:	e526                	sd	s1,136(sp)
 422:	e14a                	sd	s2,128(sp)
 424:	1100                	addi	s0,sp,160
	
	static char buf[100];

	// Setup a pipe
	int pcp[2];
	pipe(pcp);
 426:	fd840513          	addi	a0,s0,-40
 42a:	322000ef          	jal	74c <pipe>

	int fd;

	// Make sure file descriptors are open
	// Taken from source 1
	while((fd = open("console", O_RDWR)) >= 0){
 42e:	00001497          	auipc	s1,0x1
 432:	93a48493          	addi	s1,s1,-1734 # d68 <malloc+0x160>
 436:	4589                	li	a1,2
 438:	8526                	mv	a0,s1
 43a:	342000ef          	jal	77c <open>
 43e:	00054763          	bltz	a0,44c <main+0x32>
		if(fd >= 3){
 442:	4789                	li	a5,2
 444:	fea7d9e3          	bge	a5,a0,436 <main+0x1c>
			close(fd); // close 0, 1 and 2 and it will reopen itself
 448:	31c000ef          	jal	764 <close>
			break;
		}
	}
	
	// Main Loop
	while(getcmd(buf, sizeof(buf)) >= 0){
 44c:	00002497          	auipc	s1,0x2
 450:	bc448493          	addi	s1,s1,-1084 # 2010 <buf.0>
		
		int child_status;

		wait(&child_status);

		if (child_status == 2){ // CD command is detected, must execute in parent
 454:	4909                	li	s2,2
	while(getcmd(buf, sizeof(buf)) >= 0){
 456:	06400593          	li	a1,100
 45a:	8526                	mv	a0,s1
 45c:	ba5ff0ef          	jal	0 <getcmd>
 460:	06054663          	bltz	a0,4cc <main+0xb2>
		if (fork() == 0){
 464:	2d0000ef          	jal	734 <fork>
 468:	c921                	beqz	a0,4b8 <main+0x9e>
		wait(&child_status);
 46a:	f6c40513          	addi	a0,s0,-148
 46e:	2d6000ef          	jal	744 <wait>
		if (child_status == 2){ // CD command is detected, must execute in parent
 472:	f6c42783          	lw	a5,-148(s0)
 476:	ff2790e3          	bne	a5,s2,456 <main+0x3c>

			char buffer_cd_arg[100];
			memset(buffer_cd_arg, 0, sizeof(buffer_cd_arg));
 47a:	06400613          	li	a2,100
 47e:	4581                	li	a1,0
 480:	f7040513          	addi	a0,s0,-144
 484:	0d2000ef          	jal	556 <memset>

			// Read from pipe the pathname to cd
			read(pcp[0], buffer_cd_arg, sizeof(buffer_cd_arg));
 488:	06400613          	li	a2,100
 48c:	f7040593          	addi	a1,s0,-144
 490:	fd842503          	lw	a0,-40(s0)
 494:	2c0000ef          	jal	754 <read>
			
			// Attempt to use chdir system call
			if (chdir(buffer_cd_arg) < 0){
 498:	f7040513          	addi	a0,s0,-144
 49c:	310000ef          	jal	7ac <chdir>
 4a0:	fa055be3          	bgez	a0,456 <main+0x3c>
				fprintf(2, "Failed to change directory to : %s\n", buffer_cd_arg);
 4a4:	f7040613          	addi	a2,s0,-144
 4a8:	00001597          	auipc	a1,0x1
 4ac:	8c858593          	addi	a1,a1,-1848 # d70 <malloc+0x168>
 4b0:	4509                	li	a0,2
 4b2:	678000ef          	jal	b2a <fprintf>
 4b6:	b745                	j	456 <main+0x3c>
			run_command(buf, 100, pcp);
 4b8:	fd840613          	addi	a2,s0,-40
 4bc:	06400593          	li	a1,100
 4c0:	00002517          	auipc	a0,0x2
 4c4:	b5050513          	addi	a0,a0,-1200 # 2010 <buf.0>
 4c8:	b83ff0ef          	jal	4a <run_command>
			}	
		}
	}
	exit(0);
 4cc:	4501                	li	a0,0
 4ce:	26e000ef          	jal	73c <exit>

00000000000004d2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e406                	sd	ra,8(sp)
 4d6:	e022                	sd	s0,0(sp)
 4d8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 4da:	f41ff0ef          	jal	41a <main>
  exit(0);
 4de:	4501                	li	a0,0
 4e0:	25c000ef          	jal	73c <exit>

00000000000004e4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 4e4:	1141                	addi	sp,sp,-16
 4e6:	e422                	sd	s0,8(sp)
 4e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4ea:	87aa                	mv	a5,a0
 4ec:	0585                	addi	a1,a1,1
 4ee:	0785                	addi	a5,a5,1
 4f0:	fff5c703          	lbu	a4,-1(a1)
 4f4:	fee78fa3          	sb	a4,-1(a5)
 4f8:	fb75                	bnez	a4,4ec <strcpy+0x8>
    ;
  return os;
}
 4fa:	6422                	ld	s0,8(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret

0000000000000500 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 500:	1141                	addi	sp,sp,-16
 502:	e422                	sd	s0,8(sp)
 504:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 506:	00054783          	lbu	a5,0(a0)
 50a:	cb91                	beqz	a5,51e <strcmp+0x1e>
 50c:	0005c703          	lbu	a4,0(a1)
 510:	00f71763          	bne	a4,a5,51e <strcmp+0x1e>
    p++, q++;
 514:	0505                	addi	a0,a0,1
 516:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 518:	00054783          	lbu	a5,0(a0)
 51c:	fbe5                	bnez	a5,50c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 51e:	0005c503          	lbu	a0,0(a1)
}
 522:	40a7853b          	subw	a0,a5,a0
 526:	6422                	ld	s0,8(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret

000000000000052c <strlen>:

uint
strlen(const char *s)
{
 52c:	1141                	addi	sp,sp,-16
 52e:	e422                	sd	s0,8(sp)
 530:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 532:	00054783          	lbu	a5,0(a0)
 536:	cf91                	beqz	a5,552 <strlen+0x26>
 538:	0505                	addi	a0,a0,1
 53a:	87aa                	mv	a5,a0
 53c:	86be                	mv	a3,a5
 53e:	0785                	addi	a5,a5,1
 540:	fff7c703          	lbu	a4,-1(a5)
 544:	ff65                	bnez	a4,53c <strlen+0x10>
 546:	40a6853b          	subw	a0,a3,a0
 54a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 54c:	6422                	ld	s0,8(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret
  for(n = 0; s[n]; n++)
 552:	4501                	li	a0,0
 554:	bfe5                	j	54c <strlen+0x20>

0000000000000556 <memset>:

void*
memset(void *dst, int c, uint n)
{
 556:	1141                	addi	sp,sp,-16
 558:	e422                	sd	s0,8(sp)
 55a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 55c:	ca19                	beqz	a2,572 <memset+0x1c>
 55e:	87aa                	mv	a5,a0
 560:	1602                	slli	a2,a2,0x20
 562:	9201                	srli	a2,a2,0x20
 564:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 568:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 56c:	0785                	addi	a5,a5,1
 56e:	fee79de3          	bne	a5,a4,568 <memset+0x12>
  }
  return dst;
}
 572:	6422                	ld	s0,8(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret

0000000000000578 <strchr>:

char*
strchr(const char *s, char c)
{
 578:	1141                	addi	sp,sp,-16
 57a:	e422                	sd	s0,8(sp)
 57c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 57e:	00054783          	lbu	a5,0(a0)
 582:	cb99                	beqz	a5,598 <strchr+0x20>
    if(*s == c)
 584:	00f58763          	beq	a1,a5,592 <strchr+0x1a>
  for(; *s; s++)
 588:	0505                	addi	a0,a0,1
 58a:	00054783          	lbu	a5,0(a0)
 58e:	fbfd                	bnez	a5,584 <strchr+0xc>
      return (char*)s;
  return 0;
 590:	4501                	li	a0,0
}
 592:	6422                	ld	s0,8(sp)
 594:	0141                	addi	sp,sp,16
 596:	8082                	ret
  return 0;
 598:	4501                	li	a0,0
 59a:	bfe5                	j	592 <strchr+0x1a>

000000000000059c <gets>:

char*
gets(char *buf, int max)
{
 59c:	711d                	addi	sp,sp,-96
 59e:	ec86                	sd	ra,88(sp)
 5a0:	e8a2                	sd	s0,80(sp)
 5a2:	e4a6                	sd	s1,72(sp)
 5a4:	e0ca                	sd	s2,64(sp)
 5a6:	fc4e                	sd	s3,56(sp)
 5a8:	f852                	sd	s4,48(sp)
 5aa:	f456                	sd	s5,40(sp)
 5ac:	f05a                	sd	s6,32(sp)
 5ae:	ec5e                	sd	s7,24(sp)
 5b0:	1080                	addi	s0,sp,96
 5b2:	8baa                	mv	s7,a0
 5b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5b6:	892a                	mv	s2,a0
 5b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5ba:	4aa9                	li	s5,10
 5bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 5be:	89a6                	mv	s3,s1
 5c0:	2485                	addiw	s1,s1,1
 5c2:	0344d663          	bge	s1,s4,5ee <gets+0x52>
    cc = read(0, &c, 1);
 5c6:	4605                	li	a2,1
 5c8:	faf40593          	addi	a1,s0,-81
 5cc:	4501                	li	a0,0
 5ce:	186000ef          	jal	754 <read>
    if(cc < 1)
 5d2:	00a05e63          	blez	a0,5ee <gets+0x52>
    buf[i++] = c;
 5d6:	faf44783          	lbu	a5,-81(s0)
 5da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5de:	01578763          	beq	a5,s5,5ec <gets+0x50>
 5e2:	0905                	addi	s2,s2,1
 5e4:	fd679de3          	bne	a5,s6,5be <gets+0x22>
    buf[i++] = c;
 5e8:	89a6                	mv	s3,s1
 5ea:	a011                	j	5ee <gets+0x52>
 5ec:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5ee:	99de                	add	s3,s3,s7
 5f0:	00098023          	sb	zero,0(s3)
  return buf;
}
 5f4:	855e                	mv	a0,s7
 5f6:	60e6                	ld	ra,88(sp)
 5f8:	6446                	ld	s0,80(sp)
 5fa:	64a6                	ld	s1,72(sp)
 5fc:	6906                	ld	s2,64(sp)
 5fe:	79e2                	ld	s3,56(sp)
 600:	7a42                	ld	s4,48(sp)
 602:	7aa2                	ld	s5,40(sp)
 604:	7b02                	ld	s6,32(sp)
 606:	6be2                	ld	s7,24(sp)
 608:	6125                	addi	sp,sp,96
 60a:	8082                	ret

000000000000060c <stat>:

int
stat(const char *n, struct stat *st)
{
 60c:	1101                	addi	sp,sp,-32
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	e04a                	sd	s2,0(sp)
 614:	1000                	addi	s0,sp,32
 616:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 618:	4581                	li	a1,0
 61a:	162000ef          	jal	77c <open>
  if(fd < 0)
 61e:	02054263          	bltz	a0,642 <stat+0x36>
 622:	e426                	sd	s1,8(sp)
 624:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 626:	85ca                	mv	a1,s2
 628:	16c000ef          	jal	794 <fstat>
 62c:	892a                	mv	s2,a0
  close(fd);
 62e:	8526                	mv	a0,s1
 630:	134000ef          	jal	764 <close>
  return r;
 634:	64a2                	ld	s1,8(sp)
}
 636:	854a                	mv	a0,s2
 638:	60e2                	ld	ra,24(sp)
 63a:	6442                	ld	s0,16(sp)
 63c:	6902                	ld	s2,0(sp)
 63e:	6105                	addi	sp,sp,32
 640:	8082                	ret
    return -1;
 642:	597d                	li	s2,-1
 644:	bfcd                	j	636 <stat+0x2a>

0000000000000646 <atoi>:

int
atoi(const char *s)
{
 646:	1141                	addi	sp,sp,-16
 648:	e422                	sd	s0,8(sp)
 64a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 64c:	00054683          	lbu	a3,0(a0)
 650:	fd06879b          	addiw	a5,a3,-48
 654:	0ff7f793          	zext.b	a5,a5
 658:	4625                	li	a2,9
 65a:	02f66863          	bltu	a2,a5,68a <atoi+0x44>
 65e:	872a                	mv	a4,a0
  n = 0;
 660:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 662:	0705                	addi	a4,a4,1
 664:	0025179b          	slliw	a5,a0,0x2
 668:	9fa9                	addw	a5,a5,a0
 66a:	0017979b          	slliw	a5,a5,0x1
 66e:	9fb5                	addw	a5,a5,a3
 670:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 674:	00074683          	lbu	a3,0(a4)
 678:	fd06879b          	addiw	a5,a3,-48
 67c:	0ff7f793          	zext.b	a5,a5
 680:	fef671e3          	bgeu	a2,a5,662 <atoi+0x1c>
  return n;
}
 684:	6422                	ld	s0,8(sp)
 686:	0141                	addi	sp,sp,16
 688:	8082                	ret
  n = 0;
 68a:	4501                	li	a0,0
 68c:	bfe5                	j	684 <atoi+0x3e>

000000000000068e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 68e:	1141                	addi	sp,sp,-16
 690:	e422                	sd	s0,8(sp)
 692:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 694:	02b57463          	bgeu	a0,a1,6bc <memmove+0x2e>
    while(n-- > 0)
 698:	00c05f63          	blez	a2,6b6 <memmove+0x28>
 69c:	1602                	slli	a2,a2,0x20
 69e:	9201                	srli	a2,a2,0x20
 6a0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6a4:	872a                	mv	a4,a0
      *dst++ = *src++;
 6a6:	0585                	addi	a1,a1,1
 6a8:	0705                	addi	a4,a4,1
 6aa:	fff5c683          	lbu	a3,-1(a1)
 6ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6b2:	fef71ae3          	bne	a4,a5,6a6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6b6:	6422                	ld	s0,8(sp)
 6b8:	0141                	addi	sp,sp,16
 6ba:	8082                	ret
    dst += n;
 6bc:	00c50733          	add	a4,a0,a2
    src += n;
 6c0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6c2:	fec05ae3          	blez	a2,6b6 <memmove+0x28>
 6c6:	fff6079b          	addiw	a5,a2,-1
 6ca:	1782                	slli	a5,a5,0x20
 6cc:	9381                	srli	a5,a5,0x20
 6ce:	fff7c793          	not	a5,a5
 6d2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6d4:	15fd                	addi	a1,a1,-1
 6d6:	177d                	addi	a4,a4,-1
 6d8:	0005c683          	lbu	a3,0(a1)
 6dc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6e0:	fee79ae3          	bne	a5,a4,6d4 <memmove+0x46>
 6e4:	bfc9                	j	6b6 <memmove+0x28>

00000000000006e6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6e6:	1141                	addi	sp,sp,-16
 6e8:	e422                	sd	s0,8(sp)
 6ea:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6ec:	ca05                	beqz	a2,71c <memcmp+0x36>
 6ee:	fff6069b          	addiw	a3,a2,-1
 6f2:	1682                	slli	a3,a3,0x20
 6f4:	9281                	srli	a3,a3,0x20
 6f6:	0685                	addi	a3,a3,1
 6f8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6fa:	00054783          	lbu	a5,0(a0)
 6fe:	0005c703          	lbu	a4,0(a1)
 702:	00e79863          	bne	a5,a4,712 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 706:	0505                	addi	a0,a0,1
    p2++;
 708:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 70a:	fed518e3          	bne	a0,a3,6fa <memcmp+0x14>
  }
  return 0;
 70e:	4501                	li	a0,0
 710:	a019                	j	716 <memcmp+0x30>
      return *p1 - *p2;
 712:	40e7853b          	subw	a0,a5,a4
}
 716:	6422                	ld	s0,8(sp)
 718:	0141                	addi	sp,sp,16
 71a:	8082                	ret
  return 0;
 71c:	4501                	li	a0,0
 71e:	bfe5                	j	716 <memcmp+0x30>

0000000000000720 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 720:	1141                	addi	sp,sp,-16
 722:	e406                	sd	ra,8(sp)
 724:	e022                	sd	s0,0(sp)
 726:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 728:	f67ff0ef          	jal	68e <memmove>
}
 72c:	60a2                	ld	ra,8(sp)
 72e:	6402                	ld	s0,0(sp)
 730:	0141                	addi	sp,sp,16
 732:	8082                	ret

0000000000000734 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 734:	4885                	li	a7,1
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <exit>:
.global exit
exit:
 li a7, SYS_exit
 73c:	4889                	li	a7,2
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <wait>:
.global wait
wait:
 li a7, SYS_wait
 744:	488d                	li	a7,3
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 74c:	4891                	li	a7,4
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <read>:
.global read
read:
 li a7, SYS_read
 754:	4895                	li	a7,5
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <write>:
.global write
write:
 li a7, SYS_write
 75c:	48c1                	li	a7,16
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <close>:
.global close
close:
 li a7, SYS_close
 764:	48d5                	li	a7,21
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <kill>:
.global kill
kill:
 li a7, SYS_kill
 76c:	4899                	li	a7,6
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <exec>:
.global exec
exec:
 li a7, SYS_exec
 774:	489d                	li	a7,7
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <open>:
.global open
open:
 li a7, SYS_open
 77c:	48bd                	li	a7,15
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 784:	48c5                	li	a7,17
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 78c:	48c9                	li	a7,18
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 794:	48a1                	li	a7,8
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <link>:
.global link
link:
 li a7, SYS_link
 79c:	48cd                	li	a7,19
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7a4:	48d1                	li	a7,20
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7ac:	48a5                	li	a7,9
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7b4:	48a9                	li	a7,10
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7bc:	48ad                	li	a7,11
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 7c4:	48b1                	li	a7,12
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 7cc:	48b5                	li	a7,13
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7d4:	48b9                	li	a7,14
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7dc:	1101                	addi	sp,sp,-32
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7e8:	4605                	li	a2,1
 7ea:	fef40593          	addi	a1,s0,-17
 7ee:	f6fff0ef          	jal	75c <write>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6105                	addi	sp,sp,32
 7f8:	8082                	ret

00000000000007fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7fa:	7139                	addi	sp,sp,-64
 7fc:	fc06                	sd	ra,56(sp)
 7fe:	f822                	sd	s0,48(sp)
 800:	f426                	sd	s1,40(sp)
 802:	0080                	addi	s0,sp,64
 804:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 806:	c299                	beqz	a3,80c <printint+0x12>
 808:	0805c963          	bltz	a1,89a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 80c:	2581                	sext.w	a1,a1
  neg = 0;
 80e:	4881                	li	a7,0
 810:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 814:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 816:	2601                	sext.w	a2,a2
 818:	00000517          	auipc	a0,0x0
 81c:	58850513          	addi	a0,a0,1416 # da0 <digits>
 820:	883a                	mv	a6,a4
 822:	2705                	addiw	a4,a4,1
 824:	02c5f7bb          	remuw	a5,a1,a2
 828:	1782                	slli	a5,a5,0x20
 82a:	9381                	srli	a5,a5,0x20
 82c:	97aa                	add	a5,a5,a0
 82e:	0007c783          	lbu	a5,0(a5)
 832:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 836:	0005879b          	sext.w	a5,a1
 83a:	02c5d5bb          	divuw	a1,a1,a2
 83e:	0685                	addi	a3,a3,1
 840:	fec7f0e3          	bgeu	a5,a2,820 <printint+0x26>
  if(neg)
 844:	00088c63          	beqz	a7,85c <printint+0x62>
    buf[i++] = '-';
 848:	fd070793          	addi	a5,a4,-48
 84c:	00878733          	add	a4,a5,s0
 850:	02d00793          	li	a5,45
 854:	fef70823          	sb	a5,-16(a4)
 858:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 85c:	02e05a63          	blez	a4,890 <printint+0x96>
 860:	f04a                	sd	s2,32(sp)
 862:	ec4e                	sd	s3,24(sp)
 864:	fc040793          	addi	a5,s0,-64
 868:	00e78933          	add	s2,a5,a4
 86c:	fff78993          	addi	s3,a5,-1
 870:	99ba                	add	s3,s3,a4
 872:	377d                	addiw	a4,a4,-1
 874:	1702                	slli	a4,a4,0x20
 876:	9301                	srli	a4,a4,0x20
 878:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 87c:	fff94583          	lbu	a1,-1(s2)
 880:	8526                	mv	a0,s1
 882:	f5bff0ef          	jal	7dc <putc>
  while(--i >= 0)
 886:	197d                	addi	s2,s2,-1
 888:	ff391ae3          	bne	s2,s3,87c <printint+0x82>
 88c:	7902                	ld	s2,32(sp)
 88e:	69e2                	ld	s3,24(sp)
}
 890:	70e2                	ld	ra,56(sp)
 892:	7442                	ld	s0,48(sp)
 894:	74a2                	ld	s1,40(sp)
 896:	6121                	addi	sp,sp,64
 898:	8082                	ret
    x = -xx;
 89a:	40b005bb          	negw	a1,a1
    neg = 1;
 89e:	4885                	li	a7,1
    x = -xx;
 8a0:	bf85                	j	810 <printint+0x16>

00000000000008a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8a2:	711d                	addi	sp,sp,-96
 8a4:	ec86                	sd	ra,88(sp)
 8a6:	e8a2                	sd	s0,80(sp)
 8a8:	e0ca                	sd	s2,64(sp)
 8aa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8ac:	0005c903          	lbu	s2,0(a1)
 8b0:	26090863          	beqz	s2,b20 <vprintf+0x27e>
 8b4:	e4a6                	sd	s1,72(sp)
 8b6:	fc4e                	sd	s3,56(sp)
 8b8:	f852                	sd	s4,48(sp)
 8ba:	f456                	sd	s5,40(sp)
 8bc:	f05a                	sd	s6,32(sp)
 8be:	ec5e                	sd	s7,24(sp)
 8c0:	e862                	sd	s8,16(sp)
 8c2:	e466                	sd	s9,8(sp)
 8c4:	8b2a                	mv	s6,a0
 8c6:	8a2e                	mv	s4,a1
 8c8:	8bb2                	mv	s7,a2
  state = 0;
 8ca:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8cc:	4481                	li	s1,0
 8ce:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8d0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8d4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8d8:	06c00c93          	li	s9,108
 8dc:	a005                	j	8fc <vprintf+0x5a>
        putc(fd, c0);
 8de:	85ca                	mv	a1,s2
 8e0:	855a                	mv	a0,s6
 8e2:	efbff0ef          	jal	7dc <putc>
 8e6:	a019                	j	8ec <vprintf+0x4a>
    } else if(state == '%'){
 8e8:	03598263          	beq	s3,s5,90c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 8ec:	2485                	addiw	s1,s1,1
 8ee:	8726                	mv	a4,s1
 8f0:	009a07b3          	add	a5,s4,s1
 8f4:	0007c903          	lbu	s2,0(a5)
 8f8:	20090c63          	beqz	s2,b10 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 8fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 900:	fe0994e3          	bnez	s3,8e8 <vprintf+0x46>
      if(c0 == '%'){
 904:	fd579de3          	bne	a5,s5,8de <vprintf+0x3c>
        state = '%';
 908:	89be                	mv	s3,a5
 90a:	b7cd                	j	8ec <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 90c:	00ea06b3          	add	a3,s4,a4
 910:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 914:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 916:	c681                	beqz	a3,91e <vprintf+0x7c>
 918:	9752                	add	a4,a4,s4
 91a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 91e:	03878f63          	beq	a5,s8,95c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 922:	05978963          	beq	a5,s9,974 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 926:	07500713          	li	a4,117
 92a:	0ee78363          	beq	a5,a4,a10 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 92e:	07800713          	li	a4,120
 932:	12e78563          	beq	a5,a4,a5c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 936:	07000713          	li	a4,112
 93a:	14e78a63          	beq	a5,a4,a8e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 93e:	07300713          	li	a4,115
 942:	18e78a63          	beq	a5,a4,ad6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 946:	02500713          	li	a4,37
 94a:	04e79563          	bne	a5,a4,994 <vprintf+0xf2>
        putc(fd, '%');
 94e:	02500593          	li	a1,37
 952:	855a                	mv	a0,s6
 954:	e89ff0ef          	jal	7dc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 958:	4981                	li	s3,0
 95a:	bf49                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 95c:	008b8913          	addi	s2,s7,8
 960:	4685                	li	a3,1
 962:	4629                	li	a2,10
 964:	000ba583          	lw	a1,0(s7)
 968:	855a                	mv	a0,s6
 96a:	e91ff0ef          	jal	7fa <printint>
 96e:	8bca                	mv	s7,s2
      state = 0;
 970:	4981                	li	s3,0
 972:	bfad                	j	8ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 974:	06400793          	li	a5,100
 978:	02f68963          	beq	a3,a5,9aa <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 97c:	06c00793          	li	a5,108
 980:	04f68263          	beq	a3,a5,9c4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 984:	07500793          	li	a5,117
 988:	0af68063          	beq	a3,a5,a28 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 98c:	07800793          	li	a5,120
 990:	0ef68263          	beq	a3,a5,a74 <vprintf+0x1d2>
        putc(fd, '%');
 994:	02500593          	li	a1,37
 998:	855a                	mv	a0,s6
 99a:	e43ff0ef          	jal	7dc <putc>
        putc(fd, c0);
 99e:	85ca                	mv	a1,s2
 9a0:	855a                	mv	a0,s6
 9a2:	e3bff0ef          	jal	7dc <putc>
      state = 0;
 9a6:	4981                	li	s3,0
 9a8:	b791                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9aa:	008b8913          	addi	s2,s7,8
 9ae:	4685                	li	a3,1
 9b0:	4629                	li	a2,10
 9b2:	000ba583          	lw	a1,0(s7)
 9b6:	855a                	mv	a0,s6
 9b8:	e43ff0ef          	jal	7fa <printint>
        i += 1;
 9bc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9be:	8bca                	mv	s7,s2
      state = 0;
 9c0:	4981                	li	s3,0
        i += 1;
 9c2:	b72d                	j	8ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9c4:	06400793          	li	a5,100
 9c8:	02f60763          	beq	a2,a5,9f6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9cc:	07500793          	li	a5,117
 9d0:	06f60963          	beq	a2,a5,a42 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9d4:	07800793          	li	a5,120
 9d8:	faf61ee3          	bne	a2,a5,994 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9dc:	008b8913          	addi	s2,s7,8
 9e0:	4681                	li	a3,0
 9e2:	4641                	li	a2,16
 9e4:	000ba583          	lw	a1,0(s7)
 9e8:	855a                	mv	a0,s6
 9ea:	e11ff0ef          	jal	7fa <printint>
        i += 2;
 9ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9f0:	8bca                	mv	s7,s2
      state = 0;
 9f2:	4981                	li	s3,0
        i += 2;
 9f4:	bde5                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9f6:	008b8913          	addi	s2,s7,8
 9fa:	4685                	li	a3,1
 9fc:	4629                	li	a2,10
 9fe:	000ba583          	lw	a1,0(s7)
 a02:	855a                	mv	a0,s6
 a04:	df7ff0ef          	jal	7fa <printint>
        i += 2;
 a08:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a0a:	8bca                	mv	s7,s2
      state = 0;
 a0c:	4981                	li	s3,0
        i += 2;
 a0e:	bdf9                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 a10:	008b8913          	addi	s2,s7,8
 a14:	4681                	li	a3,0
 a16:	4629                	li	a2,10
 a18:	000ba583          	lw	a1,0(s7)
 a1c:	855a                	mv	a0,s6
 a1e:	dddff0ef          	jal	7fa <printint>
 a22:	8bca                	mv	s7,s2
      state = 0;
 a24:	4981                	li	s3,0
 a26:	b5d9                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a28:	008b8913          	addi	s2,s7,8
 a2c:	4681                	li	a3,0
 a2e:	4629                	li	a2,10
 a30:	000ba583          	lw	a1,0(s7)
 a34:	855a                	mv	a0,s6
 a36:	dc5ff0ef          	jal	7fa <printint>
        i += 1;
 a3a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a3c:	8bca                	mv	s7,s2
      state = 0;
 a3e:	4981                	li	s3,0
        i += 1;
 a40:	b575                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a42:	008b8913          	addi	s2,s7,8
 a46:	4681                	li	a3,0
 a48:	4629                	li	a2,10
 a4a:	000ba583          	lw	a1,0(s7)
 a4e:	855a                	mv	a0,s6
 a50:	dabff0ef          	jal	7fa <printint>
        i += 2;
 a54:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a56:	8bca                	mv	s7,s2
      state = 0;
 a58:	4981                	li	s3,0
        i += 2;
 a5a:	bd49                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 a5c:	008b8913          	addi	s2,s7,8
 a60:	4681                	li	a3,0
 a62:	4641                	li	a2,16
 a64:	000ba583          	lw	a1,0(s7)
 a68:	855a                	mv	a0,s6
 a6a:	d91ff0ef          	jal	7fa <printint>
 a6e:	8bca                	mv	s7,s2
      state = 0;
 a70:	4981                	li	s3,0
 a72:	bdad                	j	8ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a74:	008b8913          	addi	s2,s7,8
 a78:	4681                	li	a3,0
 a7a:	4641                	li	a2,16
 a7c:	000ba583          	lw	a1,0(s7)
 a80:	855a                	mv	a0,s6
 a82:	d79ff0ef          	jal	7fa <printint>
        i += 1;
 a86:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a88:	8bca                	mv	s7,s2
      state = 0;
 a8a:	4981                	li	s3,0
        i += 1;
 a8c:	b585                	j	8ec <vprintf+0x4a>
 a8e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a90:	008b8d13          	addi	s10,s7,8
 a94:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a98:	03000593          	li	a1,48
 a9c:	855a                	mv	a0,s6
 a9e:	d3fff0ef          	jal	7dc <putc>
  putc(fd, 'x');
 aa2:	07800593          	li	a1,120
 aa6:	855a                	mv	a0,s6
 aa8:	d35ff0ef          	jal	7dc <putc>
 aac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 aae:	00000b97          	auipc	s7,0x0
 ab2:	2f2b8b93          	addi	s7,s7,754 # da0 <digits>
 ab6:	03c9d793          	srli	a5,s3,0x3c
 aba:	97de                	add	a5,a5,s7
 abc:	0007c583          	lbu	a1,0(a5)
 ac0:	855a                	mv	a0,s6
 ac2:	d1bff0ef          	jal	7dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 ac6:	0992                	slli	s3,s3,0x4
 ac8:	397d                	addiw	s2,s2,-1
 aca:	fe0916e3          	bnez	s2,ab6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 ace:	8bea                	mv	s7,s10
      state = 0;
 ad0:	4981                	li	s3,0
 ad2:	6d02                	ld	s10,0(sp)
 ad4:	bd21                	j	8ec <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 ad6:	008b8993          	addi	s3,s7,8
 ada:	000bb903          	ld	s2,0(s7)
 ade:	00090f63          	beqz	s2,afc <vprintf+0x25a>
        for(; *s; s++)
 ae2:	00094583          	lbu	a1,0(s2)
 ae6:	c195                	beqz	a1,b0a <vprintf+0x268>
          putc(fd, *s);
 ae8:	855a                	mv	a0,s6
 aea:	cf3ff0ef          	jal	7dc <putc>
        for(; *s; s++)
 aee:	0905                	addi	s2,s2,1
 af0:	00094583          	lbu	a1,0(s2)
 af4:	f9f5                	bnez	a1,ae8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 af6:	8bce                	mv	s7,s3
      state = 0;
 af8:	4981                	li	s3,0
 afa:	bbcd                	j	8ec <vprintf+0x4a>
          s = "(null)";
 afc:	00000917          	auipc	s2,0x0
 b00:	29c90913          	addi	s2,s2,668 # d98 <malloc+0x190>
        for(; *s; s++)
 b04:	02800593          	li	a1,40
 b08:	b7c5                	j	ae8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b0a:	8bce                	mv	s7,s3
      state = 0;
 b0c:	4981                	li	s3,0
 b0e:	bbf9                	j	8ec <vprintf+0x4a>
 b10:	64a6                	ld	s1,72(sp)
 b12:	79e2                	ld	s3,56(sp)
 b14:	7a42                	ld	s4,48(sp)
 b16:	7aa2                	ld	s5,40(sp)
 b18:	7b02                	ld	s6,32(sp)
 b1a:	6be2                	ld	s7,24(sp)
 b1c:	6c42                	ld	s8,16(sp)
 b1e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 b20:	60e6                	ld	ra,88(sp)
 b22:	6446                	ld	s0,80(sp)
 b24:	6906                	ld	s2,64(sp)
 b26:	6125                	addi	sp,sp,96
 b28:	8082                	ret

0000000000000b2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b2a:	715d                	addi	sp,sp,-80
 b2c:	ec06                	sd	ra,24(sp)
 b2e:	e822                	sd	s0,16(sp)
 b30:	1000                	addi	s0,sp,32
 b32:	e010                	sd	a2,0(s0)
 b34:	e414                	sd	a3,8(s0)
 b36:	e818                	sd	a4,16(s0)
 b38:	ec1c                	sd	a5,24(s0)
 b3a:	03043023          	sd	a6,32(s0)
 b3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b42:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b46:	8622                	mv	a2,s0
 b48:	d5bff0ef          	jal	8a2 <vprintf>
}
 b4c:	60e2                	ld	ra,24(sp)
 b4e:	6442                	ld	s0,16(sp)
 b50:	6161                	addi	sp,sp,80
 b52:	8082                	ret

0000000000000b54 <printf>:

void
printf(const char *fmt, ...)
{
 b54:	711d                	addi	sp,sp,-96
 b56:	ec06                	sd	ra,24(sp)
 b58:	e822                	sd	s0,16(sp)
 b5a:	1000                	addi	s0,sp,32
 b5c:	e40c                	sd	a1,8(s0)
 b5e:	e810                	sd	a2,16(s0)
 b60:	ec14                	sd	a3,24(s0)
 b62:	f018                	sd	a4,32(s0)
 b64:	f41c                	sd	a5,40(s0)
 b66:	03043823          	sd	a6,48(s0)
 b6a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b6e:	00840613          	addi	a2,s0,8
 b72:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b76:	85aa                	mv	a1,a0
 b78:	4505                	li	a0,1
 b7a:	d29ff0ef          	jal	8a2 <vprintf>
}
 b7e:	60e2                	ld	ra,24(sp)
 b80:	6442                	ld	s0,16(sp)
 b82:	6125                	addi	sp,sp,96
 b84:	8082                	ret

0000000000000b86 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b86:	1141                	addi	sp,sp,-16
 b88:	e422                	sd	s0,8(sp)
 b8a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b8c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b90:	00001797          	auipc	a5,0x1
 b94:	4707b783          	ld	a5,1136(a5) # 2000 <freep>
 b98:	a02d                	j	bc2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b9a:	4618                	lw	a4,8(a2)
 b9c:	9f2d                	addw	a4,a4,a1
 b9e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ba2:	6398                	ld	a4,0(a5)
 ba4:	6310                	ld	a2,0(a4)
 ba6:	a83d                	j	be4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ba8:	ff852703          	lw	a4,-8(a0)
 bac:	9f31                	addw	a4,a4,a2
 bae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 bb0:	ff053683          	ld	a3,-16(a0)
 bb4:	a091                	j	bf8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb6:	6398                	ld	a4,0(a5)
 bb8:	00e7e463          	bltu	a5,a4,bc0 <free+0x3a>
 bbc:	00e6ea63          	bltu	a3,a4,bd0 <free+0x4a>
{
 bc0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc2:	fed7fae3          	bgeu	a5,a3,bb6 <free+0x30>
 bc6:	6398                	ld	a4,0(a5)
 bc8:	00e6e463          	bltu	a3,a4,bd0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bcc:	fee7eae3          	bltu	a5,a4,bc0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bd0:	ff852583          	lw	a1,-8(a0)
 bd4:	6390                	ld	a2,0(a5)
 bd6:	02059813          	slli	a6,a1,0x20
 bda:	01c85713          	srli	a4,a6,0x1c
 bde:	9736                	add	a4,a4,a3
 be0:	fae60de3          	beq	a2,a4,b9a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 be4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 be8:	4790                	lw	a2,8(a5)
 bea:	02061593          	slli	a1,a2,0x20
 bee:	01c5d713          	srli	a4,a1,0x1c
 bf2:	973e                	add	a4,a4,a5
 bf4:	fae68ae3          	beq	a3,a4,ba8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 bf8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bfa:	00001717          	auipc	a4,0x1
 bfe:	40f73323          	sd	a5,1030(a4) # 2000 <freep>
}
 c02:	6422                	ld	s0,8(sp)
 c04:	0141                	addi	sp,sp,16
 c06:	8082                	ret

0000000000000c08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c08:	7139                	addi	sp,sp,-64
 c0a:	fc06                	sd	ra,56(sp)
 c0c:	f822                	sd	s0,48(sp)
 c0e:	f426                	sd	s1,40(sp)
 c10:	ec4e                	sd	s3,24(sp)
 c12:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c14:	02051493          	slli	s1,a0,0x20
 c18:	9081                	srli	s1,s1,0x20
 c1a:	04bd                	addi	s1,s1,15
 c1c:	8091                	srli	s1,s1,0x4
 c1e:	0014899b          	addiw	s3,s1,1
 c22:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c24:	00001517          	auipc	a0,0x1
 c28:	3dc53503          	ld	a0,988(a0) # 2000 <freep>
 c2c:	c915                	beqz	a0,c60 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c30:	4798                	lw	a4,8(a5)
 c32:	08977a63          	bgeu	a4,s1,cc6 <malloc+0xbe>
 c36:	f04a                	sd	s2,32(sp)
 c38:	e852                	sd	s4,16(sp)
 c3a:	e456                	sd	s5,8(sp)
 c3c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c3e:	8a4e                	mv	s4,s3
 c40:	0009871b          	sext.w	a4,s3
 c44:	6685                	lui	a3,0x1
 c46:	00d77363          	bgeu	a4,a3,c4c <malloc+0x44>
 c4a:	6a05                	lui	s4,0x1
 c4c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c50:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c54:	00001917          	auipc	s2,0x1
 c58:	3ac90913          	addi	s2,s2,940 # 2000 <freep>
  if(p == (char*)-1)
 c5c:	5afd                	li	s5,-1
 c5e:	a081                	j	c9e <malloc+0x96>
 c60:	f04a                	sd	s2,32(sp)
 c62:	e852                	sd	s4,16(sp)
 c64:	e456                	sd	s5,8(sp)
 c66:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c68:	00001797          	auipc	a5,0x1
 c6c:	41078793          	addi	a5,a5,1040 # 2078 <base>
 c70:	00001717          	auipc	a4,0x1
 c74:	38f73823          	sd	a5,912(a4) # 2000 <freep>
 c78:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c7a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c7e:	b7c1                	j	c3e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c80:	6398                	ld	a4,0(a5)
 c82:	e118                	sd	a4,0(a0)
 c84:	a8a9                	j	cde <malloc+0xd6>
  hp->s.size = nu;
 c86:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c8a:	0541                	addi	a0,a0,16
 c8c:	efbff0ef          	jal	b86 <free>
  return freep;
 c90:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c94:	c12d                	beqz	a0,cf6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c98:	4798                	lw	a4,8(a5)
 c9a:	02977263          	bgeu	a4,s1,cbe <malloc+0xb6>
    if(p == freep)
 c9e:	00093703          	ld	a4,0(s2)
 ca2:	853e                	mv	a0,a5
 ca4:	fef719e3          	bne	a4,a5,c96 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 ca8:	8552                	mv	a0,s4
 caa:	b1bff0ef          	jal	7c4 <sbrk>
  if(p == (char*)-1)
 cae:	fd551ce3          	bne	a0,s5,c86 <malloc+0x7e>
        return 0;
 cb2:	4501                	li	a0,0
 cb4:	7902                	ld	s2,32(sp)
 cb6:	6a42                	ld	s4,16(sp)
 cb8:	6aa2                	ld	s5,8(sp)
 cba:	6b02                	ld	s6,0(sp)
 cbc:	a03d                	j	cea <malloc+0xe2>
 cbe:	7902                	ld	s2,32(sp)
 cc0:	6a42                	ld	s4,16(sp)
 cc2:	6aa2                	ld	s5,8(sp)
 cc4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 cc6:	fae48de3          	beq	s1,a4,c80 <malloc+0x78>
        p->s.size -= nunits;
 cca:	4137073b          	subw	a4,a4,s3
 cce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cd0:	02071693          	slli	a3,a4,0x20
 cd4:	01c6d713          	srli	a4,a3,0x1c
 cd8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cda:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cde:	00001717          	auipc	a4,0x1
 ce2:	32a73123          	sd	a0,802(a4) # 2000 <freep>
      return (void*)(p + 1);
 ce6:	01078513          	addi	a0,a5,16
  }
}
 cea:	70e2                	ld	ra,56(sp)
 cec:	7442                	ld	s0,48(sp)
 cee:	74a2                	ld	s1,40(sp)
 cf0:	69e2                	ld	s3,24(sp)
 cf2:	6121                	addi	sp,sp,64
 cf4:	8082                	ret
 cf6:	7902                	ld	s2,32(sp)
 cf8:	6a42                	ld	s4,16(sp)
 cfa:	6aa2                	ld	s5,8(sp)
 cfc:	6b02                	ld	s6,0(sp)
 cfe:	b7f5                	j	cea <malloc+0xe2>
