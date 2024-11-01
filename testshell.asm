
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
  16:	d5e58593          	addi	a1,a1,-674 # d70 <malloc+0xfa>
  1a:	4509                	li	a0,2
  1c:	7ae000ef          	jal	7ca <write>
	memset(buf, 0, nbuf);
  20:	864a                	mv	a2,s2
  22:	4581                	li	a1,0
  24:	8526                	mv	a0,s1
  26:	59e000ef          	jal	5c4 <memset>
	gets(buf, nbuf);
  2a:	85ca                	mv	a1,s2
  2c:	8526                	mv	a0,s1
  2e:	5dc000ef          	jal	60a <gets>

	fprintf(2, "Chars: %d\n", strlen(buf));
  32:	8526                	mv	a0,s1
  34:	566000ef          	jal	59a <strlen>
  38:	0005061b          	sext.w	a2,a0
  3c:	00001597          	auipc	a1,0x1
  40:	d4458593          	addi	a1,a1,-700 # d80 <malloc+0x10a>
  44:	4509                	li	a0,2
  46:	353000ef          	jal	b98 <fprintf>
	fprintf(2, "Buf: %s\n", buf);
  4a:	8626                	mv	a2,s1
  4c:	00001597          	auipc	a1,0x1
  50:	d4458593          	addi	a1,a1,-700 # d90 <malloc+0x11a>
  54:	4509                	li	a0,2
  56:	343000ef          	jal	b98 <fprintf>

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
  c2:	2ab05163          	blez	a1,364 <run_command+0x2f2>
  c6:	84aa                	mv	s1,a0
  c8:	4901                	li	s2,0
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
  d8:	f0f43c23          	sd	a5,-232(s0)
	int numargs = 0; // number of arguments
  dc:	f2043023          	sd	zero,-224(s0)
		
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
  f8:	a065                	j	1a0 <run_command+0x12e>
			fprintf(2, "REDIR_L FLAG SET\n");
  fa:	00001597          	auipc	a1,0x1
  fe:	ca658593          	addi	a1,a1,-858 # da0 <malloc+0x12a>
 102:	4509                	li	a0,2
 104:	295000ef          	jal	b98 <fprintf>
			buf[i] = 0; // Null terminate a word
 108:	00048023          	sb	zero,0(s1)
			redirection_left = 1;
 10c:	4a85                	li	s5,1
			continue;
 10e:	a069                	j	198 <run_command+0x126>
			fprintf(2, "REDIR_R FLAG SET\n");
 110:	00001597          	auipc	a1,0x1
 114:	ca858593          	addi	a1,a1,-856 # db8 <malloc+0x142>
 118:	4509                	li	a0,2
 11a:	27f000ef          	jal	b98 <fprintf>
			buf[i] = 0;
 11e:	f2843783          	ld	a5,-216(s0)
 122:	00078023          	sb	zero,0(a5)
			redirection_right = 1;
 126:	4a05                	li	s4,1
			continue;
 128:	a885                	j	198 <run_command+0x126>
			fprintf(2, "PIPE_CMD SET TO: %d\n", i+1);
 12a:	0019049b          	addiw	s1,s2,1
 12e:	8626                	mv	a2,s1
 130:	00001597          	auipc	a1,0x1
 134:	ca058593          	addi	a1,a1,-864 # dd0 <malloc+0x15a>
 138:	4509                	li	a0,2
 13a:	25f000ef          	jal	b98 <fprintf>
			buf[i] = 0;
 13e:	f2843783          	ld	a5,-216(s0)
 142:	00078023          	sb	zero,0(a5)
		}
	}
	

	// Dealing with sequence command ;
	if (sequence_cmd){
 146:	aa3d                	j	284 <run_command+0x212>
			fprintf(2, "SEQUENCE_CMD SET TO: %d\n", i+1);
 148:	2905                	addiw	s2,s2,1
 14a:	0009049b          	sext.w	s1,s2
 14e:	8626                	mv	a2,s1
 150:	00001597          	auipc	a1,0x1
 154:	c9858593          	addi	a1,a1,-872 # de8 <malloc+0x172>
 158:	4509                	li	a0,2
 15a:	23f000ef          	jal	b98 <fprintf>
			buf[i] = 0;
 15e:	f2843783          	ld	a5,-216(s0)
 162:	00078023          	sb	zero,0(a5)
	if (sequence_cmd){
 166:	10048f63          	beqz	s1,284 <run_command+0x212>

		// Parent Process
		if (fork() != 0){
 16a:	638000ef          	jal	7a2 <fork>
 16e:	18051863          	bnez	a0,2fe <run_command+0x28c>
 172:	84aa                	mv	s1,a0
 174:	aa01                	j	284 <run_command+0x212>
				buf[i] = 0; // null terminate
 176:	f2843783          	ld	a5,-216(s0)
 17a:	00078023          	sb	zero,0(a5)
				ws = 1; // start a new word
 17e:	4785                	li	a5,1
 180:	f0f43c23          	sd	a5,-232(s0)
			arguments[numargs] = 0; // NULL Terminate to make it a valid pass to exec()
 184:	f2043783          	ld	a5,-224(s0)
 188:	078e                	slli	a5,a5,0x3
 18a:	f9078793          	addi	a5,a5,-112
 18e:	97a2                	add	a5,a5,s0
 190:	fa07b823          	sd	zero,-80(a5)
 194:	8a4e                	mv	s4,s3
 196:	8ace                	mv	s5,s3
	for (int i = 0; i < nbuf; i++){
 198:	2905                	addiw	s2,s2,1
 19a:	0485                	addi	s1,s1,1
 19c:	0f2b0363          	beq	s6,s2,282 <run_command+0x210>
		if (buf[i] == '<'){
 1a0:	f2943423          	sd	s1,-216(s0)
 1a4:	0004c783          	lbu	a5,0(s1)
 1a8:	f57789e3          	beq	a5,s7,fa <run_command+0x88>
		if (buf[i] == '>'){
 1ac:	f78782e3          	beq	a5,s8,110 <run_command+0x9e>
		if (buf[i] == '|'){
 1b0:	f7978de3          	beq	a5,s9,12a <run_command+0xb8>
		if (buf[i] == ';'){
 1b4:	f9a78ae3          	beq	a5,s10,148 <run_command+0xd6>
		if (!(redirection_left || redirection_right)){
 1b8:	014ae9b3          	or	s3,s5,s4
 1bc:	02099863          	bnez	s3,1ec <run_command+0x17a>
			if ((buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\n' || buf[i] == 13)){
 1c0:	02000713          	li	a4,32
 1c4:	28f76e63          	bltu	a4,a5,460 <run_command+0x3ee>
 1c8:	00fdd733          	srl	a4,s11,a5
 1cc:	8b05                	andi	a4,a4,1
 1ce:	c719                	beqz	a4,1dc <run_command+0x16a>
				if (ws) continue; // skip this iteration if it's a start of word is whitespace
 1d0:	f1843783          	ld	a5,-232(s0)
 1d4:	d3cd                	beqz	a5,176 <run_command+0x104>
 1d6:	8a4e                	mv	s4,s3
 1d8:	8ace                	mv	s5,s3
 1da:	bf7d                	j	198 <run_command+0x126>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 1dc:	f1843703          	ld	a4,-232(s0)
 1e0:	d355                	beqz	a4,184 <run_command+0x112>
				if (strcmp(&buf[i], "") != 0){
 1e2:	28079363          	bnez	a5,468 <run_command+0x3f6>
				ws = 1; // start a new word
 1e6:	f1343c23          	sd	s3,-232(s0)
 1ea:	bf69                	j	184 <run_command+0x112>
			if (!file_name_l && redirection_left){ // if left redirection
 1ec:	f0843703          	ld	a4,-248(s0)
 1f0:	cb15                	beqz	a4,224 <run_command+0x1b2>
			if (!file_name_r && redirection_right){
 1f2:	f1043783          	ld	a5,-240(s0)
 1f6:	f3cd                	bnez	a5,198 <run_command+0x126>
 1f8:	fa0a00e3          	beqz	s4,198 <run_command+0x126>
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 1fc:	f2843783          	ld	a5,-216(s0)
 200:	0007c703          	lbu	a4,0(a5)
 204:	02000793          	li	a5,32
 208:	04e7ef63          	bltu	a5,a4,266 <run_command+0x1f4>
 20c:	008007b7          	lui	a5,0x800
 210:	07cd                	addi	a5,a5,19 # 800013 <base+0x7fdf9b>
 212:	07a6                	slli	a5,a5,0x9
 214:	00e7d7b3          	srl	a5,a5,a4
 218:	8b85                	andi	a5,a5,1
 21a:	c7b1                	beqz	a5,266 <run_command+0x1f4>
 21c:	8a4e                	mv	s4,s3
 21e:	f0043823          	sd	zero,-240(s0)
 222:	bf9d                	j	198 <run_command+0x126>
			if (!file_name_l && redirection_left){ // if left redirection
 224:	220a8863          	beqz	s5,454 <run_command+0x3e2>
				if (buf[i] != ' ' && buf[i] != '\t' && buf[i] != '\n' && buf[i] != 13){
 228:	02000713          	li	a4,32
 22c:	00f76a63          	bltu	a4,a5,240 <run_command+0x1ce>
 230:	00800737          	lui	a4,0x800
 234:	074d                	addi	a4,a4,19 # 800013 <base+0x7fdf9b>
 236:	0726                	slli	a4,a4,0x9
 238:	00f75733          	srl	a4,a4,a5
 23c:	8b05                	andi	a4,a4,1
 23e:	fb55                	bnez	a4,1f2 <run_command+0x180>
					fprintf(2, "file_name_l: <S>%s<E>\n", file_name_l);
 240:	f2843603          	ld	a2,-216(s0)
 244:	00001597          	auipc	a1,0x1
 248:	bc458593          	addi	a1,a1,-1084 # e08 <malloc+0x192>
 24c:	4509                	li	a0,2
 24e:	14b000ef          	jal	b98 <fprintf>
					file_name_l = &buf[i]; // capture string
 252:	f2843783          	ld	a5,-216(s0)
 256:	f0f43423          	sd	a5,-248(s0)
 25a:	bf61                	j	1f2 <run_command+0x180>
			if (!file_name_r && redirection_right){
 25c:	f1043783          	ld	a5,-240(s0)
 260:	f0f43423          	sd	a5,-248(s0)
 264:	bf61                	j	1fc <run_command+0x18a>
					fprintf(2, "file_name_r: <S>%s<E>\n", file_name_r);
 266:	f2843a03          	ld	s4,-216(s0)
 26a:	8652                	mv	a2,s4
 26c:	00001597          	auipc	a1,0x1
 270:	bb458593          	addi	a1,a1,-1100 # e20 <malloc+0x1aa>
 274:	4509                	li	a0,2
 276:	123000ef          	jal	b98 <fprintf>
					file_name_r = &buf[i];
 27a:	f1443823          	sd	s4,-240(s0)
					fprintf(2, "file_name_r: <S>%s<E>\n", file_name_r);
 27e:	8a4e                	mv	s4,s3
 280:	bf21                	j	198 <run_command+0x126>
 282:	4481                	li	s1,0
		}
	}

	// Dealing with redirection command < and >

	if (redirection_left){
 284:	0a0a9a63          	bnez	s5,338 <run_command+0x2c6>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
			fprintf(2, "Failed to open file: <S>%s<E>\n", file_name_l);
			exit(1); // quit
		}
	}
	if (redirection_right){
 288:	0e0a1563          	bnez	s4,372 <run_command+0x300>
			exit(1); // quit
		}
	}

	// Handle cd special case
	if (numargs > 0 && strcmp(arguments[0], "cd") == 0){
 28c:	f2043783          	ld	a5,-224(s0)
 290:	00f05c63          	blez	a5,2a8 <run_command+0x236>
 294:	00001597          	auipc	a1,0x1
 298:	bec58593          	addi	a1,a1,-1044 # e80 <malloc+0x20a>
 29c:	f4043503          	ld	a0,-192(s0)
 2a0:	2ce000ef          	jal	56e <strcmp>
 2a4:	0e050e63          	beqz	a0,3a0 <run_command+0x32e>
		// Exit with 2 to let main know there is cd command
		exit(2);

	}else{ // We know it is not a cd command
		// Technique from source 2
		if (pipe_cmd){
 2a8:	16048063          	beqz	s1,408 <run_command+0x396>
			
			pipe(p); // New pipe
 2ac:	f3840513          	addi	a0,s0,-200
 2b0:	50a000ef          	jal	7ba <pipe>
			
			if (fork() == 0){
 2b4:	4ee000ef          	jal	7a2 <fork>
 2b8:	10051663          	bnez	a0,3c4 <run_command+0x352>
				close(1); // close stdout
 2bc:	4505                	li	a0,1
 2be:	514000ef          	jal	7d2 <close>
				dup(p[1]); // Make "in" part of pipe to be stdout
 2c2:	f3c42503          	lw	a0,-196(s0)
 2c6:	55c000ef          	jal	822 <dup>
				
				close(p[0]);
 2ca:	f3842503          	lw	a0,-200(s0)
 2ce:	504000ef          	jal	7d2 <close>
				close(p[1]);
 2d2:	f3c42503          	lw	a0,-196(s0)
 2d6:	4fc000ef          	jal	7d2 <close>

				exec(arguments[0], arguments); // Execute command on the left
 2da:	f4040593          	addi	a1,s0,-192
 2de:	f4043503          	ld	a0,-192(s0)
 2e2:	500000ef          	jal	7e2 <exec>
				
				// If we reach this part that means something went wrong
				fprintf(2, "P_LEFT: Execution of the command failed:<S>%s<E>", arguments[0]);
 2e6:	f4043603          	ld	a2,-192(s0)
 2ea:	00001597          	auipc	a1,0x1
 2ee:	b9e58593          	addi	a1,a1,-1122 # e88 <malloc+0x212>
 2f2:	4509                	li	a0,2
 2f4:	0a5000ef          	jal	b98 <fprintf>
				exit(1);
 2f8:	4505                	li	a0,1
 2fa:	4b0000ef          	jal	7aa <exit>
			wait(0);
 2fe:	4501                	li	a0,0
 300:	4b2000ef          	jal	7b2 <wait>
			fprintf(2, "Buf:<S>%s<E>\n",buf);
 304:	ef843983          	ld	s3,-264(s0)
 308:	864e                	mv	a2,s3
 30a:	00001597          	auipc	a1,0x1
 30e:	b2e58593          	addi	a1,a1,-1234 # e38 <malloc+0x1c2>
 312:	4509                	li	a0,2
 314:	085000ef          	jal	b98 <fprintf>
			fprintf(2, "Buf Alt: <S>%s<E>\n", &buf[sequence_cmd]);
 318:	94ce                	add	s1,s1,s3
 31a:	8626                	mv	a2,s1
 31c:	00001597          	auipc	a1,0x1
 320:	b2c58593          	addi	a1,a1,-1236 # e48 <malloc+0x1d2>
 324:	4509                	li	a0,2
 326:	073000ef          	jal	b98 <fprintf>
			run_command(&buf[sequence_cmd], nbuf - sequence_cmd, pcp);
 32a:	f0043603          	ld	a2,-256(s0)
 32e:	412b05bb          	subw	a1,s6,s2
 332:	8526                	mv	a0,s1
 334:	d3fff0ef          	jal	72 <run_command>
		close(0); // close stdin
 338:	4501                	li	a0,0
 33a:	498000ef          	jal	7d2 <close>
		if (open(file_name_l, O_RDONLY) < 0){ // open our file with fd of 0
 33e:	4581                	li	a1,0
 340:	f0843503          	ld	a0,-248(s0)
 344:	4a6000ef          	jal	7ea <open>
 348:	f40550e3          	bgez	a0,288 <run_command+0x216>
			fprintf(2, "Failed to open file: <S>%s<E>\n", file_name_l);
 34c:	f0843603          	ld	a2,-248(s0)
 350:	00001597          	auipc	a1,0x1
 354:	b1058593          	addi	a1,a1,-1264 # e60 <malloc+0x1ea>
 358:	4509                	li	a0,2
 35a:	03f000ef          	jal	b98 <fprintf>
			exit(1); // quit
 35e:	4505                	li	a0,1
 360:	44a000ef          	jal	7aa <exit>
	char* file_name_r = 0; // Buffer to store name of file on the right
 364:	f0043823          	sd	zero,-240(s0)
	int redirection_right = 0; // >
 368:	4a01                	li	s4,0
	int numargs = 0; // number of arguments
 36a:	f2043023          	sd	zero,-224(s0)
	for (int i = 0; i < nbuf; i++){
 36e:	4481                	li	s1,0
 370:	bf21                	j	288 <run_command+0x216>
		close(1); // close stdout
 372:	4505                	li	a0,1
 374:	45e000ef          	jal	7d2 <close>
		if (open(file_name_r, O_WRONLY|O_CREATE|O_TRUNC) < 0){ // open our file with fd of 1
 378:	60100593          	li	a1,1537
 37c:	f1043503          	ld	a0,-240(s0)
 380:	46a000ef          	jal	7ea <open>
 384:	f00554e3          	bgez	a0,28c <run_command+0x21a>
			fprintf(2, "Failed to open file: <S>%s<E>\n", file_name_r);
 388:	f1043603          	ld	a2,-240(s0)
 38c:	00001597          	auipc	a1,0x1
 390:	ad458593          	addi	a1,a1,-1324 # e60 <malloc+0x1ea>
 394:	4509                	li	a0,2
 396:	003000ef          	jal	b98 <fprintf>
			exit(1); // quit
 39a:	4505                	li	a0,1
 39c:	40e000ef          	jal	7aa <exit>
		write(pcp[1], arguments[1], strlen(arguments[1]));
 3a0:	f0043783          	ld	a5,-256(s0)
 3a4:	0047a903          	lw	s2,4(a5)
 3a8:	f4843483          	ld	s1,-184(s0)
 3ac:	8526                	mv	a0,s1
 3ae:	1ec000ef          	jal	59a <strlen>
 3b2:	0005061b          	sext.w	a2,a0
 3b6:	85a6                	mv	a1,s1
 3b8:	854a                	mv	a0,s2
 3ba:	410000ef          	jal	7ca <write>
		exit(2);
 3be:	4509                	li	a0,2
 3c0:	3ea000ef          	jal	7aa <exit>
			}
			if (fork() == 0){ // Handle right side recursively
 3c4:	3de000ef          	jal	7a2 <fork>
 3c8:	e90d                	bnez	a0,3fa <run_command+0x388>
				close(0); // close stdin
 3ca:	408000ef          	jal	7d2 <close>
				dup(p[0]); // Make "out" part of pipe to be stdin
 3ce:	f3842503          	lw	a0,-200(s0)
 3d2:	450000ef          	jal	822 <dup>

				close(p[1]);
 3d6:	f3c42503          	lw	a0,-196(s0)
 3da:	3f8000ef          	jal	7d2 <close>
				close(p[0]);
 3de:	f3842503          	lw	a0,-200(s0)
 3e2:	3f0000ef          	jal	7d2 <close>

				run_command(&buf[pipe_cmd], nbuf - pipe_cmd, pcp);
 3e6:	f0043603          	ld	a2,-256(s0)
 3ea:	409b05bb          	subw	a1,s6,s1
 3ee:	ef843783          	ld	a5,-264(s0)
 3f2:	00978533          	add	a0,a5,s1
 3f6:	c7dff0ef          	jal	72 <run_command>
			}
			wait(0);
 3fa:	4501                	li	a0,0
 3fc:	3b6000ef          	jal	7b2 <wait>
			wait(0);
 400:	4501                	li	a0,0
 402:	3b0000ef          	jal	7b2 <wait>
 406:	a0a1                	j	44e <run_command+0x3dc>
		}else{ // No pipes as well, just a plain command
			exec(arguments[0], arguments);
 408:	f4040593          	addi	a1,s0,-192
 40c:	f4043503          	ld	a0,-192(s0)
 410:	3d2000ef          	jal	7e2 <exec>

			// Something went wrong if this part is reached
			fprintf(2, "DEFAULT:Execution of the command failed:<S>%s<E>", arguments[0]);
 414:	f4043603          	ld	a2,-192(s0)
 418:	00001597          	auipc	a1,0x1
 41c:	aa858593          	addi	a1,a1,-1368 # ec0 <malloc+0x24a>
 420:	4509                	li	a0,2
 422:	776000ef          	jal	b98 <fprintf>
			for(int j = 0; j < 9; j++){
 426:	f4040913          	addi	s2,s0,-192
				fprintf(2, "\nArg[%d] = <S>%s<E>, narg = %d",j , arguments[j], numargs);
 42a:	00001a17          	auipc	s4,0x1
 42e:	acea0a13          	addi	s4,s4,-1330 # ef8 <malloc+0x282>
			for(int j = 0; j < 9; j++){
 432:	49a5                	li	s3,9
				fprintf(2, "\nArg[%d] = <S>%s<E>, narg = %d",j , arguments[j], numargs);
 434:	f2043703          	ld	a4,-224(s0)
 438:	00093683          	ld	a3,0(s2)
 43c:	8626                	mv	a2,s1
 43e:	85d2                	mv	a1,s4
 440:	4509                	li	a0,2
 442:	756000ef          	jal	b98 <fprintf>
			for(int j = 0; j < 9; j++){
 446:	2485                	addiw	s1,s1,1
 448:	0921                	addi	s2,s2,8
 44a:	ff3495e3          	bne	s1,s3,434 <run_command+0x3c2>
			}	
		}
	}
	exit(0);
 44e:	4501                	li	a0,0
 450:	35a000ef          	jal	7aa <exit>
			if (!file_name_r && redirection_right){
 454:	f1043783          	ld	a5,-240(s0)
 458:	e00782e3          	beqz	a5,25c <run_command+0x1ea>
 45c:	8a4e                	mv	s4,s3
 45e:	bb2d                	j	198 <run_command+0x126>
			}else if (ws && (we == 0)){ // At the start of a new word, and not and the end of a word
 460:	f1843783          	ld	a5,-232(s0)
 464:	d20780e3          	beqz	a5,184 <run_command+0x112>
					arguments[numargs++] = &buf[i]; // Save word string to arguments
 468:	f2043703          	ld	a4,-224(s0)
 46c:	00371793          	slli	a5,a4,0x3
 470:	f9078793          	addi	a5,a5,-112
 474:	97a2                	add	a5,a5,s0
 476:	f2843683          	ld	a3,-216(s0)
 47a:	fad7b823          	sd	a3,-80(a5)
 47e:	0017079b          	addiw	a5,a4,1
 482:	f2f43023          	sd	a5,-224(s0)
 486:	b385                	j	1e6 <run_command+0x174>

0000000000000488 <main>:


// Purpose: Repeatedly prompt user for input, forks process to run commands,
// and handle the chdir special case.

int main(void){
 488:	7135                	addi	sp,sp,-160
 48a:	ed06                	sd	ra,152(sp)
 48c:	e922                	sd	s0,144(sp)
 48e:	e526                	sd	s1,136(sp)
 490:	e14a                	sd	s2,128(sp)
 492:	1100                	addi	s0,sp,160
	
	static char buf[100];

	// Setup a pipe
	int pcp[2];
	pipe(pcp);
 494:	fd840513          	addi	a0,s0,-40
 498:	322000ef          	jal	7ba <pipe>

	int fd;

	// Make sure file descriptors are open
	// Taken from source 1
	while((fd = open("console", O_RDWR)) >= 0){
 49c:	00001497          	auipc	s1,0x1
 4a0:	a7c48493          	addi	s1,s1,-1412 # f18 <malloc+0x2a2>
 4a4:	4589                	li	a1,2
 4a6:	8526                	mv	a0,s1
 4a8:	342000ef          	jal	7ea <open>
 4ac:	00054763          	bltz	a0,4ba <main+0x32>
		if(fd >= 3){
 4b0:	4789                	li	a5,2
 4b2:	fea7d9e3          	bge	a5,a0,4a4 <main+0x1c>
			close(fd); // close 0, 1 and 2 and it will reopen itself
 4b6:	31c000ef          	jal	7d2 <close>
			break;
		}
	}
	
	// Main Loop
	while(getcmd(buf, sizeof(buf)) >= 0){
 4ba:	00002497          	auipc	s1,0x2
 4be:	b5648493          	addi	s1,s1,-1194 # 2010 <buf.0>
		
		int child_status;

		wait(&child_status);

		if (child_status == 2){ // CD command is detected, must execute in parent
 4c2:	4909                	li	s2,2
	while(getcmd(buf, sizeof(buf)) >= 0){
 4c4:	06400593          	li	a1,100
 4c8:	8526                	mv	a0,s1
 4ca:	b37ff0ef          	jal	0 <getcmd>
 4ce:	06054663          	bltz	a0,53a <main+0xb2>
		if (fork() == 0){
 4d2:	2d0000ef          	jal	7a2 <fork>
 4d6:	cd1d                	beqz	a0,514 <main+0x8c>
		wait(&child_status);
 4d8:	f6c40513          	addi	a0,s0,-148
 4dc:	2d6000ef          	jal	7b2 <wait>
		if (child_status == 2){ // CD command is detected, must execute in parent
 4e0:	f6c42783          	lw	a5,-148(s0)
 4e4:	ff2790e3          	bne	a5,s2,4c4 <main+0x3c>
			char buffer_cd_arg[100];
			// Read from pipe the pathname to cd
			read(pcp[0], buffer_cd_arg, sizeof(buffer_cd_arg));
 4e8:	06400613          	li	a2,100
 4ec:	f7040593          	addi	a1,s0,-144
 4f0:	fd842503          	lw	a0,-40(s0)
 4f4:	2ce000ef          	jal	7c2 <read>
			
			// Attempt to use chdir system call
			if (chdir(buffer_cd_arg) < 0){
 4f8:	f7040513          	addi	a0,s0,-144
 4fc:	31e000ef          	jal	81a <chdir>
 500:	fc0552e3          	bgez	a0,4c4 <main+0x3c>
				fprintf(2, "Failed to change directory\n");
 504:	00001597          	auipc	a1,0x1
 508:	a2c58593          	addi	a1,a1,-1492 # f30 <malloc+0x2ba>
 50c:	4509                	li	a0,2
 50e:	68a000ef          	jal	b98 <fprintf>
 512:	bf4d                	j	4c4 <main+0x3c>
			fprintf(2, "main_child: %s", buf);
 514:	00002497          	auipc	s1,0x2
 518:	afc48493          	addi	s1,s1,-1284 # 2010 <buf.0>
 51c:	8626                	mv	a2,s1
 51e:	00001597          	auipc	a1,0x1
 522:	a0258593          	addi	a1,a1,-1534 # f20 <malloc+0x2aa>
 526:	4509                	li	a0,2
 528:	670000ef          	jal	b98 <fprintf>
			run_command(buf, 100, pcp);
 52c:	fd840613          	addi	a2,s0,-40
 530:	06400593          	li	a1,100
 534:	8526                	mv	a0,s1
 536:	b3dff0ef          	jal	72 <run_command>
			}	
		}
	}
	exit(0);
 53a:	4501                	li	a0,0
 53c:	26e000ef          	jal	7aa <exit>

0000000000000540 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 540:	1141                	addi	sp,sp,-16
 542:	e406                	sd	ra,8(sp)
 544:	e022                	sd	s0,0(sp)
 546:	0800                	addi	s0,sp,16
  extern int main();
  main();
 548:	f41ff0ef          	jal	488 <main>
  exit(0);
 54c:	4501                	li	a0,0
 54e:	25c000ef          	jal	7aa <exit>

0000000000000552 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 552:	1141                	addi	sp,sp,-16
 554:	e422                	sd	s0,8(sp)
 556:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 558:	87aa                	mv	a5,a0
 55a:	0585                	addi	a1,a1,1
 55c:	0785                	addi	a5,a5,1
 55e:	fff5c703          	lbu	a4,-1(a1)
 562:	fee78fa3          	sb	a4,-1(a5)
 566:	fb75                	bnez	a4,55a <strcpy+0x8>
    ;
  return os;
}
 568:	6422                	ld	s0,8(sp)
 56a:	0141                	addi	sp,sp,16
 56c:	8082                	ret

000000000000056e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 56e:	1141                	addi	sp,sp,-16
 570:	e422                	sd	s0,8(sp)
 572:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 574:	00054783          	lbu	a5,0(a0)
 578:	cb91                	beqz	a5,58c <strcmp+0x1e>
 57a:	0005c703          	lbu	a4,0(a1)
 57e:	00f71763          	bne	a4,a5,58c <strcmp+0x1e>
    p++, q++;
 582:	0505                	addi	a0,a0,1
 584:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 586:	00054783          	lbu	a5,0(a0)
 58a:	fbe5                	bnez	a5,57a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 58c:	0005c503          	lbu	a0,0(a1)
}
 590:	40a7853b          	subw	a0,a5,a0
 594:	6422                	ld	s0,8(sp)
 596:	0141                	addi	sp,sp,16
 598:	8082                	ret

000000000000059a <strlen>:

uint
strlen(const char *s)
{
 59a:	1141                	addi	sp,sp,-16
 59c:	e422                	sd	s0,8(sp)
 59e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5a0:	00054783          	lbu	a5,0(a0)
 5a4:	cf91                	beqz	a5,5c0 <strlen+0x26>
 5a6:	0505                	addi	a0,a0,1
 5a8:	87aa                	mv	a5,a0
 5aa:	86be                	mv	a3,a5
 5ac:	0785                	addi	a5,a5,1
 5ae:	fff7c703          	lbu	a4,-1(a5)
 5b2:	ff65                	bnez	a4,5aa <strlen+0x10>
 5b4:	40a6853b          	subw	a0,a3,a0
 5b8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 5ba:	6422                	ld	s0,8(sp)
 5bc:	0141                	addi	sp,sp,16
 5be:	8082                	ret
  for(n = 0; s[n]; n++)
 5c0:	4501                	li	a0,0
 5c2:	bfe5                	j	5ba <strlen+0x20>

00000000000005c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c4:	1141                	addi	sp,sp,-16
 5c6:	e422                	sd	s0,8(sp)
 5c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5ca:	ca19                	beqz	a2,5e0 <memset+0x1c>
 5cc:	87aa                	mv	a5,a0
 5ce:	1602                	slli	a2,a2,0x20
 5d0:	9201                	srli	a2,a2,0x20
 5d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5da:	0785                	addi	a5,a5,1
 5dc:	fee79de3          	bne	a5,a4,5d6 <memset+0x12>
  }
  return dst;
}
 5e0:	6422                	ld	s0,8(sp)
 5e2:	0141                	addi	sp,sp,16
 5e4:	8082                	ret

00000000000005e6 <strchr>:

char*
strchr(const char *s, char c)
{
 5e6:	1141                	addi	sp,sp,-16
 5e8:	e422                	sd	s0,8(sp)
 5ea:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5ec:	00054783          	lbu	a5,0(a0)
 5f0:	cb99                	beqz	a5,606 <strchr+0x20>
    if(*s == c)
 5f2:	00f58763          	beq	a1,a5,600 <strchr+0x1a>
  for(; *s; s++)
 5f6:	0505                	addi	a0,a0,1
 5f8:	00054783          	lbu	a5,0(a0)
 5fc:	fbfd                	bnez	a5,5f2 <strchr+0xc>
      return (char*)s;
  return 0;
 5fe:	4501                	li	a0,0
}
 600:	6422                	ld	s0,8(sp)
 602:	0141                	addi	sp,sp,16
 604:	8082                	ret
  return 0;
 606:	4501                	li	a0,0
 608:	bfe5                	j	600 <strchr+0x1a>

000000000000060a <gets>:

char*
gets(char *buf, int max)
{
 60a:	711d                	addi	sp,sp,-96
 60c:	ec86                	sd	ra,88(sp)
 60e:	e8a2                	sd	s0,80(sp)
 610:	e4a6                	sd	s1,72(sp)
 612:	e0ca                	sd	s2,64(sp)
 614:	fc4e                	sd	s3,56(sp)
 616:	f852                	sd	s4,48(sp)
 618:	f456                	sd	s5,40(sp)
 61a:	f05a                	sd	s6,32(sp)
 61c:	ec5e                	sd	s7,24(sp)
 61e:	1080                	addi	s0,sp,96
 620:	8baa                	mv	s7,a0
 622:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 624:	892a                	mv	s2,a0
 626:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 628:	4aa9                	li	s5,10
 62a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 62c:	89a6                	mv	s3,s1
 62e:	2485                	addiw	s1,s1,1
 630:	0344d663          	bge	s1,s4,65c <gets+0x52>
    cc = read(0, &c, 1);
 634:	4605                	li	a2,1
 636:	faf40593          	addi	a1,s0,-81
 63a:	4501                	li	a0,0
 63c:	186000ef          	jal	7c2 <read>
    if(cc < 1)
 640:	00a05e63          	blez	a0,65c <gets+0x52>
    buf[i++] = c;
 644:	faf44783          	lbu	a5,-81(s0)
 648:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 64c:	01578763          	beq	a5,s5,65a <gets+0x50>
 650:	0905                	addi	s2,s2,1
 652:	fd679de3          	bne	a5,s6,62c <gets+0x22>
    buf[i++] = c;
 656:	89a6                	mv	s3,s1
 658:	a011                	j	65c <gets+0x52>
 65a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 65c:	99de                	add	s3,s3,s7
 65e:	00098023          	sb	zero,0(s3)
  return buf;
}
 662:	855e                	mv	a0,s7
 664:	60e6                	ld	ra,88(sp)
 666:	6446                	ld	s0,80(sp)
 668:	64a6                	ld	s1,72(sp)
 66a:	6906                	ld	s2,64(sp)
 66c:	79e2                	ld	s3,56(sp)
 66e:	7a42                	ld	s4,48(sp)
 670:	7aa2                	ld	s5,40(sp)
 672:	7b02                	ld	s6,32(sp)
 674:	6be2                	ld	s7,24(sp)
 676:	6125                	addi	sp,sp,96
 678:	8082                	ret

000000000000067a <stat>:

int
stat(const char *n, struct stat *st)
{
 67a:	1101                	addi	sp,sp,-32
 67c:	ec06                	sd	ra,24(sp)
 67e:	e822                	sd	s0,16(sp)
 680:	e04a                	sd	s2,0(sp)
 682:	1000                	addi	s0,sp,32
 684:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 686:	4581                	li	a1,0
 688:	162000ef          	jal	7ea <open>
  if(fd < 0)
 68c:	02054263          	bltz	a0,6b0 <stat+0x36>
 690:	e426                	sd	s1,8(sp)
 692:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 694:	85ca                	mv	a1,s2
 696:	16c000ef          	jal	802 <fstat>
 69a:	892a                	mv	s2,a0
  close(fd);
 69c:	8526                	mv	a0,s1
 69e:	134000ef          	jal	7d2 <close>
  return r;
 6a2:	64a2                	ld	s1,8(sp)
}
 6a4:	854a                	mv	a0,s2
 6a6:	60e2                	ld	ra,24(sp)
 6a8:	6442                	ld	s0,16(sp)
 6aa:	6902                	ld	s2,0(sp)
 6ac:	6105                	addi	sp,sp,32
 6ae:	8082                	ret
    return -1;
 6b0:	597d                	li	s2,-1
 6b2:	bfcd                	j	6a4 <stat+0x2a>

00000000000006b4 <atoi>:

int
atoi(const char *s)
{
 6b4:	1141                	addi	sp,sp,-16
 6b6:	e422                	sd	s0,8(sp)
 6b8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6ba:	00054683          	lbu	a3,0(a0)
 6be:	fd06879b          	addiw	a5,a3,-48
 6c2:	0ff7f793          	zext.b	a5,a5
 6c6:	4625                	li	a2,9
 6c8:	02f66863          	bltu	a2,a5,6f8 <atoi+0x44>
 6cc:	872a                	mv	a4,a0
  n = 0;
 6ce:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6d0:	0705                	addi	a4,a4,1
 6d2:	0025179b          	slliw	a5,a0,0x2
 6d6:	9fa9                	addw	a5,a5,a0
 6d8:	0017979b          	slliw	a5,a5,0x1
 6dc:	9fb5                	addw	a5,a5,a3
 6de:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6e2:	00074683          	lbu	a3,0(a4)
 6e6:	fd06879b          	addiw	a5,a3,-48
 6ea:	0ff7f793          	zext.b	a5,a5
 6ee:	fef671e3          	bgeu	a2,a5,6d0 <atoi+0x1c>
  return n;
}
 6f2:	6422                	ld	s0,8(sp)
 6f4:	0141                	addi	sp,sp,16
 6f6:	8082                	ret
  n = 0;
 6f8:	4501                	li	a0,0
 6fa:	bfe5                	j	6f2 <atoi+0x3e>

00000000000006fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6fc:	1141                	addi	sp,sp,-16
 6fe:	e422                	sd	s0,8(sp)
 700:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 702:	02b57463          	bgeu	a0,a1,72a <memmove+0x2e>
    while(n-- > 0)
 706:	00c05f63          	blez	a2,724 <memmove+0x28>
 70a:	1602                	slli	a2,a2,0x20
 70c:	9201                	srli	a2,a2,0x20
 70e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 712:	872a                	mv	a4,a0
      *dst++ = *src++;
 714:	0585                	addi	a1,a1,1
 716:	0705                	addi	a4,a4,1
 718:	fff5c683          	lbu	a3,-1(a1)
 71c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 720:	fef71ae3          	bne	a4,a5,714 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 724:	6422                	ld	s0,8(sp)
 726:	0141                	addi	sp,sp,16
 728:	8082                	ret
    dst += n;
 72a:	00c50733          	add	a4,a0,a2
    src += n;
 72e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 730:	fec05ae3          	blez	a2,724 <memmove+0x28>
 734:	fff6079b          	addiw	a5,a2,-1
 738:	1782                	slli	a5,a5,0x20
 73a:	9381                	srli	a5,a5,0x20
 73c:	fff7c793          	not	a5,a5
 740:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 742:	15fd                	addi	a1,a1,-1
 744:	177d                	addi	a4,a4,-1
 746:	0005c683          	lbu	a3,0(a1)
 74a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 74e:	fee79ae3          	bne	a5,a4,742 <memmove+0x46>
 752:	bfc9                	j	724 <memmove+0x28>

0000000000000754 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 754:	1141                	addi	sp,sp,-16
 756:	e422                	sd	s0,8(sp)
 758:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 75a:	ca05                	beqz	a2,78a <memcmp+0x36>
 75c:	fff6069b          	addiw	a3,a2,-1
 760:	1682                	slli	a3,a3,0x20
 762:	9281                	srli	a3,a3,0x20
 764:	0685                	addi	a3,a3,1
 766:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 768:	00054783          	lbu	a5,0(a0)
 76c:	0005c703          	lbu	a4,0(a1)
 770:	00e79863          	bne	a5,a4,780 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 774:	0505                	addi	a0,a0,1
    p2++;
 776:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 778:	fed518e3          	bne	a0,a3,768 <memcmp+0x14>
  }
  return 0;
 77c:	4501                	li	a0,0
 77e:	a019                	j	784 <memcmp+0x30>
      return *p1 - *p2;
 780:	40e7853b          	subw	a0,a5,a4
}
 784:	6422                	ld	s0,8(sp)
 786:	0141                	addi	sp,sp,16
 788:	8082                	ret
  return 0;
 78a:	4501                	li	a0,0
 78c:	bfe5                	j	784 <memcmp+0x30>

000000000000078e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 78e:	1141                	addi	sp,sp,-16
 790:	e406                	sd	ra,8(sp)
 792:	e022                	sd	s0,0(sp)
 794:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 796:	f67ff0ef          	jal	6fc <memmove>
}
 79a:	60a2                	ld	ra,8(sp)
 79c:	6402                	ld	s0,0(sp)
 79e:	0141                	addi	sp,sp,16
 7a0:	8082                	ret

00000000000007a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7a2:	4885                	li	a7,1
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 7aa:	4889                	li	a7,2
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7b2:	488d                	li	a7,3
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7ba:	4891                	li	a7,4
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <read>:
.global read
read:
 li a7, SYS_read
 7c2:	4895                	li	a7,5
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <write>:
.global write
write:
 li a7, SYS_write
 7ca:	48c1                	li	a7,16
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <close>:
.global close
close:
 li a7, SYS_close
 7d2:	48d5                	li	a7,21
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <kill>:
.global kill
kill:
 li a7, SYS_kill
 7da:	4899                	li	a7,6
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7e2:	489d                	li	a7,7
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <open>:
.global open
open:
 li a7, SYS_open
 7ea:	48bd                	li	a7,15
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7f2:	48c5                	li	a7,17
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7fa:	48c9                	li	a7,18
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 802:	48a1                	li	a7,8
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <link>:
.global link
link:
 li a7, SYS_link
 80a:	48cd                	li	a7,19
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 812:	48d1                	li	a7,20
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 81a:	48a5                	li	a7,9
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <dup>:
.global dup
dup:
 li a7, SYS_dup
 822:	48a9                	li	a7,10
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 82a:	48ad                	li	a7,11
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 832:	48b1                	li	a7,12
 ecall
 834:	00000073          	ecall
 ret
 838:	8082                	ret

000000000000083a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 83a:	48b5                	li	a7,13
 ecall
 83c:	00000073          	ecall
 ret
 840:	8082                	ret

0000000000000842 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 842:	48b9                	li	a7,14
 ecall
 844:	00000073          	ecall
 ret
 848:	8082                	ret

000000000000084a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 84a:	1101                	addi	sp,sp,-32
 84c:	ec06                	sd	ra,24(sp)
 84e:	e822                	sd	s0,16(sp)
 850:	1000                	addi	s0,sp,32
 852:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 856:	4605                	li	a2,1
 858:	fef40593          	addi	a1,s0,-17
 85c:	f6fff0ef          	jal	7ca <write>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6105                	addi	sp,sp,32
 866:	8082                	ret

0000000000000868 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f426                	sd	s1,40(sp)
 870:	0080                	addi	s0,sp,64
 872:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 874:	c299                	beqz	a3,87a <printint+0x12>
 876:	0805c963          	bltz	a1,908 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 87a:	2581                	sext.w	a1,a1
  neg = 0;
 87c:	4881                	li	a7,0
 87e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 882:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 884:	2601                	sext.w	a2,a2
 886:	00000517          	auipc	a0,0x0
 88a:	6d250513          	addi	a0,a0,1746 # f58 <digits>
 88e:	883a                	mv	a6,a4
 890:	2705                	addiw	a4,a4,1
 892:	02c5f7bb          	remuw	a5,a1,a2
 896:	1782                	slli	a5,a5,0x20
 898:	9381                	srli	a5,a5,0x20
 89a:	97aa                	add	a5,a5,a0
 89c:	0007c783          	lbu	a5,0(a5)
 8a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8a4:	0005879b          	sext.w	a5,a1
 8a8:	02c5d5bb          	divuw	a1,a1,a2
 8ac:	0685                	addi	a3,a3,1
 8ae:	fec7f0e3          	bgeu	a5,a2,88e <printint+0x26>
  if(neg)
 8b2:	00088c63          	beqz	a7,8ca <printint+0x62>
    buf[i++] = '-';
 8b6:	fd070793          	addi	a5,a4,-48
 8ba:	00878733          	add	a4,a5,s0
 8be:	02d00793          	li	a5,45
 8c2:	fef70823          	sb	a5,-16(a4)
 8c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 8ca:	02e05a63          	blez	a4,8fe <printint+0x96>
 8ce:	f04a                	sd	s2,32(sp)
 8d0:	ec4e                	sd	s3,24(sp)
 8d2:	fc040793          	addi	a5,s0,-64
 8d6:	00e78933          	add	s2,a5,a4
 8da:	fff78993          	addi	s3,a5,-1
 8de:	99ba                	add	s3,s3,a4
 8e0:	377d                	addiw	a4,a4,-1
 8e2:	1702                	slli	a4,a4,0x20
 8e4:	9301                	srli	a4,a4,0x20
 8e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8ea:	fff94583          	lbu	a1,-1(s2)
 8ee:	8526                	mv	a0,s1
 8f0:	f5bff0ef          	jal	84a <putc>
  while(--i >= 0)
 8f4:	197d                	addi	s2,s2,-1
 8f6:	ff391ae3          	bne	s2,s3,8ea <printint+0x82>
 8fa:	7902                	ld	s2,32(sp)
 8fc:	69e2                	ld	s3,24(sp)
}
 8fe:	70e2                	ld	ra,56(sp)
 900:	7442                	ld	s0,48(sp)
 902:	74a2                	ld	s1,40(sp)
 904:	6121                	addi	sp,sp,64
 906:	8082                	ret
    x = -xx;
 908:	40b005bb          	negw	a1,a1
    neg = 1;
 90c:	4885                	li	a7,1
    x = -xx;
 90e:	bf85                	j	87e <printint+0x16>

0000000000000910 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 910:	711d                	addi	sp,sp,-96
 912:	ec86                	sd	ra,88(sp)
 914:	e8a2                	sd	s0,80(sp)
 916:	e0ca                	sd	s2,64(sp)
 918:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 91a:	0005c903          	lbu	s2,0(a1)
 91e:	26090863          	beqz	s2,b8e <vprintf+0x27e>
 922:	e4a6                	sd	s1,72(sp)
 924:	fc4e                	sd	s3,56(sp)
 926:	f852                	sd	s4,48(sp)
 928:	f456                	sd	s5,40(sp)
 92a:	f05a                	sd	s6,32(sp)
 92c:	ec5e                	sd	s7,24(sp)
 92e:	e862                	sd	s8,16(sp)
 930:	e466                	sd	s9,8(sp)
 932:	8b2a                	mv	s6,a0
 934:	8a2e                	mv	s4,a1
 936:	8bb2                	mv	s7,a2
  state = 0;
 938:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 93a:	4481                	li	s1,0
 93c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 93e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 942:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 946:	06c00c93          	li	s9,108
 94a:	a005                	j	96a <vprintf+0x5a>
        putc(fd, c0);
 94c:	85ca                	mv	a1,s2
 94e:	855a                	mv	a0,s6
 950:	efbff0ef          	jal	84a <putc>
 954:	a019                	j	95a <vprintf+0x4a>
    } else if(state == '%'){
 956:	03598263          	beq	s3,s5,97a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 95a:	2485                	addiw	s1,s1,1
 95c:	8726                	mv	a4,s1
 95e:	009a07b3          	add	a5,s4,s1
 962:	0007c903          	lbu	s2,0(a5)
 966:	20090c63          	beqz	s2,b7e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 96a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 96e:	fe0994e3          	bnez	s3,956 <vprintf+0x46>
      if(c0 == '%'){
 972:	fd579de3          	bne	a5,s5,94c <vprintf+0x3c>
        state = '%';
 976:	89be                	mv	s3,a5
 978:	b7cd                	j	95a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 97a:	00ea06b3          	add	a3,s4,a4
 97e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 982:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 984:	c681                	beqz	a3,98c <vprintf+0x7c>
 986:	9752                	add	a4,a4,s4
 988:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 98c:	03878f63          	beq	a5,s8,9ca <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 990:	05978963          	beq	a5,s9,9e2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 994:	07500713          	li	a4,117
 998:	0ee78363          	beq	a5,a4,a7e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 99c:	07800713          	li	a4,120
 9a0:	12e78563          	beq	a5,a4,aca <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9a4:	07000713          	li	a4,112
 9a8:	14e78a63          	beq	a5,a4,afc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9ac:	07300713          	li	a4,115
 9b0:	18e78a63          	beq	a5,a4,b44 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9b4:	02500713          	li	a4,37
 9b8:	04e79563          	bne	a5,a4,a02 <vprintf+0xf2>
        putc(fd, '%');
 9bc:	02500593          	li	a1,37
 9c0:	855a                	mv	a0,s6
 9c2:	e89ff0ef          	jal	84a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9c6:	4981                	li	s3,0
 9c8:	bf49                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 9ca:	008b8913          	addi	s2,s7,8
 9ce:	4685                	li	a3,1
 9d0:	4629                	li	a2,10
 9d2:	000ba583          	lw	a1,0(s7)
 9d6:	855a                	mv	a0,s6
 9d8:	e91ff0ef          	jal	868 <printint>
 9dc:	8bca                	mv	s7,s2
      state = 0;
 9de:	4981                	li	s3,0
 9e0:	bfad                	j	95a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 9e2:	06400793          	li	a5,100
 9e6:	02f68963          	beq	a3,a5,a18 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9ea:	06c00793          	li	a5,108
 9ee:	04f68263          	beq	a3,a5,a32 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 9f2:	07500793          	li	a5,117
 9f6:	0af68063          	beq	a3,a5,a96 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 9fa:	07800793          	li	a5,120
 9fe:	0ef68263          	beq	a3,a5,ae2 <vprintf+0x1d2>
        putc(fd, '%');
 a02:	02500593          	li	a1,37
 a06:	855a                	mv	a0,s6
 a08:	e43ff0ef          	jal	84a <putc>
        putc(fd, c0);
 a0c:	85ca                	mv	a1,s2
 a0e:	855a                	mv	a0,s6
 a10:	e3bff0ef          	jal	84a <putc>
      state = 0;
 a14:	4981                	li	s3,0
 a16:	b791                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a18:	008b8913          	addi	s2,s7,8
 a1c:	4685                	li	a3,1
 a1e:	4629                	li	a2,10
 a20:	000ba583          	lw	a1,0(s7)
 a24:	855a                	mv	a0,s6
 a26:	e43ff0ef          	jal	868 <printint>
        i += 1;
 a2a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a2c:	8bca                	mv	s7,s2
      state = 0;
 a2e:	4981                	li	s3,0
        i += 1;
 a30:	b72d                	j	95a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a32:	06400793          	li	a5,100
 a36:	02f60763          	beq	a2,a5,a64 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a3a:	07500793          	li	a5,117
 a3e:	06f60963          	beq	a2,a5,ab0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a42:	07800793          	li	a5,120
 a46:	faf61ee3          	bne	a2,a5,a02 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a4a:	008b8913          	addi	s2,s7,8
 a4e:	4681                	li	a3,0
 a50:	4641                	li	a2,16
 a52:	000ba583          	lw	a1,0(s7)
 a56:	855a                	mv	a0,s6
 a58:	e11ff0ef          	jal	868 <printint>
        i += 2;
 a5c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a5e:	8bca                	mv	s7,s2
      state = 0;
 a60:	4981                	li	s3,0
        i += 2;
 a62:	bde5                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a64:	008b8913          	addi	s2,s7,8
 a68:	4685                	li	a3,1
 a6a:	4629                	li	a2,10
 a6c:	000ba583          	lw	a1,0(s7)
 a70:	855a                	mv	a0,s6
 a72:	df7ff0ef          	jal	868 <printint>
        i += 2;
 a76:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a78:	8bca                	mv	s7,s2
      state = 0;
 a7a:	4981                	li	s3,0
        i += 2;
 a7c:	bdf9                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 a7e:	008b8913          	addi	s2,s7,8
 a82:	4681                	li	a3,0
 a84:	4629                	li	a2,10
 a86:	000ba583          	lw	a1,0(s7)
 a8a:	855a                	mv	a0,s6
 a8c:	dddff0ef          	jal	868 <printint>
 a90:	8bca                	mv	s7,s2
      state = 0;
 a92:	4981                	li	s3,0
 a94:	b5d9                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a96:	008b8913          	addi	s2,s7,8
 a9a:	4681                	li	a3,0
 a9c:	4629                	li	a2,10
 a9e:	000ba583          	lw	a1,0(s7)
 aa2:	855a                	mv	a0,s6
 aa4:	dc5ff0ef          	jal	868 <printint>
        i += 1;
 aa8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 aaa:	8bca                	mv	s7,s2
      state = 0;
 aac:	4981                	li	s3,0
        i += 1;
 aae:	b575                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab0:	008b8913          	addi	s2,s7,8
 ab4:	4681                	li	a3,0
 ab6:	4629                	li	a2,10
 ab8:	000ba583          	lw	a1,0(s7)
 abc:	855a                	mv	a0,s6
 abe:	dabff0ef          	jal	868 <printint>
        i += 2;
 ac2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ac4:	8bca                	mv	s7,s2
      state = 0;
 ac6:	4981                	li	s3,0
        i += 2;
 ac8:	bd49                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 aca:	008b8913          	addi	s2,s7,8
 ace:	4681                	li	a3,0
 ad0:	4641                	li	a2,16
 ad2:	000ba583          	lw	a1,0(s7)
 ad6:	855a                	mv	a0,s6
 ad8:	d91ff0ef          	jal	868 <printint>
 adc:	8bca                	mv	s7,s2
      state = 0;
 ade:	4981                	li	s3,0
 ae0:	bdad                	j	95a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ae2:	008b8913          	addi	s2,s7,8
 ae6:	4681                	li	a3,0
 ae8:	4641                	li	a2,16
 aea:	000ba583          	lw	a1,0(s7)
 aee:	855a                	mv	a0,s6
 af0:	d79ff0ef          	jal	868 <printint>
        i += 1;
 af4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 af6:	8bca                	mv	s7,s2
      state = 0;
 af8:	4981                	li	s3,0
        i += 1;
 afa:	b585                	j	95a <vprintf+0x4a>
 afc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 afe:	008b8d13          	addi	s10,s7,8
 b02:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b06:	03000593          	li	a1,48
 b0a:	855a                	mv	a0,s6
 b0c:	d3fff0ef          	jal	84a <putc>
  putc(fd, 'x');
 b10:	07800593          	li	a1,120
 b14:	855a                	mv	a0,s6
 b16:	d35ff0ef          	jal	84a <putc>
 b1a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b1c:	00000b97          	auipc	s7,0x0
 b20:	43cb8b93          	addi	s7,s7,1084 # f58 <digits>
 b24:	03c9d793          	srli	a5,s3,0x3c
 b28:	97de                	add	a5,a5,s7
 b2a:	0007c583          	lbu	a1,0(a5)
 b2e:	855a                	mv	a0,s6
 b30:	d1bff0ef          	jal	84a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b34:	0992                	slli	s3,s3,0x4
 b36:	397d                	addiw	s2,s2,-1
 b38:	fe0916e3          	bnez	s2,b24 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 b3c:	8bea                	mv	s7,s10
      state = 0;
 b3e:	4981                	li	s3,0
 b40:	6d02                	ld	s10,0(sp)
 b42:	bd21                	j	95a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 b44:	008b8993          	addi	s3,s7,8
 b48:	000bb903          	ld	s2,0(s7)
 b4c:	00090f63          	beqz	s2,b6a <vprintf+0x25a>
        for(; *s; s++)
 b50:	00094583          	lbu	a1,0(s2)
 b54:	c195                	beqz	a1,b78 <vprintf+0x268>
          putc(fd, *s);
 b56:	855a                	mv	a0,s6
 b58:	cf3ff0ef          	jal	84a <putc>
        for(; *s; s++)
 b5c:	0905                	addi	s2,s2,1
 b5e:	00094583          	lbu	a1,0(s2)
 b62:	f9f5                	bnez	a1,b56 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b64:	8bce                	mv	s7,s3
      state = 0;
 b66:	4981                	li	s3,0
 b68:	bbcd                	j	95a <vprintf+0x4a>
          s = "(null)";
 b6a:	00000917          	auipc	s2,0x0
 b6e:	3e690913          	addi	s2,s2,998 # f50 <malloc+0x2da>
        for(; *s; s++)
 b72:	02800593          	li	a1,40
 b76:	b7c5                	j	b56 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 b78:	8bce                	mv	s7,s3
      state = 0;
 b7a:	4981                	li	s3,0
 b7c:	bbf9                	j	95a <vprintf+0x4a>
 b7e:	64a6                	ld	s1,72(sp)
 b80:	79e2                	ld	s3,56(sp)
 b82:	7a42                	ld	s4,48(sp)
 b84:	7aa2                	ld	s5,40(sp)
 b86:	7b02                	ld	s6,32(sp)
 b88:	6be2                	ld	s7,24(sp)
 b8a:	6c42                	ld	s8,16(sp)
 b8c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 b8e:	60e6                	ld	ra,88(sp)
 b90:	6446                	ld	s0,80(sp)
 b92:	6906                	ld	s2,64(sp)
 b94:	6125                	addi	sp,sp,96
 b96:	8082                	ret

0000000000000b98 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b98:	715d                	addi	sp,sp,-80
 b9a:	ec06                	sd	ra,24(sp)
 b9c:	e822                	sd	s0,16(sp)
 b9e:	1000                	addi	s0,sp,32
 ba0:	e010                	sd	a2,0(s0)
 ba2:	e414                	sd	a3,8(s0)
 ba4:	e818                	sd	a4,16(s0)
 ba6:	ec1c                	sd	a5,24(s0)
 ba8:	03043023          	sd	a6,32(s0)
 bac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bb0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bb4:	8622                	mv	a2,s0
 bb6:	d5bff0ef          	jal	910 <vprintf>
}
 bba:	60e2                	ld	ra,24(sp)
 bbc:	6442                	ld	s0,16(sp)
 bbe:	6161                	addi	sp,sp,80
 bc0:	8082                	ret

0000000000000bc2 <printf>:

void
printf(const char *fmt, ...)
{
 bc2:	711d                	addi	sp,sp,-96
 bc4:	ec06                	sd	ra,24(sp)
 bc6:	e822                	sd	s0,16(sp)
 bc8:	1000                	addi	s0,sp,32
 bca:	e40c                	sd	a1,8(s0)
 bcc:	e810                	sd	a2,16(s0)
 bce:	ec14                	sd	a3,24(s0)
 bd0:	f018                	sd	a4,32(s0)
 bd2:	f41c                	sd	a5,40(s0)
 bd4:	03043823          	sd	a6,48(s0)
 bd8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bdc:	00840613          	addi	a2,s0,8
 be0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 be4:	85aa                	mv	a1,a0
 be6:	4505                	li	a0,1
 be8:	d29ff0ef          	jal	910 <vprintf>
}
 bec:	60e2                	ld	ra,24(sp)
 bee:	6442                	ld	s0,16(sp)
 bf0:	6125                	addi	sp,sp,96
 bf2:	8082                	ret

0000000000000bf4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bf4:	1141                	addi	sp,sp,-16
 bf6:	e422                	sd	s0,8(sp)
 bf8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bfa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfe:	00001797          	auipc	a5,0x1
 c02:	4027b783          	ld	a5,1026(a5) # 2000 <freep>
 c06:	a02d                	j	c30 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c08:	4618                	lw	a4,8(a2)
 c0a:	9f2d                	addw	a4,a4,a1
 c0c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c10:	6398                	ld	a4,0(a5)
 c12:	6310                	ld	a2,0(a4)
 c14:	a83d                	j	c52 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c16:	ff852703          	lw	a4,-8(a0)
 c1a:	9f31                	addw	a4,a4,a2
 c1c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c1e:	ff053683          	ld	a3,-16(a0)
 c22:	a091                	j	c66 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c24:	6398                	ld	a4,0(a5)
 c26:	00e7e463          	bltu	a5,a4,c2e <free+0x3a>
 c2a:	00e6ea63          	bltu	a3,a4,c3e <free+0x4a>
{
 c2e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c30:	fed7fae3          	bgeu	a5,a3,c24 <free+0x30>
 c34:	6398                	ld	a4,0(a5)
 c36:	00e6e463          	bltu	a3,a4,c3e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c3a:	fee7eae3          	bltu	a5,a4,c2e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 c3e:	ff852583          	lw	a1,-8(a0)
 c42:	6390                	ld	a2,0(a5)
 c44:	02059813          	slli	a6,a1,0x20
 c48:	01c85713          	srli	a4,a6,0x1c
 c4c:	9736                	add	a4,a4,a3
 c4e:	fae60de3          	beq	a2,a4,c08 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 c52:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c56:	4790                	lw	a2,8(a5)
 c58:	02061593          	slli	a1,a2,0x20
 c5c:	01c5d713          	srli	a4,a1,0x1c
 c60:	973e                	add	a4,a4,a5
 c62:	fae68ae3          	beq	a3,a4,c16 <free+0x22>
    p->s.ptr = bp->s.ptr;
 c66:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c68:	00001717          	auipc	a4,0x1
 c6c:	38f73c23          	sd	a5,920(a4) # 2000 <freep>
}
 c70:	6422                	ld	s0,8(sp)
 c72:	0141                	addi	sp,sp,16
 c74:	8082                	ret

0000000000000c76 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c76:	7139                	addi	sp,sp,-64
 c78:	fc06                	sd	ra,56(sp)
 c7a:	f822                	sd	s0,48(sp)
 c7c:	f426                	sd	s1,40(sp)
 c7e:	ec4e                	sd	s3,24(sp)
 c80:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c82:	02051493          	slli	s1,a0,0x20
 c86:	9081                	srli	s1,s1,0x20
 c88:	04bd                	addi	s1,s1,15
 c8a:	8091                	srli	s1,s1,0x4
 c8c:	0014899b          	addiw	s3,s1,1
 c90:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c92:	00001517          	auipc	a0,0x1
 c96:	36e53503          	ld	a0,878(a0) # 2000 <freep>
 c9a:	c915                	beqz	a0,cce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c9e:	4798                	lw	a4,8(a5)
 ca0:	08977a63          	bgeu	a4,s1,d34 <malloc+0xbe>
 ca4:	f04a                	sd	s2,32(sp)
 ca6:	e852                	sd	s4,16(sp)
 ca8:	e456                	sd	s5,8(sp)
 caa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 cac:	8a4e                	mv	s4,s3
 cae:	0009871b          	sext.w	a4,s3
 cb2:	6685                	lui	a3,0x1
 cb4:	00d77363          	bgeu	a4,a3,cba <malloc+0x44>
 cb8:	6a05                	lui	s4,0x1
 cba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cbe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cc2:	00001917          	auipc	s2,0x1
 cc6:	33e90913          	addi	s2,s2,830 # 2000 <freep>
  if(p == (char*)-1)
 cca:	5afd                	li	s5,-1
 ccc:	a081                	j	d0c <malloc+0x96>
 cce:	f04a                	sd	s2,32(sp)
 cd0:	e852                	sd	s4,16(sp)
 cd2:	e456                	sd	s5,8(sp)
 cd4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 cd6:	00001797          	auipc	a5,0x1
 cda:	3a278793          	addi	a5,a5,930 # 2078 <base>
 cde:	00001717          	auipc	a4,0x1
 ce2:	32f73123          	sd	a5,802(a4) # 2000 <freep>
 ce6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ce8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cec:	b7c1                	j	cac <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 cee:	6398                	ld	a4,0(a5)
 cf0:	e118                	sd	a4,0(a0)
 cf2:	a8a9                	j	d4c <malloc+0xd6>
  hp->s.size = nu;
 cf4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cf8:	0541                	addi	a0,a0,16
 cfa:	efbff0ef          	jal	bf4 <free>
  return freep;
 cfe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d02:	c12d                	beqz	a0,d64 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d06:	4798                	lw	a4,8(a5)
 d08:	02977263          	bgeu	a4,s1,d2c <malloc+0xb6>
    if(p == freep)
 d0c:	00093703          	ld	a4,0(s2)
 d10:	853e                	mv	a0,a5
 d12:	fef719e3          	bne	a4,a5,d04 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 d16:	8552                	mv	a0,s4
 d18:	b1bff0ef          	jal	832 <sbrk>
  if(p == (char*)-1)
 d1c:	fd551ce3          	bne	a0,s5,cf4 <malloc+0x7e>
        return 0;
 d20:	4501                	li	a0,0
 d22:	7902                	ld	s2,32(sp)
 d24:	6a42                	ld	s4,16(sp)
 d26:	6aa2                	ld	s5,8(sp)
 d28:	6b02                	ld	s6,0(sp)
 d2a:	a03d                	j	d58 <malloc+0xe2>
 d2c:	7902                	ld	s2,32(sp)
 d2e:	6a42                	ld	s4,16(sp)
 d30:	6aa2                	ld	s5,8(sp)
 d32:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 d34:	fae48de3          	beq	s1,a4,cee <malloc+0x78>
        p->s.size -= nunits;
 d38:	4137073b          	subw	a4,a4,s3
 d3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d3e:	02071693          	slli	a3,a4,0x20
 d42:	01c6d713          	srli	a4,a3,0x1c
 d46:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d48:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d4c:	00001717          	auipc	a4,0x1
 d50:	2aa73a23          	sd	a0,692(a4) # 2000 <freep>
      return (void*)(p + 1);
 d54:	01078513          	addi	a0,a5,16
  }
}
 d58:	70e2                	ld	ra,56(sp)
 d5a:	7442                	ld	s0,48(sp)
 d5c:	74a2                	ld	s1,40(sp)
 d5e:	69e2                	ld	s3,24(sp)
 d60:	6121                	addi	sp,sp,64
 d62:	8082                	ret
 d64:	7902                	ld	s2,32(sp)
 d66:	6a42                	ld	s4,16(sp)
 d68:	6aa2                	ld	s5,8(sp)
 d6a:	6b02                	ld	s6,0(sp)
 d6c:	b7f5                	j	d58 <malloc+0xe2>
