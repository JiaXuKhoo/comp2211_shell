
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
  16:	e1e58593          	addi	a1,a1,-482 # e30 <malloc+0xfa>
  1a:	4509                	li	a0,2
  1c:	06f000ef          	jal	88a <write>
	memset(buf, 0, nbuf);
  20:	864a                	mv	a2,s2
  22:	4581                	li	a1,0
  24:	8526                	mv	a0,s1
  26:	65e000ef          	jal	684 <memset>
	gets(buf, nbuf);
  2a:	85ca                	mv	a1,s2
  2c:	8526                	mv	a0,s1
  2e:	69c000ef          	jal	6ca <gets>

	fprintf(2, "Chars: %d\n", strlen(buf));
  32:	8526                	mv	a0,s1
  34:	626000ef          	jal	65a <strlen>
  38:	0005061b          	sext.w	a2,a0
  3c:	00001597          	auipc	a1,0x1
  40:	dfc58593          	addi	a1,a1,-516 # e38 <malloc+0x102>
  44:	4509                	li	a0,2
  46:	413000ef          	jal	c58 <fprintf>
	fprintf(2, "Buf: %s\n", buf);
  4a:	8626                	mv	a2,s1
  4c:	00001597          	auipc	a1,0x1
  50:	dfc58593          	addi	a1,a1,-516 # e48 <malloc+0x112>
  54:	4509                	li	a0,2
  56:	403000ef          	jal	c58 <fprintf>

	if (buf[0] == 0){
  5a:	0004c503          	lbu	a0,0(s1)
  5e:	00153513          	seqz	a0,a0
		return -1;
	}
	return 0;
}
  62:	40a00533          	neg	a0,a0
  66:	60e2                	ld	ra,24(sp)
  68:	6442                	ld	s0,16(sp)
  6a:	64a2                	ld	s1,8(sp)
  6c:	6902                	ld	s2,0(sp)
  6e:	6105                	addi	sp,sp,32
  70:	8082                	ret

0000000000000072 <run_command>:

// Purpose: Recursive function to parse command character by character at *buf and execute it

__attribute__((noreturn))
void run_command(char* buf, int nbuf, int* pcp){
  72:	716d                	addi	sp,sp,-272
  74:	e606                	sd	ra,264(sp)
  76:	e222                	sd	s0,256(sp)
  78:	fda6                	sd	s1,248(sp)
  7a:	f9ca                	sd	s2,240(sp)
  7c:	f5ce                	sd	s3,232(sp)
  7e:	f1d2                	sd	s4,224(sp)
  80:	edd6                	sd	s5,216(sp)
  82:	e9da                	sd	s6,208(sp)
  84:	e5de                	sd	s7,200(sp)
  86:	e1e2                	sd	s8,192(sp)
  88:	fd66                	sd	s9,184(sp)
  8a:	f96a                	sd	s10,176(sp)
  8c:	f56e                	sd	s11,168(sp)
  8e:	0a00                	addi	s0,sp,272
  90:	eea43c23          	sd	a0,-264(s0)
  94:	8b2e                	mv	s6,a1
  96:	f0c43023          	sd	a2,-256(s0)

	// Useful data structures and flags
	
	char* arguments[10] = {0}; // Initialize everything to NULL
  9a:	f4043023          	sd	zero,-192(s0)
  9e:	f4043423          	sd	zero,-184(s0)
  a2:	f4043823          	sd	zero,-176(s0)
  a6:	f4043c23          	sd	zero,-168(s0)
  aa:	f6043023          	sd	zero,-160(s0)
  ae:	f6043423          	sd	zero,-152(s0)
  b2:	f6043823          	sd	zero,-144(s0)
  b6:	f6043c23          	sd	zero,-136(s0)
  ba:	f8043023          	sd	zero,-128(s0)
  be:	f8043423          	sd	zero,-120(s0)
	int pipe_cmd = 0; // stores the location where | operator occurs

	int sequence_cmd = 0; // stores the location where ; operator occurs

	// Parsing character by character
	for (int i = 0; i < nbuf; i++){
  c2:	44b05263          	blez	a1,506 <run_command+0x494>
  c6:	84aa                	mv	s1,a0
  c8:	4981                	li	s3,0
	char* file_name_r = 0; // Buffer to store name of file on the right
  ca:	f0043823          	sd	zero,-240(s0)
	char* file_name_l = 0; // Buffer to store name of file on the left
  ce:	f0043423          	sd	zero,-248(s0)
	int redirection_right = 0; // >
  d2:	4a01                	li	s4,0
	int redirection_left = 0; // <
  d4:	4a81                	li	s5,0
	int ws = 1; // word start flag
  d6:	4785                	li	a5,1
  d8:	f2f43023          	sd	a5,-224(s0)
	int numargs = 0; // number of arguments
  dc:	f0043c23          	sd	zero,-232(s0)
		
		// Sets flag and null terminate for a valid string
		// Apparently \0 in integer is 0
		if (buf[i] == '<'){
  e0:	03c00b93          	li	s7,60
			
			redirection_left = 1;
			buf[i] = 0; // Null terminate a word
			continue;
		}
		if (buf[i] == '>'){
  e4:	03e00c13          	li	s8,62

			redirection_right = 1;
			buf[i] = 0;
			continue;
		}
		if (buf[i] == '|'){
  e8:	07c00c93          	li	s9,124

			pipe_cmd = i + 1; // 1 positon offset
			buf[i] = 0;
			break; // Handling recursively
		}
		if (buf[i] == ';'){
  ec:	03b00d13          	li	s10,59
  f0:	00800db7          	lui	s11,0x800
  f4:	0dcd                	addi	s11,s11,19 # 800013 <base+0x7fdf9b>
  f6:	0da6                	slli	s11,s11,0x9
  f8:	a2e9                	j	2c2 <run_command+0x250>
			fprintf(2, "REDIR_L FLAG SET\n");
  fa:	00001597          	auipc	a1,0x1
  fe:	d5e58593          	addi	a1,a1,-674 # e58 <malloc+0x122>
 102:	4509                	li	a0,2
 104:	355000ef          	jal	c58 <fprintf>
			buf[i] = 0; // Null terminate a word
 108:	00048023          	sb	zero,0(s1)
			redirection_left = 1;
 10c:	4a85                	li	s5,1
			continue;
 10e:	a275                	j	2ba <run_command+0x248>
			fprintf(2, "REDIR_R FLAG SET\n");
 110:	00001597          	auipc	a1,0x1
 114:	d6058593          	addi	a1,a1,-672 # e70 <malloc+0x13a>
 118:	4509                	li	a0,2
 11a:	33f000ef          	jal	c58 <fprintf>
			buf[i] = 0;
 11e:	f2843783          	ld	a5,-216(s0)
 122:	00078023          	sb	zero,0(a5)
			redirection_right = 1;
 126:	4a05                	li	s4,1
			continue;
 128:	aa49                	j	2ba <run_command+0x248>
			fprintf(2, "PIPE_CMD SET TO: %d\n", i+1);
 12a:	0019849b          	addiw	s1,s3,1
 12e:	8626                	mv	a2,s1
 130:	00001597          	auipc	a1,0x1
 134:	d5858593          	addi	a1,a1,-680 # e88 <malloc+0x152>
 138:	4509                	li	a0,2
 13a:	31f000ef          	jal	c58 <fprintf>
			buf[i] = 0;
 13e:	f2843783          	ld	a5,-216(s0)
 142:	00078023          	sb	zero,0(a5)
			}
		}
	}
	
	
	arguments[numargs] = 0; // NULL terminate for exec() to work
 146:	f1843783          	ld	a5,-232(s0)
 14a:	078e                	slli	a5,a5,0x3
 14c:	f9078793          	addi	a5,a5,-112
 150:	97a2                	add	a5,a5,s0
 152:	fa07b823          	sd	zero,-80(a5)
		wait(0);
	}

	// Dealing with redirection command < and >

	if (redirection_left){
 156:	280a9363          	bnez	s5,3dc <run_command+0x36a>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_l);
			exit(1); // quit
		}
	}
	if (redirection_right){
 15a:	2a0a1763          	bnez	s4,408 <run_command+0x396>
			exit(1); // quit
		}
	}

	// Handle cd special case
	if (numargs > 0 && strcmp(arguments[0], "cd") == 0){
 15e:	f1843783          	ld	a5,-232(s0)
 162:	00f05c63          	blez	a5,17a <run_command+0x108>
 166:	00001597          	auipc	a1,0x1
 16a:	dca58593          	addi	a1,a1,-566 # f30 <malloc+0x1fa>
 16e:	f4043503          	ld	a0,-192(s0)
 172:	4bc000ef          	jal	62e <strcmp>
 176:	2c050063          	beqz	a0,436 <run_command+0x3c4>
		// Exit with 2 to let main know there is cd command
		exit(2);

	}else{ // We know it is not a cd command
		// Technique from source 2
		if (pipe_cmd){
 17a:	32048263          	beqz	s1,49e <run_command+0x42c>
			
			pipe(p); // New pipe
 17e:	f3840513          	addi	a0,s0,-200
 182:	6f8000ef          	jal	87a <pipe>
			
			if (fork() == 0){
 186:	6dc000ef          	jal	862 <fork>
 18a:	892a                	mv	s2,a0
 18c:	2c051763          	bnez	a0,45a <run_command+0x3e8>
				close(1); // close stdout
 190:	4505                	li	a0,1
 192:	700000ef          	jal	892 <close>
				dup(p[1]); // Make "in" part of pipe to be stdout
 196:	f3c42503          	lw	a0,-196(s0)
 19a:	748000ef          	jal	8e2 <dup>
				
				close(p[0]);
 19e:	f3842503          	lw	a0,-200(s0)
 1a2:	6f0000ef          	jal	892 <close>
				close(p[1]);
 1a6:	f3c42503          	lw	a0,-196(s0)
 1aa:	6e8000ef          	jal	892 <close>

				exec(arguments[0], arguments); // Execute command on the left
 1ae:	f4040593          	addi	a1,s0,-192
 1b2:	f4043503          	ld	a0,-192(s0)
 1b6:	6ec000ef          	jal	8a2 <exec>
				
				// If we reach this part that means something went wrong
				fprintf(2, "================================================\n");
 1ba:	00001597          	auipc	a1,0x1
 1be:	d7e58593          	addi	a1,a1,-642 # f38 <malloc+0x202>
 1c2:	4509                	li	a0,2
 1c4:	295000ef          	jal	c58 <fprintf>
				fprintf(2, "P_LEFT: Execution of the command failed:<S>%s<E>\n", arguments[0]);
 1c8:	f4043603          	ld	a2,-192(s0)
 1cc:	00001597          	auipc	a1,0x1
 1d0:	da458593          	addi	a1,a1,-604 # f70 <malloc+0x23a>
 1d4:	4509                	li	a0,2
 1d6:	283000ef          	jal	c58 <fprintf>
				fprintf(2, "================================================\n");
 1da:	00001597          	auipc	a1,0x1
 1de:	d5e58593          	addi	a1,a1,-674 # f38 <malloc+0x202>
 1e2:	4509                	li	a0,2
 1e4:	275000ef          	jal	c58 <fprintf>
				for (int j = 0; j < 9; j++){
 1e8:	f4040493          	addi	s1,s0,-192
					fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n", j, arguments[j], numargs);
 1ec:	00001a17          	auipc	s4,0x1
 1f0:	dbca0a13          	addi	s4,s4,-580 # fa8 <malloc+0x272>
				for (int j = 0; j < 9; j++){
 1f4:	49a5                	li	s3,9
					fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n", j, arguments[j], numargs);
 1f6:	f1843703          	ld	a4,-232(s0)
 1fa:	6094                	ld	a3,0(s1)
 1fc:	864a                	mv	a2,s2
 1fe:	85d2                	mv	a1,s4
 200:	4509                	li	a0,2
 202:	257000ef          	jal	c58 <fprintf>
				for (int j = 0; j < 9; j++){
 206:	2905                	addiw	s2,s2,1
 208:	04a1                	addi	s1,s1,8
 20a:	ff3916e3          	bne	s2,s3,1f6 <run_command+0x184>
				}

				exit(1);
 20e:	4505                	li	a0,1
 210:	65a000ef          	jal	86a <exit>
			fprintf(2, "SEQUENCE_CMD SET TO: %d\n", i+1);
 214:	2985                	addiw	s3,s3,1
 216:	0009849b          	sext.w	s1,s3
 21a:	8626                	mv	a2,s1
 21c:	00001597          	auipc	a1,0x1
 220:	c8458593          	addi	a1,a1,-892 # ea0 <malloc+0x16a>
 224:	4509                	li	a0,2
 226:	233000ef          	jal	c58 <fprintf>
			buf[i] = 0;
 22a:	f2843783          	ld	a5,-216(s0)
 22e:	00078023          	sb	zero,0(a5)
	arguments[numargs] = 0; // NULL terminate for exec() to work
 232:	f1843783          	ld	a5,-232(s0)
 236:	078e                	slli	a5,a5,0x3
 238:	f9078793          	addi	a5,a5,-112
 23c:	97a2                	add	a5,a5,s0
 23e:	fa07b823          	sd	zero,-80(a5)
	if (sequence_cmd){
 242:	f0048ae3          	beqz	s1,156 <run_command+0xe4>
		if (fork() != 0){
 246:	61c000ef          	jal	862 <fork>
 24a:	892a                	mv	s2,a0
 24c:	18050363          	beqz	a0,3d2 <run_command+0x360>
			wait(0);
 250:	4501                	li	a0,0
 252:	620000ef          	jal	872 <wait>
			fprintf(2, "Sequenced: <S>%s<E>\n", &buf[sequence_cmd]);
 256:	ef843783          	ld	a5,-264(s0)
 25a:	94be                	add	s1,s1,a5
 25c:	8626                	mv	a2,s1
 25e:	00001597          	auipc	a1,0x1
 262:	c9258593          	addi	a1,a1,-878 # ef0 <malloc+0x1ba>
 266:	4509                	li	a0,2
 268:	1f1000ef          	jal	c58 <fprintf>
			run_command(&buf[sequence_cmd], nbuf - sequence_cmd, pcp);
 26c:	f0043603          	ld	a2,-256(s0)
 270:	413b05bb          	subw	a1,s6,s3
 274:	8526                	mv	a0,s1
 276:	dfdff0ef          	jal	72 <run_command>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 27a:	f2043703          	ld	a4,-224(s0)
 27e:	14070663          	beqz	a4,3ca <run_command+0x358>
				if (strcmp(&buf[i], "") != 0){
 282:	e791                	bnez	a5,28e <run_command+0x21c>
					fprintf(2, "file_name_r: <S>%s<E>\n", file_name_r);
 284:	8a4a                	mv	s4,s2
 286:	8aca                	mv	s5,s2
 288:	f3243023          	sd	s2,-224(s0)
 28c:	a03d                	j	2ba <run_command+0x248>
					arguments[numargs++] = &buf[i]; // Save word string to arguments
 28e:	f1843703          	ld	a4,-232(s0)
 292:	00371793          	slli	a5,a4,0x3
 296:	f9078793          	addi	a5,a5,-112
 29a:	97a2                	add	a5,a5,s0
 29c:	f2843683          	ld	a3,-216(s0)
 2a0:	fad7b823          	sd	a3,-80(a5)
 2a4:	0017079b          	addiw	a5,a4,1
 2a8:	f0f43c23          	sd	a5,-232(s0)
 2ac:	bfe1                	j	284 <run_command+0x212>
			if (!file_name_l && redirection_left){ // if left redirection
 2ae:	f0843703          	ld	a4,-248(s0)
 2b2:	cf31                	beqz	a4,30e <run_command+0x29c>
			if (!file_name_r && redirection_right){
 2b4:	f1043783          	ld	a5,-240(s0)
 2b8:	c3dd                	beqz	a5,35e <run_command+0x2ec>
	for (int i = 0; i < nbuf; i++){
 2ba:	2985                	addiw	s3,s3,1
 2bc:	0485                	addi	s1,s1,1
 2be:	273b0463          	beq	s6,s3,526 <run_command+0x4b4>
		if (buf[i] == '<'){
 2c2:	f2943423          	sd	s1,-216(s0)
 2c6:	0004c783          	lbu	a5,0(s1)
 2ca:	e37788e3          	beq	a5,s7,fa <run_command+0x88>
		if (buf[i] == '>'){
 2ce:	e58781e3          	beq	a5,s8,110 <run_command+0x9e>
		if (buf[i] == '|'){
 2d2:	e5978ce3          	beq	a5,s9,12a <run_command+0xb8>
		if (buf[i] == ';'){
 2d6:	f3a78fe3          	beq	a5,s10,214 <run_command+0x1a2>
		if (!(redirection_left || redirection_right)){
 2da:	014ae933          	or	s2,s5,s4
 2de:	2901                	sext.w	s2,s2
 2e0:	fc0917e3          	bnez	s2,2ae <run_command+0x23c>
			if ((buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\n' || buf[i] == 13)){
 2e4:	02000713          	li	a4,32
 2e8:	24f76963          	bltu	a4,a5,53a <run_command+0x4c8>
 2ec:	00fdd733          	srl	a4,s11,a5
 2f0:	8b05                	andi	a4,a4,1
 2f2:	d741                	beqz	a4,27a <run_command+0x208>
				if (ws) continue; // skip this iteration if it's a start of word is whitespace
 2f4:	f2043783          	ld	a5,-224(s0)
 2f8:	e7f1                	bnez	a5,3c4 <run_command+0x352>
				buf[i] = 0; // null terminate
 2fa:	f2843703          	ld	a4,-216(s0)
 2fe:	00070023          	sb	zero,0(a4)
 302:	8a3e                	mv	s4,a5
 304:	8abe                	mv	s5,a5
				ws = 1; // start a new word
 306:	4785                	li	a5,1
 308:	f2f43023          	sd	a5,-224(s0)
 30c:	b77d                	j	2ba <run_command+0x248>
			if (!file_name_l && redirection_left){ // if left redirection
 30e:	200a8663          	beqz	s5,51a <run_command+0x4a8>
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 312:	02000713          	li	a4,32
 316:	00f76a63          	bltu	a4,a5,32a <run_command+0x2b8>
 31a:	00800737          	lui	a4,0x800
 31e:	074d                	addi	a4,a4,19 # 800013 <base+0x7fdf9b>
 320:	0726                	slli	a4,a4,0x9
 322:	00f75733          	srl	a4,a4,a5
 326:	8b05                	andi	a4,a4,1
 328:	f751                	bnez	a4,2b4 <run_command+0x242>
					file_name_l[strlen(file_name_l) - 1] = 0; // Remove trailing newline
 32a:	f2843503          	ld	a0,-216(s0)
 32e:	32c000ef          	jal	65a <strlen>
 332:	fff5079b          	addiw	a5,a0,-1
 336:	1782                	slli	a5,a5,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	f2843703          	ld	a4,-216(s0)
 33e:	97ba                	add	a5,a5,a4
 340:	00078023          	sb	zero,0(a5)
					fprintf(2, "file_name_l: <S>%s<E>\n", file_name_l);
 344:	863a                	mv	a2,a4
 346:	00001597          	auipc	a1,0x1
 34a:	b7a58593          	addi	a1,a1,-1158 # ec0 <malloc+0x18a>
 34e:	4509                	li	a0,2
 350:	109000ef          	jal	c58 <fprintf>
					file_name_l = &buf[i]; // capture string
 354:	f2843703          	ld	a4,-216(s0)
 358:	f0e43423          	sd	a4,-248(s0)
 35c:	bfa1                	j	2b4 <run_command+0x242>
			if (!file_name_r && redirection_right){
 35e:	f40a0ee3          	beqz	s4,2ba <run_command+0x248>
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 362:	f2843783          	ld	a5,-216(s0)
 366:	0007c703          	lbu	a4,0(a5)
 36a:	02000793          	li	a5,32
 36e:	02e7e363          	bltu	a5,a4,394 <run_command+0x322>
 372:	008007b7          	lui	a5,0x800
 376:	07cd                	addi	a5,a5,19 # 800013 <base+0x7fdf9b>
 378:	07a6                	slli	a5,a5,0x9
 37a:	00e7d7b3          	srl	a5,a5,a4
 37e:	8b85                	andi	a5,a5,1
 380:	cb91                	beqz	a5,394 <run_command+0x322>
 382:	8a4a                	mv	s4,s2
 384:	f0043823          	sd	zero,-240(s0)
 388:	bf0d                	j	2ba <run_command+0x248>
			if (!file_name_r && redirection_right){
 38a:	f1043783          	ld	a5,-240(s0)
 38e:	f0f43423          	sd	a5,-248(s0)
 392:	bfc1                	j	362 <run_command+0x2f0>
					file_name_r[strlen(file_name_r) - 1] = 0; // Remove trailing newline
 394:	f2843a03          	ld	s4,-216(s0)
 398:	8552                	mv	a0,s4
 39a:	2c0000ef          	jal	65a <strlen>
 39e:	fff5079b          	addiw	a5,a0,-1
 3a2:	1782                	slli	a5,a5,0x20
 3a4:	9381                	srli	a5,a5,0x20
 3a6:	97d2                	add	a5,a5,s4
 3a8:	00078023          	sb	zero,0(a5)
					fprintf(2, "file_name_r: <S>%s<E>\n", file_name_r);
 3ac:	8652                	mv	a2,s4
 3ae:	00001597          	auipc	a1,0x1
 3b2:	b2a58593          	addi	a1,a1,-1238 # ed8 <malloc+0x1a2>
 3b6:	4509                	li	a0,2
 3b8:	0a1000ef          	jal	c58 <fprintf>
					file_name_r = &buf[i];
 3bc:	f1443823          	sd	s4,-240(s0)
					fprintf(2, "file_name_r: <S>%s<E>\n", file_name_r);
 3c0:	8a4a                	mv	s4,s2
 3c2:	bde5                	j	2ba <run_command+0x248>
 3c4:	8a4a                	mv	s4,s2
 3c6:	8aca                	mv	s5,s2
 3c8:	bdcd                	j	2ba <run_command+0x248>
 3ca:	f2043a83          	ld	s5,-224(s0)
 3ce:	8a56                	mv	s4,s5
 3d0:	b5ed                	j	2ba <run_command+0x248>
		wait(0);
 3d2:	4501                	li	a0,0
 3d4:	49e000ef          	jal	872 <wait>
 3d8:	84ca                	mv	s1,s2
 3da:	bbb5                	j	156 <run_command+0xe4>
		close(0); // close stdin
 3dc:	4501                	li	a0,0
 3de:	4b4000ef          	jal	892 <close>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
 3e2:	4581                	li	a1,0
 3e4:	f0843503          	ld	a0,-248(s0)
 3e8:	4c2000ef          	jal	8aa <open>
 3ec:	d60557e3          	bgez	a0,15a <run_command+0xe8>
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_l);
 3f0:	f0843603          	ld	a2,-248(s0)
 3f4:	00001597          	auipc	a1,0x1
 3f8:	b1458593          	addi	a1,a1,-1260 # f08 <malloc+0x1d2>
 3fc:	4509                	li	a0,2
 3fe:	05b000ef          	jal	c58 <fprintf>
			exit(1); // quit
 402:	4505                	li	a0,1
 404:	466000ef          	jal	86a <exit>
		close(1); // close stdout
 408:	4505                	li	a0,1
 40a:	488000ef          	jal	892 <close>
		if (open(file_name_r, O_WRONLY|O_CREATE|O_TRUNC) < 0){ // open our file with fd of 1
 40e:	60100593          	li	a1,1537
 412:	f1043503          	ld	a0,-240(s0)
 416:	494000ef          	jal	8aa <open>
 41a:	d40552e3          	bgez	a0,15e <run_command+0xec>
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_r);
 41e:	f1043603          	ld	a2,-240(s0)
 422:	00001597          	auipc	a1,0x1
 426:	ae658593          	addi	a1,a1,-1306 # f08 <malloc+0x1d2>
 42a:	4509                	li	a0,2
 42c:	02d000ef          	jal	c58 <fprintf>
			exit(1); // quit
 430:	4505                	li	a0,1
 432:	438000ef          	jal	86a <exit>
		write(pcp[1], arguments[1], strlen(arguments[1]));
 436:	f0043783          	ld	a5,-256(s0)
 43a:	0047a903          	lw	s2,4(a5)
 43e:	f4843483          	ld	s1,-184(s0)
 442:	8526                	mv	a0,s1
 444:	216000ef          	jal	65a <strlen>
 448:	0005061b          	sext.w	a2,a0
 44c:	85a6                	mv	a1,s1
 44e:	854a                	mv	a0,s2
 450:	43a000ef          	jal	88a <write>
		exit(2);
 454:	4509                	li	a0,2
 456:	414000ef          	jal	86a <exit>
			}
			if (fork() == 0){ // Handle right side recursively
 45a:	408000ef          	jal	862 <fork>
 45e:	e90d                	bnez	a0,490 <run_command+0x41e>
				close(0); // close stdin
 460:	432000ef          	jal	892 <close>
				dup(p[0]); // Make "out" part of pipe to be stdin
 464:	f3842503          	lw	a0,-200(s0)
 468:	47a000ef          	jal	8e2 <dup>

				close(p[1]);
 46c:	f3c42503          	lw	a0,-196(s0)
 470:	422000ef          	jal	892 <close>
				close(p[0]);
 474:	f3842503          	lw	a0,-200(s0)
 478:	41a000ef          	jal	892 <close>

				run_command(&buf[pipe_cmd], nbuf - pipe_cmd, pcp);
 47c:	f0043603          	ld	a2,-256(s0)
 480:	409b05bb          	subw	a1,s6,s1
 484:	ef843783          	ld	a5,-264(s0)
 488:	00978533          	add	a0,a5,s1
 48c:	be7ff0ef          	jal	72 <run_command>
				exit(0);
			}
			wait(0);
 490:	4501                	li	a0,0
 492:	3e0000ef          	jal	872 <wait>
			wait(0);
 496:	4501                	li	a0,0
 498:	3da000ef          	jal	872 <wait>
 49c:	a095                	j	500 <run_command+0x48e>
		}else{ // No pipes as well, just a plain command
			exec(arguments[0], arguments);
 49e:	f4040593          	addi	a1,s0,-192
 4a2:	f4043503          	ld	a0,-192(s0)
 4a6:	3fc000ef          	jal	8a2 <exec>

			// Something went wrong if this part is reached
			fprintf(2, "===============================================\n");
 4aa:	00001597          	auipc	a1,0x1
 4ae:	b1e58593          	addi	a1,a1,-1250 # fc8 <malloc+0x292>
 4b2:	4509                	li	a0,2
 4b4:	7a4000ef          	jal	c58 <fprintf>
			fprintf(2, "DEFAULT:Execution of the command failed:<S>%s<E>\n", arguments[0]);
 4b8:	f4043603          	ld	a2,-192(s0)
 4bc:	00001597          	auipc	a1,0x1
 4c0:	b4458593          	addi	a1,a1,-1212 # 1000 <malloc+0x2ca>
 4c4:	4509                	li	a0,2
 4c6:	792000ef          	jal	c58 <fprintf>
			fprintf(2, "===============================================\n");
 4ca:	00001597          	auipc	a1,0x1
 4ce:	afe58593          	addi	a1,a1,-1282 # fc8 <malloc+0x292>
 4d2:	4509                	li	a0,2
 4d4:	784000ef          	jal	c58 <fprintf>
			for(int j = 0; j < 9; j++){
 4d8:	f4040913          	addi	s2,s0,-192
				fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n",j , arguments[j], numargs);
 4dc:	00001a17          	auipc	s4,0x1
 4e0:	acca0a13          	addi	s4,s4,-1332 # fa8 <malloc+0x272>
			for(int j = 0; j < 9; j++){
 4e4:	49a5                	li	s3,9
				fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n",j , arguments[j], numargs);
 4e6:	f1843703          	ld	a4,-232(s0)
 4ea:	00093683          	ld	a3,0(s2)
 4ee:	8626                	mv	a2,s1
 4f0:	85d2                	mv	a1,s4
 4f2:	4509                	li	a0,2
 4f4:	764000ef          	jal	c58 <fprintf>
			for(int j = 0; j < 9; j++){
 4f8:	2485                	addiw	s1,s1,1
 4fa:	0921                	addi	s2,s2,8
 4fc:	ff3495e3          	bne	s1,s3,4e6 <run_command+0x474>
			}	
		}
	}
	exit(0);
 500:	4501                	li	a0,0
 502:	368000ef          	jal	86a <exit>
	char* file_name_r = 0; // Buffer to store name of file on the right
 506:	f0043823          	sd	zero,-240(s0)
	char* file_name_l = 0; // Buffer to store name of file on the left
 50a:	f0043423          	sd	zero,-248(s0)
	int redirection_right = 0; // >
 50e:	4a01                	li	s4,0
	int redirection_left = 0; // <
 510:	4a81                	li	s5,0
	int numargs = 0; // number of arguments
 512:	f0043c23          	sd	zero,-232(s0)
	int pipe_cmd = 0; // stores the location where | operator occurs
 516:	4481                	li	s1,0
 518:	b13d                	j	146 <run_command+0xd4>
			if (!file_name_r && redirection_right){
 51a:	f1043783          	ld	a5,-240(s0)
 51e:	e60786e3          	beqz	a5,38a <run_command+0x318>
 522:	8a4a                	mv	s4,s2
 524:	bb59                	j	2ba <run_command+0x248>
	arguments[numargs] = 0; // NULL terminate for exec() to work
 526:	f1843783          	ld	a5,-232(s0)
 52a:	078e                	slli	a5,a5,0x3
 52c:	f9078793          	addi	a5,a5,-112
 530:	97a2                	add	a5,a5,s0
 532:	fa07b823          	sd	zero,-80(a5)
 536:	4481                	li	s1,0
 538:	b939                	j	156 <run_command+0xe4>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 53a:	f2043783          	ld	a5,-224(s0)
 53e:	d40798e3          	bnez	a5,28e <run_command+0x21c>
 542:	8a3e                	mv	s4,a5
 544:	8abe                	mv	s5,a5
 546:	bb95                	j	2ba <run_command+0x248>

0000000000000548 <main>:


// Purpose: Repeatedly prompt user for input, forks process to run commands,
// and handle the chdir special case.

int main(void){
 548:	7135                	addi	sp,sp,-160
 54a:	ed06                	sd	ra,152(sp)
 54c:	e922                	sd	s0,144(sp)
 54e:	e526                	sd	s1,136(sp)
 550:	e14a                	sd	s2,128(sp)
 552:	1100                	addi	s0,sp,160
	
	static char buf[100];

	// Setup a pipe
	int pcp[2];
	pipe(pcp);
 554:	fd840513          	addi	a0,s0,-40
 558:	322000ef          	jal	87a <pipe>

	int fd;

	// Make sure file descriptors are open
	// Taken from source 1
	while((fd = open("console", O_RDWR)) >= 0){
 55c:	00001497          	auipc	s1,0x1
 560:	adc48493          	addi	s1,s1,-1316 # 1038 <malloc+0x302>
 564:	4589                	li	a1,2
 566:	8526                	mv	a0,s1
 568:	342000ef          	jal	8aa <open>
 56c:	00054763          	bltz	a0,57a <main+0x32>
		if(fd >= 3){
 570:	4789                	li	a5,2
 572:	fea7d9e3          	bge	a5,a0,564 <main+0x1c>
			close(fd); // close 0, 1 and 2 and it will reopen itself
 576:	31c000ef          	jal	892 <close>
			break;
		}
	}
	
	// Main Loop
	while(getcmd(buf, sizeof(buf)) >= 0){
 57a:	00002497          	auipc	s1,0x2
 57e:	a9648493          	addi	s1,s1,-1386 # 2010 <buf.0>
		
		int child_status;

		wait(&child_status);

		if (child_status == 2){ // CD command is detected, must execute in parent
 582:	4909                	li	s2,2
	while(getcmd(buf, sizeof(buf)) >= 0){
 584:	06400593          	li	a1,100
 588:	8526                	mv	a0,s1
 58a:	a77ff0ef          	jal	0 <getcmd>
 58e:	06054663          	bltz	a0,5fa <main+0xb2>
		if (fork() == 0){
 592:	2d0000ef          	jal	862 <fork>
 596:	cd1d                	beqz	a0,5d4 <main+0x8c>
		wait(&child_status);
 598:	f6c40513          	addi	a0,s0,-148
 59c:	2d6000ef          	jal	872 <wait>
		if (child_status == 2){ // CD command is detected, must execute in parent
 5a0:	f6c42783          	lw	a5,-148(s0)
 5a4:	ff2790e3          	bne	a5,s2,584 <main+0x3c>
			char buffer_cd_arg[100];
			// Read from pipe the pathname to cd
			read(pcp[0], buffer_cd_arg, sizeof(buffer_cd_arg));
 5a8:	06400613          	li	a2,100
 5ac:	f7040593          	addi	a1,s0,-144
 5b0:	fd842503          	lw	a0,-40(s0)
 5b4:	2ce000ef          	jal	882 <read>
			
			// Attempt to use chdir system call
			if (chdir(buffer_cd_arg) < 0){
 5b8:	f7040513          	addi	a0,s0,-144
 5bc:	31e000ef          	jal	8da <chdir>
 5c0:	fc0552e3          	bgez	a0,584 <main+0x3c>
				fprintf(2, "Failed to change directory\n");
 5c4:	00001597          	auipc	a1,0x1
 5c8:	a9458593          	addi	a1,a1,-1388 # 1058 <malloc+0x322>
 5cc:	4509                	li	a0,2
 5ce:	68a000ef          	jal	c58 <fprintf>
 5d2:	bf4d                	j	584 <main+0x3c>
			fprintf(2, "main_child: <S>%s<S>", buf);
 5d4:	00002497          	auipc	s1,0x2
 5d8:	a3c48493          	addi	s1,s1,-1476 # 2010 <buf.0>
 5dc:	8626                	mv	a2,s1
 5de:	00001597          	auipc	a1,0x1
 5e2:	a6258593          	addi	a1,a1,-1438 # 1040 <malloc+0x30a>
 5e6:	4509                	li	a0,2
 5e8:	670000ef          	jal	c58 <fprintf>
			run_command(buf, 100, pcp);
 5ec:	fd840613          	addi	a2,s0,-40
 5f0:	06400593          	li	a1,100
 5f4:	8526                	mv	a0,s1
 5f6:	a7dff0ef          	jal	72 <run_command>
			}	
		}
	}
	exit(0);
 5fa:	4501                	li	a0,0
 5fc:	26e000ef          	jal	86a <exit>

0000000000000600 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 600:	1141                	addi	sp,sp,-16
 602:	e406                	sd	ra,8(sp)
 604:	e022                	sd	s0,0(sp)
 606:	0800                	addi	s0,sp,16
  extern int main();
  main();
 608:	f41ff0ef          	jal	548 <main>
  exit(0);
 60c:	4501                	li	a0,0
 60e:	25c000ef          	jal	86a <exit>

0000000000000612 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 612:	1141                	addi	sp,sp,-16
 614:	e422                	sd	s0,8(sp)
 616:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 618:	87aa                	mv	a5,a0
 61a:	0585                	addi	a1,a1,1
 61c:	0785                	addi	a5,a5,1
 61e:	fff5c703          	lbu	a4,-1(a1)
 622:	fee78fa3          	sb	a4,-1(a5)
 626:	fb75                	bnez	a4,61a <strcpy+0x8>
    ;
  return os;
}
 628:	6422                	ld	s0,8(sp)
 62a:	0141                	addi	sp,sp,16
 62c:	8082                	ret

000000000000062e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e422                	sd	s0,8(sp)
 632:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 634:	00054783          	lbu	a5,0(a0)
 638:	cb91                	beqz	a5,64c <strcmp+0x1e>
 63a:	0005c703          	lbu	a4,0(a1)
 63e:	00f71763          	bne	a4,a5,64c <strcmp+0x1e>
    p++, q++;
 642:	0505                	addi	a0,a0,1
 644:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 646:	00054783          	lbu	a5,0(a0)
 64a:	fbe5                	bnez	a5,63a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 64c:	0005c503          	lbu	a0,0(a1)
}
 650:	40a7853b          	subw	a0,a5,a0
 654:	6422                	ld	s0,8(sp)
 656:	0141                	addi	sp,sp,16
 658:	8082                	ret

000000000000065a <strlen>:

uint
strlen(const char *s)
{
 65a:	1141                	addi	sp,sp,-16
 65c:	e422                	sd	s0,8(sp)
 65e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 660:	00054783          	lbu	a5,0(a0)
 664:	cf91                	beqz	a5,680 <strlen+0x26>
 666:	0505                	addi	a0,a0,1
 668:	87aa                	mv	a5,a0
 66a:	86be                	mv	a3,a5
 66c:	0785                	addi	a5,a5,1
 66e:	fff7c703          	lbu	a4,-1(a5)
 672:	ff65                	bnez	a4,66a <strlen+0x10>
 674:	40a6853b          	subw	a0,a3,a0
 678:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 67a:	6422                	ld	s0,8(sp)
 67c:	0141                	addi	sp,sp,16
 67e:	8082                	ret
  for(n = 0; s[n]; n++)
 680:	4501                	li	a0,0
 682:	bfe5                	j	67a <strlen+0x20>

0000000000000684 <memset>:

void*
memset(void *dst, int c, uint n)
{
 684:	1141                	addi	sp,sp,-16
 686:	e422                	sd	s0,8(sp)
 688:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 68a:	ca19                	beqz	a2,6a0 <memset+0x1c>
 68c:	87aa                	mv	a5,a0
 68e:	1602                	slli	a2,a2,0x20
 690:	9201                	srli	a2,a2,0x20
 692:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 696:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 69a:	0785                	addi	a5,a5,1
 69c:	fee79de3          	bne	a5,a4,696 <memset+0x12>
  }
  return dst;
}
 6a0:	6422                	ld	s0,8(sp)
 6a2:	0141                	addi	sp,sp,16
 6a4:	8082                	ret

00000000000006a6 <strchr>:

char*
strchr(const char *s, char c)
{
 6a6:	1141                	addi	sp,sp,-16
 6a8:	e422                	sd	s0,8(sp)
 6aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 6ac:	00054783          	lbu	a5,0(a0)
 6b0:	cb99                	beqz	a5,6c6 <strchr+0x20>
    if(*s == c)
 6b2:	00f58763          	beq	a1,a5,6c0 <strchr+0x1a>
  for(; *s; s++)
 6b6:	0505                	addi	a0,a0,1
 6b8:	00054783          	lbu	a5,0(a0)
 6bc:	fbfd                	bnez	a5,6b2 <strchr+0xc>
      return (char*)s;
  return 0;
 6be:	4501                	li	a0,0
}
 6c0:	6422                	ld	s0,8(sp)
 6c2:	0141                	addi	sp,sp,16
 6c4:	8082                	ret
  return 0;
 6c6:	4501                	li	a0,0
 6c8:	bfe5                	j	6c0 <strchr+0x1a>

00000000000006ca <gets>:

char*
gets(char *buf, int max)
{
 6ca:	711d                	addi	sp,sp,-96
 6cc:	ec86                	sd	ra,88(sp)
 6ce:	e8a2                	sd	s0,80(sp)
 6d0:	e4a6                	sd	s1,72(sp)
 6d2:	e0ca                	sd	s2,64(sp)
 6d4:	fc4e                	sd	s3,56(sp)
 6d6:	f852                	sd	s4,48(sp)
 6d8:	f456                	sd	s5,40(sp)
 6da:	f05a                	sd	s6,32(sp)
 6dc:	ec5e                	sd	s7,24(sp)
 6de:	1080                	addi	s0,sp,96
 6e0:	8baa                	mv	s7,a0
 6e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6e4:	892a                	mv	s2,a0
 6e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 6e8:	4aa9                	li	s5,10
 6ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 6ec:	89a6                	mv	s3,s1
 6ee:	2485                	addiw	s1,s1,1
 6f0:	0344d663          	bge	s1,s4,71c <gets+0x52>
    cc = read(0, &c, 1);
 6f4:	4605                	li	a2,1
 6f6:	faf40593          	addi	a1,s0,-81
 6fa:	4501                	li	a0,0
 6fc:	186000ef          	jal	882 <read>
    if(cc < 1)
 700:	00a05e63          	blez	a0,71c <gets+0x52>
    buf[i++] = c;
 704:	faf44783          	lbu	a5,-81(s0)
 708:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 70c:	01578763          	beq	a5,s5,71a <gets+0x50>
 710:	0905                	addi	s2,s2,1
 712:	fd679de3          	bne	a5,s6,6ec <gets+0x22>
    buf[i++] = c;
 716:	89a6                	mv	s3,s1
 718:	a011                	j	71c <gets+0x52>
 71a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 71c:	99de                	add	s3,s3,s7
 71e:	00098023          	sb	zero,0(s3)
  return buf;
}
 722:	855e                	mv	a0,s7
 724:	60e6                	ld	ra,88(sp)
 726:	6446                	ld	s0,80(sp)
 728:	64a6                	ld	s1,72(sp)
 72a:	6906                	ld	s2,64(sp)
 72c:	79e2                	ld	s3,56(sp)
 72e:	7a42                	ld	s4,48(sp)
 730:	7aa2                	ld	s5,40(sp)
 732:	7b02                	ld	s6,32(sp)
 734:	6be2                	ld	s7,24(sp)
 736:	6125                	addi	sp,sp,96
 738:	8082                	ret

000000000000073a <stat>:

int
stat(const char *n, struct stat *st)
{
 73a:	1101                	addi	sp,sp,-32
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	e04a                	sd	s2,0(sp)
 742:	1000                	addi	s0,sp,32
 744:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 746:	4581                	li	a1,0
 748:	162000ef          	jal	8aa <open>
  if(fd < 0)
 74c:	02054263          	bltz	a0,770 <stat+0x36>
 750:	e426                	sd	s1,8(sp)
 752:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 754:	85ca                	mv	a1,s2
 756:	16c000ef          	jal	8c2 <fstat>
 75a:	892a                	mv	s2,a0
  close(fd);
 75c:	8526                	mv	a0,s1
 75e:	134000ef          	jal	892 <close>
  return r;
 762:	64a2                	ld	s1,8(sp)
}
 764:	854a                	mv	a0,s2
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6902                	ld	s2,0(sp)
 76c:	6105                	addi	sp,sp,32
 76e:	8082                	ret
    return -1;
 770:	597d                	li	s2,-1
 772:	bfcd                	j	764 <stat+0x2a>

0000000000000774 <atoi>:

int
atoi(const char *s)
{
 774:	1141                	addi	sp,sp,-16
 776:	e422                	sd	s0,8(sp)
 778:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 77a:	00054683          	lbu	a3,0(a0)
 77e:	fd06879b          	addiw	a5,a3,-48
 782:	0ff7f793          	zext.b	a5,a5
 786:	4625                	li	a2,9
 788:	02f66863          	bltu	a2,a5,7b8 <atoi+0x44>
 78c:	872a                	mv	a4,a0
  n = 0;
 78e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 790:	0705                	addi	a4,a4,1
 792:	0025179b          	slliw	a5,a0,0x2
 796:	9fa9                	addw	a5,a5,a0
 798:	0017979b          	slliw	a5,a5,0x1
 79c:	9fb5                	addw	a5,a5,a3
 79e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 7a2:	00074683          	lbu	a3,0(a4)
 7a6:	fd06879b          	addiw	a5,a3,-48
 7aa:	0ff7f793          	zext.b	a5,a5
 7ae:	fef671e3          	bgeu	a2,a5,790 <atoi+0x1c>
  return n;
}
 7b2:	6422                	ld	s0,8(sp)
 7b4:	0141                	addi	sp,sp,16
 7b6:	8082                	ret
  n = 0;
 7b8:	4501                	li	a0,0
 7ba:	bfe5                	j	7b2 <atoi+0x3e>

00000000000007bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7bc:	1141                	addi	sp,sp,-16
 7be:	e422                	sd	s0,8(sp)
 7c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 7c2:	02b57463          	bgeu	a0,a1,7ea <memmove+0x2e>
    while(n-- > 0)
 7c6:	00c05f63          	blez	a2,7e4 <memmove+0x28>
 7ca:	1602                	slli	a2,a2,0x20
 7cc:	9201                	srli	a2,a2,0x20
 7ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 7d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 7d4:	0585                	addi	a1,a1,1
 7d6:	0705                	addi	a4,a4,1
 7d8:	fff5c683          	lbu	a3,-1(a1)
 7dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 7e0:	fef71ae3          	bne	a4,a5,7d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 7e4:	6422                	ld	s0,8(sp)
 7e6:	0141                	addi	sp,sp,16
 7e8:	8082                	ret
    dst += n;
 7ea:	00c50733          	add	a4,a0,a2
    src += n;
 7ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 7f0:	fec05ae3          	blez	a2,7e4 <memmove+0x28>
 7f4:	fff6079b          	addiw	a5,a2,-1
 7f8:	1782                	slli	a5,a5,0x20
 7fa:	9381                	srli	a5,a5,0x20
 7fc:	fff7c793          	not	a5,a5
 800:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 802:	15fd                	addi	a1,a1,-1
 804:	177d                	addi	a4,a4,-1
 806:	0005c683          	lbu	a3,0(a1)
 80a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 80e:	fee79ae3          	bne	a5,a4,802 <memmove+0x46>
 812:	bfc9                	j	7e4 <memmove+0x28>

0000000000000814 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 814:	1141                	addi	sp,sp,-16
 816:	e422                	sd	s0,8(sp)
 818:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 81a:	ca05                	beqz	a2,84a <memcmp+0x36>
 81c:	fff6069b          	addiw	a3,a2,-1
 820:	1682                	slli	a3,a3,0x20
 822:	9281                	srli	a3,a3,0x20
 824:	0685                	addi	a3,a3,1
 826:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 828:	00054783          	lbu	a5,0(a0)
 82c:	0005c703          	lbu	a4,0(a1)
 830:	00e79863          	bne	a5,a4,840 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 834:	0505                	addi	a0,a0,1
    p2++;
 836:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 838:	fed518e3          	bne	a0,a3,828 <memcmp+0x14>
  }
  return 0;
 83c:	4501                	li	a0,0
 83e:	a019                	j	844 <memcmp+0x30>
      return *p1 - *p2;
 840:	40e7853b          	subw	a0,a5,a4
}
 844:	6422                	ld	s0,8(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret
  return 0;
 84a:	4501                	li	a0,0
 84c:	bfe5                	j	844 <memcmp+0x30>

000000000000084e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 84e:	1141                	addi	sp,sp,-16
 850:	e406                	sd	ra,8(sp)
 852:	e022                	sd	s0,0(sp)
 854:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 856:	f67ff0ef          	jal	7bc <memmove>
}
 85a:	60a2                	ld	ra,8(sp)
 85c:	6402                	ld	s0,0(sp)
 85e:	0141                	addi	sp,sp,16
 860:	8082                	ret

0000000000000862 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 862:	4885                	li	a7,1
 ecall
 864:	00000073          	ecall
 ret
 868:	8082                	ret

000000000000086a <exit>:
.global exit
exit:
 li a7, SYS_exit
 86a:	4889                	li	a7,2
 ecall
 86c:	00000073          	ecall
 ret
 870:	8082                	ret

0000000000000872 <wait>:
.global wait
wait:
 li a7, SYS_wait
 872:	488d                	li	a7,3
 ecall
 874:	00000073          	ecall
 ret
 878:	8082                	ret

000000000000087a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 87a:	4891                	li	a7,4
 ecall
 87c:	00000073          	ecall
 ret
 880:	8082                	ret

0000000000000882 <read>:
.global read
read:
 li a7, SYS_read
 882:	4895                	li	a7,5
 ecall
 884:	00000073          	ecall
 ret
 888:	8082                	ret

000000000000088a <write>:
.global write
write:
 li a7, SYS_write
 88a:	48c1                	li	a7,16
 ecall
 88c:	00000073          	ecall
 ret
 890:	8082                	ret

0000000000000892 <close>:
.global close
close:
 li a7, SYS_close
 892:	48d5                	li	a7,21
 ecall
 894:	00000073          	ecall
 ret
 898:	8082                	ret

000000000000089a <kill>:
.global kill
kill:
 li a7, SYS_kill
 89a:	4899                	li	a7,6
 ecall
 89c:	00000073          	ecall
 ret
 8a0:	8082                	ret

00000000000008a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 8a2:	489d                	li	a7,7
 ecall
 8a4:	00000073          	ecall
 ret
 8a8:	8082                	ret

00000000000008aa <open>:
.global open
open:
 li a7, SYS_open
 8aa:	48bd                	li	a7,15
 ecall
 8ac:	00000073          	ecall
 ret
 8b0:	8082                	ret

00000000000008b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 8b2:	48c5                	li	a7,17
 ecall
 8b4:	00000073          	ecall
 ret
 8b8:	8082                	ret

00000000000008ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 8ba:	48c9                	li	a7,18
 ecall
 8bc:	00000073          	ecall
 ret
 8c0:	8082                	ret

00000000000008c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 8c2:	48a1                	li	a7,8
 ecall
 8c4:	00000073          	ecall
 ret
 8c8:	8082                	ret

00000000000008ca <link>:
.global link
link:
 li a7, SYS_link
 8ca:	48cd                	li	a7,19
 ecall
 8cc:	00000073          	ecall
 ret
 8d0:	8082                	ret

00000000000008d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 8d2:	48d1                	li	a7,20
 ecall
 8d4:	00000073          	ecall
 ret
 8d8:	8082                	ret

00000000000008da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 8da:	48a5                	li	a7,9
 ecall
 8dc:	00000073          	ecall
 ret
 8e0:	8082                	ret

00000000000008e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 8e2:	48a9                	li	a7,10
 ecall
 8e4:	00000073          	ecall
 ret
 8e8:	8082                	ret

00000000000008ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 8ea:	48ad                	li	a7,11
 ecall
 8ec:	00000073          	ecall
 ret
 8f0:	8082                	ret

00000000000008f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 8f2:	48b1                	li	a7,12
 ecall
 8f4:	00000073          	ecall
 ret
 8f8:	8082                	ret

00000000000008fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 8fa:	48b5                	li	a7,13
 ecall
 8fc:	00000073          	ecall
 ret
 900:	8082                	ret

0000000000000902 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 902:	48b9                	li	a7,14
 ecall
 904:	00000073          	ecall
 ret
 908:	8082                	ret

000000000000090a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 90a:	1101                	addi	sp,sp,-32
 90c:	ec06                	sd	ra,24(sp)
 90e:	e822                	sd	s0,16(sp)
 910:	1000                	addi	s0,sp,32
 912:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 916:	4605                	li	a2,1
 918:	fef40593          	addi	a1,s0,-17
 91c:	f6fff0ef          	jal	88a <write>
}
 920:	60e2                	ld	ra,24(sp)
 922:	6442                	ld	s0,16(sp)
 924:	6105                	addi	sp,sp,32
 926:	8082                	ret

0000000000000928 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 928:	7139                	addi	sp,sp,-64
 92a:	fc06                	sd	ra,56(sp)
 92c:	f822                	sd	s0,48(sp)
 92e:	f426                	sd	s1,40(sp)
 930:	0080                	addi	s0,sp,64
 932:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 934:	c299                	beqz	a3,93a <printint+0x12>
 936:	0805c963          	bltz	a1,9c8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 93a:	2581                	sext.w	a1,a1
  neg = 0;
 93c:	4881                	li	a7,0
 93e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 942:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 944:	2601                	sext.w	a2,a2
 946:	00000517          	auipc	a0,0x0
 94a:	73a50513          	addi	a0,a0,1850 # 1080 <digits>
 94e:	883a                	mv	a6,a4
 950:	2705                	addiw	a4,a4,1
 952:	02c5f7bb          	remuw	a5,a1,a2
 956:	1782                	slli	a5,a5,0x20
 958:	9381                	srli	a5,a5,0x20
 95a:	97aa                	add	a5,a5,a0
 95c:	0007c783          	lbu	a5,0(a5)
 960:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 964:	0005879b          	sext.w	a5,a1
 968:	02c5d5bb          	divuw	a1,a1,a2
 96c:	0685                	addi	a3,a3,1
 96e:	fec7f0e3          	bgeu	a5,a2,94e <printint+0x26>
  if(neg)
 972:	00088c63          	beqz	a7,98a <printint+0x62>
    buf[i++] = '-';
 976:	fd070793          	addi	a5,a4,-48
 97a:	00878733          	add	a4,a5,s0
 97e:	02d00793          	li	a5,45
 982:	fef70823          	sb	a5,-16(a4)
 986:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 98a:	02e05a63          	blez	a4,9be <printint+0x96>
 98e:	f04a                	sd	s2,32(sp)
 990:	ec4e                	sd	s3,24(sp)
 992:	fc040793          	addi	a5,s0,-64
 996:	00e78933          	add	s2,a5,a4
 99a:	fff78993          	addi	s3,a5,-1
 99e:	99ba                	add	s3,s3,a4
 9a0:	377d                	addiw	a4,a4,-1
 9a2:	1702                	slli	a4,a4,0x20
 9a4:	9301                	srli	a4,a4,0x20
 9a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 9aa:	fff94583          	lbu	a1,-1(s2)
 9ae:	8526                	mv	a0,s1
 9b0:	f5bff0ef          	jal	90a <putc>
  while(--i >= 0)
 9b4:	197d                	addi	s2,s2,-1
 9b6:	ff391ae3          	bne	s2,s3,9aa <printint+0x82>
 9ba:	7902                	ld	s2,32(sp)
 9bc:	69e2                	ld	s3,24(sp)
}
 9be:	70e2                	ld	ra,56(sp)
 9c0:	7442                	ld	s0,48(sp)
 9c2:	74a2                	ld	s1,40(sp)
 9c4:	6121                	addi	sp,sp,64
 9c6:	8082                	ret
    x = -xx;
 9c8:	40b005bb          	negw	a1,a1
    neg = 1;
 9cc:	4885                	li	a7,1
    x = -xx;
 9ce:	bf85                	j	93e <printint+0x16>

00000000000009d0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 9d0:	711d                	addi	sp,sp,-96
 9d2:	ec86                	sd	ra,88(sp)
 9d4:	e8a2                	sd	s0,80(sp)
 9d6:	e0ca                	sd	s2,64(sp)
 9d8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 9da:	0005c903          	lbu	s2,0(a1)
 9de:	26090863          	beqz	s2,c4e <vprintf+0x27e>
 9e2:	e4a6                	sd	s1,72(sp)
 9e4:	fc4e                	sd	s3,56(sp)
 9e6:	f852                	sd	s4,48(sp)
 9e8:	f456                	sd	s5,40(sp)
 9ea:	f05a                	sd	s6,32(sp)
 9ec:	ec5e                	sd	s7,24(sp)
 9ee:	e862                	sd	s8,16(sp)
 9f0:	e466                	sd	s9,8(sp)
 9f2:	8b2a                	mv	s6,a0
 9f4:	8a2e                	mv	s4,a1
 9f6:	8bb2                	mv	s7,a2
  state = 0;
 9f8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 9fa:	4481                	li	s1,0
 9fc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 9fe:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 a02:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 a06:	06c00c93          	li	s9,108
 a0a:	a005                	j	a2a <vprintf+0x5a>
        putc(fd, c0);
 a0c:	85ca                	mv	a1,s2
 a0e:	855a                	mv	a0,s6
 a10:	efbff0ef          	jal	90a <putc>
 a14:	a019                	j	a1a <vprintf+0x4a>
    } else if(state == '%'){
 a16:	03598263          	beq	s3,s5,a3a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 a1a:	2485                	addiw	s1,s1,1
 a1c:	8726                	mv	a4,s1
 a1e:	009a07b3          	add	a5,s4,s1
 a22:	0007c903          	lbu	s2,0(a5)
 a26:	20090c63          	beqz	s2,c3e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 a2a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 a2e:	fe0994e3          	bnez	s3,a16 <vprintf+0x46>
      if(c0 == '%'){
 a32:	fd579de3          	bne	a5,s5,a0c <vprintf+0x3c>
        state = '%';
 a36:	89be                	mv	s3,a5
 a38:	b7cd                	j	a1a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 a3a:	00ea06b3          	add	a3,s4,a4
 a3e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 a42:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 a44:	c681                	beqz	a3,a4c <vprintf+0x7c>
 a46:	9752                	add	a4,a4,s4
 a48:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 a4c:	03878f63          	beq	a5,s8,a8a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 a50:	05978963          	beq	a5,s9,aa2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 a54:	07500713          	li	a4,117
 a58:	0ee78363          	beq	a5,a4,b3e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 a5c:	07800713          	li	a4,120
 a60:	12e78563          	beq	a5,a4,b8a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a64:	07000713          	li	a4,112
 a68:	14e78a63          	beq	a5,a4,bbc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 a6c:	07300713          	li	a4,115
 a70:	18e78a63          	beq	a5,a4,c04 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 a74:	02500713          	li	a4,37
 a78:	04e79563          	bne	a5,a4,ac2 <vprintf+0xf2>
        putc(fd, '%');
 a7c:	02500593          	li	a1,37
 a80:	855a                	mv	a0,s6
 a82:	e89ff0ef          	jal	90a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 a86:	4981                	li	s3,0
 a88:	bf49                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 a8a:	008b8913          	addi	s2,s7,8
 a8e:	4685                	li	a3,1
 a90:	4629                	li	a2,10
 a92:	000ba583          	lw	a1,0(s7)
 a96:	855a                	mv	a0,s6
 a98:	e91ff0ef          	jal	928 <printint>
 a9c:	8bca                	mv	s7,s2
      state = 0;
 a9e:	4981                	li	s3,0
 aa0:	bfad                	j	a1a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 aa2:	06400793          	li	a5,100
 aa6:	02f68963          	beq	a3,a5,ad8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 aaa:	06c00793          	li	a5,108
 aae:	04f68263          	beq	a3,a5,af2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 ab2:	07500793          	li	a5,117
 ab6:	0af68063          	beq	a3,a5,b56 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 aba:	07800793          	li	a5,120
 abe:	0ef68263          	beq	a3,a5,ba2 <vprintf+0x1d2>
        putc(fd, '%');
 ac2:	02500593          	li	a1,37
 ac6:	855a                	mv	a0,s6
 ac8:	e43ff0ef          	jal	90a <putc>
        putc(fd, c0);
 acc:	85ca                	mv	a1,s2
 ace:	855a                	mv	a0,s6
 ad0:	e3bff0ef          	jal	90a <putc>
      state = 0;
 ad4:	4981                	li	s3,0
 ad6:	b791                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 ad8:	008b8913          	addi	s2,s7,8
 adc:	4685                	li	a3,1
 ade:	4629                	li	a2,10
 ae0:	000ba583          	lw	a1,0(s7)
 ae4:	855a                	mv	a0,s6
 ae6:	e43ff0ef          	jal	928 <printint>
        i += 1;
 aea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 aec:	8bca                	mv	s7,s2
      state = 0;
 aee:	4981                	li	s3,0
        i += 1;
 af0:	b72d                	j	a1a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 af2:	06400793          	li	a5,100
 af6:	02f60763          	beq	a2,a5,b24 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 afa:	07500793          	li	a5,117
 afe:	06f60963          	beq	a2,a5,b70 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 b02:	07800793          	li	a5,120
 b06:	faf61ee3          	bne	a2,a5,ac2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b0a:	008b8913          	addi	s2,s7,8
 b0e:	4681                	li	a3,0
 b10:	4641                	li	a2,16
 b12:	000ba583          	lw	a1,0(s7)
 b16:	855a                	mv	a0,s6
 b18:	e11ff0ef          	jal	928 <printint>
        i += 2;
 b1c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 b1e:	8bca                	mv	s7,s2
      state = 0;
 b20:	4981                	li	s3,0
        i += 2;
 b22:	bde5                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 b24:	008b8913          	addi	s2,s7,8
 b28:	4685                	li	a3,1
 b2a:	4629                	li	a2,10
 b2c:	000ba583          	lw	a1,0(s7)
 b30:	855a                	mv	a0,s6
 b32:	df7ff0ef          	jal	928 <printint>
        i += 2;
 b36:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 b38:	8bca                	mv	s7,s2
      state = 0;
 b3a:	4981                	li	s3,0
        i += 2;
 b3c:	bdf9                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 b3e:	008b8913          	addi	s2,s7,8
 b42:	4681                	li	a3,0
 b44:	4629                	li	a2,10
 b46:	000ba583          	lw	a1,0(s7)
 b4a:	855a                	mv	a0,s6
 b4c:	dddff0ef          	jal	928 <printint>
 b50:	8bca                	mv	s7,s2
      state = 0;
 b52:	4981                	li	s3,0
 b54:	b5d9                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b56:	008b8913          	addi	s2,s7,8
 b5a:	4681                	li	a3,0
 b5c:	4629                	li	a2,10
 b5e:	000ba583          	lw	a1,0(s7)
 b62:	855a                	mv	a0,s6
 b64:	dc5ff0ef          	jal	928 <printint>
        i += 1;
 b68:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b6a:	8bca                	mv	s7,s2
      state = 0;
 b6c:	4981                	li	s3,0
        i += 1;
 b6e:	b575                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b70:	008b8913          	addi	s2,s7,8
 b74:	4681                	li	a3,0
 b76:	4629                	li	a2,10
 b78:	000ba583          	lw	a1,0(s7)
 b7c:	855a                	mv	a0,s6
 b7e:	dabff0ef          	jal	928 <printint>
        i += 2;
 b82:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b84:	8bca                	mv	s7,s2
      state = 0;
 b86:	4981                	li	s3,0
        i += 2;
 b88:	bd49                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 b8a:	008b8913          	addi	s2,s7,8
 b8e:	4681                	li	a3,0
 b90:	4641                	li	a2,16
 b92:	000ba583          	lw	a1,0(s7)
 b96:	855a                	mv	a0,s6
 b98:	d91ff0ef          	jal	928 <printint>
 b9c:	8bca                	mv	s7,s2
      state = 0;
 b9e:	4981                	li	s3,0
 ba0:	bdad                	j	a1a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ba2:	008b8913          	addi	s2,s7,8
 ba6:	4681                	li	a3,0
 ba8:	4641                	li	a2,16
 baa:	000ba583          	lw	a1,0(s7)
 bae:	855a                	mv	a0,s6
 bb0:	d79ff0ef          	jal	928 <printint>
        i += 1;
 bb4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 bb6:	8bca                	mv	s7,s2
      state = 0;
 bb8:	4981                	li	s3,0
        i += 1;
 bba:	b585                	j	a1a <vprintf+0x4a>
 bbc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 bbe:	008b8d13          	addi	s10,s7,8
 bc2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 bc6:	03000593          	li	a1,48
 bca:	855a                	mv	a0,s6
 bcc:	d3fff0ef          	jal	90a <putc>
  putc(fd, 'x');
 bd0:	07800593          	li	a1,120
 bd4:	855a                	mv	a0,s6
 bd6:	d35ff0ef          	jal	90a <putc>
 bda:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bdc:	00000b97          	auipc	s7,0x0
 be0:	4a4b8b93          	addi	s7,s7,1188 # 1080 <digits>
 be4:	03c9d793          	srli	a5,s3,0x3c
 be8:	97de                	add	a5,a5,s7
 bea:	0007c583          	lbu	a1,0(a5)
 bee:	855a                	mv	a0,s6
 bf0:	d1bff0ef          	jal	90a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bf4:	0992                	slli	s3,s3,0x4
 bf6:	397d                	addiw	s2,s2,-1
 bf8:	fe0916e3          	bnez	s2,be4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 bfc:	8bea                	mv	s7,s10
      state = 0;
 bfe:	4981                	li	s3,0
 c00:	6d02                	ld	s10,0(sp)
 c02:	bd21                	j	a1a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 c04:	008b8993          	addi	s3,s7,8
 c08:	000bb903          	ld	s2,0(s7)
 c0c:	00090f63          	beqz	s2,c2a <vprintf+0x25a>
        for(; *s; s++)
 c10:	00094583          	lbu	a1,0(s2)
 c14:	c195                	beqz	a1,c38 <vprintf+0x268>
          putc(fd, *s);
 c16:	855a                	mv	a0,s6
 c18:	cf3ff0ef          	jal	90a <putc>
        for(; *s; s++)
 c1c:	0905                	addi	s2,s2,1
 c1e:	00094583          	lbu	a1,0(s2)
 c22:	f9f5                	bnez	a1,c16 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 c24:	8bce                	mv	s7,s3
      state = 0;
 c26:	4981                	li	s3,0
 c28:	bbcd                	j	a1a <vprintf+0x4a>
          s = "(null)";
 c2a:	00000917          	auipc	s2,0x0
 c2e:	44e90913          	addi	s2,s2,1102 # 1078 <malloc+0x342>
        for(; *s; s++)
 c32:	02800593          	li	a1,40
 c36:	b7c5                	j	c16 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 c38:	8bce                	mv	s7,s3
      state = 0;
 c3a:	4981                	li	s3,0
 c3c:	bbf9                	j	a1a <vprintf+0x4a>
 c3e:	64a6                	ld	s1,72(sp)
 c40:	79e2                	ld	s3,56(sp)
 c42:	7a42                	ld	s4,48(sp)
 c44:	7aa2                	ld	s5,40(sp)
 c46:	7b02                	ld	s6,32(sp)
 c48:	6be2                	ld	s7,24(sp)
 c4a:	6c42                	ld	s8,16(sp)
 c4c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 c4e:	60e6                	ld	ra,88(sp)
 c50:	6446                	ld	s0,80(sp)
 c52:	6906                	ld	s2,64(sp)
 c54:	6125                	addi	sp,sp,96
 c56:	8082                	ret

0000000000000c58 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c58:	715d                	addi	sp,sp,-80
 c5a:	ec06                	sd	ra,24(sp)
 c5c:	e822                	sd	s0,16(sp)
 c5e:	1000                	addi	s0,sp,32
 c60:	e010                	sd	a2,0(s0)
 c62:	e414                	sd	a3,8(s0)
 c64:	e818                	sd	a4,16(s0)
 c66:	ec1c                	sd	a5,24(s0)
 c68:	03043023          	sd	a6,32(s0)
 c6c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c70:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c74:	8622                	mv	a2,s0
 c76:	d5bff0ef          	jal	9d0 <vprintf>
}
 c7a:	60e2                	ld	ra,24(sp)
 c7c:	6442                	ld	s0,16(sp)
 c7e:	6161                	addi	sp,sp,80
 c80:	8082                	ret

0000000000000c82 <printf>:

void
printf(const char *fmt, ...)
{
 c82:	711d                	addi	sp,sp,-96
 c84:	ec06                	sd	ra,24(sp)
 c86:	e822                	sd	s0,16(sp)
 c88:	1000                	addi	s0,sp,32
 c8a:	e40c                	sd	a1,8(s0)
 c8c:	e810                	sd	a2,16(s0)
 c8e:	ec14                	sd	a3,24(s0)
 c90:	f018                	sd	a4,32(s0)
 c92:	f41c                	sd	a5,40(s0)
 c94:	03043823          	sd	a6,48(s0)
 c98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c9c:	00840613          	addi	a2,s0,8
 ca0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ca4:	85aa                	mv	a1,a0
 ca6:	4505                	li	a0,1
 ca8:	d29ff0ef          	jal	9d0 <vprintf>
}
 cac:	60e2                	ld	ra,24(sp)
 cae:	6442                	ld	s0,16(sp)
 cb0:	6125                	addi	sp,sp,96
 cb2:	8082                	ret

0000000000000cb4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cb4:	1141                	addi	sp,sp,-16
 cb6:	e422                	sd	s0,8(sp)
 cb8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cbe:	00001797          	auipc	a5,0x1
 cc2:	3427b783          	ld	a5,834(a5) # 2000 <freep>
 cc6:	a02d                	j	cf0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cc8:	4618                	lw	a4,8(a2)
 cca:	9f2d                	addw	a4,a4,a1
 ccc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cd0:	6398                	ld	a4,0(a5)
 cd2:	6310                	ld	a2,0(a4)
 cd4:	a83d                	j	d12 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 cd6:	ff852703          	lw	a4,-8(a0)
 cda:	9f31                	addw	a4,a4,a2
 cdc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cde:	ff053683          	ld	a3,-16(a0)
 ce2:	a091                	j	d26 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ce4:	6398                	ld	a4,0(a5)
 ce6:	00e7e463          	bltu	a5,a4,cee <free+0x3a>
 cea:	00e6ea63          	bltu	a3,a4,cfe <free+0x4a>
{
 cee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cf0:	fed7fae3          	bgeu	a5,a3,ce4 <free+0x30>
 cf4:	6398                	ld	a4,0(a5)
 cf6:	00e6e463          	bltu	a3,a4,cfe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cfa:	fee7eae3          	bltu	a5,a4,cee <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 cfe:	ff852583          	lw	a1,-8(a0)
 d02:	6390                	ld	a2,0(a5)
 d04:	02059813          	slli	a6,a1,0x20
 d08:	01c85713          	srli	a4,a6,0x1c
 d0c:	9736                	add	a4,a4,a3
 d0e:	fae60de3          	beq	a2,a4,cc8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d12:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d16:	4790                	lw	a2,8(a5)
 d18:	02061593          	slli	a1,a2,0x20
 d1c:	01c5d713          	srli	a4,a1,0x1c
 d20:	973e                	add	a4,a4,a5
 d22:	fae68ae3          	beq	a3,a4,cd6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 d26:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d28:	00001717          	auipc	a4,0x1
 d2c:	2cf73c23          	sd	a5,728(a4) # 2000 <freep>
}
 d30:	6422                	ld	s0,8(sp)
 d32:	0141                	addi	sp,sp,16
 d34:	8082                	ret

0000000000000d36 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d36:	7139                	addi	sp,sp,-64
 d38:	fc06                	sd	ra,56(sp)
 d3a:	f822                	sd	s0,48(sp)
 d3c:	f426                	sd	s1,40(sp)
 d3e:	ec4e                	sd	s3,24(sp)
 d40:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d42:	02051493          	slli	s1,a0,0x20
 d46:	9081                	srli	s1,s1,0x20
 d48:	04bd                	addi	s1,s1,15
 d4a:	8091                	srli	s1,s1,0x4
 d4c:	0014899b          	addiw	s3,s1,1
 d50:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 d52:	00001517          	auipc	a0,0x1
 d56:	2ae53503          	ld	a0,686(a0) # 2000 <freep>
 d5a:	c915                	beqz	a0,d8e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d5e:	4798                	lw	a4,8(a5)
 d60:	08977a63          	bgeu	a4,s1,df4 <malloc+0xbe>
 d64:	f04a                	sd	s2,32(sp)
 d66:	e852                	sd	s4,16(sp)
 d68:	e456                	sd	s5,8(sp)
 d6a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 d6c:	8a4e                	mv	s4,s3
 d6e:	0009871b          	sext.w	a4,s3
 d72:	6685                	lui	a3,0x1
 d74:	00d77363          	bgeu	a4,a3,d7a <malloc+0x44>
 d78:	6a05                	lui	s4,0x1
 d7a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d7e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d82:	00001917          	auipc	s2,0x1
 d86:	27e90913          	addi	s2,s2,638 # 2000 <freep>
  if(p == (char*)-1)
 d8a:	5afd                	li	s5,-1
 d8c:	a081                	j	dcc <malloc+0x96>
 d8e:	f04a                	sd	s2,32(sp)
 d90:	e852                	sd	s4,16(sp)
 d92:	e456                	sd	s5,8(sp)
 d94:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d96:	00001797          	auipc	a5,0x1
 d9a:	2e278793          	addi	a5,a5,738 # 2078 <base>
 d9e:	00001717          	auipc	a4,0x1
 da2:	26f73123          	sd	a5,610(a4) # 2000 <freep>
 da6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 da8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dac:	b7c1                	j	d6c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 dae:	6398                	ld	a4,0(a5)
 db0:	e118                	sd	a4,0(a0)
 db2:	a8a9                	j	e0c <malloc+0xd6>
  hp->s.size = nu;
 db4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 db8:	0541                	addi	a0,a0,16
 dba:	efbff0ef          	jal	cb4 <free>
  return freep;
 dbe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 dc2:	c12d                	beqz	a0,e24 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dc6:	4798                	lw	a4,8(a5)
 dc8:	02977263          	bgeu	a4,s1,dec <malloc+0xb6>
    if(p == freep)
 dcc:	00093703          	ld	a4,0(s2)
 dd0:	853e                	mv	a0,a5
 dd2:	fef719e3          	bne	a4,a5,dc4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 dd6:	8552                	mv	a0,s4
 dd8:	b1bff0ef          	jal	8f2 <sbrk>
  if(p == (char*)-1)
 ddc:	fd551ce3          	bne	a0,s5,db4 <malloc+0x7e>
        return 0;
 de0:	4501                	li	a0,0
 de2:	7902                	ld	s2,32(sp)
 de4:	6a42                	ld	s4,16(sp)
 de6:	6aa2                	ld	s5,8(sp)
 de8:	6b02                	ld	s6,0(sp)
 dea:	a03d                	j	e18 <malloc+0xe2>
 dec:	7902                	ld	s2,32(sp)
 dee:	6a42                	ld	s4,16(sp)
 df0:	6aa2                	ld	s5,8(sp)
 df2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 df4:	fae48de3          	beq	s1,a4,dae <malloc+0x78>
        p->s.size -= nunits;
 df8:	4137073b          	subw	a4,a4,s3
 dfc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 dfe:	02071693          	slli	a3,a4,0x20
 e02:	01c6d713          	srli	a4,a3,0x1c
 e06:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e08:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e0c:	00001717          	auipc	a4,0x1
 e10:	1ea73a23          	sd	a0,500(a4) # 2000 <freep>
      return (void*)(p + 1);
 e14:	01078513          	addi	a0,a5,16
  }
}
 e18:	70e2                	ld	ra,56(sp)
 e1a:	7442                	ld	s0,48(sp)
 e1c:	74a2                	ld	s1,40(sp)
 e1e:	69e2                	ld	s3,24(sp)
 e20:	6121                	addi	sp,sp,64
 e22:	8082                	ret
 e24:	7902                	ld	s2,32(sp)
 e26:	6a42                	ld	s4,16(sp)
 e28:	6aa2                	ld	s5,8(sp)
 e2a:	6b02                	ld	s6,0(sp)
 e2c:	b7f5                	j	e18 <malloc+0xe2>
