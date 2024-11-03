
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
  16:	e5e58593          	addi	a1,a1,-418 # e70 <malloc+0x102>
  1a:	4509                	li	a0,2
  1c:	0a7000ef          	jal	8c2 <write>
	memset(buf, 0, nbuf);
  20:	864a                	mv	a2,s2
  22:	4581                	li	a1,0
  24:	8526                	mv	a0,s1
  26:	696000ef          	jal	6bc <memset>
	gets(buf, nbuf);
  2a:	85ca                	mv	a1,s2
  2c:	8526                	mv	a0,s1
  2e:	6d4000ef          	jal	702 <gets>

	fprintf(2, "Chars: %d\n", strlen(buf));
  32:	8526                	mv	a0,s1
  34:	65e000ef          	jal	692 <strlen>
  38:	0005061b          	sext.w	a2,a0
  3c:	00001597          	auipc	a1,0x1
  40:	e3c58593          	addi	a1,a1,-452 # e78 <malloc+0x10a>
  44:	4509                	li	a0,2
  46:	44b000ef          	jal	c90 <fprintf>
	fprintf(2, "Buf: %s\n", buf);
  4a:	8626                	mv	a2,s1
  4c:	00001597          	auipc	a1,0x1
  50:	e3c58593          	addi	a1,a1,-452 # e88 <malloc+0x11a>
  54:	4509                	li	a0,2
  56:	43b000ef          	jal	c90 <fprintf>

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
  c2:	44b05c63          	blez	a1,51a <run_command+0x4a8>
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
  fe:	d9e58593          	addi	a1,a1,-610 # e98 <malloc+0x12a>
 102:	4509                	li	a0,2
 104:	38d000ef          	jal	c90 <fprintf>
			buf[i] = 0; // Null terminate a word
 108:	00048023          	sb	zero,0(s1)
			redirection_left = 1;
 10c:	4a85                	li	s5,1
			continue;
 10e:	a275                	j	2ba <run_command+0x248>
			fprintf(2, "REDIR_R FLAG SET\n");
 110:	00001597          	auipc	a1,0x1
 114:	da058593          	addi	a1,a1,-608 # eb0 <malloc+0x142>
 118:	4509                	li	a0,2
 11a:	377000ef          	jal	c90 <fprintf>
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
 134:	d9858593          	addi	a1,a1,-616 # ec8 <malloc+0x15a>
 138:	4509                	li	a0,2
 13a:	357000ef          	jal	c90 <fprintf>
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
 16a:	e0a58593          	addi	a1,a1,-502 # f70 <malloc+0x202>
 16e:	f4043503          	ld	a0,-192(s0)
 172:	4f4000ef          	jal	666 <strcmp>
 176:	2c050063          	beqz	a0,436 <run_command+0x3c4>
		// Exit with 2 to let main know there is cd command
		exit(2);

	}else{ // We know it is not a cd command
		// Technique from source 2
		if (pipe_cmd){
 17a:	32048c63          	beqz	s1,4b2 <run_command+0x440>
			
			pipe(p); // New pipe
 17e:	f3840513          	addi	a0,s0,-200
 182:	730000ef          	jal	8b2 <pipe>
			
			if (fork() == 0){
 186:	714000ef          	jal	89a <fork>
 18a:	892a                	mv	s2,a0
 18c:	2c051763          	bnez	a0,45a <run_command+0x3e8>
				close(1); // close stdout
 190:	4505                	li	a0,1
 192:	738000ef          	jal	8ca <close>
				dup(p[1]); // Make "in" part of pipe to be stdout
 196:	f3c42503          	lw	a0,-196(s0)
 19a:	780000ef          	jal	91a <dup>
				
				close(p[0]);
 19e:	f3842503          	lw	a0,-200(s0)
 1a2:	728000ef          	jal	8ca <close>
				close(p[1]);
 1a6:	f3c42503          	lw	a0,-196(s0)
 1aa:	720000ef          	jal	8ca <close>

				exec(arguments[0], arguments); // Execute command on the left
 1ae:	f4040593          	addi	a1,s0,-192
 1b2:	f4043503          	ld	a0,-192(s0)
 1b6:	724000ef          	jal	8da <exec>
				
				// If we reach this part that means something went wrong
				fprintf(2, "================================================\n");
 1ba:	00001597          	auipc	a1,0x1
 1be:	dbe58593          	addi	a1,a1,-578 # f78 <malloc+0x20a>
 1c2:	4509                	li	a0,2
 1c4:	2cd000ef          	jal	c90 <fprintf>
				fprintf(2, "P_LEFT: Execution of the command failed:<S>%s<E>\n", arguments[0]);
 1c8:	f4043603          	ld	a2,-192(s0)
 1cc:	00001597          	auipc	a1,0x1
 1d0:	de458593          	addi	a1,a1,-540 # fb0 <malloc+0x242>
 1d4:	4509                	li	a0,2
 1d6:	2bb000ef          	jal	c90 <fprintf>
				fprintf(2, "================================================\n");
 1da:	00001597          	auipc	a1,0x1
 1de:	d9e58593          	addi	a1,a1,-610 # f78 <malloc+0x20a>
 1e2:	4509                	li	a0,2
 1e4:	2ad000ef          	jal	c90 <fprintf>
				for (int j = 0; j < 9; j++){
 1e8:	f4040493          	addi	s1,s0,-192
					fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n", j, arguments[j], numargs);
 1ec:	00001a17          	auipc	s4,0x1
 1f0:	dfca0a13          	addi	s4,s4,-516 # fe8 <malloc+0x27a>
				for (int j = 0; j < 9; j++){
 1f4:	49a5                	li	s3,9
					fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n", j, arguments[j], numargs);
 1f6:	f1843703          	ld	a4,-232(s0)
 1fa:	6094                	ld	a3,0(s1)
 1fc:	864a                	mv	a2,s2
 1fe:	85d2                	mv	a1,s4
 200:	4509                	li	a0,2
 202:	28f000ef          	jal	c90 <fprintf>
				for (int j = 0; j < 9; j++){
 206:	2905                	addiw	s2,s2,1
 208:	04a1                	addi	s1,s1,8
 20a:	ff3916e3          	bne	s2,s3,1f6 <run_command+0x184>
				}

				exit(1);
 20e:	4505                	li	a0,1
 210:	692000ef          	jal	8a2 <exit>
			fprintf(2, "SEQUENCE_CMD SET TO: %d\n", i+1);
 214:	2985                	addiw	s3,s3,1
 216:	0009849b          	sext.w	s1,s3
 21a:	8626                	mv	a2,s1
 21c:	00001597          	auipc	a1,0x1
 220:	cc458593          	addi	a1,a1,-828 # ee0 <malloc+0x172>
 224:	4509                	li	a0,2
 226:	26b000ef          	jal	c90 <fprintf>
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
 246:	654000ef          	jal	89a <fork>
 24a:	892a                	mv	s2,a0
 24c:	18050363          	beqz	a0,3d2 <run_command+0x360>
			wait(0);
 250:	4501                	li	a0,0
 252:	658000ef          	jal	8aa <wait>
			fprintf(2, "Sequenced: <S>%s<E>\n", &buf[sequence_cmd]);
 256:	ef843783          	ld	a5,-264(s0)
 25a:	94be                	add	s1,s1,a5
 25c:	8626                	mv	a2,s1
 25e:	00001597          	auipc	a1,0x1
 262:	cd258593          	addi	a1,a1,-814 # f30 <malloc+0x1c2>
 266:	4509                	li	a0,2
 268:	229000ef          	jal	c90 <fprintf>
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
 2be:	273b0e63          	beq	s6,s3,53a <run_command+0x4c8>
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
 2e8:	26f76363          	bltu	a4,a5,54e <run_command+0x4dc>
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
 30e:	220a8063          	beqz	s5,52e <run_command+0x4bc>
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
 32e:	364000ef          	jal	692 <strlen>
 332:	fff5079b          	addiw	a5,a0,-1
 336:	1782                	slli	a5,a5,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	f2843703          	ld	a4,-216(s0)
 33e:	97ba                	add	a5,a5,a4
 340:	00078023          	sb	zero,0(a5)
					fprintf(2, "file_name_l: <S>%s<E>\n", file_name_l);
 344:	863a                	mv	a2,a4
 346:	00001597          	auipc	a1,0x1
 34a:	bba58593          	addi	a1,a1,-1094 # f00 <malloc+0x192>
 34e:	4509                	li	a0,2
 350:	141000ef          	jal	c90 <fprintf>
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
 39a:	2f8000ef          	jal	692 <strlen>
 39e:	fff5079b          	addiw	a5,a0,-1
 3a2:	1782                	slli	a5,a5,0x20
 3a4:	9381                	srli	a5,a5,0x20
 3a6:	97d2                	add	a5,a5,s4
 3a8:	00078023          	sb	zero,0(a5)
					fprintf(2, "file_name_r: <S>%s<E>\n", file_name_r);
 3ac:	8652                	mv	a2,s4
 3ae:	00001597          	auipc	a1,0x1
 3b2:	b6a58593          	addi	a1,a1,-1174 # f18 <malloc+0x1aa>
 3b6:	4509                	li	a0,2
 3b8:	0d9000ef          	jal	c90 <fprintf>
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
 3d4:	4d6000ef          	jal	8aa <wait>
 3d8:	84ca                	mv	s1,s2
 3da:	bbb5                	j	156 <run_command+0xe4>
		close(0); // close stdin
 3dc:	4501                	li	a0,0
 3de:	4ec000ef          	jal	8ca <close>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
 3e2:	4581                	li	a1,0
 3e4:	f0843503          	ld	a0,-248(s0)
 3e8:	4fa000ef          	jal	8e2 <open>
 3ec:	d60557e3          	bgez	a0,15a <run_command+0xe8>
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_l);
 3f0:	f0843603          	ld	a2,-248(s0)
 3f4:	00001597          	auipc	a1,0x1
 3f8:	b5458593          	addi	a1,a1,-1196 # f48 <malloc+0x1da>
 3fc:	4509                	li	a0,2
 3fe:	093000ef          	jal	c90 <fprintf>
			exit(1); // quit
 402:	4505                	li	a0,1
 404:	49e000ef          	jal	8a2 <exit>
		close(1); // close stdout
 408:	4505                	li	a0,1
 40a:	4c0000ef          	jal	8ca <close>
		if (open(file_name_r, O_WRONLY|O_CREATE|O_TRUNC) < 0){ // open our file with fd of 1
 40e:	60100593          	li	a1,1537
 412:	f1043503          	ld	a0,-240(s0)
 416:	4cc000ef          	jal	8e2 <open>
 41a:	d40552e3          	bgez	a0,15e <run_command+0xec>
			fprintf(2, "\nFailed to open file: <S>%s<E>\n ", file_name_r);
 41e:	f1043603          	ld	a2,-240(s0)
 422:	00001597          	auipc	a1,0x1
 426:	b2658593          	addi	a1,a1,-1242 # f48 <malloc+0x1da>
 42a:	4509                	li	a0,2
 42c:	065000ef          	jal	c90 <fprintf>
			exit(1); // quit
 430:	4505                	li	a0,1
 432:	470000ef          	jal	8a2 <exit>
		write(pcp[1], arguments[1], strlen(arguments[1]));
 436:	f0043783          	ld	a5,-256(s0)
 43a:	0047a903          	lw	s2,4(a5)
 43e:	f4843483          	ld	s1,-184(s0)
 442:	8526                	mv	a0,s1
 444:	24e000ef          	jal	692 <strlen>
 448:	0005061b          	sext.w	a2,a0
 44c:	85a6                	mv	a1,s1
 44e:	854a                	mv	a0,s2
 450:	472000ef          	jal	8c2 <write>
		exit(2);
 454:	4509                	li	a0,2
 456:	44c000ef          	jal	8a2 <exit>
			}
			if (fork() == 0){ // Handle right side recursively
 45a:	440000ef          	jal	89a <fork>
 45e:	e90d                	bnez	a0,490 <run_command+0x41e>
				close(0); // close stdin
 460:	46a000ef          	jal	8ca <close>
				dup(p[0]); // Make "out" part of pipe to be stdin
 464:	f3842503          	lw	a0,-200(s0)
 468:	4b2000ef          	jal	91a <dup>

				close(p[1]);
 46c:	f3c42503          	lw	a0,-196(s0)
 470:	45a000ef          	jal	8ca <close>
				close(p[0]);
 474:	f3842503          	lw	a0,-200(s0)
 478:	452000ef          	jal	8ca <close>

				run_command(&buf[pipe_cmd], nbuf - pipe_cmd, pcp);
 47c:	f0043603          	ld	a2,-256(s0)
 480:	409b05bb          	subw	a1,s6,s1
 484:	ef843783          	ld	a5,-264(s0)
 488:	00978533          	add	a0,a5,s1
 48c:	be7ff0ef          	jal	72 <run_command>
				exit(0);
			}
			
			close(p[0]);
 490:	f3842503          	lw	a0,-200(s0)
 494:	436000ef          	jal	8ca <close>
			close(p[1]);
 498:	f3c42503          	lw	a0,-196(s0)
 49c:	42e000ef          	jal	8ca <close>
			wait(0);
 4a0:	4501                	li	a0,0
 4a2:	408000ef          	jal	8aa <wait>
			wait(0);
 4a6:	4501                	li	a0,0
 4a8:	402000ef          	jal	8aa <wait>
				fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n",j , arguments[j], numargs);
			}
			exit(1);	
		}
	}
	exit(0);
 4ac:	4501                	li	a0,0
 4ae:	3f4000ef          	jal	8a2 <exit>
			exec(arguments[0], arguments);
 4b2:	f4040593          	addi	a1,s0,-192
 4b6:	f4043503          	ld	a0,-192(s0)
 4ba:	420000ef          	jal	8da <exec>
			fprintf(2, "===============================================\n");
 4be:	00001597          	auipc	a1,0x1
 4c2:	b4a58593          	addi	a1,a1,-1206 # 1008 <malloc+0x29a>
 4c6:	4509                	li	a0,2
 4c8:	7c8000ef          	jal	c90 <fprintf>
			fprintf(2, "DEFAULT:Execution of the command failed:<S>%s<E>\n", arguments[0]);
 4cc:	f4043603          	ld	a2,-192(s0)
 4d0:	00001597          	auipc	a1,0x1
 4d4:	b7058593          	addi	a1,a1,-1168 # 1040 <malloc+0x2d2>
 4d8:	4509                	li	a0,2
 4da:	7b6000ef          	jal	c90 <fprintf>
			fprintf(2, "===============================================\n");
 4de:	00001597          	auipc	a1,0x1
 4e2:	b2a58593          	addi	a1,a1,-1238 # 1008 <malloc+0x29a>
 4e6:	4509                	li	a0,2
 4e8:	7a8000ef          	jal	c90 <fprintf>
			for(int j = 0; j < 9; j++){
 4ec:	f4040913          	addi	s2,s0,-192
				fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n",j , arguments[j], numargs);
 4f0:	00001a17          	auipc	s4,0x1
 4f4:	af8a0a13          	addi	s4,s4,-1288 # fe8 <malloc+0x27a>
			for(int j = 0; j < 9; j++){
 4f8:	49a5                	li	s3,9
				fprintf(2, "Arg[%d] = <S>%s<E>, narg = %d\n",j , arguments[j], numargs);
 4fa:	f1843703          	ld	a4,-232(s0)
 4fe:	00093683          	ld	a3,0(s2)
 502:	8626                	mv	a2,s1
 504:	85d2                	mv	a1,s4
 506:	4509                	li	a0,2
 508:	788000ef          	jal	c90 <fprintf>
			for(int j = 0; j < 9; j++){
 50c:	2485                	addiw	s1,s1,1
 50e:	0921                	addi	s2,s2,8
 510:	ff3495e3          	bne	s1,s3,4fa <run_command+0x488>
			exit(1);	
 514:	4505                	li	a0,1
 516:	38c000ef          	jal	8a2 <exit>
	char* file_name_r = 0; // Buffer to store name of file on the right
 51a:	f0043823          	sd	zero,-240(s0)
	char* file_name_l = 0; // Buffer to store name of file on the left
 51e:	f0043423          	sd	zero,-248(s0)
	int redirection_right = 0; // >
 522:	4a01                	li	s4,0
	int redirection_left = 0; // <
 524:	4a81                	li	s5,0
	int numargs = 0; // number of arguments
 526:	f0043c23          	sd	zero,-232(s0)
	int pipe_cmd = 0; // stores the location where | operator occurs
 52a:	4481                	li	s1,0
 52c:	b929                	j	146 <run_command+0xd4>
			if (!file_name_r && redirection_right){
 52e:	f1043783          	ld	a5,-240(s0)
 532:	e4078ce3          	beqz	a5,38a <run_command+0x318>
 536:	8a4a                	mv	s4,s2
 538:	b349                	j	2ba <run_command+0x248>
	arguments[numargs] = 0; // NULL terminate for exec() to work
 53a:	f1843783          	ld	a5,-232(s0)
 53e:	078e                	slli	a5,a5,0x3
 540:	f9078793          	addi	a5,a5,-112
 544:	97a2                	add	a5,a5,s0
 546:	fa07b823          	sd	zero,-80(a5)
 54a:	4481                	li	s1,0
 54c:	b129                	j	156 <run_command+0xe4>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 54e:	f2043783          	ld	a5,-224(s0)
 552:	d2079ee3          	bnez	a5,28e <run_command+0x21c>
 556:	8a3e                	mv	s4,a5
 558:	8abe                	mv	s5,a5
 55a:	b385                	j	2ba <run_command+0x248>

000000000000055c <main>:


// Purpose: Repeatedly prompt user for input, forks process to run commands,
// and handle the chdir special case.

int main(void){
 55c:	7171                	addi	sp,sp,-176
 55e:	f506                	sd	ra,168(sp)
 560:	f122                	sd	s0,160(sp)
 562:	ed26                	sd	s1,152(sp)
 564:	e94a                	sd	s2,144(sp)
 566:	e54e                	sd	s3,136(sp)
 568:	1900                	addi	s0,sp,176
	
	static char buf[100];

	// Setup a pipe
	int pcp[2];
	pipe(pcp);
 56a:	fc840513          	addi	a0,s0,-56
 56e:	344000ef          	jal	8b2 <pipe>

	int fd;

	// Make sure file descriptors are open
	// Taken from source 1
	while((fd = open("console", O_RDWR)) >= 0){
 572:	00001497          	auipc	s1,0x1
 576:	b0648493          	addi	s1,s1,-1274 # 1078 <malloc+0x30a>
 57a:	4589                	li	a1,2
 57c:	8526                	mv	a0,s1
 57e:	364000ef          	jal	8e2 <open>
 582:	00054763          	bltz	a0,590 <main+0x34>
		if(fd >= 3){
 586:	4789                	li	a5,2
 588:	fea7d9e3          	bge	a5,a0,57a <main+0x1e>
			close(fd); // close 0, 1 and 2 and it will reopen itself
 58c:	33e000ef          	jal	8ca <close>
			break;
		}
	}
	
	// Main Loop
	while(getcmd(buf, sizeof(buf)) >= 0){
 590:	00002917          	auipc	s2,0x2
 594:	a8090913          	addi	s2,s2,-1408 # 2010 <buf.0>
		
		int child_status;

		wait(&child_status);

		if (child_status == 2){ // CD command is detected, must execute in parent
 598:	4489                	li	s1,2

			// FIXME:
			fprintf(2, "Child status 2, cd DETECTED\n");
 59a:	00001997          	auipc	s3,0x1
 59e:	afe98993          	addi	s3,s3,-1282 # 1098 <malloc+0x32a>
	while(getcmd(buf, sizeof(buf)) >= 0){
 5a2:	06400593          	li	a1,100
 5a6:	854a                	mv	a0,s2
 5a8:	a59ff0ef          	jal	0 <getcmd>
 5ac:	08054363          	bltz	a0,632 <main+0xd6>
		if (fork() == 0){
 5b0:	2ea000ef          	jal	89a <fork>
 5b4:	cd21                	beqz	a0,60c <main+0xb0>
		wait(&child_status);
 5b6:	f5c40513          	addi	a0,s0,-164
 5ba:	2f0000ef          	jal	8aa <wait>
		if (child_status == 2){ // CD command is detected, must execute in parent
 5be:	f5c42783          	lw	a5,-164(s0)
 5c2:	fe9790e3          	bne	a5,s1,5a2 <main+0x46>
			fprintf(2, "Child status 2, cd DETECTED\n");
 5c6:	85ce                	mv	a1,s3
 5c8:	8526                	mv	a0,s1
 5ca:	6c6000ef          	jal	c90 <fprintf>

			char buffer_cd_arg[100];
			memset(buffer_cd_arg, 0, sizeof(buffer_cd_arg));
 5ce:	06400613          	li	a2,100
 5d2:	4581                	li	a1,0
 5d4:	f6040513          	addi	a0,s0,-160
 5d8:	0e4000ef          	jal	6bc <memset>

			// Read from pipe the pathname to cd
			read(pcp[0], buffer_cd_arg, sizeof(buffer_cd_arg));
 5dc:	06400613          	li	a2,100
 5e0:	f6040593          	addi	a1,s0,-160
 5e4:	fc842503          	lw	a0,-56(s0)
 5e8:	2d2000ef          	jal	8ba <read>
			
			// Attempt to use chdir system call
			if (chdir(buffer_cd_arg) < 0){
 5ec:	f6040513          	addi	a0,s0,-160
 5f0:	322000ef          	jal	912 <chdir>
 5f4:	fa0557e3          	bgez	a0,5a2 <main+0x46>
				fprintf(2, "Failed to change directory to buf: <S>%s<E>\n", buffer_cd_arg);
 5f8:	f6040613          	addi	a2,s0,-160
 5fc:	00001597          	auipc	a1,0x1
 600:	abc58593          	addi	a1,a1,-1348 # 10b8 <malloc+0x34a>
 604:	4509                	li	a0,2
 606:	68a000ef          	jal	c90 <fprintf>
 60a:	bf61                	j	5a2 <main+0x46>
			fprintf(2, "main_child: <S>%s<E>\n", buf);
 60c:	00002497          	auipc	s1,0x2
 610:	a0448493          	addi	s1,s1,-1532 # 2010 <buf.0>
 614:	8626                	mv	a2,s1
 616:	00001597          	auipc	a1,0x1
 61a:	a6a58593          	addi	a1,a1,-1430 # 1080 <malloc+0x312>
 61e:	4509                	li	a0,2
 620:	670000ef          	jal	c90 <fprintf>
			run_command(buf, 100, pcp);
 624:	fc840613          	addi	a2,s0,-56
 628:	06400593          	li	a1,100
 62c:	8526                	mv	a0,s1
 62e:	a45ff0ef          	jal	72 <run_command>
			}	
		}
	}
	exit(0);
 632:	4501                	li	a0,0
 634:	26e000ef          	jal	8a2 <exit>

0000000000000638 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 638:	1141                	addi	sp,sp,-16
 63a:	e406                	sd	ra,8(sp)
 63c:	e022                	sd	s0,0(sp)
 63e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 640:	f1dff0ef          	jal	55c <main>
  exit(0);
 644:	4501                	li	a0,0
 646:	25c000ef          	jal	8a2 <exit>

000000000000064a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 64a:	1141                	addi	sp,sp,-16
 64c:	e422                	sd	s0,8(sp)
 64e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 650:	87aa                	mv	a5,a0
 652:	0585                	addi	a1,a1,1
 654:	0785                	addi	a5,a5,1
 656:	fff5c703          	lbu	a4,-1(a1)
 65a:	fee78fa3          	sb	a4,-1(a5)
 65e:	fb75                	bnez	a4,652 <strcpy+0x8>
    ;
  return os;
}
 660:	6422                	ld	s0,8(sp)
 662:	0141                	addi	sp,sp,16
 664:	8082                	ret

0000000000000666 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 666:	1141                	addi	sp,sp,-16
 668:	e422                	sd	s0,8(sp)
 66a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 66c:	00054783          	lbu	a5,0(a0)
 670:	cb91                	beqz	a5,684 <strcmp+0x1e>
 672:	0005c703          	lbu	a4,0(a1)
 676:	00f71763          	bne	a4,a5,684 <strcmp+0x1e>
    p++, q++;
 67a:	0505                	addi	a0,a0,1
 67c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 67e:	00054783          	lbu	a5,0(a0)
 682:	fbe5                	bnez	a5,672 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 684:	0005c503          	lbu	a0,0(a1)
}
 688:	40a7853b          	subw	a0,a5,a0
 68c:	6422                	ld	s0,8(sp)
 68e:	0141                	addi	sp,sp,16
 690:	8082                	ret

0000000000000692 <strlen>:

uint
strlen(const char *s)
{
 692:	1141                	addi	sp,sp,-16
 694:	e422                	sd	s0,8(sp)
 696:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 698:	00054783          	lbu	a5,0(a0)
 69c:	cf91                	beqz	a5,6b8 <strlen+0x26>
 69e:	0505                	addi	a0,a0,1
 6a0:	87aa                	mv	a5,a0
 6a2:	86be                	mv	a3,a5
 6a4:	0785                	addi	a5,a5,1
 6a6:	fff7c703          	lbu	a4,-1(a5)
 6aa:	ff65                	bnez	a4,6a2 <strlen+0x10>
 6ac:	40a6853b          	subw	a0,a3,a0
 6b0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 6b2:	6422                	ld	s0,8(sp)
 6b4:	0141                	addi	sp,sp,16
 6b6:	8082                	ret
  for(n = 0; s[n]; n++)
 6b8:	4501                	li	a0,0
 6ba:	bfe5                	j	6b2 <strlen+0x20>

00000000000006bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 6c2:	ca19                	beqz	a2,6d8 <memset+0x1c>
 6c4:	87aa                	mv	a5,a0
 6c6:	1602                	slli	a2,a2,0x20
 6c8:	9201                	srli	a2,a2,0x20
 6ca:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 6ce:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 6d2:	0785                	addi	a5,a5,1
 6d4:	fee79de3          	bne	a5,a4,6ce <memset+0x12>
  }
  return dst;
}
 6d8:	6422                	ld	s0,8(sp)
 6da:	0141                	addi	sp,sp,16
 6dc:	8082                	ret

00000000000006de <strchr>:

char*
strchr(const char *s, char c)
{
 6de:	1141                	addi	sp,sp,-16
 6e0:	e422                	sd	s0,8(sp)
 6e2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 6e4:	00054783          	lbu	a5,0(a0)
 6e8:	cb99                	beqz	a5,6fe <strchr+0x20>
    if(*s == c)
 6ea:	00f58763          	beq	a1,a5,6f8 <strchr+0x1a>
  for(; *s; s++)
 6ee:	0505                	addi	a0,a0,1
 6f0:	00054783          	lbu	a5,0(a0)
 6f4:	fbfd                	bnez	a5,6ea <strchr+0xc>
      return (char*)s;
  return 0;
 6f6:	4501                	li	a0,0
}
 6f8:	6422                	ld	s0,8(sp)
 6fa:	0141                	addi	sp,sp,16
 6fc:	8082                	ret
  return 0;
 6fe:	4501                	li	a0,0
 700:	bfe5                	j	6f8 <strchr+0x1a>

0000000000000702 <gets>:

char*
gets(char *buf, int max)
{
 702:	711d                	addi	sp,sp,-96
 704:	ec86                	sd	ra,88(sp)
 706:	e8a2                	sd	s0,80(sp)
 708:	e4a6                	sd	s1,72(sp)
 70a:	e0ca                	sd	s2,64(sp)
 70c:	fc4e                	sd	s3,56(sp)
 70e:	f852                	sd	s4,48(sp)
 710:	f456                	sd	s5,40(sp)
 712:	f05a                	sd	s6,32(sp)
 714:	ec5e                	sd	s7,24(sp)
 716:	1080                	addi	s0,sp,96
 718:	8baa                	mv	s7,a0
 71a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 71c:	892a                	mv	s2,a0
 71e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 720:	4aa9                	li	s5,10
 722:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 724:	89a6                	mv	s3,s1
 726:	2485                	addiw	s1,s1,1
 728:	0344d663          	bge	s1,s4,754 <gets+0x52>
    cc = read(0, &c, 1);
 72c:	4605                	li	a2,1
 72e:	faf40593          	addi	a1,s0,-81
 732:	4501                	li	a0,0
 734:	186000ef          	jal	8ba <read>
    if(cc < 1)
 738:	00a05e63          	blez	a0,754 <gets+0x52>
    buf[i++] = c;
 73c:	faf44783          	lbu	a5,-81(s0)
 740:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 744:	01578763          	beq	a5,s5,752 <gets+0x50>
 748:	0905                	addi	s2,s2,1
 74a:	fd679de3          	bne	a5,s6,724 <gets+0x22>
    buf[i++] = c;
 74e:	89a6                	mv	s3,s1
 750:	a011                	j	754 <gets+0x52>
 752:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 754:	99de                	add	s3,s3,s7
 756:	00098023          	sb	zero,0(s3)
  return buf;
}
 75a:	855e                	mv	a0,s7
 75c:	60e6                	ld	ra,88(sp)
 75e:	6446                	ld	s0,80(sp)
 760:	64a6                	ld	s1,72(sp)
 762:	6906                	ld	s2,64(sp)
 764:	79e2                	ld	s3,56(sp)
 766:	7a42                	ld	s4,48(sp)
 768:	7aa2                	ld	s5,40(sp)
 76a:	7b02                	ld	s6,32(sp)
 76c:	6be2                	ld	s7,24(sp)
 76e:	6125                	addi	sp,sp,96
 770:	8082                	ret

0000000000000772 <stat>:

int
stat(const char *n, struct stat *st)
{
 772:	1101                	addi	sp,sp,-32
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	e04a                	sd	s2,0(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 77e:	4581                	li	a1,0
 780:	162000ef          	jal	8e2 <open>
  if(fd < 0)
 784:	02054263          	bltz	a0,7a8 <stat+0x36>
 788:	e426                	sd	s1,8(sp)
 78a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 78c:	85ca                	mv	a1,s2
 78e:	16c000ef          	jal	8fa <fstat>
 792:	892a                	mv	s2,a0
  close(fd);
 794:	8526                	mv	a0,s1
 796:	134000ef          	jal	8ca <close>
  return r;
 79a:	64a2                	ld	s1,8(sp)
}
 79c:	854a                	mv	a0,s2
 79e:	60e2                	ld	ra,24(sp)
 7a0:	6442                	ld	s0,16(sp)
 7a2:	6902                	ld	s2,0(sp)
 7a4:	6105                	addi	sp,sp,32
 7a6:	8082                	ret
    return -1;
 7a8:	597d                	li	s2,-1
 7aa:	bfcd                	j	79c <stat+0x2a>

00000000000007ac <atoi>:

int
atoi(const char *s)
{
 7ac:	1141                	addi	sp,sp,-16
 7ae:	e422                	sd	s0,8(sp)
 7b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7b2:	00054683          	lbu	a3,0(a0)
 7b6:	fd06879b          	addiw	a5,a3,-48
 7ba:	0ff7f793          	zext.b	a5,a5
 7be:	4625                	li	a2,9
 7c0:	02f66863          	bltu	a2,a5,7f0 <atoi+0x44>
 7c4:	872a                	mv	a4,a0
  n = 0;
 7c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 7c8:	0705                	addi	a4,a4,1
 7ca:	0025179b          	slliw	a5,a0,0x2
 7ce:	9fa9                	addw	a5,a5,a0
 7d0:	0017979b          	slliw	a5,a5,0x1
 7d4:	9fb5                	addw	a5,a5,a3
 7d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 7da:	00074683          	lbu	a3,0(a4)
 7de:	fd06879b          	addiw	a5,a3,-48
 7e2:	0ff7f793          	zext.b	a5,a5
 7e6:	fef671e3          	bgeu	a2,a5,7c8 <atoi+0x1c>
  return n;
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret
  n = 0;
 7f0:	4501                	li	a0,0
 7f2:	bfe5                	j	7ea <atoi+0x3e>

00000000000007f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7f4:	1141                	addi	sp,sp,-16
 7f6:	e422                	sd	s0,8(sp)
 7f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 7fa:	02b57463          	bgeu	a0,a1,822 <memmove+0x2e>
    while(n-- > 0)
 7fe:	00c05f63          	blez	a2,81c <memmove+0x28>
 802:	1602                	slli	a2,a2,0x20
 804:	9201                	srli	a2,a2,0x20
 806:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 80a:	872a                	mv	a4,a0
      *dst++ = *src++;
 80c:	0585                	addi	a1,a1,1
 80e:	0705                	addi	a4,a4,1
 810:	fff5c683          	lbu	a3,-1(a1)
 814:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 818:	fef71ae3          	bne	a4,a5,80c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 81c:	6422                	ld	s0,8(sp)
 81e:	0141                	addi	sp,sp,16
 820:	8082                	ret
    dst += n;
 822:	00c50733          	add	a4,a0,a2
    src += n;
 826:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 828:	fec05ae3          	blez	a2,81c <memmove+0x28>
 82c:	fff6079b          	addiw	a5,a2,-1
 830:	1782                	slli	a5,a5,0x20
 832:	9381                	srli	a5,a5,0x20
 834:	fff7c793          	not	a5,a5
 838:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 83a:	15fd                	addi	a1,a1,-1
 83c:	177d                	addi	a4,a4,-1
 83e:	0005c683          	lbu	a3,0(a1)
 842:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 846:	fee79ae3          	bne	a5,a4,83a <memmove+0x46>
 84a:	bfc9                	j	81c <memmove+0x28>

000000000000084c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 84c:	1141                	addi	sp,sp,-16
 84e:	e422                	sd	s0,8(sp)
 850:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 852:	ca05                	beqz	a2,882 <memcmp+0x36>
 854:	fff6069b          	addiw	a3,a2,-1
 858:	1682                	slli	a3,a3,0x20
 85a:	9281                	srli	a3,a3,0x20
 85c:	0685                	addi	a3,a3,1
 85e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 860:	00054783          	lbu	a5,0(a0)
 864:	0005c703          	lbu	a4,0(a1)
 868:	00e79863          	bne	a5,a4,878 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 86c:	0505                	addi	a0,a0,1
    p2++;
 86e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 870:	fed518e3          	bne	a0,a3,860 <memcmp+0x14>
  }
  return 0;
 874:	4501                	li	a0,0
 876:	a019                	j	87c <memcmp+0x30>
      return *p1 - *p2;
 878:	40e7853b          	subw	a0,a5,a4
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret
  return 0;
 882:	4501                	li	a0,0
 884:	bfe5                	j	87c <memcmp+0x30>

0000000000000886 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 886:	1141                	addi	sp,sp,-16
 888:	e406                	sd	ra,8(sp)
 88a:	e022                	sd	s0,0(sp)
 88c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 88e:	f67ff0ef          	jal	7f4 <memmove>
}
 892:	60a2                	ld	ra,8(sp)
 894:	6402                	ld	s0,0(sp)
 896:	0141                	addi	sp,sp,16
 898:	8082                	ret

000000000000089a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 89a:	4885                	li	a7,1
 ecall
 89c:	00000073          	ecall
 ret
 8a0:	8082                	ret

00000000000008a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 8a2:	4889                	li	a7,2
 ecall
 8a4:	00000073          	ecall
 ret
 8a8:	8082                	ret

00000000000008aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 8aa:	488d                	li	a7,3
 ecall
 8ac:	00000073          	ecall
 ret
 8b0:	8082                	ret

00000000000008b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 8b2:	4891                	li	a7,4
 ecall
 8b4:	00000073          	ecall
 ret
 8b8:	8082                	ret

00000000000008ba <read>:
.global read
read:
 li a7, SYS_read
 8ba:	4895                	li	a7,5
 ecall
 8bc:	00000073          	ecall
 ret
 8c0:	8082                	ret

00000000000008c2 <write>:
.global write
write:
 li a7, SYS_write
 8c2:	48c1                	li	a7,16
 ecall
 8c4:	00000073          	ecall
 ret
 8c8:	8082                	ret

00000000000008ca <close>:
.global close
close:
 li a7, SYS_close
 8ca:	48d5                	li	a7,21
 ecall
 8cc:	00000073          	ecall
 ret
 8d0:	8082                	ret

00000000000008d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 8d2:	4899                	li	a7,6
 ecall
 8d4:	00000073          	ecall
 ret
 8d8:	8082                	ret

00000000000008da <exec>:
.global exec
exec:
 li a7, SYS_exec
 8da:	489d                	li	a7,7
 ecall
 8dc:	00000073          	ecall
 ret
 8e0:	8082                	ret

00000000000008e2 <open>:
.global open
open:
 li a7, SYS_open
 8e2:	48bd                	li	a7,15
 ecall
 8e4:	00000073          	ecall
 ret
 8e8:	8082                	ret

00000000000008ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 8ea:	48c5                	li	a7,17
 ecall
 8ec:	00000073          	ecall
 ret
 8f0:	8082                	ret

00000000000008f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 8f2:	48c9                	li	a7,18
 ecall
 8f4:	00000073          	ecall
 ret
 8f8:	8082                	ret

00000000000008fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 8fa:	48a1                	li	a7,8
 ecall
 8fc:	00000073          	ecall
 ret
 900:	8082                	ret

0000000000000902 <link>:
.global link
link:
 li a7, SYS_link
 902:	48cd                	li	a7,19
 ecall
 904:	00000073          	ecall
 ret
 908:	8082                	ret

000000000000090a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 90a:	48d1                	li	a7,20
 ecall
 90c:	00000073          	ecall
 ret
 910:	8082                	ret

0000000000000912 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 912:	48a5                	li	a7,9
 ecall
 914:	00000073          	ecall
 ret
 918:	8082                	ret

000000000000091a <dup>:
.global dup
dup:
 li a7, SYS_dup
 91a:	48a9                	li	a7,10
 ecall
 91c:	00000073          	ecall
 ret
 920:	8082                	ret

0000000000000922 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 922:	48ad                	li	a7,11
 ecall
 924:	00000073          	ecall
 ret
 928:	8082                	ret

000000000000092a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 92a:	48b1                	li	a7,12
 ecall
 92c:	00000073          	ecall
 ret
 930:	8082                	ret

0000000000000932 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 932:	48b5                	li	a7,13
 ecall
 934:	00000073          	ecall
 ret
 938:	8082                	ret

000000000000093a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 93a:	48b9                	li	a7,14
 ecall
 93c:	00000073          	ecall
 ret
 940:	8082                	ret

0000000000000942 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 942:	1101                	addi	sp,sp,-32
 944:	ec06                	sd	ra,24(sp)
 946:	e822                	sd	s0,16(sp)
 948:	1000                	addi	s0,sp,32
 94a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 94e:	4605                	li	a2,1
 950:	fef40593          	addi	a1,s0,-17
 954:	f6fff0ef          	jal	8c2 <write>
}
 958:	60e2                	ld	ra,24(sp)
 95a:	6442                	ld	s0,16(sp)
 95c:	6105                	addi	sp,sp,32
 95e:	8082                	ret

0000000000000960 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 960:	7139                	addi	sp,sp,-64
 962:	fc06                	sd	ra,56(sp)
 964:	f822                	sd	s0,48(sp)
 966:	f426                	sd	s1,40(sp)
 968:	0080                	addi	s0,sp,64
 96a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 96c:	c299                	beqz	a3,972 <printint+0x12>
 96e:	0805c963          	bltz	a1,a00 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 972:	2581                	sext.w	a1,a1
  neg = 0;
 974:	4881                	li	a7,0
 976:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 97a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 97c:	2601                	sext.w	a2,a2
 97e:	00000517          	auipc	a0,0x0
 982:	77250513          	addi	a0,a0,1906 # 10f0 <digits>
 986:	883a                	mv	a6,a4
 988:	2705                	addiw	a4,a4,1
 98a:	02c5f7bb          	remuw	a5,a1,a2
 98e:	1782                	slli	a5,a5,0x20
 990:	9381                	srli	a5,a5,0x20
 992:	97aa                	add	a5,a5,a0
 994:	0007c783          	lbu	a5,0(a5)
 998:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 99c:	0005879b          	sext.w	a5,a1
 9a0:	02c5d5bb          	divuw	a1,a1,a2
 9a4:	0685                	addi	a3,a3,1
 9a6:	fec7f0e3          	bgeu	a5,a2,986 <printint+0x26>
  if(neg)
 9aa:	00088c63          	beqz	a7,9c2 <printint+0x62>
    buf[i++] = '-';
 9ae:	fd070793          	addi	a5,a4,-48
 9b2:	00878733          	add	a4,a5,s0
 9b6:	02d00793          	li	a5,45
 9ba:	fef70823          	sb	a5,-16(a4)
 9be:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 9c2:	02e05a63          	blez	a4,9f6 <printint+0x96>
 9c6:	f04a                	sd	s2,32(sp)
 9c8:	ec4e                	sd	s3,24(sp)
 9ca:	fc040793          	addi	a5,s0,-64
 9ce:	00e78933          	add	s2,a5,a4
 9d2:	fff78993          	addi	s3,a5,-1
 9d6:	99ba                	add	s3,s3,a4
 9d8:	377d                	addiw	a4,a4,-1
 9da:	1702                	slli	a4,a4,0x20
 9dc:	9301                	srli	a4,a4,0x20
 9de:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 9e2:	fff94583          	lbu	a1,-1(s2)
 9e6:	8526                	mv	a0,s1
 9e8:	f5bff0ef          	jal	942 <putc>
  while(--i >= 0)
 9ec:	197d                	addi	s2,s2,-1
 9ee:	ff391ae3          	bne	s2,s3,9e2 <printint+0x82>
 9f2:	7902                	ld	s2,32(sp)
 9f4:	69e2                	ld	s3,24(sp)
}
 9f6:	70e2                	ld	ra,56(sp)
 9f8:	7442                	ld	s0,48(sp)
 9fa:	74a2                	ld	s1,40(sp)
 9fc:	6121                	addi	sp,sp,64
 9fe:	8082                	ret
    x = -xx;
 a00:	40b005bb          	negw	a1,a1
    neg = 1;
 a04:	4885                	li	a7,1
    x = -xx;
 a06:	bf85                	j	976 <printint+0x16>

0000000000000a08 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 a08:	711d                	addi	sp,sp,-96
 a0a:	ec86                	sd	ra,88(sp)
 a0c:	e8a2                	sd	s0,80(sp)
 a0e:	e0ca                	sd	s2,64(sp)
 a10:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 a12:	0005c903          	lbu	s2,0(a1)
 a16:	26090863          	beqz	s2,c86 <vprintf+0x27e>
 a1a:	e4a6                	sd	s1,72(sp)
 a1c:	fc4e                	sd	s3,56(sp)
 a1e:	f852                	sd	s4,48(sp)
 a20:	f456                	sd	s5,40(sp)
 a22:	f05a                	sd	s6,32(sp)
 a24:	ec5e                	sd	s7,24(sp)
 a26:	e862                	sd	s8,16(sp)
 a28:	e466                	sd	s9,8(sp)
 a2a:	8b2a                	mv	s6,a0
 a2c:	8a2e                	mv	s4,a1
 a2e:	8bb2                	mv	s7,a2
  state = 0;
 a30:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 a32:	4481                	li	s1,0
 a34:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 a36:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 a3a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 a3e:	06c00c93          	li	s9,108
 a42:	a005                	j	a62 <vprintf+0x5a>
        putc(fd, c0);
 a44:	85ca                	mv	a1,s2
 a46:	855a                	mv	a0,s6
 a48:	efbff0ef          	jal	942 <putc>
 a4c:	a019                	j	a52 <vprintf+0x4a>
    } else if(state == '%'){
 a4e:	03598263          	beq	s3,s5,a72 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 a52:	2485                	addiw	s1,s1,1
 a54:	8726                	mv	a4,s1
 a56:	009a07b3          	add	a5,s4,s1
 a5a:	0007c903          	lbu	s2,0(a5)
 a5e:	20090c63          	beqz	s2,c76 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 a62:	0009079b          	sext.w	a5,s2
    if(state == 0){
 a66:	fe0994e3          	bnez	s3,a4e <vprintf+0x46>
      if(c0 == '%'){
 a6a:	fd579de3          	bne	a5,s5,a44 <vprintf+0x3c>
        state = '%';
 a6e:	89be                	mv	s3,a5
 a70:	b7cd                	j	a52 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 a72:	00ea06b3          	add	a3,s4,a4
 a76:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 a7a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 a7c:	c681                	beqz	a3,a84 <vprintf+0x7c>
 a7e:	9752                	add	a4,a4,s4
 a80:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 a84:	03878f63          	beq	a5,s8,ac2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 a88:	05978963          	beq	a5,s9,ada <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 a8c:	07500713          	li	a4,117
 a90:	0ee78363          	beq	a5,a4,b76 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 a94:	07800713          	li	a4,120
 a98:	12e78563          	beq	a5,a4,bc2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a9c:	07000713          	li	a4,112
 aa0:	14e78a63          	beq	a5,a4,bf4 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 aa4:	07300713          	li	a4,115
 aa8:	18e78a63          	beq	a5,a4,c3c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 aac:	02500713          	li	a4,37
 ab0:	04e79563          	bne	a5,a4,afa <vprintf+0xf2>
        putc(fd, '%');
 ab4:	02500593          	li	a1,37
 ab8:	855a                	mv	a0,s6
 aba:	e89ff0ef          	jal	942 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 abe:	4981                	li	s3,0
 ac0:	bf49                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 ac2:	008b8913          	addi	s2,s7,8
 ac6:	4685                	li	a3,1
 ac8:	4629                	li	a2,10
 aca:	000ba583          	lw	a1,0(s7)
 ace:	855a                	mv	a0,s6
 ad0:	e91ff0ef          	jal	960 <printint>
 ad4:	8bca                	mv	s7,s2
      state = 0;
 ad6:	4981                	li	s3,0
 ad8:	bfad                	j	a52 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 ada:	06400793          	li	a5,100
 ade:	02f68963          	beq	a3,a5,b10 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 ae2:	06c00793          	li	a5,108
 ae6:	04f68263          	beq	a3,a5,b2a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 aea:	07500793          	li	a5,117
 aee:	0af68063          	beq	a3,a5,b8e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 af2:	07800793          	li	a5,120
 af6:	0ef68263          	beq	a3,a5,bda <vprintf+0x1d2>
        putc(fd, '%');
 afa:	02500593          	li	a1,37
 afe:	855a                	mv	a0,s6
 b00:	e43ff0ef          	jal	942 <putc>
        putc(fd, c0);
 b04:	85ca                	mv	a1,s2
 b06:	855a                	mv	a0,s6
 b08:	e3bff0ef          	jal	942 <putc>
      state = 0;
 b0c:	4981                	li	s3,0
 b0e:	b791                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 b10:	008b8913          	addi	s2,s7,8
 b14:	4685                	li	a3,1
 b16:	4629                	li	a2,10
 b18:	000ba583          	lw	a1,0(s7)
 b1c:	855a                	mv	a0,s6
 b1e:	e43ff0ef          	jal	960 <printint>
        i += 1;
 b22:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 b24:	8bca                	mv	s7,s2
      state = 0;
 b26:	4981                	li	s3,0
        i += 1;
 b28:	b72d                	j	a52 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 b2a:	06400793          	li	a5,100
 b2e:	02f60763          	beq	a2,a5,b5c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 b32:	07500793          	li	a5,117
 b36:	06f60963          	beq	a2,a5,ba8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 b3a:	07800793          	li	a5,120
 b3e:	faf61ee3          	bne	a2,a5,afa <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b42:	008b8913          	addi	s2,s7,8
 b46:	4681                	li	a3,0
 b48:	4641                	li	a2,16
 b4a:	000ba583          	lw	a1,0(s7)
 b4e:	855a                	mv	a0,s6
 b50:	e11ff0ef          	jal	960 <printint>
        i += 2;
 b54:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 b56:	8bca                	mv	s7,s2
      state = 0;
 b58:	4981                	li	s3,0
        i += 2;
 b5a:	bde5                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 b5c:	008b8913          	addi	s2,s7,8
 b60:	4685                	li	a3,1
 b62:	4629                	li	a2,10
 b64:	000ba583          	lw	a1,0(s7)
 b68:	855a                	mv	a0,s6
 b6a:	df7ff0ef          	jal	960 <printint>
        i += 2;
 b6e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 b70:	8bca                	mv	s7,s2
      state = 0;
 b72:	4981                	li	s3,0
        i += 2;
 b74:	bdf9                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 b76:	008b8913          	addi	s2,s7,8
 b7a:	4681                	li	a3,0
 b7c:	4629                	li	a2,10
 b7e:	000ba583          	lw	a1,0(s7)
 b82:	855a                	mv	a0,s6
 b84:	dddff0ef          	jal	960 <printint>
 b88:	8bca                	mv	s7,s2
      state = 0;
 b8a:	4981                	li	s3,0
 b8c:	b5d9                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b8e:	008b8913          	addi	s2,s7,8
 b92:	4681                	li	a3,0
 b94:	4629                	li	a2,10
 b96:	000ba583          	lw	a1,0(s7)
 b9a:	855a                	mv	a0,s6
 b9c:	dc5ff0ef          	jal	960 <printint>
        i += 1;
 ba0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 ba2:	8bca                	mv	s7,s2
      state = 0;
 ba4:	4981                	li	s3,0
        i += 1;
 ba6:	b575                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ba8:	008b8913          	addi	s2,s7,8
 bac:	4681                	li	a3,0
 bae:	4629                	li	a2,10
 bb0:	000ba583          	lw	a1,0(s7)
 bb4:	855a                	mv	a0,s6
 bb6:	dabff0ef          	jal	960 <printint>
        i += 2;
 bba:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 bbc:	8bca                	mv	s7,s2
      state = 0;
 bbe:	4981                	li	s3,0
        i += 2;
 bc0:	bd49                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 bc2:	008b8913          	addi	s2,s7,8
 bc6:	4681                	li	a3,0
 bc8:	4641                	li	a2,16
 bca:	000ba583          	lw	a1,0(s7)
 bce:	855a                	mv	a0,s6
 bd0:	d91ff0ef          	jal	960 <printint>
 bd4:	8bca                	mv	s7,s2
      state = 0;
 bd6:	4981                	li	s3,0
 bd8:	bdad                	j	a52 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 bda:	008b8913          	addi	s2,s7,8
 bde:	4681                	li	a3,0
 be0:	4641                	li	a2,16
 be2:	000ba583          	lw	a1,0(s7)
 be6:	855a                	mv	a0,s6
 be8:	d79ff0ef          	jal	960 <printint>
        i += 1;
 bec:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 bee:	8bca                	mv	s7,s2
      state = 0;
 bf0:	4981                	li	s3,0
        i += 1;
 bf2:	b585                	j	a52 <vprintf+0x4a>
 bf4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 bf6:	008b8d13          	addi	s10,s7,8
 bfa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 bfe:	03000593          	li	a1,48
 c02:	855a                	mv	a0,s6
 c04:	d3fff0ef          	jal	942 <putc>
  putc(fd, 'x');
 c08:	07800593          	li	a1,120
 c0c:	855a                	mv	a0,s6
 c0e:	d35ff0ef          	jal	942 <putc>
 c12:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 c14:	00000b97          	auipc	s7,0x0
 c18:	4dcb8b93          	addi	s7,s7,1244 # 10f0 <digits>
 c1c:	03c9d793          	srli	a5,s3,0x3c
 c20:	97de                	add	a5,a5,s7
 c22:	0007c583          	lbu	a1,0(a5)
 c26:	855a                	mv	a0,s6
 c28:	d1bff0ef          	jal	942 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c2c:	0992                	slli	s3,s3,0x4
 c2e:	397d                	addiw	s2,s2,-1
 c30:	fe0916e3          	bnez	s2,c1c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 c34:	8bea                	mv	s7,s10
      state = 0;
 c36:	4981                	li	s3,0
 c38:	6d02                	ld	s10,0(sp)
 c3a:	bd21                	j	a52 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 c3c:	008b8993          	addi	s3,s7,8
 c40:	000bb903          	ld	s2,0(s7)
 c44:	00090f63          	beqz	s2,c62 <vprintf+0x25a>
        for(; *s; s++)
 c48:	00094583          	lbu	a1,0(s2)
 c4c:	c195                	beqz	a1,c70 <vprintf+0x268>
          putc(fd, *s);
 c4e:	855a                	mv	a0,s6
 c50:	cf3ff0ef          	jal	942 <putc>
        for(; *s; s++)
 c54:	0905                	addi	s2,s2,1
 c56:	00094583          	lbu	a1,0(s2)
 c5a:	f9f5                	bnez	a1,c4e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 c5c:	8bce                	mv	s7,s3
      state = 0;
 c5e:	4981                	li	s3,0
 c60:	bbcd                	j	a52 <vprintf+0x4a>
          s = "(null)";
 c62:	00000917          	auipc	s2,0x0
 c66:	48690913          	addi	s2,s2,1158 # 10e8 <malloc+0x37a>
        for(; *s; s++)
 c6a:	02800593          	li	a1,40
 c6e:	b7c5                	j	c4e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 c70:	8bce                	mv	s7,s3
      state = 0;
 c72:	4981                	li	s3,0
 c74:	bbf9                	j	a52 <vprintf+0x4a>
 c76:	64a6                	ld	s1,72(sp)
 c78:	79e2                	ld	s3,56(sp)
 c7a:	7a42                	ld	s4,48(sp)
 c7c:	7aa2                	ld	s5,40(sp)
 c7e:	7b02                	ld	s6,32(sp)
 c80:	6be2                	ld	s7,24(sp)
 c82:	6c42                	ld	s8,16(sp)
 c84:	6ca2                	ld	s9,8(sp)
    }
  }
}
 c86:	60e6                	ld	ra,88(sp)
 c88:	6446                	ld	s0,80(sp)
 c8a:	6906                	ld	s2,64(sp)
 c8c:	6125                	addi	sp,sp,96
 c8e:	8082                	ret

0000000000000c90 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c90:	715d                	addi	sp,sp,-80
 c92:	ec06                	sd	ra,24(sp)
 c94:	e822                	sd	s0,16(sp)
 c96:	1000                	addi	s0,sp,32
 c98:	e010                	sd	a2,0(s0)
 c9a:	e414                	sd	a3,8(s0)
 c9c:	e818                	sd	a4,16(s0)
 c9e:	ec1c                	sd	a5,24(s0)
 ca0:	03043023          	sd	a6,32(s0)
 ca4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 ca8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 cac:	8622                	mv	a2,s0
 cae:	d5bff0ef          	jal	a08 <vprintf>
}
 cb2:	60e2                	ld	ra,24(sp)
 cb4:	6442                	ld	s0,16(sp)
 cb6:	6161                	addi	sp,sp,80
 cb8:	8082                	ret

0000000000000cba <printf>:

void
printf(const char *fmt, ...)
{
 cba:	711d                	addi	sp,sp,-96
 cbc:	ec06                	sd	ra,24(sp)
 cbe:	e822                	sd	s0,16(sp)
 cc0:	1000                	addi	s0,sp,32
 cc2:	e40c                	sd	a1,8(s0)
 cc4:	e810                	sd	a2,16(s0)
 cc6:	ec14                	sd	a3,24(s0)
 cc8:	f018                	sd	a4,32(s0)
 cca:	f41c                	sd	a5,40(s0)
 ccc:	03043823          	sd	a6,48(s0)
 cd0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cd4:	00840613          	addi	a2,s0,8
 cd8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cdc:	85aa                	mv	a1,a0
 cde:	4505                	li	a0,1
 ce0:	d29ff0ef          	jal	a08 <vprintf>
}
 ce4:	60e2                	ld	ra,24(sp)
 ce6:	6442                	ld	s0,16(sp)
 ce8:	6125                	addi	sp,sp,96
 cea:	8082                	ret

0000000000000cec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cec:	1141                	addi	sp,sp,-16
 cee:	e422                	sd	s0,8(sp)
 cf0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cf2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cf6:	00001797          	auipc	a5,0x1
 cfa:	30a7b783          	ld	a5,778(a5) # 2000 <freep>
 cfe:	a02d                	j	d28 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d00:	4618                	lw	a4,8(a2)
 d02:	9f2d                	addw	a4,a4,a1
 d04:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d08:	6398                	ld	a4,0(a5)
 d0a:	6310                	ld	a2,0(a4)
 d0c:	a83d                	j	d4a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d0e:	ff852703          	lw	a4,-8(a0)
 d12:	9f31                	addw	a4,a4,a2
 d14:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d16:	ff053683          	ld	a3,-16(a0)
 d1a:	a091                	j	d5e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d1c:	6398                	ld	a4,0(a5)
 d1e:	00e7e463          	bltu	a5,a4,d26 <free+0x3a>
 d22:	00e6ea63          	bltu	a3,a4,d36 <free+0x4a>
{
 d26:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d28:	fed7fae3          	bgeu	a5,a3,d1c <free+0x30>
 d2c:	6398                	ld	a4,0(a5)
 d2e:	00e6e463          	bltu	a3,a4,d36 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d32:	fee7eae3          	bltu	a5,a4,d26 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 d36:	ff852583          	lw	a1,-8(a0)
 d3a:	6390                	ld	a2,0(a5)
 d3c:	02059813          	slli	a6,a1,0x20
 d40:	01c85713          	srli	a4,a6,0x1c
 d44:	9736                	add	a4,a4,a3
 d46:	fae60de3          	beq	a2,a4,d00 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d4a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d4e:	4790                	lw	a2,8(a5)
 d50:	02061593          	slli	a1,a2,0x20
 d54:	01c5d713          	srli	a4,a1,0x1c
 d58:	973e                	add	a4,a4,a5
 d5a:	fae68ae3          	beq	a3,a4,d0e <free+0x22>
    p->s.ptr = bp->s.ptr;
 d5e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d60:	00001717          	auipc	a4,0x1
 d64:	2af73023          	sd	a5,672(a4) # 2000 <freep>
}
 d68:	6422                	ld	s0,8(sp)
 d6a:	0141                	addi	sp,sp,16
 d6c:	8082                	ret

0000000000000d6e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d6e:	7139                	addi	sp,sp,-64
 d70:	fc06                	sd	ra,56(sp)
 d72:	f822                	sd	s0,48(sp)
 d74:	f426                	sd	s1,40(sp)
 d76:	ec4e                	sd	s3,24(sp)
 d78:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d7a:	02051493          	slli	s1,a0,0x20
 d7e:	9081                	srli	s1,s1,0x20
 d80:	04bd                	addi	s1,s1,15
 d82:	8091                	srli	s1,s1,0x4
 d84:	0014899b          	addiw	s3,s1,1
 d88:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 d8a:	00001517          	auipc	a0,0x1
 d8e:	27653503          	ld	a0,630(a0) # 2000 <freep>
 d92:	c915                	beqz	a0,dc6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d94:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d96:	4798                	lw	a4,8(a5)
 d98:	08977a63          	bgeu	a4,s1,e2c <malloc+0xbe>
 d9c:	f04a                	sd	s2,32(sp)
 d9e:	e852                	sd	s4,16(sp)
 da0:	e456                	sd	s5,8(sp)
 da2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 da4:	8a4e                	mv	s4,s3
 da6:	0009871b          	sext.w	a4,s3
 daa:	6685                	lui	a3,0x1
 dac:	00d77363          	bgeu	a4,a3,db2 <malloc+0x44>
 db0:	6a05                	lui	s4,0x1
 db2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 db6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dba:	00001917          	auipc	s2,0x1
 dbe:	24690913          	addi	s2,s2,582 # 2000 <freep>
  if(p == (char*)-1)
 dc2:	5afd                	li	s5,-1
 dc4:	a081                	j	e04 <malloc+0x96>
 dc6:	f04a                	sd	s2,32(sp)
 dc8:	e852                	sd	s4,16(sp)
 dca:	e456                	sd	s5,8(sp)
 dcc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 dce:	00001797          	auipc	a5,0x1
 dd2:	2aa78793          	addi	a5,a5,682 # 2078 <base>
 dd6:	00001717          	auipc	a4,0x1
 dda:	22f73523          	sd	a5,554(a4) # 2000 <freep>
 dde:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 de0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 de4:	b7c1                	j	da4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 de6:	6398                	ld	a4,0(a5)
 de8:	e118                	sd	a4,0(a0)
 dea:	a8a9                	j	e44 <malloc+0xd6>
  hp->s.size = nu;
 dec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 df0:	0541                	addi	a0,a0,16
 df2:	efbff0ef          	jal	cec <free>
  return freep;
 df6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 dfa:	c12d                	beqz	a0,e5c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dfc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dfe:	4798                	lw	a4,8(a5)
 e00:	02977263          	bgeu	a4,s1,e24 <malloc+0xb6>
    if(p == freep)
 e04:	00093703          	ld	a4,0(s2)
 e08:	853e                	mv	a0,a5
 e0a:	fef719e3          	bne	a4,a5,dfc <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 e0e:	8552                	mv	a0,s4
 e10:	b1bff0ef          	jal	92a <sbrk>
  if(p == (char*)-1)
 e14:	fd551ce3          	bne	a0,s5,dec <malloc+0x7e>
        return 0;
 e18:	4501                	li	a0,0
 e1a:	7902                	ld	s2,32(sp)
 e1c:	6a42                	ld	s4,16(sp)
 e1e:	6aa2                	ld	s5,8(sp)
 e20:	6b02                	ld	s6,0(sp)
 e22:	a03d                	j	e50 <malloc+0xe2>
 e24:	7902                	ld	s2,32(sp)
 e26:	6a42                	ld	s4,16(sp)
 e28:	6aa2                	ld	s5,8(sp)
 e2a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 e2c:	fae48de3          	beq	s1,a4,de6 <malloc+0x78>
        p->s.size -= nunits;
 e30:	4137073b          	subw	a4,a4,s3
 e34:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e36:	02071693          	slli	a3,a4,0x20
 e3a:	01c6d713          	srli	a4,a3,0x1c
 e3e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e40:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e44:	00001717          	auipc	a4,0x1
 e48:	1aa73e23          	sd	a0,444(a4) # 2000 <freep>
      return (void*)(p + 1);
 e4c:	01078513          	addi	a0,a5,16
  }
}
 e50:	70e2                	ld	ra,56(sp)
 e52:	7442                	ld	s0,48(sp)
 e54:	74a2                	ld	s1,40(sp)
 e56:	69e2                	ld	s3,24(sp)
 e58:	6121                	addi	sp,sp,64
 e5a:	8082                	ret
 e5c:	7902                	ld	s2,32(sp)
 e5e:	6a42                	ld	s4,16(sp)
 e60:	6aa2                	ld	s5,8(sp)
 e62:	6b02                	ld	s6,0(sp)
 e64:	b7f5                	j	e50 <malloc+0xe2>
